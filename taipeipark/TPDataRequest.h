//
//  TPDataRequest.h
//  taipeipark
//
//  Created by Esu Tsai on 2017/4/12.
//  Copyright © 2017年 Esu Tsai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface TPDataRequest : AFHTTPSessionManager

typedef void (^APIFetchResult)(NSArray *successData);
@property (copy, nonatomic) APIFetchResult apiFetchResult;

+ (TPDataRequest *)sharedInstance;
- (void)apiGetWithPath:(NSString *)path
                params:(NSDictionary *)params
               success:(APIFetchResult)successBlock
               failure:(void (^)(NSDictionary *errorData))failureBlock
            completion:(void (^)(void))completionBlock;

@end
