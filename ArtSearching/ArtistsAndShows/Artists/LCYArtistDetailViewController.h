//
//  LCYArtistDetailViewController.h
//  ArtSearching
//
//  Created by eagle on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCYArtistDetailViewController : UIViewController
@property (strong, nonatomic) NSString *artistID;
@end

@protocol LCYArtistDetailViewControllerXMLParserDelegate <NSObject>
@optional
- (void)didFinishGetXMLInfo:(id)info;
@end
@interface LCYArtistDetailViewControllerXMLParser : NSObject<NSXMLParserDelegate>
@property (weak, nonatomic) id<LCYArtistDetailViewControllerXMLParserDelegate>delegate;
@end
