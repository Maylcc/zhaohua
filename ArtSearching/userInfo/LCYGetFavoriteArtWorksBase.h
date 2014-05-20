//
//  LCYGetFavoriteArtWorksBase.h
//
//  Created by 超逸 李 on 14-5-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetFavoriteArtWorksBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double num;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSArray *infos;
@property (nonatomic, assign) double pageNo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
