//
//  LCYRegisterGlobal.h
//  ArtSearching
//
//  Created by Licy on 14-4-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCYRegisterGlobal : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) NSString *userName;

+ (LCYRegisterGlobal *)sharedInstance;

@end
