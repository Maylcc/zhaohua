//
//  ArtShareViewController.m
//  ArtSearching
//
//  Created by developer on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ArtShareViewController.h"
#import <objc/message.h>
#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>
#import "ShareHelper.h"
#import "UMSocial.h"
#import "InsertView.h"
@interface ArtShareViewController ()<ResponseForShared,UMSocialUIDelegate>
{
    UIView *_selfSuperView;
    BOOL isSharingViewShow;
    SEL beforeCloseSlector;
    BOOL isFirstAdd;
    id  owner;
    UIImage *currentImage;
    ShareHelper *shareHelper;
    InsertView *insertView;
}
@property(nonatomic,strong)UIView *selfSuperView;
@end

@implementation ArtShareViewController
@synthesize selfSuperView = _selfSuperView;
-(id)initWithSuperView:(UIView *)superViews
{
    if(self = [super initWithNibName:@"ArtShareViewController" bundle:nil])
    {
        self.selfSuperView = superViews;
        isSharingViewShow = NO;
        isFirstAdd = YES;
        shareHelper = [ShareHelper initialInstance];
        shareHelper.wxResponseDelegate = self;
        insertView = [[InsertView alloc] initWithMessage:@"复制成功" andSuperV:superViews withPoint:200];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setCloseMethod:(SEL)selector withOwner:(id)owners
{
    if(owners == nil)
    {
        return;
    }
    else
    {
        owner = owners;
        beforeCloseSlector = selector;
    }
}

- (void)presentShareView
{
    if(isFirstAdd)
    {
        [self addSubViews];
        isFirstAdd = NO;
    }
//    UIImage *cuImage = [self subImageForBlur:[self superViewForImage]];
    self.blurImageView.image = [self blurryImageS:self.blurImageView.image withBlurLevel:0.01];
    [self shareViewMethod];
}

- (void)addSubViews
{
    self.view.frame = CGRectMake(0, self.selfSuperView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.selfSuperView addSubview:self.view];
}

- (void)shareViewMethod
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if(isSharingViewShow)
    {
        self.view.frame = CGRectMake(0, self.selfSuperView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        isSharingViewShow = NO;
    }
    else
    {
        self.view.frame = CGRectMake(0, self.selfSuperView.frame.size.height-self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        isSharingViewShow = YES;
    }
    [UIView commitAnimations];
}


- (void)hideShareView
{
    if([owner respondsToSelector:beforeCloseSlector])
    {
        objc_msgSend(owner, beforeCloseSlector);
    }
    [self shareViewMethod];
}

- (IBAction)closeShareView:(id)sender
{
    [self hideShareView];
}

- (IBAction)wxShare:(id)sender
{
    if([shareHelper isWXInstalled])
    {
        [shareHelper requestONWX:0];
    }
    else
    {
    
    }
}

- (IBAction)pyShare:(id)sender
{
    if([shareHelper isWXInstalled])
    {
        [shareHelper requestONWX:1];
    }
    else
    {
        
    }
}

- (IBAction)wbShare:(id)sender
{
    [shareHelper weiBoShare:3];
}

// !!!:shareHelper的代理
- (void)WXShareResponseFlag:(int)flag
{
    if(flag == 0)
    {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }
    else
    {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"" message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }
}

// !!!:将父类视图变为图片
- (UIImage *)superViewForImage
{
    UIImage *imageForReturn ;
    UIGraphicsBeginImageContext(self.selfSuperView.bounds.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [self.selfSuperView.layer renderInContext:currentContext];
    imageForReturn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageForReturn;
}

// !!!:截取图片的一部分
- (UIImage *)subImageForBlur:(UIImage *)backOfSuperView
{
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.selfSuperView.frame.size.height-self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    UIImage *imageForBLUR = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([backOfSuperView CGImage], rect)];
    return imageForBLUR;

}



//模糊的两个方法
// !!!:模糊方法没有用到
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *)blurryImageS:(UIImage *)image withBlurLevel:(CGFloat)blur {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur),
                        nil];
    
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage
                                             fromRect:[outputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}

-(IBAction)shareViewBtnCLick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag-10 ;
    //设置分享内容和回调对象
    if (tag == 0){
        //微信会话
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享到微信－找画APP" shareImage:[UIImage imageNamed:@"Icon"] socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else if (tag == 1){
        //朋友圈分享
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享到朋友圈－找画APP" shareImage:[UIImage imageNamed:@"Icon"] socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else if (tag == 2){
        //新浪微博
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享到新浪微博－找画APP" shareImage:[UIImage imageNamed:@"Icon"] socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else if (tag == 3){
        //复制链接地址
        [[UIPasteboard generalPasteboard] setString:@"找画URL"];
        [insertView showMessageViewWithTime:1];
    }
    
}

@end
