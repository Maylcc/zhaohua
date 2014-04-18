//
//  LCYActivityList.m
//
//  Created by   on 14-4-18
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYActivityList.h"


NSString *const kLCYActivityListOrganizer = @"organizer";
NSString *const kLCYActivityListActivityDesign = @"activityDesign";
NSString *const kLCYActivityListActivityTitle = @"activityTitle";
NSString *const kLCYActivityListId = @"id";
NSString *const kLCYActivityListActivitySponsor = @"activitySponsor";
NSString *const kLCYActivityListCoorganizer = @"coorganizer";
NSString *const kLCYActivityListActivityWeekTime = @"activityWeekTime";
NSString *const kLCYActivityListBeScanTime = @"beScanTime";
NSString *const kLCYActivityListType = @"type";
NSString *const kLCYActivityListActivityStartTime = @"activityStartTime";


@interface LCYActivityList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYActivityList

@synthesize organizer = _organizer;
@synthesize activityDesign = _activityDesign;
@synthesize activityTitle = _activityTitle;
@synthesize activityListIdentifier = _activityListIdentifier;
@synthesize activitySponsor = _activitySponsor;
@synthesize coorganizer = _coorganizer;
@synthesize activityWeekTime = _activityWeekTime;
@synthesize beScanTime = _beScanTime;
@synthesize type = _type;
@synthesize activityStartTime = _activityStartTime;


+ (LCYActivityList *)modelObjectWithDictionary:(NSDictionary *)dict
{
    LCYActivityList *instance = [[LCYActivityList alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.organizer = [self objectOrNilForKey:kLCYActivityListOrganizer fromDictionary:dict];
            self.activityDesign = [self objectOrNilForKey:kLCYActivityListActivityDesign fromDictionary:dict];
            self.activityTitle = [self objectOrNilForKey:kLCYActivityListActivityTitle fromDictionary:dict];
            self.activityListIdentifier = [[self objectOrNilForKey:kLCYActivityListId fromDictionary:dict] doubleValue];
            self.activitySponsor = [self objectOrNilForKey:kLCYActivityListActivitySponsor fromDictionary:dict];
            self.coorganizer = [self objectOrNilForKey:kLCYActivityListCoorganizer fromDictionary:dict];
            self.activityWeekTime = [self objectOrNilForKey:kLCYActivityListActivityWeekTime fromDictionary:dict];
            self.beScanTime = [[self objectOrNilForKey:kLCYActivityListBeScanTime fromDictionary:dict] doubleValue];
            self.type = [[self objectOrNilForKey:kLCYActivityListType fromDictionary:dict] doubleValue];
            self.activityStartTime = [self objectOrNilForKey:kLCYActivityListActivityStartTime fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.organizer forKey:kLCYActivityListOrganizer];
    [mutableDict setValue:self.activityDesign forKey:kLCYActivityListActivityDesign];
    [mutableDict setValue:self.activityTitle forKey:kLCYActivityListActivityTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.activityListIdentifier] forKey:kLCYActivityListId];
    [mutableDict setValue:self.activitySponsor forKey:kLCYActivityListActivitySponsor];
    [mutableDict setValue:self.coorganizer forKey:kLCYActivityListCoorganizer];
    [mutableDict setValue:self.activityWeekTime forKey:kLCYActivityListActivityWeekTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.beScanTime] forKey:kLCYActivityListBeScanTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kLCYActivityListType];
    [mutableDict setValue:self.activityStartTime forKey:kLCYActivityListActivityStartTime];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.organizer = [aDecoder decodeObjectForKey:kLCYActivityListOrganizer];
    self.activityDesign = [aDecoder decodeObjectForKey:kLCYActivityListActivityDesign];
    self.activityTitle = [aDecoder decodeObjectForKey:kLCYActivityListActivityTitle];
    self.activityListIdentifier = [aDecoder decodeDoubleForKey:kLCYActivityListId];
    self.activitySponsor = [aDecoder decodeObjectForKey:kLCYActivityListActivitySponsor];
    self.coorganizer = [aDecoder decodeObjectForKey:kLCYActivityListCoorganizer];
    self.activityWeekTime = [aDecoder decodeObjectForKey:kLCYActivityListActivityWeekTime];
    self.beScanTime = [aDecoder decodeDoubleForKey:kLCYActivityListBeScanTime];
    self.type = [aDecoder decodeDoubleForKey:kLCYActivityListType];
    self.activityStartTime = [aDecoder decodeObjectForKey:kLCYActivityListActivityStartTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_organizer forKey:kLCYActivityListOrganizer];
    [aCoder encodeObject:_activityDesign forKey:kLCYActivityListActivityDesign];
    [aCoder encodeObject:_activityTitle forKey:kLCYActivityListActivityTitle];
    [aCoder encodeDouble:_activityListIdentifier forKey:kLCYActivityListId];
    [aCoder encodeObject:_activitySponsor forKey:kLCYActivityListActivitySponsor];
    [aCoder encodeObject:_coorganizer forKey:kLCYActivityListCoorganizer];
    [aCoder encodeObject:_activityWeekTime forKey:kLCYActivityListActivityWeekTime];
    [aCoder encodeDouble:_beScanTime forKey:kLCYActivityListBeScanTime];
    [aCoder encodeDouble:_type forKey:kLCYActivityListType];
    [aCoder encodeObject:_activityStartTime forKey:kLCYActivityListActivityStartTime];
}


@end
