//
//  WADataEnvironment.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WADataEnvironment.h"

@implementation WADataEnvironment

SINGLETON_GCD(WADataEnvironment);

+ (void)initialize{
    if ([self class] == [WADataEnvironment class]) {
        NSString *folder = [APP_SUPPORT stringByAppendingPathComponent:@"Albums"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:folder])
        {
            [manager createDirectoryAtPath:folder
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        }
    }
}

+ (NSString *)configForKey:(NSString *)key{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Configs" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:file];
    return config[key];
}

+ (void)cacheAlbumList:(id)data forName:(NSString *)name{
    if (!name) {
        name = @"新郎新娘";
    }
    NSString *folder = [APP_SUPPORT stringByAppendingPathComponent:@"Albums"];
    NSString *path = [NSString stringWithFormat:@"%@/%@.plist", folder, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [data writeToFile:path atomically:YES];
}

+ (id)cachedAlbumeListForName:(NSString *)name{
    if (!name) {
        name = @"新郎新娘";
    }
    
    NSString *folder = [APP_SUPPORT stringByAppendingPathComponent:@"Albums"];
    NSString *path = [NSString stringWithFormat:@"%@/%@.plist", folder, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return [NSArray arrayWithContentsOfFile:path];
}

+ (void)cachePhotoList:(id)data forName:(NSString *)name{
    if (!name) return;
    
    NSString *folder = [APP_SUPPORT stringByAppendingPathComponent:@"Albums"];
    NSString *path = [NSString stringWithFormat:@"%@/%@.plist", folder, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [data writeToFile:path atomically:YES];
}

+ (id)cachedPhotoListForName:(NSString *)name{
    if (!name) return nil;
    
    NSString *folder = [APP_SUPPORT stringByAppendingPathComponent:@"Albums"];
    NSString *path = [NSString stringWithFormat:@"%@/%@.plist", folder, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

@end
