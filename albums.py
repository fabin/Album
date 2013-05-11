#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
from __future__ import with_statement
from base import JINJA_ENVIRONMENT, BaseHandler
from google.appengine.api import files, images, users
from google.appengine.ext import blobstore, db
from google.appengine.ext.db import BadKeyError
from google.appengine.ext.webapp import blobstore_handlers
import json
import logging
import re
import urllib
import webapp2


EXPIRATION_TIME = 300  # seconds

class Album(db.Model):
    name = db.StringProperty()
    cover = db.StringProperty()
    description = db.StringProperty(multiline=True)
    date = db.DateTimeProperty(auto_now_add=True)

class Picture(db.Model):
    name = db.StringProperty()
    image = db.StringProperty()
    date = db.DateTimeProperty(auto_now_add=True)
    
def create_album_key(album_name=None):
    """Constructs a Datastore key for a Guestbook entity with guestbook_name."""
    return db.Key.from_path('Album', album_name or 'default_album')

class Albums(BaseHandler):

    def get(self):
        greetings_query = Album.all().order('-date')
        albums = greetings_query.fetch(10)

        user = users.get_current_user()
        if user:
            url = users.create_logout_url(self.request.uri)
            url_linktext = 'Logout'
        else:
            url = users.create_login_url(self.request.uri)
            url_linktext = 'Login'

        template_values = {
            'albums': albums,
            'url': url,
            'url_linktext': url_linktext,
        }

        template = JINJA_ENVIRONMENT.get_template('/templates/albums.html')
        self.response.write(template.render(template_values))
        
class AlbumCreate(BaseHandler):

    def get(self):
        album = None
        album_key = self.request.get('album')
        if album_key:
            album = Album.get(album_key);
        template_values = {
            'album': album
        }
        template = JINJA_ENVIRONMENT.get_template('/templates/albumsCreate.html')
        self.response.write(template.render(template_values))
        
    def post(self):
        # We set the same parent key on the 'Album' to ensure each greeting
        # is in the same entity group. Queries across the single entity group
        # will be consistent. However, the write rate to a single entity group
        # should be limited to ~1/second.
        album_key = self.request.get('album_key')
        if album_key:
            greeting = Album.get(album_key)
        else :
            greeting = Album(parent=create_album_key())
        greeting.name = self.request.get('name')
        greeting.cover = self.request.get('cover')
        greeting.description = self.request.get('description')
        greeting.put()
        self.redirect('/albums')

class AlbumDetails(BaseHandler):
    def get(self, key):
        album = None
        try:
            album = Album.get(key)
        except BadKeyError:
            self.error(404)
        if not album:
            self.error(404)
        else:
            
            pictures = Picture.all().ancestor(album)
            
            template = JINJA_ENVIRONMENT.get_template('/templates/albumDetails.html')
            template_values = {
            'album': album,
            'pictures': pictures
            }
            self.response.write(template.render(template_values))
class AlbumPicture(blobstore_handlers.BlobstoreDownloadHandler):
    def get(self, picture_key):
        picture = Picture.get(picture_key)
        if not picture:
            self.error(404)
        
        logging.info('str(picture.image) == ' + str(picture.image))
        
        if not blobstore.get(picture.image):
            self.error(404)
        else:
            # Cache for the expiration time:
            self.response.headers['Cache-Control'] = \
                'public,max-age=%d' % EXPIRATION_TIME
            self.send_blob(picture.image)
class AlbumDelete(blobstore_handlers.BlobstoreDownloadHandler):
    def get(self, album_key):
        album = Album.get(album_key)
        album.delete()
        self.redirect('/albums')
        
MIN_FILE_SIZE = 1  # bytes
MAX_FILE_SIZE = 5000000  # bytes
IMAGE_TYPES = re.compile('image/(gif|p?jpeg|(x-)?png)')
ACCEPT_FILE_TYPES = IMAGE_TYPES

class AlbumCoverUploadHandler(BaseHandler):


    def initialize(self, request, response):
        super(AlbumCoverUploadHandler, self).initialize(request, response)
        logging.info("initialize(...)")
        self.response.headers['Access-Control-Allow-Origin'] = '*'
        self.response.headers[
            'Access-Control-Allow-Methods'
        ] = 'OPTIONS, HEAD, GET, POST, PUT, DELETE'
        self.response.headers[
            'Access-Control-Allow-Headers'
        ] = 'Content-Type, Content-Range, Content-Disposition'

    def validate(self, fileObject):
        logging.info("validate(...)")
        if fileObject['size'] < MIN_FILE_SIZE:
            fileObject['error'] = 'File is too small'
        elif fileObject['size'] > MAX_FILE_SIZE:
            fileObject['error'] = 'File is too big'
        elif not ACCEPT_FILE_TYPES.match(fileObject['type']):
            fileObject['error'] = 'File type not allowed'
        else:
            return True
        return False

    def get_file_size(self, fileObject):
        logging.info("get_file_size(...)")
        fileObject.seek(0, 2)  # Seek to the end of the fileObject
        size = fileObject.tell()  # Get the position of EOF
        fileObject.seek(0)  # Reset the fileObject position to the beginning
        return size

    def write_blob(self, data, info):
        logging.info("write_blob(...)")
        blob = files.blobstore.create(
            mime_type=info['type'],
            _blobinfo_uploaded_filename=info['name']
        )
        with files.open(blob, 'a') as f:
            f.write(data)
        files.finalize(blob)
        return files.blobstore.get_blob_key(blob)

    def handle_upload(self):
        logging.info("handle_upload(...)")
        results = []
        blob_keys = []
        for name, fieldStorage in self.request.POST.items():  # @UnusedVariable
            if type(fieldStorage) is unicode:
                continue
            result = {}
            result['name'] = re.sub(
                r'^.*\\',
                '',
                fieldStorage.filename
            )
            result['type'] = fieldStorage.type
            result['size'] = self.get_file_size(fieldStorage.file)
            if self.validate(result):
                blob_key = str(
                    self.write_blob(fieldStorage.value, result)
                )
                blob_keys.append(blob_key)
                
#                 album_key = self.request.get('album_key')
                image_url = images.get_serving_url(
                            blob_key,
                            secure_url=self.request.host_url.startswith(
                                'https'
                            )
                        )
                result['url'] = image_url
                logging.info("url == " + result['url'])

                result['delete_type'] = 'DELETE'
                result['delete_url'] = self.request.host_url + \
                    '/?key=' + urllib.quote(blob_key, '')
                    
#                 if (IMAGE_TYPES.match(result['type'])):
#                     try:
#                         result['url'] = images.get_serving_url(
#                             blob_key,
#                             secure_url=self.request.host_url.startswith(
#                                 'https'
#                             )
#                         )
#                         result['thumbnail_url'] = result['url'] + \
#                             THUMBNAIL_MODIFICATOR
#                     except:  # Could not get an image serving url
#                         pass
#                 if not 'url' in result:
#                     result['url'] = self.request.host_url + \
#                         '/' + blob_key + '/' + urllib.quote(
#                             result['name'].encode('utf-8'), '')
#                     result['thumbnail_url'] = result['url'] + THUMBNAIL_MODIFICATOR
            results.append(result)
#         deferred.defer(
#             cleanup,
#             blob_keys,
#             _countdown=EXPIRATION_TIME
#         )
        return results

    def post(self):
        logging.info("post(...)")
        
        if (self.request.get('_method') == 'DELETE'):
            return self.delete()
        result = {'files': self.handle_upload()}
        s = json.dumps(result, separators=(',', ':'))
        if 'application/json' in self.request.headers.get('Accept'):
            self.response.headers['Content-Type'] = 'application/json'
        self.response.write(s)

app = webapp2.WSGIApplication([('/albums', Albums),
                               ('', Albums),
                               ('/', Albums),
                               ('/albums/picture/([^/]+)', AlbumPicture),
                               ('/albums/details/([^/]+)', AlbumDetails),
                               ('/albums/delete/([^/]+)', AlbumDelete),
                               ('/albums/create/cover', AlbumCoverUploadHandler),
                               ('/albums/create', AlbumCreate)],
                              debug=True)
