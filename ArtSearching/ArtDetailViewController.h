//
//  ArtDetailViewController.h
//  ArtSearching
//
//  Created by developer on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *contentTableView;
}

-(id)initWithWorkID:(NSString *)userid andWorkUrl:(NSString *)workUrl withBundleName:(NSString *)bundleName;
@end
