//
//  XDTools.m
//  XDCommonApp
//
//  Created by XD-XY on 2/12/14.
//  Copyright (c) 2014 XD-XY. All rights reserved.
//

#import "XDTools.h"
#import "Reachability.h"
#import "XDHeader.h"
#define version_tag 1000

@implementation XDTools
DEFINE_SINGLETON_FOR_CLASS(XDTools)


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

+ (NSData*)compressTalkImage:(UIImage*)comImage
{
    CGFloat compression = 0.5f;
    CGFloat maxCompression = 0.2f;
    int maxFileSize = 80*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(comImage, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(comImage, compression);
    }
    return imageData;
}
+ (NSDictionary *)JSonFromString:(NSString* )result
{
    NSDictionary *json = [result objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return json;
    
}

+ (LCYAppDelegate *)appDelegate
{
    return (LCYAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(BOOL)NetworkReachable
{
    NetworkStatus wifi = [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus];
    NetworkStatus gprs = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if(wifi == NotReachable && gprs == NotReachable)
    {
        return NO;
    }
    return YES;
}

+ (void)showProgress:(UIView *) view
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)showProgress:(UIView *) view showText:(NSString*)text
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
}

+ (void) showTips:(NSString *)text toView:(UIView *)view
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
	[hud show:YES];
	[hud hide:YES afterDelay:1];
}

+ (void)showSuccessTips:(NSString *)text toView:(UIView *)view
{
    
}

+ (void)showErrorTips:(NSString *)text toView:(UIView *)view
{

}

+ (void)hideProgress:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

/***
 **自适应高度和宽度，其中参数widget是你要改变的label,size是定义label的长宽最大值,sizefont这个是字体的大小
 ***/
+(CGRect )xyAutoSizeOfWidget:(UILabel *)widget andSize:(CGSize)size andtextFont:(CGFloat )sizefont
{
    widget.numberOfLines = 0;
    CGRect rect = widget.frame;
    NSLog(@"rect = %f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    if (IOS7){
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:sizefont],NSFontAttributeName,nil];
        CGSize  actualsize =[widget.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        CGRect tmpRect = CGRectMake(rect.origin.x, rect.origin.y, actualsize.width, actualsize.height);
        return tmpRect;
    }else{
        CGSize strSize = [widget.text sizeWithFont:[UIFont systemFontOfSize:sizefont] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        CGRect tmpRect = CGRectMake(rect.origin.x, rect.origin.y, strSize.width, strSize.height);
        return tmpRect;
    }
}

- (void)checkVersion:(UIViewController *)viewController isShowAlert:(BOOL)isShow
{
    
//    NSDictionary *dict = @{};
//    
//    __weak ASIFormDataRequest *request = [XDTools postRequestWithDict:dict API:API_CHECKVERSION];
//    [request setCompletionBlock:^{
//        NSString *responseString = [request responseString];
//        NSDictionary *responseDic = [XDTools  JSonFromString:responseString];
//        DDLOG(@"responseDic:%@", responseDic);
//        NSString *  resultNum = [responseDic objectForKey:@"success_code"];
//        NSDictionary * success_message = [responseDic objectForKey:@"success_message"];
//        int seccesNum = [resultNum intValue];
//        if (seccesNum == 200) {
//            appDownloadUrl = [success_message objectForKey:@"downloadURL"];
//            NSString *version = [success_message objectForKey:@"currentVersion"];
//            NSString * oldversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//            if ([oldversion compare:version] == NSOrderedAscending) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"有新的版本是否更新"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"取消"
//                                                      otherButtonTitles:@"确定", nil];
//                alert.tag = version_tag;
//                [alert show];
//            }else{
//                //这已经是最新的版本
//                if (isShow) {
//                    [XDTools showAlertViewWithTitle:nil msg:@"已经是最新版本" viewController:viewController];
//                }
//            }
//        }
//        else
//        {
//            return ;
//        }
//    }];
//    
//    [request setFailedBlock:^{
//        NSError *error = [request error];
//        DDLOG_CURRENT_METHOD;
//        DDLOG(@"error=%@",error);
//    }];
//    [request startAsynchronous];
    
    UIAlertView * versionAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新的版本" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立即更新",nil];
    versionAlert.tag=version_tag;
    [versionAlert show];
}
//获取soap信息

+ (ASIHTTPRequest*)getRequestWithDict:(NSDictionary *)dict API:(NSString *)api
{
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSMutableString *params = [[NSMutableString alloc] init];
    for (id keys in muDict) {
        [params appendFormat:@"&%@=%@",keys,[muDict objectForKey:keys]];
    }
    NSRange rang = [params rangeOfString:@"?"];
    if(rang.location == NSNotFound){
        NSRange rangAnd = [params rangeOfString:@"&"];
        [params replaceCharactersInRange:rangAnd withString:@"?"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",HOSTURL,api,params];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DDLOG(@"urlStr:%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:12];
    return request;
}

+ (ASIFormDataRequest*)postRequestWithDict:(NSString *)body API:(NSString *)api
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTURL,api]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //设置头

   NSString  *soap = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             " <soap:Header>\n"
                             " <CredentialSoapHeader xmlns=\"http://tempuri.org/\">\n"
                             "<UserName>%@</UserName>\n"
                             " <UserPassword>%@</UserPassword>\n"
                             " </CredentialSoapHeader>"
                             "</soap:Header>"
							 "<soap:Body>\n"
                             "%@"
							 "</soap:Body>\n"
							 "</soap:Envelope>\n",USERNAME,USERPASSWORD,body
							 ];

    NSString *msgLength = [NSString stringWithFormat:@"%d", [soap length]];

    
    [request addRequestHeader:@"Content-Length" value:msgLength];
    [request addRequestHeader:@"Host" value:@"115.29.41.251"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml;charset=utf-8"];
    [request addRequestHeader: @"SOAPAction" value:[NSString stringWithFormat:@"%@%@",NAMESPACE,api]];
    [request appendPostData:[soap dataUsingEncoding:NSUTF8StringEncoding]];

    [request setDefaultResponseEncoding:NSUTF8StringEncoding];//
    
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:12];
//    for (id key in muDict) {
//        [request setPostValue:[muDict objectForKey:key] forKey:key];
//    }
    return request;
}

//异步加载缓存图片

+ (void)fillImageView:(UIImageView *)imageView withImageFromURL:(NSString*)url  keyUrl:(NSString*)keyUrl{
	NSURL *imageURL = [NSURL URLWithString:url];
//	NSString *key = [keyUrl MD5Hash];
//	NSData *data = [FTWCache objectForKey:key];
//	if (data) {
//		UIImage *image = [UIImage imageWithData:data];
//        imageView.image = image;
//	} else {
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
		dispatch_async(queue, ^{
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:data];
            imageView.image = image;
//            if (image != nil) {
//                [FTWCache setObject:data forKey:key];
//                image = [UIImage imageWithData:data];
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    imageView.image = image;
//                });
//            }
			
		});
//	}
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==version_tag){
        if (buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com.hk/"]];
        }
    }
}
@end
