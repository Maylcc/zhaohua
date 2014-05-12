//
//  ZXYUserDefaultSettings.h
//  ArtSearching
//
//  Created by developer on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYUserDefaultSettings : NSObject
+ (NSDate *)zxyUserUpdateTime;
+ (void)saveUserUpdateTime:(NSString *)dateString;
@end
