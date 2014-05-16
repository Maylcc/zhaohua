//
//  ShareHelper.m
//  ArtSearching
//
//  Created by developer on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ShareHelper.h"
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

@end
