//
//  QuestionAnswerID.h
//  Pods
//
//  Created by developer on 14-5-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QuestionAnswerID : NSManagedObject

@property (nonatomic, retain) NSString * questionAnswer;
@property (nonatomic, retain) NSNumber * questionID;
@property (nonatomic, retain) NSNumber * sortIndex;

@end
