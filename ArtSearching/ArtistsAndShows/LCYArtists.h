//
//  LCYArtists.h
//
//  Created by 超逸 李 on 14-5-1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYArtists : NSObject <NSCoding>

@property (nonatomic, strong) NSString *artistPortalS;
@property (nonatomic, assign) double artistId;
@property (nonatomic, assign) double artistWorkCount;
@property (nonatomic, assign) double artistOpenTime;
@property (nonatomic, strong) NSString *artistPortal;
@property (nonatomic, strong) NSString *artistName;

+ (LCYArtists *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
