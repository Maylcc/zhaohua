//
//  DownLoadPictureOperation.h
//  ArtSearching
//
//  Created by developer on 14-4-20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXYFileOperation.h"
@class  StartArtList;
@interface DownLoadPictureOperation : NSOperation

-(id)initWithPicUrls:(NSArray *)urlArr;
-(id)initWithUrl:(StartArtList *)startArt;
@end
