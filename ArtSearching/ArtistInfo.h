//
//  ArtistInfo.h
//
//  Created by 宇周  on 14-4-23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ArtistInfo : NSObject <NSCoding>

@property (nonatomic, assign) double artistStoreCount;
@property (nonatomic, assign) double artistWorkCount;
@property (nonatomic, strong) NSString *artistEducation;
@property (nonatomic, strong) NSString *artistPortalS;
@property (nonatomic, strong) NSString *artistPortal;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *artistIntroduction;
@property (nonatomic, assign) double artistScanCount;
@property (nonatomic, assign) double code;

+ (ArtistInfo *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
