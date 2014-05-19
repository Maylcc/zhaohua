//
//  DataStartGallertyCell.m
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DataStartGallertyCell.h"

@implementation DataStartGallertyCell

- (void)awakeFromNib
{
    // Initialization code
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDataImage:)];
    self.dataImage.userInteractionEnabled = YES;
    [self.dataImage addGestureRecognizer:tapGes];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDataImage:(UIGestureRecognizer *)ges
{
    DrawPointType drawType;
    if(self.isArtist)
    {
        drawType = DrawArtistsPoint
        ;
    }
    else
    {
        drawType = DrawGalleryPoint;
    }
    if([self.delegate respondsToSelector:@selector(drawPointLine:withType:)])
    {
        [self.delegate drawPointLine:self.artDetail withType:drawType];
    }
}
@end
