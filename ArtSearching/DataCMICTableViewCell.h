//
//  DataCMICTableViewCell.h
//  ArtSearching
//
//  Created by developer on 14-4-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetHelperDelegate.h"
@class NetHelper;
@protocol isCMICDown <NSObject>

- (void)completeDownCMICData:(BOOL)isSuccess withResponseDic:(NSDictionary *)responseDic;

@end

@interface DataCMICTableViewCell : UITableViewCell<NetHelperDelegate,NSXMLParserDelegate>
{
    NetHelper *netHelper;
}
@property (nonatomic,strong) id<isCMICDown>delegate;
@property (weak, nonatomic) IBOutlet UILabel *indexNum;
@property (weak, nonatomic) IBOutlet UIImageView *arrowPic;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitProgress;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@end
