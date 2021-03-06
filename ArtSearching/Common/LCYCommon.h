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
 *  获取当前用户记录的密码
 *
 *  @return 密码字符串
 */
+ (NSString *)userPassword;
/**
 *  修改当前用户的密码
 *
 *  @param password 新密码
 *
 *  @return 修改成功或失败
 */
+ (BOOL)changeUserPassword:(NSString *)password;

/**
 *  返回当前用户ID，需要自己先判断是否已经登录
 *
 *  @return 用户ID字符串
 */
+ (NSString *)currentUserID;

/**
 *  返回当前用户绑定的电话号码
 *
 *  @return 电话号码字符串
 */
+ (NSString *)currentUserPhoneNumber;
/**
 *  修改当前用户手机号码
 *
 *  @param phoneNumber 新手机号
 *
 *  @return 是否修改成功
 */
+ (BOOL)changeUserPhoneNumber:(NSString *)phoneNumber;

/**
 *  将Data写入到文件，文件路径为Path，自动根据文件路径创建文件夹
 *
 *  @param data 待写入的数据
 *  @param path 文件路径
 */
+ (void)writeData:(NSData *)data toFilePath:(NSString *)path;

/**
 *  返回图片的缩略图位置
 *
 *  @param path 原图位置
 *
 *  @return 缩略图路径
 */
+ (NSString *)thumbPathForImagePath:(NSString *)path;

CA_EXTERN NSString *const hostURLPrefix;    /**< 接口URL前缀 */
CA_EXTERN NSString *const hostIMGPrefix;    /**< 图片地址前缀 */
CA_EXTERN NSString *const ActivityList;     /**< 展览列表 */
//CA_EXTERN NSString *const ActivityOrganizationListSearchByKey;      /**< 搜索 */
CA_EXTERN NSString *const Login;            /**< 登录 */
CA_EXTERN NSString *const GetUserInfo;      /**< 获得用户详细信息，头像，简介，用户名，ID */
CA_EXTERN NSString *const RegisterGetValidate;      /**< 获取验证码 */
CA_EXTERN NSString *const RegisterOne;      /**< 注册第一步：发送手机号与验证码 */
CA_EXTERN NSString *const RegisterTwo;      /**< 注册第二步：发送密码 */
CA_EXTERN NSString *const UploadFile;       /**< 注册第三步：上传头像图片 */
CA_EXTERN NSString *const RegisterThree;    /**< 注册第三步：上传姓名，头像信息 */
CA_EXTERN NSString *const GetAllExhibition; /**< 主页：获得所有展览 */
CA_EXTERN NSString *const GetArtistList;    /**< 所有艺术家 */
CA_EXTERN NSString *const GetGalleryList;   /**< 所有画廊 */
CA_EXTERN NSString *const GetArtistInforById;       /**< 根据ID获取艺术家详细信息 */
CA_EXTERN NSString *const GetGalleryInfoById;       /**< 根据ID获取画廊详细信息 */
CA_EXTERN NSString *const GetOwnExhibition; /**< 我的展览 */
CA_EXTERN NSString *const GetApplyerInfo;   /**< 我的展览-申请者信息 */
CA_EXTERN NSString *const WorkListCategory; /**< 获取分类信息 */
CA_EXTERN NSString *const WorkListCategoryById;     /**< 获取分类信息（二级分类） */
CA_EXTERN NSString *const GetFavoriteArtWorks;      /**< 获取所有收藏作品 */
CA_EXTERN NSString *const GetArtworkListByArtistId; /**< 分页获取此艺术家的所有作品 */
CA_EXTERN NSString *const GetArtworkListByGallryId; /**< 分页获取此画廊的所有作品 */



#pragma mark - UserDefaults
CA_EXTERN NSString *const UserDefaultsIsLogin;              /**< 是否已经登陆 */
CA_EXTERN NSString *const UserDefaultsUserId;               /**< 已经登录的用户名（需要另行检查是否已经登录）*/
CA_EXTERN NSString *const UserDefaultsUserPhone;            /**< 已经登录的用户手机号（需要另行检查是否已经登录） */

#pragma mark - 加密
CA_EXTERN NSString *const EncryptionKey;        /**< AES加密-密钥 */

#pragma mark - 凶猛的数据
CA_EXTERN NSString *const hostForXM;  /**< 接口URL前缀 */
CA_EXTERN NSString *const startList;  /**< 星级接口 */
CA_EXTERN NSString *const imageHost;  /**< 获取图片前缀 */
CA_EXTERN NSString *const startArtDetail;  /**< 星级作品详细信息 */
CA_EXTERN NSString *const getArtistInfo;  /**< 作者详细信息 */
CA_EXTERN NSString *const getMarketTotalIndex;  /**< 市场指数 */
CA_EXTERN NSString *const getQuestionStatus;  /**< 回答问题状态 */
CA_EXTERN NSString *const getQuestions;  /**< 获取问题 */
CA_EXTERN NSString *const answerQuestion;/**< 回答问题URL*/
CA_EXTERN NSString *const getQuestionlIndex;/**< 取得相关问题的指数信息 */
CA_EXTERN NSString *const getAddStore      ; /** < 关注 */
CA_EXTERN NSString *const addCom     ;   /** < 评论 */
CA_EXTERN NSString *const changePortal;  /** <改变头像 */
CA_EXTERN NSString *const changePassword; /** <修改密码 */
CA_EXTERN NSString *const changePhone; /** <修改电话 */
@end
