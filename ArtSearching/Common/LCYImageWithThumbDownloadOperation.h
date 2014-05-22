//
//  LCYImageWithThumbDownloadOperation.h
//  ArtSearching
//
//  Created by eagle on 14-5-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LCYImageWithThumbDownloadOperationDelegate <NSObject>
@optional
/**
 *  一张图片下载完毕时调用
 */
- (void)imageWithThumbDownloadDidFinished;
@end
@interface LCYImageWithThumbDownloadOperation : NSOperation
@property (weak, nonatomic) id<LCYImageWithThumbDownloadOperationDelegate>delegate;
- (void)addImageName:(NSString *)imageName ratio:(CGFloat)ratio;
- (void)initConfigure;
@end

@interface ImageWithThumbDownloadOperationImageInfo : NSObject
- (id)initWithName:(NSString *)imageName ratio:(CGFloat)ratio;
@property (strong, nonatomic) NSString *imageName;
@property CGFloat ratio;
@end
