//
//  AnswerQuestionViewController.m
//  ArtSearching
//
//  Created by developer on 14-5-13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "AnswerQuestionViewController.h"
#import "AnswerSelectCellTableViewCell.h"
#import "AnswerSubmitCell.h"
#import "QuestionAnswerID.h"
#import "QuestionNameID.h"
#import "ZXYProvider.h"
#import "InsertView.h"
#import "LCYCommon.h"
#import "TouchXML.h"
@interface AnswerQuestionViewController ()<SelectCellAnswerDelegate,SubmitAnswerDelegate,InsertViewDoneDelegate>
{
    NSMutableDictionary *answerIndexDic;
    BOOL isFirstRunForTableView;
    NSArray *_questionArr;
    ZXYProvider *dataProvider;
    InsertView *insertView;
}
@property(nonatomic,strong)NSArray *questionArr;
@end

@implementation AnswerQuestionViewController
@synthesize questionArr = _questionArr;
- (id)initWithQuestionArray:(NSArray *)questionArr
{
    if(self = [super initWithNibName:@"AnswerQuestionViewController" bundle:nil])
    {
        self.questionArr = questionArr;
        answerIndexDic = [[NSMutableDictionary alloc] init];
        isFirstRunForTableView = YES;
        dataProvider = [ZXYProvider sharedInstance];
        insertView = [[InsertView alloc] initWithMessage:@"正在提交答案，请稍后" andSuperV:self.view withPoint:150];
        insertView.delegate = self;
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
    static NSString *submitCell = @"answerQuestionIdentifier";
    if(indexPath.row<self.questionArr.count)
    {
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
        QuestionNameID *questionName = [self.questionArr objectAtIndex:indexPath.row];
        cell.titleIndex.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.questionTitle.text = questionName.questionName;
        cell.answerForButtonTitle = [dataProvider readCoreDataFromDB:@"QuestionAnswerID" withContentNumber:questionName.questionID andKey:@"questionID"];
        cell.questionID = [questionName.questionID stringValue];
        [cell selectAnswerWithHistory:[(NSNumber *)[answerIndexDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] integerValue]];
        return cell;
    }
    else
    {
        AnswerSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:submitCell];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AnswerSubmitCell class]) owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[AnswerSubmitCell class]])
                {
                    cell = (AnswerSubmitCell *)oneObject;
                    cell.submitDelegate = self;
                }
            }
        }
        return cell;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionArr.count+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.questionArr.count)
    {
        return 146;
    }
    else
    {
        return 71;
    }
}

#pragma mark - 按下答案的代理方法
- (void)selectCellAnswerDelegate:(NSInteger)index withQuestionID:(NSString *)quesID
{
    [answerIndexDic setObject:[NSNumber numberWithInteger:index] forKey:quesID];
    for(int i = 0;i<answerIndexDic.allKeys.count;i++)
    {
        NSLog(@"key -- > %@/n value -- >%@/n",answerIndexDic.allKeys[i],[answerIndexDic objectForKey:[answerIndexDic.allKeys objectAtIndex:i]]);
    }
    
}

#pragma mark - 按下发送答案按钮的代理方法 及构造字符串
- (void)submitButtonTouchUpInside
{
    // !!!:判断有没有问题没有回答，如果需要额外功能在此添加focus
    
    if(answerIndexDic.allKeys.count < self.questionArr.count)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有问题没有回答，请检查后回答完成所有题目" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [insertView showMessageView];
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",hostForXM,answerQuestion];
    NSString *userID    = [LCYCommon currentUserID];
    NSString *answerString = [self toHTTPAnswer];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID",answerString,@"answers", nil];
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [requestManager POST:stringURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CXMLDocument *documentXML = [[CXMLDocument alloc] initWithData:[operation responseData] options:0 error:nil];
        CXMLElement  *rootElement = [documentXML rootElement];
        NSString *stringJSON = [rootElement stringValue];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[stringJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSString *resultString = [dic objectForKey:@"result"];
        if([resultString isEqualToString:@"ok"])
        {
            [insertView setAfterDoneSelector:@selector(popView)];
            [insertView setMessage:@"提交成功！" ];
        }
        else
        {
            [insertView setMessage:@"提交失败！" ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [insertView setMessage:@"提交失败！" ];
    }];
    NSLog(@"发送答案");
}
//构造答案的字符串 格式3,2,1,2以逗号隔开
- (NSMutableString *)toHTTPAnswer
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    for(int i = 0;i<self.questionArr.count;i++)
    {
        QuestionNameID *question = [self.questionArr objectAtIndex:i];
        NSInteger answer = [(NSNumber *)[answerIndexDic objectForKey:[question.questionID stringValue]] integerValue];
        if(i == self.questionArr.count-1)
        {
            [resultString appendString:[NSString stringWithFormat:@"%d",answer]];
        }
        else
        {
            [resultString appendString:[NSString stringWithFormat:@"%d,",answer]];
        }
    }
    NSLog(@"%@",resultString);
    return resultString;

}

- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
