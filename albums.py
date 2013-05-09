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
import jinja2
import os
from google.appengine.ext.webapp import blobstore_handlers
from google.appengine.ext import blobstore
import logging

JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)))
    
import webapp2

from google.appengine.ext import db
from google.appengine.api import users

EXPIRATION_TIME = 300  # seconds

class Album(db.Model):
    name = db.StringProperty()
    description = db.StringProperty(multiline=True)
    date = db.DateTimeProperty(auto_now_add=True)

class Picture(db.Model):
    name = db.StringProperty()
    image = db.StringProperty()
    date = db.DateTimeProperty(auto_now_add=True)
    
def album_key(album_name=None):
    """Constructs a Datastore key for a Guestbook entity with guestbook_name."""
    return db.Key.from_path('Album', album_name or 'default_album')

class Albums(webapp2.RequestHandler):

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
        
class AlbumCreate(webapp2.RequestHandler):

    def get(self):
        template = JINJA_ENVIRONMENT.get_template('/templates/albumsCreate.html')
        self.response.write(template.render())
        
    def post(self):
        # We set the same parent key on the 'Album' to ensure each greeting
        # is in the same entity group. Queries across the single entity group
        # will be consistent. However, the write rate to a single entity group
        # should be limited to ~1/second.
        greeting = Album(parent=album_key());
        greeting.name = self.request.get('name')
        greeting.description = self.request.get('description')
        greeting.put()
        self.redirect('/albums')

class AlbumDetails(webapp2.RequestHandler):
    def get(self, key):
        album = Album.get(key) 
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
        
app = webapp2.WSGIApplication([('/albums', Albums),
                               ('', Albums),
                               ('/', Albums),
                               ('/albums/picture/([^/]+)', AlbumPicture),
                               ('/albums/details/([^/]+)', AlbumDetails),
                               ('/albums/create', AlbumCreate)],
                              debug=True)
