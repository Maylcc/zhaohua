//
//  ArtDetailContentArtCell.m
//  ArtSearching
//
//  Created by developer on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ArtDetailContentArtCell.h"
#import "LCYArtistDetailViewController.h"
@interface ArtDetailContentArtCell()
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@end

@implementation ArtDetailContentArtCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toAuthodDetail:(id)sender
{
    if([self.delegate respondsToSelector:@selector(artToAuthorDelegateWithID:)])
    {
        [self.delegate artToAuthorDelegateWithID:self.indexNum];
    }
}

- (IBAction)actionForSharing:(id)sender
{
    if([self.delegate respondsToSelector:@selector(toShareWithWXWBView)])
    {
        [self.delegate toShareWithWXWBView];
    }
}

- (IBAction)actionCollect:(id)sender
{
    if([self.delegate respondsToSelector:@selector(payAttention)])
    {
        [self.delegate payAttention];
    }

}

- (IBAction)addComment:(id)sender
{
    if([self.delegate respondsToSelector:@selector(addComment)])
    {
        [self.delegate addComment];
    }
}
@end
