//
//  LCYArtistDetailLine2TableViewCell.m
//  ArtSearching
//
//  Created by eagle on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYArtistDetailLine2TableViewCell.h"

@implementation LCYArtistDetailLine2TableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)shareButtonPressed:(id)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(sharedButtonDidClicked)]) {
        [self.delegate sharedButtonDidClicked];
    }
}

@end
