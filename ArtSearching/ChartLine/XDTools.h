//
//  XDTools.h
//  XDCommonApp
//
//  Created by XD-XY on 2/12/14.
//  Copyright (c) 2014 XD-XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCYAppdelegate.h"
#import "XDHeader.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "JSONKit.h"
#import "XDTools.h"
#import "MBProgressHUD.h"
@interface XDTools : NSObject<UIAlertViewDelegate>

DEFINE_SINGLETON_FOR_HEADER(XDTools)

+ (NSDictionary *) JSonFromString: (NSString*)result;
+ (LCYAppDelegate *)appDelegate;
+ (BOOL)NetworkReachable;

+ (void)showProgress:(UIView *) view;
+ (void)showProgress:(UIView *) view showText:(NSString*)text;
+ (void) showTips:(NSString *)text toView:(UIView *)view;
+ (void)showSuccessTips:(NSString *)text toView:(UIView *)view;
+ (void)showErrorTips:(NSString *)text toView:(UIView *)view;
+ (void)hideProgress:(UIView *)view;
+ (NSData*)compressImage:(UIImage*)comImage;

- (void)checkVersion:(UIViewController *)viewController isShowAlert:(BOOL)isShow;

+ (ASIHTTPRequest*)getRequestWithDict:(NSDictionary *)dict API:(NSString *)api;
+ (ASIFormDataRequest*)postRequestWithDict:(NSString *)body API:(NSString *)api;
+(CGRect )xyAutoSizeOfWidget:(UILabel *)widget andSize:(CGSize)size andtextFont:(CGFloat )sizefont;

+ (void)fillImageView:(UIImageView *)imageView withImageFromURL:(NSString*)url  keyUrl:(NSString*)keyUrl;
@end
