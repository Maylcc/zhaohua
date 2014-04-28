//
//  LCYRegisterOneResult.h
//
//  Created by   on 14-4-28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYRegisterOneResult : NSObject <NSCoding>

@property (nonatomic, assign) double uid;
@property (nonatomic, assign) double code;

+ (LCYRegisterOneResult *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
