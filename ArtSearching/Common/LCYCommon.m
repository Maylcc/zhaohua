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
NSString *const hostIMGPrefix = @"http://115.29.41.251";
NSString *const ActivityList  = @"ActivityList";
//NSString *const ActivityOrganizationListSearchByKey     = @"ActivityOrganizationListSearchByKey";
NSString *const Login         = @"Login";
NSString *const GetUserInfo   = @"GetUserInfo";
NSString *const RegisterGetValidate     = @"RegisterGetValidate";
NSString *const RegisterOne             = @"RegisterOne";
NSString *const RegisterTwo             = @"RegisterTwo";
NSString *const UploadFile              = @"UploadFile";
NSString *const RegisterThree           = @"RegisterThree";
NSString *const GetAllExhibition        = @"GetAllExhibition";
NSString *const GetArtistList           = @"GetArtistList";
NSString *const GetGalleryList          = @"GetGalleryList";
NSString *const GetOwnExhibition        = @"GetOwnExhibition";
NSString *const GetApplyerInfo          = @"GetApplyerInfo";
NSString *const WorkListCategory        = @"WorkListCategory";
NSString *const WorkListCategoryById    = @"WorkListCategoryById";
NSString *const GetArtistInforById      = @"GetArtistInforById";
NSString *const GetGalleryInfoById      = @"GetGalleryInfoById";
NSString *const GetFavoriteArtWorks     = @"GetFavoriteArtWorks";


NSString *const UserDefaultsIsLogin     = @"isUserLogin";
NSString *const UserDefaultsUserId      = @"userLoginID";
NSString *const UserDefaultsUserPhone   = @"userPhoneNumber";

#pragma mark - 凶猛的数据
NSString *const hostForXM     = @"http://115.29.41.251:88/webservice_art_base.asmx/";
NSString *const startList     = @"StarList";
NSString *const imageHost     = @"http://115.29.41.251/";
NSString *const startArtDetail= @"WorkDetailByWorkId";
NSString *const getArtistInfo = @"GetArtistInforById";
NSString *const getMarketTotalIndex = @"GetMarketTotalIndex";
NSString *const getQuestionStatus   = @"GetQuestionStatus";
NSString *const getQuestions        = @"GetQuestions";
NSString *const answerQuestion      = @"AnswerQuestion";
NSString *const getQuestionlIndex   = @"GetQuestionlIndex";
NSString *const getAddStore        = @"AddStore";
NSString *const addCom             = @"AddCom";
NSString *const changePortal       = @"ChangePortal";
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

+ (NSString *)renrenMainImagePath{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [cache objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:@"renrenMainImages"]]) {
            [fileManager createDirectoryAtPath:[cachePath stringByAppendingPathComponent:@"renrenMainImages"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        string = [cachePath stringByAppendingPathComponent:@"renrenMainImages"];
    });
    return string;
}
+ (NSString *)artistAvatarImagePath{
    static NSString *string;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [cache objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:@"artistAvatarImages"]]) {
            [fileManager createDirectoryAtPath:[cachePath stringByAppendingPathComponent:@"artistAvatarImages"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        string = [cachePath stringByAppendingPathComponent:@"artistAvatarImages"];
    });
    return string;
}

+ (BOOL)isUserLogin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [userDefaults boolForKey:UserDefaultsIsLogin];
    return isLogin;
}

+ (NSString *)currentUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:UserDefaultsUserId];
    return userID;
}

+ (NSString *)currentUserPhoneNumber{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userPhoneNumber = [userDefaults objectForKey:UserDefaultsUserPhone];
    return userPhoneNumber;
}

+ (BOOL)isFileExistsAt:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)writeData:(NSData *)data toFilePath:(NSString *)path{
    NSString *pathWithoutFileName = [path stringByDeletingLastPathComponent];
    LCYLOG(@"path without file name = %@",pathWithoutFileName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:pathWithoutFileName isDirectory:&isDir]) {
        LCYLOG(@"creating folder");
        [fileManager createDirectoryAtPath:pathWithoutFileName withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [data writeToFile:path atomically:YES];
}
@end
