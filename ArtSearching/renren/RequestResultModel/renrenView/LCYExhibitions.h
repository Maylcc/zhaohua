//
//  LCYExhibitions.h
//
//  Created by   on 14-4-29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYExhibitions : NSObject <NSCoding>

@property (nonatomic, strong) NSString *organizerName;
@property (nonatomic, strong) NSString *exhibitionid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSString *attenderNames;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *describinfo;
@property (nonatomic, strong) NSString *commentNums;
@property (nonatomic, strong) NSString *viewNum;
@property (nonatomic, strong) NSString *organizerPic;

+ (LCYExhibitions *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
