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

@end
