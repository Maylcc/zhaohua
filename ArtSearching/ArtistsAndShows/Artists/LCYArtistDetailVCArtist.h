//
//  LCYArtistDetailVCArtist.h
//
//  Created by 超逸 李 on 14-5-12
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYArtistDetailVCArtist : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double artistStoreCount;
@property (nonatomic, assign) double artistWorkCount;
@property (nonatomic, strong) NSString *artistEducation;
@property (nonatomic, strong) NSString *artistPortalS;
@property (nonatomic, strong) NSString *artistPortal;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *artistIntroduction;
@property (nonatomic, assign) double artistScanCount;
@property (nonatomic, assign) double code;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
