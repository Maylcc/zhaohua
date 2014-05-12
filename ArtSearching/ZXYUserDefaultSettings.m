//
//  ZXYUserDefaultSettings.m
//  ArtSearching
//
//  Created by developer on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYUserDefaultSettings.h"
#define USERDEFAULTSETTINGSDATE @"ZXYUserDefaultSettings-userSettingDate"
@implementation ZXYUserDefaultSettings
+ (NSString *)userSettingDate
{
    NSString *userSettingDateString = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTSETTINGSDATE];
    if(userSettingDateString == nil)
    {
        userSettingDateString = @"20140101000000";
        [[NSUserDefaults standardUserDefaults] setObject:@"20140101000000" forKey:USERDEFAULTSETTINGSDATE];
    }
    return userSettingDateString;
}

+ (NSDate *)zxyUserUpdateTime
{
    NSString *dateString = [self userSettingDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (void)saveUserUpdateTime:(NSString *)dateString
{
     [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:USERDEFAULTSETTINGSDATE];
}
@end
