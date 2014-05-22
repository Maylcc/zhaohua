//
//  LCYUserInformationViewController.h
//  ArtSearching
//
//  Created by Licy on 14-4-22.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCYUserInfoStatus) {
    LCYUserInfoStatusCarePics,      /**< 作品收藏 */
    LCYUserInfoStatusOthers         /**< 关注艺术家和画廊 */
};

@interface LCYUserInformationViewController : UIViewController
@end
@interface LCYUserInfomationCollectionCellHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *icyLabel;
@end


#pragma mark - 下拉刷新
@class LCYUserInformationRefreshParser;
@protocol LCYUserInformationRefreshParserDelegate <NSObject>
@optional
- (void)pullDownParserDidEnd:(LCYUserInformationRefreshParser *)parser withResultInfo:(NSDictionary *)info;
@end
@interface LCYUserInformationRefreshParser : NSObject<NSXMLParserDelegate>
@property LCYUserInfoStatus currentStatus;
@property (weak, nonatomic) id<LCYUserInformationRefreshParserDelegate>delegate;
@end

#pragma mark - 上拉加载更多
@class LCYUserInformationLoadMoreParser;
@protocol LCYUserInformationLoadMoreParserDelegate <NSObject>
@optional
- (void)pushUpParserDidEnd:(LCYUserInformationLoadMoreParser *)parser withResultInfo:(NSDictionary *)info;
@end
@interface LCYUserInformationLoadMoreParser : NSObject<NSXMLParserDelegate>
@property LCYUserInfoStatus currentStatus;
@property (weak, nonatomic) id<LCYUserInformationLoadMoreParserDelegate>delegate;
@end
