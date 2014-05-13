//
//  QuestionAnswerID.h
//  ArtSearching
//
//  Created by developer on 14-5-13.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QuestionAnswerID : NSManagedObject

@property (nonatomic, retain) NSNumber * questionID;
@property (nonatomic, retain) NSString * questionAnswer;

@end
