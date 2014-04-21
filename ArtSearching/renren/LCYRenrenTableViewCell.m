//
//  LCYRenrenTableViewCell.m
//  ArtSearching
//
//  Created by 李超逸 on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRenrenTableViewCell.h"

@implementation LCYRenrenTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions
/**
 *  评论
 *
 *  @param sender 按钮
 */
- (IBAction)commentButtonPressed:(id)sender {
    NSLog(@"comment button pressed");
}
/**
 *  欣赏
 *
 *  @param sender 按钮
 */
- (IBAction)enjoyButtonPressed:(id)sender {
    NSLog(@"enjoy button pressed");
}
/**
 *  分享
 *
 *  @param sender 按钮
 */
- (IBAction)shareButtonPressed:(id)sender {
    NSLog(@"share button pressed");
}


@end
