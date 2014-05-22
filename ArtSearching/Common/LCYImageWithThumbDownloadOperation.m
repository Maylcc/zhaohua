//
//  LCYImageWithThumbDownloadOperation.m
//  ArtSearching
//
//  Created by eagle on 14-5-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYImageWithThumbDownloadOperation.h"
#import "LCYCommon.h"
#import "UIImage+LCYScale.h"

@interface LCYImageWithThumbDownloadOperation ()
@property (strong, atomic) NSMutableArray *imageArray;
@property (strong, atomic) NSCondition *arrayCondition;
@end
@implementation LCYImageWithThumbDownloadOperation
- (void)initConfigure{
    self.imageArray = [NSMutableArray array];
    self.arrayCondition = [[NSCondition alloc] init];
}

- (void)main{
    while (YES) {
        // 检查线程是否已经结束
        if (self.isCancelled) {
            break;
        }
        // 检查需要下载的列表
        [self.arrayCondition lock];
        if (self.imageArray.count == 0) {
            [self.arrayCondition wait];
            [self.arrayCondition unlock];
        } else {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ImageWithThumbDownloadOperationImageInfo *imageInfo = [self.imageArray lastObject];
            NSString *imageName = imageInfo.imageName;
            CGFloat ratio = imageInfo.ratio;
            [self.imageArray removeObject:imageInfo];
            LCYLOG(@"pop object:%@",imageName);
            LCYLOG(@"current object count = %ld",(long)self.imageArray.count);
            [self.arrayCondition unlock];
            // 开启异步下载，完成后发送signal
            NSString *imageURL = [hostIMGPrefix stringByAppendingPathComponent:imageName];
            NSString *urlString = [[NSString stringWithFormat:@"%@",imageURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *imageFileName = imageName;
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIImage *downImg = (UIImage *)responseObject;
                NSData *imageData = UIImageJPEGRepresentation(downImg, 1.0);
                LCYLOG(@"success");
                [LCYCommon writeData:imageData toFilePath:[[LCYCommon renrenMainImagePath
                                                            ] stringByAppendingPathComponent:imageFileName]];
                LCYLOG(@"write to file:%@",[[LCYCommon renrenMainImagePath] stringByAppendingPathComponent:imageFileName]);
                // TODO:压缩图片
                NSString *thumbPath = [LCYCommon thumbPathForImagePath:[[LCYCommon renrenMainImagePath
                                                                         ] stringByAppendingPathComponent:imageFileName]];
                CGSize thumbImageSize = CGSizeMake(320.0, 320.0/ratio);
                UIImage *thumbImage = [downImg scaleToSize:thumbImageSize];
                NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, 1.0);
                [LCYCommon writeData:thumbImageData toFilePath:thumbPath];
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(imageWithThumbDownloadDidFinished)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate imageWithThumbDownloadDidFinished];
                    });
                }
                dispatch_semaphore_signal(sema);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LCYLOG(@"下载图片失败 error is %@",error);
                dispatch_semaphore_signal(sema);
            }];
            [requestOperation start];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
    }
}

- (void)addImageName:(NSString *)imageName ratio:(CGFloat)ratio{
    [self.arrayCondition lock];
    ImageWithThumbDownloadOperationImageInfo *info = [[ImageWithThumbDownloadOperationImageInfo alloc] initWithName:imageName ratio:ratio];
    [self.imageArray addObject:info];
    [self.arrayCondition signal];
    [self.arrayCondition unlock];
}
@end


@implementation ImageWithThumbDownloadOperationImageInfo
- (id)initWithName:(NSString *)imageName ratio:(CGFloat)ratio{
    if (self = [super init]) {
        _imageName = imageName;
        _ratio = ratio;
    }
    return self;
}
@end