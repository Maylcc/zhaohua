//
//  AnswerQuestionViewController.h
//  ArtSearching
//
//  Created by developer on 14-5-13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerQuestionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tableV;
}
- (id)initWithQuestionArray:(NSArray *)questionArr;
@end
