//
//  LCYCommon.m
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYCommon.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

NSString *const hostURLPrefix = @"http://115.29.41.251:88/webservice_art_base.asmx/";
NSString *const ActivityList  = @"ActivityList";
//NSString *const ActivityOrganizationListSearchByKey     = @"ActivityOrganizationListSearchByKey";
NSString *const Login         = @"Login";
NSString *const RegisterGetValidate     = @"RegisterGetValidate";
NSString *const RegisterOne             = @"RegisterOne";
NSString *const RegisterTwo             = @"RegisterTwo";
NSString *const UploadFile              = @"UploadFile";
NSString *const RegisterThree           = @"RegisterThree";
NSString *const GetAllExhibition        = @"GetAllExhibition";


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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/xml", nil];
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        XMLParser.delegate = delegate;
        [XMLParser setShouldProcessNamespaces:NO];
        [XMLParser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failed) {
            dispatch_async(dispatch_get_main_queue(), failed);
        }
    }];
}

+ (BOOL)networkAvailable{
    NetworkStatus wifi = [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus];
    NetworkStatus gprs = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if(wifi == NotReachable && gprs == NotReachable)
    {
        return NO;
    }
    return YES;
}

+ (void)showHUDTo:(UIView *)view withTips:(NSString *)tips{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = tips;
}

+ (void)hideHUDFrom:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (NSData*)compressImage:(UIImage*)comImage
{
    CGFloat compression = 0.4f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 80*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(comImage, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(comImage, compression);
    }
    return imageData;
}

@end
