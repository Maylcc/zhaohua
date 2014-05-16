//
//  LCYImageDownloadOperation.m
//  ArtSearching
//
//  Created by eagle on 14-5-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYImageDownloadOperation.h"
#import "LCYCommon.h"

@interface LCYImageDownloadOperation ()
@property (strong, atomic) NSMutableArray *imageNameArray;
@property (strong, atomic) NSCondition *arrayCondition;
@end

@implementation LCYImageDownloadOperation
- (void)initConfigure{
    self.imageNameArray = [NSMutableArray array];
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
        if (self.imageNameArray.count == 0) {
            [self.arrayCondition wait];
            [self.arrayCondition unlock];
        } else {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            NSString *imageName = [self.imageNameArray lastObject];
            [self.imageNameArray removeObject:imageName];
            LCYLOG(@"pop object:%@",imageName);
            LCYLOG(@"current object count = %ld",(long)self.imageNameArray.count);
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
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(imageDownloadDidFinished)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate imageDownloadDidFinished];
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

- (void)addImageName:(NSString *)imageName{
    [self.arrayCondition lock];
    BOOL gotOne = NO;
    for (NSString *oneImageName in self.imageNameArray) {
        if ([oneImageName isEqualToString:imageName]) {
            gotOne = YES;
            break;
        }
    }
    if (!gotOne) {
        [self.imageNameArray addObject:imageName];
        [self.arrayCondition signal];
    }
    [self.arrayCondition unlock];
}
@end
