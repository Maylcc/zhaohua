//
//  ArtDetailContentArtCell.m
//  ArtSearching
//
//  Created by developer on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ArtDetailContentArtCell.h"
#import "LCYArtistDetailViewController.h"
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
    LCYArtistDetailViewController *artistDVC = [[LCYArtistDetailViewController alloc] init];
//    artistDVC.artistID = artistID;
//    artistDVC.title = artistName;
//    [self.navigationController pushViewController:artistDVC animated:YES];
}
@end
