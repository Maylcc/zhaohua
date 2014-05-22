//
//  UIImage+LCYScale.h
//  ArtSearching
//
//  Created by eagle on 14-5-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LCYScale)
/**
 *  将图片压缩至指定分辨率
 *
 *  @param size 压缩后分辨率
 *
 *  @return 压缩后图片
 */
- (UIImage *)scaleToSize:(CGSize)size;
@end
