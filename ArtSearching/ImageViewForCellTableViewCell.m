//
//  ImageViewForCellTableViewCell.m
//  ArtSearching
//
//  Created by developer on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ImageViewForCellTableViewCell.h"

@implementation ImageViewForCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBGImage:)];
    [self.bigImageView setUserInteractionEnabled:YES];
    [self.bigImageView addGestureRecognizer:tapGes];
}

- (void)showBGImage:(UIGestureRecognizer *)ges
{
    if([self.delegate respondsToSelector:@selector(showBigImageDelegate)])
    {
        [self.delegate showBigImageDelegate];
    }
}

@end
