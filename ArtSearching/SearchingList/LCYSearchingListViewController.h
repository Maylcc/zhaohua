//
//  LCYSearchingListViewController.h
//  ArtSearching
//
//  Created by eagle on 14-5-9.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCYSearchingListViewController : UIViewController

@end

@class LCYSearchingListMainParser;
@protocol LCYSearchingListMainParserDelegate <NSObject>
@optional
- (void)resultParserDidFinish:(LCYSearchingListMainParser *)parser withInfo:(id)resultInfo;
@end
@interface LCYSearchingListMainParser : NSObject<NSXMLParserDelegate>
@property (weak, nonatomic) id<LCYSearchingListMainParserDelegate>delegate;
@end