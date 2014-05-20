//
//  DataArtListCellTableViewCell.h
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawPointLineDelegate.h"
#import "StartArtList.h"
@class ArtDetail;
@class ZXYFileOperation;
@interface DataArtListCellTableViewCell : UITableViewCell
{
    ZXYFileOperation *fileOperation;
}
@property (nonatomic,strong) StartArtList *artDetail;
@property (weak, nonatomic) IBOutlet UILabel *indexLbl;
@property (weak, nonatomic) IBOutlet UILabel *artNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *authodLbl;
@property (weak, nonatomic) IBOutlet UILabel *lookNums;
@property (weak, nonatomic) IBOutlet UILabel *collectNum;
@property (weak, nonatomic) IBOutlet UIImageView *dataImg;
@property (weak, nonatomic) IBOutlet UIImageView *artImage;
@property (nonatomic,strong)id<DrawPointLineDelegate>delegate;
@property (nonatomic,strong)NSString *cellIndex;
@end
