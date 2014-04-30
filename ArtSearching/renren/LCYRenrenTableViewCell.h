//
//  LCYRenrenTableViewCell.h
//  ArtSearching
//
//  Created by 李超逸 on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCYRenrenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel; /**< 题目 */

@property (weak, nonatomic) IBOutlet UILabel *host;/**< 策展人 */

@property (weak, nonatomic) IBOutlet UILabel *participant;/**< 参展人 */

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;/**< 时间 */

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;/**< 详情 */

@property (weak, nonatomic) IBOutlet UILabel *commentCount;/**< 评论次数 */

@property (weak, nonatomic) IBOutlet UILabel *admireCount;/**< 欣赏次数 */

@property (weak, nonatomic) IBOutlet UIImageView *hostAvatarImageView;/**< 策展人头像 */

@property (weak, nonatomic) IBOutlet UIImageView *exhibitionImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *exhibitionImageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *exhibitionImageThree;


@end
