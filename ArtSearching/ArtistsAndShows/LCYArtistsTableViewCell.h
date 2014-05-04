//
//  LCYArtistsTableViewCell.h
//  ArtSearching
//
//  Created by eagle on 14-5-1.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCYArtistsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icyImage;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistWorksLabel;

@end
