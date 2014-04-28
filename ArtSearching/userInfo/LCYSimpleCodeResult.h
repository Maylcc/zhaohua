//
//  LCYSimpleCodeResult.h
//
//  Created by   on 14-4-24
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYSimpleCodeResult : NSObject <NSCoding>

@property (nonatomic, assign) double code;

+ (LCYSimpleCodeResult *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
