//
//  DataListViewController.h
//  ArtSearching
//
//  Created by developer on 14-4-17.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "LCYCommon.h"
@interface DataListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *dataTableV;
}
@end
