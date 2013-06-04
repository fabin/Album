#!/usr/bin/env python
# -*- coding: utf-8 -*-
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
from google.appengine.ext import  db
import json
import logging
import webapp2
from upload import UploadHandler


class Settings(db.Model):
    girlName = db.StringProperty()
    boyName = db.StringProperty()
    date = db.DateTimeProperty(auto_now_add=True)

class WebSetting(db.Model):
    praise1 = db.StringProperty()
    praise2 = db.StringProperty()
    praise3 = db.StringProperty()
    
class AppSetting(db.Model):
    appName = db.StringProperty()
    appHead = db.StringProperty()
    appWelcome = db.StringProperty()
    appCongratulation = db.StringProperty()
    cover = db.StringProperty()
    
    
def create_setting_key(setting_name=None):
    return db.Key.from_path('Settings', setting_name or 'default_setting')

class SettingsHandler(BaseHandler):
    def get(self):
        settings_query = Settings.all().order('date')
        settings = settings_query.fetch(1)
        setting = settings[0] if len(settings) > 0 else {}
        logging.info("get setting = " + str(setting))
        
        if isinstance(setting, Settings):
            webSettings = WebSetting.all().ancestor(setting).fetch(1)
            webSetting = webSettings[0] if len(webSettings) > 0 else {}
            appSettings = AppSetting.all().ancestor(setting).fetch(1)
            appSetting = appSettings[0] if len(appSettings) > 0 else {}
        else:
            webSetting = {}
            appSetting = {}
            
        template_values = {
            'setting' : setting,
            'webSetting' : webSetting,
            'appSetting' : appSetting
            }
        template = JINJA_ENVIRONMENT.get_template('/templates/settings.html')
        self.response.write(template.render(template_values))
    def post(self):
        
        settings_query = Settings.all().order('date')
        settings = settings_query.fetch(1)
        setting = settings[0] if len(settings) > 0 else None
        if not setting:
            setting = Settings(parent=db.Key.from_path('Settings', 'default_setting'))
        setting.girlName = self.request.get('girlName')
        setting.boyName = self.request.get('boyName')
        setting.save()
        
        appSettings = AppSetting.all().ancestor(setting).fetch(1)
        appSetting = appSettings[0] if len(appSettings) > 0 else AppSetting(parent=setting)
        appSetting.appName = self.request.get('appName')
        appSetting.appHead = self.request.get('appHead')
        appSetting.appWelcome = self.request.get('appWelcome')
        appSetting.appCongratulation = self.request.get('appCongratulation')
        appSetting.save()
        
        webSettings = WebSetting.all().ancestor(setting).fetch(1)
        webSetting = webSettings[0] if len(webSettings) > 0 else WebSetting(parent=setting)
        webSetting.praise1 = self.request.get('praise1')
        webSetting.praise2 = self.request.get('praise2')
        webSetting.praise3 = self.request.get('praise3')
        webSetting.save()
        
        template_values = {
            'setting' : setting,
            'appSetting' : appSetting,
            'webSetting' : webSetting,
            'updated' : True
            }
        template = JINJA_ENVIRONMENT.get_template('/templates/settings.html')
        self.response.write(template.render(template_values))
        
class SettingUploadHandler(UploadHandler):
    def post(self):
        logging.info("SettingUploadHandler(...)")
        
        result = self.handle_upload()
        s = json.dumps(result, separators=(',', ':'))
        if 'application/json' in self.request.headers.get('Accept'):
            self.response.headers['Content-Type'] = 'application/json'
        self.response.write(s)

app = webapp2.WSGIApplication([('/settings', SettingsHandler), ('/settings/upload', SettingUploadHandler)],
                              debug=True)
