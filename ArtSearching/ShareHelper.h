//
//  ShareHelper.h
//  ArtSearching
//
//  Created by developer on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
/**
 *  微信返回到应用代理
 *
 */
@protocol ResponseForShared<NSObject>
/*! @brief 用于获得分享结果是不是成功了
 *
 */
- (void)WXShareResponseFlag:(int)flag;
@end

typedef enum
{
    SharedTypeWX = 0,
    SharedTypePY = 1,
}SharedType;
@interface ShareHelper : NSObject<WXApiDelegate>

@property (nonatomic,strong)id<ResponseForShared>wxResponseDelegate;/**< 微信分享response代理*/

+ (ShareHelper *)initialInstance;
/*! @brief 微信分享 type为1表示是朋友圈 type为0表示聊天分享
 
 */
- (void)requestONWX:(SharedType)type;

/*! @brief 判断微信有没有安装
 *  @return 安装返回YES，没有安装返回NO
 */
- (BOOL)isWXInstalled;
@end
