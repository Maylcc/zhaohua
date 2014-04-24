//
//  ShowBigImageViewController.m
//  ArtSearching
//
//  Created by developer on 14-4-23.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ShowBigImageViewController.h"

@interface ShowBigImageViewController ()
{
    CGFloat zs ;
    NSData *_imageData;
    BOOL isBarHidden;
}
@property (nonatomic,strong)NSData *imageData;
@end

@implementation ShowBigImageViewController
@synthesize imageData = _imageData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithImageData:(NSData *)imageData
{
    self = [super initWithNibName:@"ShowBigImageViewController" bundle:nil];
    if(self)
    {
        self.imageData = imageData;
        zs = 2;
        isBarHidden = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bigImageScroll.delegate = self;
    self.bigImageView.image = [UIImage imageWithData:self.imageData];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 45, 45);
    [backBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNaviBar)];
//    tapGes.numberOfTapsRequired = 1;
//    [self.bigImageView addGestureRecognizer:tapGes];
    
    UITapGestureRecognizer *tapGesTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleTheImage)];
    tapGesTwo.numberOfTapsRequired = 2;
    [self.bigImageScroll addGestureRecognizer:tapGesTwo];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImage *imageForView = [UIImage imageWithData:self.imageData];
    float radio = imageForView.size.height/imageForView.size.width;
    [self.bigImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 320*radio)];
    //self.bigImageScroll.frame = CGRectMake(0, 0, imageForView.size.width, imageForView.size.height);
    //self.bigImageScroll.contentSize = CGSizeMake(imageForView.size.width/2, imageForView.size.height/2);
    NSLog(@"size is %f   ,   %f",imageForView.size.width,imageForView.size.height);
    [super viewWillAppear:animated];
    //[self.bigImageScroll setContentSize:CGSizeMake(20000,20000)];
}

- (void)backViewBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideNaviBar
{
    
    if(!isBarHidden)
    {
        isBarHidden = YES;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        isBarHidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)scaleTheImage
{
    CGFloat zoomSize = zs;
    zs = (zoomSize == 1)?3.0:1.0;
    [self.bigImageScroll setZoomScale:zoomSize animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigImageView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if([touch tapCount])
    {
        CGFloat zoomSize = zs;
        zoomSize = (zoomSize == 1)?2.0:1;
        [self.bigImageScroll setZoomScale:zoomSize];
    }
}
@end
