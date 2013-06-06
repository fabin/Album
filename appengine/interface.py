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
from albums import Album, Picture
import json
import webapp2
import album_settings

class InterfaceAlbumsHandler(webapp2.RequestHandler):

    def get(self):
        albums_query = Album.all().order('-date')
        albums = albums_query.fetch(60)
        results = [];
        for album in albums:
            result = {}
            result['key'] = str(album.key())
            result['name'] = album.name
            result['cover'] = album.cover
            result['description'] = album.description
            results.append(result)
            
        s = json.dumps(results, separators=(',', ':'))
        
        self.response.headers['Content-Type'] = 'application/json'
        self.response.write(s)
class InterfaceAlbumDetailsHandler(webapp2.RequestHandler):

    def get(self, album_key):
        album = Album.get(album_key)
        
        result_album = {}
        result_album['key'] = str(album.key())
        result_album['name'] = album.name
        result_album['cover'] = album.cover
        result_album['description'] = album.description
            
        result_pictures = [];
        pictures = Picture.all().ancestor(album)
        for picture in pictures:
            resultPicture = {}
            resultPicture['key'] = str(picture.key())
            resultPicture['name'] = picture.name
            resultPicture['url'] = picture.image
            resultPicture['date'] = str(picture.date)
            result_pictures.append(resultPicture)
        
        result = {}
        result['album'] = result_album
        result['pictures'] = result_pictures
        s = json.dumps(result, separators=(',', ':'))
        
        self.response.headers['Content-Type'] = 'application/json'
        self.response.write(s)


class InterfaceAppSettingHandler(webapp2.RequestHandler):
    def get(self):
        settings_query = album_settings.Settings.all().order('date')
        settings = settings_query.fetch(1)
        setting = settings[0] if len(settings) > 0 else {}
        if isinstance(setting, album_settings.Settings):
            appSettings = album_settings.AppSetting.all().ancestor(setting).fetch(1)
            appSetting = appSettings[0] if len(appSettings) > 0 else {}
        result = {}
        result['girlName'] = setting.girlName
        result['boyName'] = setting.boyName
        result['appName'] = appSetting.appName
        result['appHead'] = appSetting.appHead
        result['appWelcome'] = appSetting.appWelcome
        result['appCongratulation'] = appSetting.appCongratulation
        s = json.dumps(result, separators=(',', ':'))
        self.response.headers['Content-Type'] = 'application/json'
        self.response.write(s)

app = webapp2.WSGIApplication([('/interface/albums', InterfaceAlbumsHandler), ('/interface/album/([^/]+)', InterfaceAlbumDetailsHandler), ('/interface/appSetting', InterfaceAppSettingHandler)],
                              debug=True)
