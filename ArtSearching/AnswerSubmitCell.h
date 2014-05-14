//
//  AnswerSubmitCell.h
//  ArtSearching
//
//  Created by developer on 14-5-14.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SubmitAnswerDelegate <NSObject>
- (void)submitButtonTouchUpInside;
@end
@interface AnswerSubmitCell : UITableViewCell
@property (nonatomic,strong)id<SubmitAnswerDelegate> submitDelegate;
- (IBAction)submitAction:(id)sender;
@end
