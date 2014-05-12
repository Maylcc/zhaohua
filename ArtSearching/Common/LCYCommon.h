//
//  LCYCommon.h
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height - 568) ? NO : YES)

@interface LCYCommon : NSObject

/**
 *  向服务器发送POST请求
 *
 *  @param api        接口名
 *  @param parameters 所需参数
 *  @param delegate   代理，需要解析xml
 */
+ (void)postRequestWithAPI:(NSString *)api
                parameters:(NSDictionary *)parameters
           successDelegate:(id<NSXMLParserDelegate>)delegate
               failedBlock:(void (^)(void))failed;
/**
 *  检查是否有网络连接
 *
 *  @return 是或否
 */
+ (BOOL)networkAvailable;
/**
 *  显示透明指示层
 *
 *  @param view 用于显示的界面
 *  @param tips 指示层的提示信息
 */
+ (void)showHUDTo:(UIView *)view
         withTips:(NSString *)tips;
/**
 *  隐藏特定界面的透明指示层
 *
 *  @param view 特定的界面
 */
+ (void)hideHUDFrom:(UIView *)view;
/**
 *  将图片压缩为NSdata，用于上传头像
 *
 *  @param comImage 原始图片
 *
 *  @return 压缩后的数据
 */
+ (NSData*)compressImage:(UIImage*)comImage;
/**
 *  人人策画
 *
 *  @return 所有图片的下载路径文件夹
 */
+ (NSString *)renrenMainImagePath;

/**
 *  艺术家头像
 *
 *  @return 头像文件夹地址
 */
+ (NSString *)artistAvatarImagePath;

/**
 *  文件是否存在
 *
 *  @param path 文件地址
 *
 *  @return 是否存在
 */
+ (BOOL)isFileExistsAt:(NSString *)path;

/**
 *  用户是否已经登录
 *
 *  @return 是或否
 */
+ (BOOL)isUserLogin;

/**
 *  返回当前用户ID，需要自己先判断是否已经登录
 *
 *  @return 用户ID字符串
 */
+ (NSString *)currentUserID;

CA_EXTERN NSString *const hostURLPrefix;    /**< 接口URL前缀 */
CA_EXTERN NSString *const hostIMGPrefix;    /**< 图片地址前缀 */
CA_EXTERN NSString *const ActivityList;     /**< 展览列表 */
//CA_EXTERN NSString *const ActivityOrganizationListSearchByKey;      /**< 搜索 */
CA_EXTERN NSString *const Login;            /**< 登录 */
CA_EXTERN NSString *const RegisterGetValidate;      /**< 获取验证码 */
CA_EXTERN NSString *const RegisterOne;      /**< 注册第一步：发送手机号与验证码 */
CA_EXTERN NSString *const RegisterTwo;      /**< 注册第二步：发送密码 */
CA_EXTERN NSString *const UploadFile;       /**< 注册第三步：上传头像图片 */
CA_EXTERN NSString *const RegisterThree;    /**< 注册第三步：上传姓名，头像信息 */
CA_EXTERN NSString *const GetAllExhibition; /**< 主页：获得所有展览 */
CA_EXTERN NSString *const GetArtistList;    /**< 所有艺术家 */
CA_EXTERN NSString *const GetArtistInforById;       /**< 根据ID获取艺术家详细信息 */
CA_EXTERN NSString *const GetOwnExhibition; /**< 我的展览 */
CA_EXTERN NSString *const GetApplyerInfo;   /**< 我的展览-申请者信息 */
CA_EXTERN NSString *const WorkListCategory; /**< 获取分类信息 */
CA_EXTERN NSString *const WorkListCategoryById;     /**< 获取分类信息（二级分类） */



#pragma mark - UserDefaults
CA_EXTERN NSString *const UserDefaultsIsLogin;                      /**< 是否已经登陆 */
CA_EXTERN NSString *const UserDefaultsUserId;                       /**< 已经登录的用户名（需要另行检查是否已经登录）*/

#pragma mark - 凶猛的数据
CA_EXTERN NSString *const hostForXM;
CA_EXTERN NSString *const startList;
CA_EXTERN NSString *const imageHost;
CA_EXTERN NSString *const startArtDetail;
CA_EXTERN NSString *const getArtistInfo;
CA_EXTERN NSString *const getMarketTotalIndex;
CA_EXTERN NSString *const getQuestionStatus;
@end
