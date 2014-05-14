//
//  AnswerSelectCellTableViewCell.m
//  ArtSearching
//
//  Created by developer on 14-5-13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "AnswerSelectCellTableViewCell.h"
#import "QuestionAnswerID.h"
@implementation AnswerSelectCellTableViewCell
@synthesize questionID = _questionID;
@synthesize answerForButtonTitle = _answersForButtonTitle;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self setButtonTitles:self.answerForButtonTitle];
}

- (IBAction)selectAnswer:(id)sender
{
    UIButton *selectButton = (UIButton *)sender;
    for(UIButton *button in self.answerButtons)
    {
        if(button != selectButton)
        {
            [button setSelected:NO];
        }
        else
        {
            [button setSelected:YES];
        }
    }
    NSInteger index = [self.answerButtons indexOfObject:selectButton];
    if([self.delegate respondsToSelector:@selector(selectCellAnswerDelegate:withQuestionID:)])
    {
        [self.delegate selectCellAnswerDelegate:index+1 withQuestionID:self.questionID];
    }
}

- (void)setButtonTitles:(NSArray *)titleS
{
    for(int i = 0 ;i<titleS.count;i++)
    {
        QuestionAnswerID *answer = [titleS objectAtIndex:i];
        UIButton *currentButton = [self.answerButtons objectAtIndex:i];
        [currentButton setTitle:answer.questionAnswer forState:UIControlStateNormal];
    }
    
    if(titleS.count == 2)
    {
        for(int i = 0;i<self.answerButtons.count;i++)
        {
            if(i == 2)
            {
                UIButton *button = [self.answerButtons objectAtIndex:2];
                [button setHidden:YES];
            }
        }
    }
}

- (void)selectAnswerWithHistory:(NSInteger)stringIndex
{
    if(stringIndex == 0)
    {
        for(UIButton *button in self.answerButtons)
        {
            [button setSelected:NO];
        }
        return;
    }
    UIButton *button = [self.answerButtons objectAtIndex:stringIndex-1];
    [self selectAnswer:button];
}

@end
