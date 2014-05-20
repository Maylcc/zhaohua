//
//  InsertView.m
//  ArtSearching
//
//  Created by developer on 14-4-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "InsertView.h"
#import <objc/message.h>
@interface InsertView ()
{
    UIView *_superV;
    NSString *_message;
    NSTimeInterval _timerInterval;
    SEL  _selector;
}
@end


@implementation InsertView

- (id)initWithMessage:(NSString *)message andSuperV:(UIView *)superV withPoint:(CGFloat)positionY
{
    self = [super initWithFrame:CGRectMake(40, positionY, 240, 40)];
    if(self)
    {
        NSAssert(![_superV isKindOfClass:[UIView class]], @"必须是UIView的子类");
        NSAssert(superV != nil, @"superV不能是nil");
        _superV = superV;
        _message = message;
        UILabel *messageTitle = [[UILabel alloc] init];
        messageTitle.tag = 11;
        messageTitle.frame = CGRectMake(0, 0, 240, 40);
        //messageTitle.center = self.center;
        
        [messageTitle setText:_message];
        [messageTitle setTextAlignment:NSTextAlignmentCenter];
        [messageTitle setTextColor:[UIColor whiteColor]];
        UIFont *font = [UIFont boldSystemFontOfSize:16];
        [messageTitle setFont:font];
        [self addSubview:messageTitle];
        

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.layer.backgroundColor = [UIColor grayColor].CGColor;
    self.layer.opacity = 0.8;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    [super drawRect:rect];
    
}

- (void)showMessageViewWithTime:(NSTimeInterval)time
{
    [self showMessageView];
    NSTimer *timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(hideMessageView) userInfo:nil repeats:NO];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:time];
    [timer setFireDate:date];
    [timer fire];
}

- (void)setAfterDoneSelector:(SEL)selector
{
    if([self.delegate respondsToSelector:selector])
    {
        _selector = selector;
    }
}

- (void)setMessage:(NSString *)message
{
    UILabel *label = (UILabel *)[self viewWithTag:11];
    label.text = message;
    NSTimer *timer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(hideMessageView) userInfo:nil repeats:NO];
    [timer fire];
}

- (void)showMessageView
{
    self.alpha = 0;
    [_superV setUserInteractionEnabled:NO];
    [_superV addSubview:self];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.alpha = 0.8;
    [UIView commitAnimations];
}

- (void)hideMessageView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    self.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(removeSelf)];
    [UIView commitAnimations];
}

- (void)removeSelf
{
    [_superV setUserInteractionEnabled:YES];
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:_selector])
        {
            objc_msgSend(self.delegate, _selector);
        }
    }
    [self removeFromSuperview];
}
@end
