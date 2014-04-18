//
//  NetConnect.m
//  ArtSearching
//
//  Created by developer on 14-4-17.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "NetConnect.h"

@implementation NetConnect
static NetConnect *netConnect;
+ (NetConnect *)sharedSelf
{
    @synchronized(self)
    {
        if(netConnect == nil)
        {
            return [[self alloc] init];
        }
    }
    return netConnect;
}

+ (id)alloc
{
    @synchronized(self)
    {
            netConnect = [super alloc];
            return netConnect;
    }
    return nil;
}

-(void)obtainStartList
{
    NSString *hostUrl = [NSString stringWithFormat:@"%@%@",hostForXM,startList];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hostUrl]];
    AFHTTPRequestOperation *operate = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operate setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success string is %@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail string is %@",operation.responseString);
    }];
    [operate start];
}
@end
