//
//  LCYMyCollectionCell.h
//  ArtSearching
//
//  Created by eagle on 14-5-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCYMyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icyImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewerCountLabel;
- (void)checkOn;
- (void)checkOff;
@end
