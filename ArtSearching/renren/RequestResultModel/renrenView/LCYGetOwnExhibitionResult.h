//
//  LCYGetOwnExhibitionResult.h
//
//  Created by 超逸 李 on 14-5-4
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetOwnExhibitionResult : NSObject <NSCoding>

@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *pageno;
@property (nonatomic, strong) NSArray *exhibitions;

+ (LCYGetOwnExhibitionResult *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
