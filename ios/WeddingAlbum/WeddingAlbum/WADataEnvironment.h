//
//  WADataEnvironment.h
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SINGLETONGCD.h"

@interface WADataEnvironment : NSObject

+ (id)sharedWADataEnvironment;

+ (NSString *)configForKey:(NSString *)key;

+ (void)cacheAlbumList:(id)data forName:(NSString *)name;
+ (id)cachedAlbumeListForName:(NSString *)name;

+ (void)cachePhotoList:(id)data forName:(NSString *)name;
+ (id)cachedPhotoListForName:(NSString *)name;

@end
