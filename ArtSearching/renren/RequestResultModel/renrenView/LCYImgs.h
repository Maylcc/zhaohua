//
//  LCYImgs.h
//
//  Created by   on 14-4-29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYImgs : NSObject <NSCoding>

@property (nonatomic, strong) NSString *url;

+ (LCYImgs *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
