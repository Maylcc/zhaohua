//
//  LCYImageDownloadOperation.h
//  ArtSearching
//
//  Created by eagle on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCYImageDownloadOperationDelegate <NSObject>
@optional
/**
 *  一张图片下载完毕时调用
 */
- (void)imageDownloadDidFinished;
@end

@interface LCYImageDownloadOperation : NSOperation
@property (weak, nonatomic) id<LCYImageDownloadOperationDelegate>delegate;
- (void)addImageName:(NSString *)imageName;
- (void)initConfigure;
@end
