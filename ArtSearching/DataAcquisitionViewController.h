//
//  DataAcquisitionViewController.h
//  ArtSearching
//
//  Created by developer on 14-4-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataAcquisitionViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *ploatScroll;

@property (weak, nonatomic) IBOutlet UIImageView *scrollImage;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dateType;

- (id)initWithInitialDataDic:(NSDictionary *)dataDic;
- (IBAction)selectDateType:(id)sender;
@end
