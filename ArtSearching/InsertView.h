//
//  InsertView.h
//  ArtSearching
//
//  Created by developer on 14-4-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsertView : UIView
- (id)initWithMessage:(NSString *)message andSuperV:(UIView *)superV withPoint:(CGFloat)positionY;
- (void)showMessageViewWithTime:(NSTimeInterval)time;
- (void)showMessageView;
- (void)hideMessageView;
@end
