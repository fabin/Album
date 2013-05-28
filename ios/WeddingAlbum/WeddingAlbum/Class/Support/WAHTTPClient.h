//
//  WAHTTPClient.h
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "AFHTTPClient.h"

@interface WAHTTPClient : AFHTTPClient

+ (id)sharedWAHTTPClient;

+ (void)albumListSuccess:(SLObjectBlock)success failure:(SLErrorBlock)failure;

+ (void)photoListForKey:(NSString *)key success:(SLObjectBlock)success failure:(SLErrorBlock)failure;
@end
