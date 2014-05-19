//
//  XDHeader.h
//  XDCommonApp
//
//  Created by XD-XY on 2/12/14.
//  Copyright (c) 2014 XD-XY. All rights reserved.
//
#import "SoapXmlParseHelper.h"
//#import "WLSingleton.h"
#ifndef XDCommonApp_XDHeader_h
#define XDCommonApp_XDHeader_h

//===========================================控制参数=====================================================
/*引导页数量
  当引导页为0时，表示没有引导页
 */
#define GUIDECOUNT 0

/*底部菜单栏中TabBar的个数
  本框架中提供三种数量3，4，5
 */
#define TABBARCOUNT 4

/****
 tabbar是否是需要登录才能进入(0表示不需要，1表示需要)
 ****/
#define NEEDACCOUNTFORLOGIN @[@"0",@"0",@"0",@"1"]
//程序进去默认选择第几个tabar
#define DEFAULTSELECTINDEX 0

//statusBar 背景图片
#define STATUSBARBG @"statusBar_bg"
//显示隐藏statusBar
#define SETSTATUSBARHIDDEN(isHidden)\
if (isHidden){\
[[UIApplication sharedApplication] setStatusBarHidden:YES];\
}else{\
[[UIApplication sharedApplication] setStatusBarHidden:NO];\
}

/*设置statusBar的字体
 UIStatusBarStyleDefault:黑体白字
 UIStatusBarStyleLightContent:黑体黑字
 */
#define SETSTATUSBARTEXTBLACKCOLORE(isBlack)\
if (isBlack){\
[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];\
}else{\
[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];\
}


//=============================================颜色值========================================
#define BGCOLOR [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]
#define TEXTBLACKCOLORE [UIColor colorWithRed:((float)((0x3a3a3a & 0xFF0000) >> 16))/255.0 \
green:((float)((0x3a3a3a & 0xFF00) >> 8))/255.0 \
blue:((float)(0x3a3a3a & 0xFF))/255.0 alpha:1.0]
#define TEXTBLACKCOLORE2 [UIColor colorWithRed:((float)((0x777777 & 0xFF0000) >> 16))/255.0 \
green:((float)((0x777777 & 0xFF00) >> 8))/255.0 \
blue:((float)(0x777777 & 0xFF))/255.0 alpha:1.0]  //119
#define TEXTBLACKCOLORE3 [UIColor colorWithRed:((float)((0x999999 & 0xFF0000) >> 16))/255.0 \
green:((float)((0x999999 & 0xFF00) >> 8))/255.0 \
blue:((float)(0x999999 & 0xFF))/255.0 alpha:1.0]
#define TEXTBLACKCOLORE4 [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1] //与活动热点列表中的浏览量数量一样的颜色
#define TEXTBLACKCOLORE5 [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1] //与活动列表中的主办、策展一样的颜色


//用户信息
#define kMY_USERINFO                @"myUserInfo"
#define kMY_USER_NAME               @"myUserName"
#define kMY_USER_ID                 @"myUserId"
#define kMY_USER_PASSWORD           @"myUserPassword"
#define kMY_USER_TOKEN              @"myUserToken"
#define kMY_USER_NICKERNAME         @"myNickerName"

//一级页面的导航栏标题
#define FIRSTVIEWTITLETEXT  @""
#define SECONDVIEWTITLETEXT @""
#define THIRDVIEWTITLETEXT  @""
#define FOURTHVIEWTITLETEXT @"我"
#define FIFTHVIEWTITLETEXT  @"FIVE"

/******
 导航栏
 ******/
#define NAVIGATIONBGIMAGEIOS7 @"nav_bg_ios7"
#define NAVIGATIONBGIMAGE @"nav_bg"
#define NAVIGATIONTITLEFONT [UIFont systemFontOfSize:15.0f]
#define NAVIGATIONTITLECOLORE [UIColor whiteColor]

//=======================================友盟分享==================================================
#define UMAPPKEY         @"532bb56d56240b2ce5081d39"
#define WEIXINAPPID      @"wx15be7f75b99c4f20"
#define kWeixinAppSecret @"1c9f1682db781f4f8b3670e03bb4d9dc"
#define SHARETITLE       @"请输入您要分享的文字"
#define DOWNLOADRUL      @"http://www.google.com.hk/"

//走马灯图片数量
#define PAGESCROLLVIEWNUMBER 4
//走马灯固定的图片(若无图片用 nil表示)
#define PAGESCROLLVIEWIMAGE1 @"tab_button1_notOn"
#define PAGESCROLLVIEWIMAGE2 @"tab_button2_notOn"
#define PAGESCROLLVIEWIMAGE3 @"tab_button3_notOn"
#define PAGESCROLLVIEWIMAGE4 @"tab_button4_notOn"
//走马灯的图片来源是否是网络请求来的(YES表示是，NO表示不是)
#define ISREQUSETIMAGE YES
//默认背景图片
#define PAGEDEFAULTIAMGE [UIImage imageNamed:@"normalPageScrollviewImage"]
//每张图片是否有点击事件(YES 表示有， NO 表示没有)
#define ISHAVEGESTURECLICK YES



//=======================================通用坐标=====================================================
#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define UI_MAINSCREEN_HEIGHT            (UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT)
#define UI_MAINSCREEN_HEIGHT_ROTATE     (UI_SCREEN_WIDTH - UI_STATUS_BAR_HEIGHT)
#define UI_WHOLE_SCREEN_FRAME           CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)
#define UI_WHOLE_SCREEN_FRAME_ROTATE    CGRectMake(0, 0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH)
#define UI_MAIN_VIEW_FRAME              CGRectMake(0, UI_STATUS_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT)
#define UI_MAIN_VIEW_FRAME_ROTATE       CGRectMake(0, UI_STATUS_BAR_HEIGHT, UI_SCREEN_HEIGHT, UI_MAINSCREEN_HEIGHT_ROTATE)
#define UI_NONAVBAR_VIEW_FRAME          CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT)
#define UI_APPLICTION_VIEW_FRAME        CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT)


//首次启动
#define ISFIRSTSTART  @"isfirststart"

//判断是否是ios7系统
#define IOS7                           [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.f
//判断是否是iphone5的设备
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//算 宽加X坐标的和
#define width_x(view)  view.frame.size.width + view.frame.origin.x
//算 高加Y坐标的和
#define height_y(view)  view.frame.size.height + view.frame.origin.y

//打印输出
#ifdef DEBUG

#define DDLOG(...) NSLog(__VA_ARGS__)
#define DDLOG_CURRENT_METHOD NSLog(@"%@-%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))

#else

#define DDLOG(...) ;
#define DDLOG_CURRENT_METHOD ;

#endif

/*********
 宏作用:单例生成宏
 使用方法:http://blog.csdn.net/totogo2010/article/details/8373642
 **********/
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
//RBG color
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//字符串不为空
#define IS_NOT_EMPTY(string) (string !=nil && [string isKindOfClass:[NSString class]] && ![string isEqualToString:@""])

//数组不为空
#define ARRAY_IS_NOT_EMPTY(array) (array && [array isKindOfClass:[NSArray class]] && [array count])

#pragma mark - Api macro

//#define HOST_URL                          @"http://app.lgmi.com/"
#define API_GetInfoList                       @"getInfo.asp"
#define brokenNetwork                        @"网络连不接失败，请先检测网络！"

/////////////////////////////////////////////////////////////////////////////////
//接口url的拼接
#define USERNAME                            @"111111"
#define USERPASSWORD                        @"111111"
#define NAMESPACE                           @"http://tempuri.org/"//命名空间
#define HOSTURL                             @"http://115.29.41.251:88/webservice_art_base.asmx?op="
//Host Url
//以下是方法名
#define LOGIN                               @"Login" //登录
#define ACTIVITYLIST                        @"ActivityList"//活动列表
#define DATAHOTLIST                         @"DataHotList" //获取热点图片url列表
#define STARWORKLIST                        @"StarList" //获取明星前十项的数据集合
#define GETSTARINFOBYID                     @"GetStarInforById" //点击作品查看折线图
#define GETSTARWORKPVINFOBYIS               @"GetStarWorkPVInfoById"//点击某项作品获取详情
#define STARGALLERYLIST                     @"StarGalleryList"//明星画廊
#define GETSTARGALLERYPVINFOBYID            @"GetStarGalleryPVInfoById"//明星画廊详情
#define ACTIVITYDETAILBYID                  @"ActivityDetailById"  //活动详情页模板
#define ACTIVITYDETAILSEARCHBYKEY           @"ActivityDetailSearchByKey"  //活动详情搜索
#define WORKLISTCATEGORY                    @"WorkListCategory"  //作品列表一级分类
#define WORKLISTCATEGORYBYID                @"WorkListCategoryById"  //作品列表二级分类
#define WORKLISTBYID                        @"WorkListById"  //搜索栏及联想功能
#define GETALLSIZE                          @"GetAllSize"  //获取全部尺寸
#define GETORDERBYOT                        @"GetOrderByHot"  //获取热度
#define WORKDETAILBYWORK                    @"WorkDetailByWorkId"  //作品详情页
#define GETARTISTRECORD                     @"getArtistRecord"  //艺术家录音
#define GETWORKBIGIMAGEBYID                 @"GetWorkBigImageById"  //根据id获取大图
#define GETSERVERTIME                       @"GetServerTime"  //获取服务器时间
#define SENDIMAGEINFOR                      @"SendImageInfor"  //把浏览时间和显示信息发给服务器
#define GETARTISTLIST                       @"GetArtistList"  //获取艺术家列表页
#define GETGALLERYLIST                      @"GetGalleryList" // 获取艺术家（画廊）列表页
#define GETARTISTINFORBYID                  @"GetArtistInforById"  //获取画廊详情页
#define GETMYARTISTINFORBYID                @"GetMyArtistListInforsByuid"  //获取个人主页
#define GETARTWORKLISTBYARTISTID            @"GetArtworkListByArtistId"//通过艺术家id获取瀑布流
#define GETARTWORKLISTBYGALLERYID           @"GetArtworkListByGallryId"//通过画廊的id获取瀑布流
#define GETARTWORKLISTBYACTIVITYID          @"GetArtworkListByActivityId" //模板3进瀑布流
#define MYIINFORISARTIST                    @"myInforIsArtist"  //判断是否是艺术家
#define CHANGEPORTAL                        @"ChangePortal"  //修改头像
#define CHANGEEMAIL                         @"ChangeEmail"  //修改绑定的邮箱
#define CHANGEPHONE                         @"ChangePhone"  //修改绑定的手机
#define FORGETPASSWORD                      @"Forgetpassword"  //忘记密码重置
#define REGISTERGETVALIDATE                 @"RegisterGetValidate"  //获取验证码
#define REGISTERONE                         @"RegisterOne"  //注册第一步
#define REGISTERTWO                         @"RegisterTwo"  //注册第二步
#define REGISTERTHREE                       @"RegisterThree"  //注册第二步
#define CHANGEPASSWORD                      @"ChangePassword"  //修改密码
#define CHECKUPDATE                         @"CheckUpdate"  //版本更新
#define UPLOADFILE                          @"UploadFile"    //上传头像
#define CHANGEPORTAL                        @"ChangePortal" //修改头像
#define CHANGEPHONE                         @"ChangePhone"//修改手机号
#define CHANGEEMAIL                         @"ChangeEmail" //修改邮箱
#define CHECKUPDATE                         @"CheckUpdate" //版本更新
#define WORKLISTBYORGERNIZATIONID           @"ActivityArtworkListByOrganizationId"//根据参展机构id获取瀑布流
#define ORGNIZATIONLISTBYKEY                @"ActivityDetailSearchByKey"//参展机构搜索页面

#define SEARCHPICS                          @"SearchPics_2"
#define GETUSERINFO                         @"GetUserInfo"//获取昵称

#define GetGalleryInfoById                  @"GetGalleryInfoById"//画廊详情
#define ADDCOM                              @"AddCom"// 写评论
#define GetMyStoreInfor                     @"GetMyStoreInfor"//判断是否收藏
#define addStore                            @"AddStore"// 添加收藏
#define cancelStore                         @"CancelStore"// 取消收藏
#define GETStarWorkPVInfoById               @"GetStarWorkPVInfoById"// 明星作品折线图数据
#define GETStarArtistPVInfoById             @"GetStarArtistPVInfoById"// 明星艺术家
#define GETStarGalleryPVInfoById            @"GetStarGalleryPVInfoById"// 明星画廊
#define SHAREBTNTAG 1001

#define NOTHAVENETWORK   @"无网络链接"
#define ImageMainUrl @"http://115.29.41.251/"
#endif
