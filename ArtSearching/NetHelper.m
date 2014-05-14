//
//  NetHelper.m
//  ArtSearching
//
//  Created by developer on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "NetHelper.h"

@implementation NetHelper
static NetHelper *netChild;
+(NetHelper *)sharedSelf
{
    @synchronized(self)
    {
        if(netChild == nil)
        {
            return [[self alloc] init];
        }
    }
    return netChild;
}

+(id)alloc
{
    @synchronized(self)
    {
        netChild = [super alloc];
        return netChild;
    }
    return nil;
}

/**
  NetHelper的代理方法
 */
- (void)requestStart:(NSString *)urlString withParams:(NSDictionary *)params bySerialize:(AFHTTPResponseSerializer *)serializer
{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer = serializer;
    if(params==nil)
    {
        [operationManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteSuccess withOperation:operation withObject:responseObject];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteFail withOperation:operation withObject:error];
            }

        }];
    }
    else
    {
        [operationManager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteSuccess withOperation:operation withObject:responseObject];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if([self.netHelperDelegate respondsToSelector:@selector(requestCompleteDelegateWithFlag:withOperation:withObject:)])
            {
                [self.netHelperDelegate requestCompleteDelegateWithFlag:requestCompleteFail withOperation:operation withObject:error];
            }

        }];
    }
}


@end
