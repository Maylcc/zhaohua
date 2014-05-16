//
//  DataListViewController.m
//  ArtSearching
//
//  Created by developer on 14-4-17.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DataListViewController.h"
#import "DataArtListCellTableViewCell.h"
#import "DataStartGallertyCell.h"
#import "DataAcquisitionViewController.h"
#import "DataCMICTableViewCell.h"
#import "UIFolderTableView.h"
#import "ZXYFileOperation.h"
#import "StartArtList.h"
#import "StartArtistsList.h"
#import "StartGalleryList.h"
#import "ArtDetailViewController.h"
#import "ZXYUserDefaultSettings.h"
#import "XMLParserHelper.h"
#import "NetHelper.h"
#import "InsertView.h"
#import "LCYRegisterViewController.h"
#import "TouchXML.h"
#import "AnswerQuestionViewController.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define TEXTBLACKCOLORE [UIColor colorWithRed:((float)((0x3a3a3a & 0xFF0000) >> 16))/255.0 \
green:((float)((0x3a3a3a & 0xFF00) >> 8))/255.0 \
blue:((float)(0x3a3a3a & 0xFF))/255.0 alpha:1.0]

@interface DataListViewController ()<UIFolderTableViewDelegate,isCMICDown>
{
    BOOL isCMICDown; //判断CMI总体指数是否下载完成
    InsertView *insertViewL; //提示视图
    NSDictionary *dataOfCMAICView;
    UIImageView *_arrowImage;
}
@end

@implementation DataListViewController
//实例化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        netConnect = [NetConnect sharedSelf];
        
        xmlParser  = [XMLParserHelper sharedSelf];
        dataProvider = [ZXYProvider sharedInstance];
        arrArtistsList = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtistsList" orderByKey:@"beScanTime" isDes:NO]];
        arrArtList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtList" isDes:NO orderByKey:@"beScanTime",@"beStoreTime",nil]];
        arrGalleryList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartGalleryList" orderByKey:@"beScanTime" isDes:NO]];
        fileOperation = [ZXYFileOperation sharedSelf];
        isCMICDown = NO;
        insertViewL = [[InsertView alloc] initWithMessage:@"请稍后..." andSuperV:self.view withPoint:150];
    }
    return self;
}

//视图实例化
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNotificationCenter *refreshNoti = [NSNotificationCenter defaultCenter];
    [refreshNoti addObserver:self selector:@selector(refreshCurrentTable:) name:@"DataListViewFresh" object:nil];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    self.title = @"数据凶猛";
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // !!!:在此处获取所有星级作品，画家，画廊
    [self obtainAllStartData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources txvhat can be recreated.
}

/**
  获取星级作品，作者，画廊
 */
- (void)obtainAllStartData
{
   [NSThread detachNewThreadSelector:@selector(obtainStartList) toTarget:netConnect withObject:nil];
    //[netConnect obtainStartList];
}

#pragma mark - table代理以及数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewIdentifier = @"headerViewIdentifier";
    UIView *headerView = [tableView dequeueReusableCellWithIdentifier:headerViewIdentifier];
    if(headerView == nil)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
        headerView.backgroundColor = RGBA(217, 217, 217, 1);
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, UI_SCREEN_WIDTH-15, 22)];
        titleLbl.textColor = TEXTBLACKCOLORE;
        titleLbl.font = [UIFont systemFontOfSize:13.5];
        titleLbl.backgroundColor = [UIColor clearColor];
        if(section == 0)
        {
            titleLbl.text = @"信心指数";
            //return nil;
        }
        else if(section == 1)
        {
            titleLbl.text = @"  明星作品 (10)";
        }
        else if(section == 2)
        {
            titleLbl.text = @"  明星艺术家 (10)";
        }
        else
        {
            titleLbl.text = @"  明星画廊 (10)";
        }
        [headerView addSubview:titleLbl];
    }
    return headerView;
   
}
//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return arrArtList.count;
    }
    else if(section == 2)
    {
        return arrArtistsList.count;
    }
    else
    {
        return arrGalleryList.count;
    }
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    if(indexPath.section == 0)
    {
        static NSString *cmicCellIdentifier = @"cmicCellIdentifier";
        DataCMICTableViewCell *cmicCell = [tableView dequeueReusableCellWithIdentifier:cmicCellIdentifier];
        if(cmicCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DataCMICTableViewCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[DataCMICTableViewCell class]])
                {
                    cmicCell = (DataCMICTableViewCell *)oneObject;
                    _arrowImage = cmicCell.arrowImage;
                    cmicCell.delegate = self;
                }
            }

        }
        cell = cmicCell;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *artListCellIdentifier = @"artListCellIdentifier";
        DataArtListCellTableViewCell *cellArt = [tableView dequeueReusableCellWithIdentifier:artListCellIdentifier];
        if(cellArt == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DataArtListCellTableViewCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[DataArtListCellTableViewCell class]])
                {
                    cellArt = (DataArtListCellTableViewCell *)oneObject;
                }
            }
        }
        StartArtList *artList = [arrArtList objectAtIndex:indexPath.row];
        cellArt.authodLbl.text = artList.author;
        cellArt.artNameLbl.text = artList.title;
        cellArt.cellIndex = [NSString stringWithFormat:@"%d",artList.id_Art.intValue ];
        cellArt.lookNums.text   = [NSString stringWithFormat:@"%d",artList.beScanTime.intValue ];
        cellArt.collectNum.text = [NSString stringWithFormat:@"%d", artList.beStoreTime.intValue ];
        cellArt.indexLbl.text   = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
        NSString *pathString = [fileOperation findArtOfStartByUrl:artList.url_Small];
        if([fileOperation fileExistsAtPath:pathString])
        {
            cellArt.artImage.image = [UIImage imageWithContentsOfFile:pathString];
        }
        else
        {
            cellArt.artImage.image = [UIImage imageNamed:@"placehold_image.png"];
        }

        cell = cellArt;
    }
    else
    {
        static NSString *artGalleryAndArtistIdentifier = @"artGalleryAndArtistIdentifier";
        DataStartGallertyCell *galleryCell = [tableView dequeueReusableCellWithIdentifier:artGalleryAndArtistIdentifier];
        if(galleryCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DataStartGallertyCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[DataStartGallertyCell class]])
                {
                    galleryCell = (DataStartGallertyCell *)oneObject;
                }
            }
            
        }
        if(indexPath.section == 2)
        {
            StartArtistsList *artist = [arrArtistsList objectAtIndex:indexPath.row];
            galleryCell.authordName.text = artist.author;
            galleryCell.lookNums.text    = [NSString stringWithFormat:@"%d", artist.beScanTime.intValue ];
            galleryCell.collectionNums.text = [NSString stringWithFormat:@"%d", artist.beStoreTime.intValue ];
            galleryCell.indexLbl.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
            galleryCell.numOfArts.text = [NSString stringWithFormat:@"%d件作品",artist.workCount.intValue];
            NSString *filePath = [fileOperation findArtistOfStartByUrl:artist.url_small andID:artist.id_Art.stringValue withType:@""];
            if([fileOperation fileExistsAtPath:filePath])
            {
                galleryCell.authordImage.image = [UIImage imageWithContentsOfFile:[fileOperation findArtistOfStartByUrl:artist.url_small andID:artist.id_Art.stringValue withType:@""]];
            }
            else
            {
                galleryCell.authordImage.image = [UIImage imageNamed:@"personal_setting.png"];
            }
        }
        else 
        {
            StartGalleryList *artist = [arrGalleryList objectAtIndex:indexPath.row];
            galleryCell.authordName.text = artist.name;
            galleryCell.lookNums.text    = [NSString stringWithFormat:@"%d", artist.beScanTime.intValue ];
            galleryCell.collectionNums.text = [NSString stringWithFormat:@"%d", artist.beStoreTime.intValue ];
            galleryCell.indexLbl.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
            galleryCell.numOfArts.text = [NSString stringWithFormat:@"%d件作品",artist.workCount.intValue];
            NSString *filePath = [fileOperation findArtistOfStartByUrl:artist.url andID:artist.id_Art.stringValue withType:@""];
            if([fileOperation fileExistsAtPath:filePath])
            {
                galleryCell.authordImage.image = [UIImage imageWithContentsOfFile:[fileOperation findArtistOfStartByUrl:artist.url andID:artist.id_Art.stringValue withType:@""]];
            }
            else
            {
                galleryCell.authordImage.image = [UIImage imageNamed:@"personal_setting.png"];
            }
            
        }
        

        cell = galleryCell;
        
        
    }
    return cell;
}
//
- (CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 44;
    }
    else if(indexPath.section == 1)
    {
        return 210;
    }
    else
    {
        return 51;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 44;
    }
    else if(indexPath.section == 1)
    {
        return 210;
    }
    else
    {
        return 51;
    }

}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    return 22;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(!isCMICDown)
        {
            return;
        }
        if([LCYCommon isUserLogin])
        {
            [insertViewL showMessageView];
            netHelper  = [NetHelper sharedSelf];
            netHelper.netHelperDelegate = self;
            NSString *userID = [LCYCommon currentUserID];
            NSDate *date = [ZXYUserDefaultSettings zxyUserUpdateTime];
           // NSDate *date = [NSDate date];
            NSString *stringURL = [NSString stringWithFormat:@"%@%@",hostForXM,getQuestionStatus];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"Date",userID,@"UserID",nil];
            AFXMLParserResponseSerializer *xmlSerializer = [AFXMLParserResponseSerializer serializer];
            [netHelper requestStart:stringURL withParams:dic bySerialize:xmlSerializer];
        }
        else
        {
            LCYRegisterViewController *registerVC = [[LCYRegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
            return;
        }
        
       // [self tableViewOpenGl];
        
    }
    
    if(indexPath.section == 1)
    {
        StartArtList *art = [arrArtList objectAtIndex:indexPath.row];
        ArtDetailViewController *artDetailViewController = [[ArtDetailViewController alloc] initWithWorkID:art.id_Art.stringValue andWorkUrl:art.url withBundleName:@"ArtDetailViewController"];
        [self.navigationController pushViewController:artDetailViewController animated:YES];
    }
}

#pragma mark - 拉开效果
- (void)tableViewOpenGl
{
    if(dataOfCMAICView == nil)
    {
        return;
    }
    _arrowImage.transform = CGAffineTransformMakeRotation((180.0f * M_PI) / 180.0f);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    dataAc = [[DataAcquisitionViewController alloc] initWithInitialDataDic:dataOfCMAICView];
    dataTableV.scrollEnabled = NO;
    UIFolderTableView *folderTableView = (UIFolderTableView *)dataTableV;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:dataAc.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                     _arrowImage.transform = CGAffineTransformMakeRotation(2*M_PI);
                                }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                }
                           completionBlock:^{
                               // completed actions
                               
                               dataTableV.scrollEnabled = YES;
                           }];

}
#pragma mark - 返回函数
- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshCurrentTable:(NSNotification *)noti
{
    [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:YES];
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DataListViewFresh" object:nil];
}

- (void)refreshTable
{
    arrArtistsList = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtistsList" orderByKey:@"beScanTime" isDes:NO]];
    arrArtList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartArtList" isDes:NO orderByKey:@"beScanTime",@"beStoreTime",nil]];
    arrGalleryList     = [NSArray arrayWithArray:[dataProvider readCoreDataFromDB:@"StartGalleryList" orderByKey:@"beScanTime" isDes:NO]];
    [dataTableV reloadData];
}
#pragma mark - 判断是否需要再次提问的网络代理
- (void)requestCompleteDelegateWithFlag:(requestCompleteFlag)flag withOperation:(AFHTTPRequestOperation *)opertation withObject:(id)object
{
    if(flag == requestCompleteSuccess)
    {
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:[opertation responseData] encoding:NSUTF8StringEncoding options:0 error:nil];
        CXMLElement *root = [document rootElement];
        NSLog(@"response json is %@",[root stringValue]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[[root stringValue]dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSString *needUpdate = [dic valueForKey:@"needupdate"];
        NSString *needAnswerAgain = [dic valueForKey:@"needansweragain"];
        // !!!:判断是否更新
        /*
        if([needUpdate isEqualToString:@"yes"])
        {
            NSLog(@"需要更新本地题库");
            NSString *userID = [LCYCommon currentUserID];
            NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID", nil];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",hostForXM,getQuestions];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            [manager POST:urlString parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                
                CXMLDocument *xmlDocument = [[CXMLDocument alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding options:0 error:nil];
                CXMLElement *rootS = [xmlDocument rootElement];
                NSLog(@"%@",[rootS stringValue]);
                NSDictionary *operationDic = [NSJSONSerialization JSONObjectWithData:[[rootS stringValue] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                NSString *dateString = [operationDic objectForKey:@"date"];
                [ZXYUserDefaultSettings saveUserUpdateTime:dateString];
                NSArray *operationArr = [operationDic objectForKey:@"questions"];
                [dataProvider saveQuestionAndAnswer:operationArr];
                [self performSelectorOnMainThread:@selector(hideMessage) withObject:nil waitUntilDone:YES];
                NSArray *questionArr = [dataProvider readCoreDataFromDB:@"QuestionNameID" orderByKey:@"questionID" isDes:NO];
                AnswerQuestionViewController *answerView = [[AnswerQuestionViewController alloc] initWithQuestionArray:questionArr];
                [self.navigationController pushViewController:answerView animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ;
            }];
            
        }
        // !!!:是否需要重新回答
        else if([needAnswerAgain isEqualToString:@"yes"])
        {
            NSArray *questionArr = [dataProvider readCoreDataFromDB:@"QuestionNameID" orderByKey:@"questionID" isDes:NO];
            AnswerQuestionViewController *answerView = [[AnswerQuestionViewController alloc] initWithQuestionArray:questionArr];
            [self.navigationController pushViewController:answerView animated:YES];

            [self performSelectorOnMainThread:@selector(hideMessage) withObject:nil waitUntilDone:YES];
            NSLog(@"需要重新回答");
        }
        // TODO:没有实现显示数据
        // !!!:显示数据
        else
        {
         */
            [self tableViewOpenGl];
            [self performSelectorOnMainThread:@selector(hideMessage) withObject:nil waitUntilDone:YES];
            NSLog(@"显示数据");
       // }
    }
    else
    {
        [self performSelectorOnMainThread:@selector(hideMessage) withObject:nil waitUntilDone:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接错误，请链接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 隐藏提示语
- (void)hideMessage
{
    [insertViewL hideMessageView];
}

#pragma mark - CMAIC统计值下载完成代理
- (void)completeDownCMICData:(BOOL)isSuccess withResponseDic:(NSDictionary *)responseDic
{
    if(isSuccess)
    {
        isCMICDown = YES;
        dataOfCMAICView = responseDic;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"下载CAMIC指数失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
@end
