//
//  LCYArtistDetailLine2TableViewCell.h
//  ArtSearching
//
//  Created by eagle on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCYArtistDetailLine2TableViewCellDelegate <NSObject>
@optional
- (void)sharedButtonDidClicked;
@end

@interface LCYArtistDetailLine2TableViewCell : UITableViewCell
@property (weak, nonatomic) id<LCYArtistDetailLine2TableViewCellDelegate>delegate;
@end
