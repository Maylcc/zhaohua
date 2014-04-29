//
//  LCYGetAllExhibitionResult.h
//
//  Created by   on 14-4-29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetAllExhibitionResult : NSObject <NSCoding>

@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *pageno;
@property (nonatomic, strong) NSArray *exhibitions;

+ (LCYGetAllExhibitionResult *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
