//
//  LCYRenrenViewController.h
//  ArtSearching
//
//  Created by eagle on 14-4-16.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCYDataModels.h"

@interface LCYRenrenViewController : UIViewController

@end



@class LCYApplyersResultParser;
@protocol LCYApplyerResultParserDelegate <NSObject>
@optional
- (void)resultParserDidFinish:(LCYApplyersResultParser *)parser;
@end
@interface LCYApplyersResultParser : NSObject<NSXMLParserDelegate>
@property (strong, nonatomic) NSArray *result;
@property (weak, nonatomic) id<LCYApplyerResultParserDelegate>delegate;
@end
