//
//  LCYCommon.h
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

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

CA_EXTERN NSString *const hostURLPrefix;    /**< 接口URL前缀 */
CA_EXTERN NSString *const ActivityList;     /**< 展览列表 */
//CA_EXTERN NSString *const ActivityOrganizationListSearchByKey;      /**< 搜索 */
CA_EXTERN NSString *const Login;            /**< 登录 */

#pragma mark - UserDefaults
CA_EXTERN NSString *const UserDefaultsIsLogin;                      /**< 是否已经登陆 */
CA_EXTERN NSString *const UserDefaultsUserId;                       /**< 已经登录的用户名（需要另行检查是否已经登录）*/

#pragma mark - 凶猛的数据
CA_EXTERN NSString *const hostForXM;
CA_EXTERN NSString *const startList;
CA_EXTERN NSString *const imageHost;
CA_EXTERN NSString *const startArtDetail;
CA_EXTERN NSString *const getArtistInfo;
@end
