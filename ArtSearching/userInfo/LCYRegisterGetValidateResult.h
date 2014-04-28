//
//  LCYRegisterGetValidateResult.h
//
//  Created by   on 14-4-24
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYRegisterGetValidateResult : NSObject <NSCoding>

@property (nonatomic, strong) NSString *vcode;
@property (nonatomic, assign) double code;

+ (LCYRegisterGetValidateResult *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
