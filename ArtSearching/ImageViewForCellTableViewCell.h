//
//  ImageViewForCellTableViewCell.h
//  ArtSearching
//
//  Created by developer on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol showBigImage <NSObject>
-(void)showBigImageDelegate;
@end
@interface ImageViewForCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (nonatomic,strong) id<showBigImage>delegate;

@end
