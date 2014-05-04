//
//  LCYGetArtistListResult.h
//
//  Created by 超逸 李 on 14-5-1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetArtistListResult : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *artists;
@property (nonatomic, assign) double totalCount;
@property (nonatomic, assign) double code;

+ (LCYGetArtistListResult *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
