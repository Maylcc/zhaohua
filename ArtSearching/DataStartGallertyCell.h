//
//  DataStartGallertyCell.h
//  ArtSearching
//
//  Created by developer on 14-4-18.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataStartGallertyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexLbl;
@property (weak, nonatomic) IBOutlet UIImageView *authordImage;
@property (weak, nonatomic) IBOutlet UILabel *authordName;
@property (weak, nonatomic) IBOutlet UILabel *numOfArts;
@property (weak, nonatomic) IBOutlet UILabel *lookNums;
@property (weak, nonatomic) IBOutlet UILabel *collectionNums;
@property (weak, nonatomic) IBOutlet UIImageView *dataImage;

@end
