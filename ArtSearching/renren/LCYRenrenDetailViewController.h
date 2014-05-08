//
//  LCYRenrenDetailViewController.h
//  ArtSearching
//
//  Created by eagle on 14-5-8.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCYDataModels.h"

@interface LCYRenrenDetailViewController : UIViewController
/**
 *  展览基本信息，从上级页面获得
 */
@property (strong, nonatomic) LCYExhibitions *exhibitionInfo;
@end

@interface LCYRenrenDetailFirstLineCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icyImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *attenderLabel;
@end

@interface LCYRenrenDetailSecondLineCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextView *icyTextView;
@end

@interface LCYRenrenDetailFirstHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
