//
//  ShareHelper.m
//  ArtSearching
//
//  Created by developer on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ShareHelper.h"
#import "UMSocial.h"
@interface ShareHelper()
@end
@implementation ShareHelper
static ShareHelper *helper;
+ (ShareHelper *)initialInstance
{
    @synchronized(self)
    {
        if(helper == nil)
        {
            [WXApi registerApp:@"wx15be7f75b99c4f20"];
            return [[self alloc] init];
        }
    }
    return helper;
}

+ (id)alloc
{
    @synchronized(self)
    {
        helper = [super alloc];
        return helper;
    }
    return nil;
}

- (BOOL)isWXInstalled
{
    if([WXApi isWXAppInstalled])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)requestONWX:(SharedType)type
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"好友向您推荐应用\"找画\"";
    message.description = @"这个应用是摄影、艺术爱好者的天堂";
    [message setThumbImage:[UIImage imageNamed:@"iconForWeixin.png"]];
    int _scene ;
    if(type == SharedTypeWX)
    {
        _scene = WXSceneSession;
        
    }
    else
    {
        _scene = WXSceneTimeline;
    }
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = @"http://www.qq.com";
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)weiBoShare:(SharedType)type
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
    
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = @"分享网页标题";
    webpage.description = [NSString stringWithFormat:@"分享网页内容简介-%.0f", [[NSDate date] timeIntervalSince1970]];
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]];
    webpage.webpageUrl = @"http://sina.cn?a=1";
    message.mediaObject = webpage;
    return message;
}

-(void)shareViewBtnCLick:(UIButton *)button
{
    int tag = button.tag ;
    //设置分享内容和回调对象
    if (tag == 0){
        //微信会话
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享到微信－找画APP" shareImage:[UIImage imageNamed:@"Icon"] socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else if (tag == 1){
        //朋友圈分享
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享到朋友圈－找画APP" shareImage:[UIImage imageNamed:@"Icon"] socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else if (tag == 2){
        //新浪微博
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享到新浪微博－找画APP" shareImage:[UIImage imageNamed:@"Icon"] socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else if (tag == 3){
        //复制链接地址
        [[UIPasteboard generalPasteboard] setString:@"找画URL"];
    }
    
}

@end
