//
//  LCYExhibitions.h
//
//  Created by 超逸 李 on 14-5-4
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYMineExhibitions : NSObject <NSCoding>

@property (nonatomic, strong) NSString *organizerPic;
@property (nonatomic, strong) NSString *exhibitionid;
@property (nonatomic, strong) NSArray *applyers;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *attenderNames;
@property (nonatomic, strong) NSString *describinfo;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSString *commentNums;
@property (nonatomic, strong) NSString *viewNum;
@property (nonatomic, strong) NSString *organizerName;

+ (LCYMineExhibitions *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
