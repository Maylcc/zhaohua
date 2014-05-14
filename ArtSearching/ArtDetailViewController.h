//
//  ArtDetailViewController.h
//  ArtSearching
//
//  Created by developer on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewForCellTableViewCell.h"
@interface ArtDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,showBigImage>
{
    IBOutlet UITableView *contentTableView;
}

/**
  实例化方法传入作品id 还有大图的url
 */
-(id)initWithWorkID:(NSString *)userid andWorkUrl:(NSString *)workUrl withBundleName:(NSString *)bundleName;
@end
