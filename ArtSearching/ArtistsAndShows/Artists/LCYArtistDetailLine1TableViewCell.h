//
//  LCYArtistDetailLine1TableViewCell.h
//  ArtSearching
//
//  Created by eagle on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCYArtistDetailLine1TableViewCell : UITableViewCell
/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
/**
 *  教育程度
 */
@property (weak, nonatomic) IBOutlet UILabel *artistEducationLabel;
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *icyImage;

@end
