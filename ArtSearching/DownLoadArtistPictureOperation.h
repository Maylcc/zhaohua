//
//  DownLoadArtistPictureOperation.h
//  ArtSearching
//
//  Created by developer on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadArtistPictureOperation : NSOperation
-(id)initWithUrl:(NSString *)urlString byType:(NSString *)DBName andID:(NSString *)stringID;
@end
