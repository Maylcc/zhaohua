//
//  AnswerQuestionViewController.m
//  ArtSearching
//
//  Created by developer on 14-5-13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "AnswerQuestionViewController.h"
#import "AnswerSelectCellTableViewCell.h"
@interface AnswerQuestionViewController ()<SelectCellAnswerDelegate>
{
    NSMutableDictionary *answerIndexDic;
    BOOL isFirstRunForTableView;
}
@end

@implementation AnswerQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        answerIndexDic = [[NSMutableDictionary alloc] init];
        isFirstRunForTableView = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isFirstRunForTableView = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *answerCell = @"ZXYAnswerCellIdentifier";
    AnswerSelectCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:answerCell];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AnswerSelectCellTableViewCell class]) owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[AnswerSelectCellTableViewCell class]])
            {
                cell = (AnswerSelectCellTableViewCell *)oneObject;
                cell.delegate = self;
            }
        }
    }
   
    cell.answerForButtonTitle = [NSArray arrayWithObjects:@"好",@"还可以", nil];
    cell.questionID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [cell selectAnswerWithHistory:[(NSNumber *)[answerIndexDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] integerValue]];
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146;
}

#pragma mark - 按下答案的代理方法
- (void)selectCellAnswerDelegate:(NSInteger)index withQuestionID:(NSString *)quesID
{
    [answerIndexDic setObject:[NSNumber numberWithInteger:index] forKey:quesID];
    
}
@end
