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

+ (NSString *)configForKey:(NSString *)key{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Configs" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:file];
    return config[key];
}

@end
