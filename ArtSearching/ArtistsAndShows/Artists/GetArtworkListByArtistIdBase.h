//
//  GetArtworkListByArtistIdBase.h
//
//  Created by 超逸 李 on 14-5-21
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GetArtworkListByArtistIdBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double code;
@property (nonatomic, assign) double totalCount;
@property (nonatomic, strong) NSArray *workList;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
