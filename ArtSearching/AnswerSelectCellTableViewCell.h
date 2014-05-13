//
//  AnswerSelectCellTableViewCell.h
//  ArtSearching
//
//  Created by developer on 14-5-13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectCellAnswerDelegate <NSObject>
- (void)selectCellAnswerDelegate:(NSInteger)index withQuestionID:(NSString *)quesID;
@end
@interface AnswerSelectCellTableViewCell : UITableViewCell
{
    NSString *_questionID;
    NSArray  *_answersForButtonTitle;
}
@property (strong, nonatomic) id<SelectCellAnswerDelegate>delegate;
@property (strong, nonatomic) NSArray *answerForButtonTitle;
@property (strong, nonatomic) NSString *selectIndex;
@property (strong, nonatomic) NSString *questionID;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (weak, nonatomic) IBOutlet UILabel *titleIndex;
@property (weak, nonatomic) IBOutlet UITextView *questionTitle;
- (void)selectAnswerWithHistory:(NSInteger)stringIndex;
- (IBAction)selectAnswer:(id)sender;

@end
