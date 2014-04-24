//
//  LCYCommon.m
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYCommon.h"
#import <AFNetworking/AFNetworking.h>

NSString *const hostURLPrefix = @"http://115.29.41.251:88/webservice_art_base.asmx/";
NSString *const ActivityList  = @"ActivityList";
//NSString *const ActivityOrganizationListSearchByKey     = @"ActivityOrganizationListSearchByKey";
NSString *const Login         = @"Login";
NSString *const UserDefaultsIsLogin     = @"isUserLogin";
NSString *const UserDefaultsUserId      = @"userLoginID";

#pragma mark - 凶猛的数据
NSString *const hostForXM     = @"http://115.29.41.251:88/webservice_art_base.asmx/";
NSString *const startList     = @"StarList";
NSString *const imageHost     = @"http://115.29.41.251/";
NSString *const startArtDetail= @"WorkDetailByWorkId";
NSString *const getArtistInfo = @"GetArtistInforById";
@implementation LCYCommon

+ (void)postRequestWithAPI:(NSString *)api parameters:(NSDictionary *)parameters successDelegate:(id<NSXMLParserDelegate>)delegate failedBlock:(void (^)(void))failed{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",hostURLPrefix,api];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        XMLParser.delegate = delegate;
        [XMLParser setShouldProcessNamespaces:NO];
        [XMLParser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), failed);
    }];
}

@end
