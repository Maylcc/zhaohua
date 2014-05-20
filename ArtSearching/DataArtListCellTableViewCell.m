//
//  DataArtListCellTableViewCell.m
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DataArtListCellTableViewCell.h"
#import "ZXYFileOperation.h"
#import "ArtDetail.h"
@interface DataArtListCellTableViewCell()

@end
@implementation DataArtListCellTableViewCell
- (void)awakeFromNib
{
    // Initialization code
    UITapGestureRecognizer *tapDataImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDataImage:)];
    self.dataImg.userInteractionEnabled = YES;
    [self.dataImg addGestureRecognizer:tapDataImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)showDataImage:(UIGestureRecognizer *)ges
{
    if([self.delegate respondsToSelector:@selector(drawPointLine:withType:)])
    {
       [self.delegate drawPointLine:self.artDetail.id_Art withType:DrawArtsPoint];
    }
}
@end
