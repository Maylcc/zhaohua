//
//  LCYRegisterGlobal.m
//  ArtSearching
//
//  Created by Licy on 14-4-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYRegisterGlobal.h"

@implementation LCYRegisterGlobal

- (id)init{
    if (self = [super init]) {
    }
    return self;
}

+ (LCYRegisterGlobal *)sharedInstance{
    static LCYRegisterGlobal *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
