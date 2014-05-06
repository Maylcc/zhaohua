//
//  LCYArtistsAndShowsViewController.h
//  ArtSearching
//
//  Created by Licy on 14-4-30.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCYArtistsAndShowsViewController : UIViewController

@end




@protocol LCYArtistsAvatarDownloadOperationDelegate <NSObject>
@optional
- (void)avatarDownloadDidFinished;
@end
@interface LCYArtistsAvatarDownloadOperation : NSOperation
@property (weak, nonatomic) id<LCYArtistsAvatarDownloadOperationDelegate>delegate;
- (void)addAvartarURL:(NSString *)URL;
@end
