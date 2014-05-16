//
//  ArtShareViewController.h
//  ArtSearching
//
//  Created by developer on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ArtShareViewController : UIViewController
- (id)initWithSuperView:(UIView *)superViews;
- (void)presentShareView;
- (void)setCloseMethod:(SEL)selector withOwner:(id)owner;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;
- (IBAction)closeShareView:(id)sender;
- (IBAction)wxShare:(id)sender;
- (IBAction)pyShare:(id)sender;
- (IBAction)wbShare:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *clipMethod;

@end
