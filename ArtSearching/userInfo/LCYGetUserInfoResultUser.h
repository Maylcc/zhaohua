//
//  LCYGetUserInfoResultUser.h
//
//  Created by 超逸 李 on 14-5-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetUserInfoResultUser : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double code;
@property (nonatomic, assign) id unike;
@property (nonatomic, strong) NSString *uheadurl;
@property (nonatomic, strong) NSString *ubrief;
@property (nonatomic, assign) double uid;
@property (nonatomic, strong) NSString *uname;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
