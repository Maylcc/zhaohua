//
//  LCYShowDetailLine2TableViewCell.h
//  ArtSearching
//
//  Created by eagle on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCYShowDetailLine2TableViewCellDelegate <NSObject>
@optional
- (void)sharedButtonDidClicked;
@end

@interface LCYShowDetailLine2TableViewCell : UITableViewCell
@property (weak, nonatomic) id<LCYShowDetailLine2TableViewCellDelegate>delegate;
@end
