//
//  AnswerSubmitCell.m
//  ArtSearching
//
//  Created by developer on 14-5-14.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "AnswerSubmitCell.h"

@implementation AnswerSubmitCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submitAction:(id)sender
{
    if([self.submitDelegate respondsToSelector:@selector(submitButtonTouchUpInside)])
    {
        [self.submitDelegate submitButtonTouchUpInside];
    }
}
@end
