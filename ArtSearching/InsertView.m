//
//  InsertView.m
//  ArtSearching
//
//  Created by developer on 14-4-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "InsertView.h"
@interface InsertView ()
{
    UIView *_superV;
    NSString *_message;
    NSTimeInterval _timerInterval;
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
    //[_message drawInRect:<#(CGRect)#> withAttributes:<#(NSDictionary *)#>]
   
    [super drawRect:rect];
    
}

- (void)showMessageViewWithTime:(NSTimeInterval)time
{
    [self showMessageView];
    NSTimer *timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(hideMessageView) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}
- (void)showMessageView
{
    [_superV addSubview:self];
}

- (void)hideMessageView
{
    [self removeFromSuperview];
}

@end
