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
