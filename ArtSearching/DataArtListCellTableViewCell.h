//
//  DataArtListCellTableViewCell.h
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataArtListCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexLbl;
@property (weak, nonatomic) IBOutlet UILabel *artNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *authodLbl;
@property (weak, nonatomic) IBOutlet UILabel *lookNums;
@property (weak, nonatomic) IBOutlet UILabel *collectNum;
@property (weak, nonatomic) IBOutlet UIImageView *dataImg;
@property (weak, nonatomic) IBOutlet UIImageView *artImage;

@end
