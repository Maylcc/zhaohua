//
//  LCYMyCollectionCell.m
//  ArtSearching
//
//  Created by eagle on 14-5-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYMyCollectionCell.h"

@interface LCYMyCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;

@end

@implementation LCYMyCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)checkOn{
    [self.checkMarkImageView setHidden:NO];
}

- (void)checkOff{
    [self.checkMarkImageView setHidden:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
