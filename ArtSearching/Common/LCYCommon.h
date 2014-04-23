//
//  LCYCommon.h
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCYCommon : NSObject

CA_EXTERN NSString *const hostURLPrefix;    /**< 接口URL前缀 */
CA_EXTERN NSString *const ActivityList;     /**< 展览列表 */
CA_EXTERN NSString *const ActivityOrganizationListSearchByKey;      /**< 搜索 */

#pragma mark - 凶猛的数据
CA_EXTERN NSString *const hostForXM;
CA_EXTERN NSString *const startList;
CA_EXTERN NSString *const imageHost;
CA_EXTERN NSString *const startArtDetail;
CA_EXTERN NSString *const getArtistInfo;
@end
