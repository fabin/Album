//
//  WAHTTPClient.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WAHTTPClient.h"
#import "JSONKit.h"

@implementation WAHTTPClient

SINGLETON_GCD(WAHTTPClient);

- (id)init
{
    NSString *server = CONFIG(KeyServer);
    if (!server){
        server = [NSString stringWithFormat:@"http://%@", CONFIG(KeyOptionServer)];
    }
    
    self = [super initWithBaseURL:[NSURL URLWithString:server]];
    if (self) {
        
    }
    return self;
}

+ (void)albumListSuccess:(SLObjectBlock)success failure:(SLErrorBlock)failure{
    [[self sharedWAHTTPClient] getPath:@"interface/albums"
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   NSArray *arr = [responseObject objectFromJSONData];
                                   
                                   SLLog(@"result %@", arr);
                                   success(arr);
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failure(error);
                               }];
}

+ (void)photoListForKey:(NSString *)key success:(SLObjectBlock)success failure:(SLErrorBlock)failure{
    [[self sharedWAHTTPClient] getPath:[NSString stringWithFormat:@"interface/album/%@", key]
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   NSArray *arr = [responseObject objectFromJSONData];
                                   
                                   SLLog(@"result %@", arr);
                                   
                                   success(arr);
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failure(error);
                               }];
}

@end
