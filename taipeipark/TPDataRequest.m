//
//  TPDataRequest.m
//  taipeipark
//
//  Created by Esu Tsai on 2017/4/12.
//  Copyright © 2017年 Esu Tsai. All rights reserved.
//

#import "TPDataRequest.h"
#import "TPParkDataManager.h"

@implementation TPDataRequest

+ (TPDataRequest *)sharedInstance
{
    static TPDataRequest *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[TPDataRequest alloc] init];
    });
    return shareInstance;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        // initialize stuff here
    }
    
    return self;
}

- (void)apiGetWithPath:(NSString *)path
                params:(NSDictionary *)params
               success:(APIFetchResult)successBlock
               failure:(void (^)(NSDictionary *errorData))failureBlock
            completion:(void (^)(void))completionBlock
{
    self.apiFetchResult                    = successBlock;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //資料呼叫成功，並加以處理
        NSArray *parkData = [[responseObject objectForKey:@"result"] objectForKey:@"results"];
        TPParkDataManager *parkDataManager = [[TPParkDataManager alloc] init];
        parkDataManager.parkList           = parkData;
        
        if(successBlock){
            successBlock(parkDataManager.resultParkList);
        }
        if(completionBlock){
            completionBlock();
        }
        self.apiFetchResult = nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorParams = @{@"status":@"fail",
                                      @"message":@"系統連線錯誤！請稍候再試"};
        if(failureBlock){
            failureBlock(errorParams);
        }
        if(completionBlock){
            completionBlock();
        }
        self.apiFetchResult = nil;
    }];
}


@end
