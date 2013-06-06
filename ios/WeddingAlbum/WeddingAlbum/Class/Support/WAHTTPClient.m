//
//  WAHTTPClient.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WAHTTPClient.h"
#import "JSONKit.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation WAHTTPClient

SINGLETON_GCD(WAHTTPClient);

- (id)init
{
    NSString *server = CONFIG(KeyServer);
    if (!server){
        server = CONFIG(KeyOptionServer);
    }
    
    if (![server hasPrefix:@"http://"]){
        server = [NSString stringWithFormat:@"http://%@", server];
    }
    
    self = [super initWithBaseURL:[NSURL URLWithString:server]];
    if (self) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
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

+ (void)appSettingSuccess:(SLObjectBlock)success failure:(SLErrorBlock)failure{
    [[self sharedWAHTTPClient] getPath:@"interface/appSetting"
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   NSDictionary *dic = [responseObject objectFromJSONData];
                                   SLLog(@"result %@", arr);
                                   if (dic.count > 0) {
                                       success(dic);
                                   }else{
                                       failure(nil);
                                   }
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failure(error);
                               }];
}

@end
