//
//  LCYArtistsAndShowsViewController.h
//  ArtSearching
//
//  Created by Licy on 14-4-30.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCYArtistsAndShowsStatus){
    LCYArtistsAndShowsStatusArtists,    /**< 艺术家 */
    LCYArtistsAndShowsStatusShows       /**< 画廊 */
};

@interface LCYArtistsAndShowsViewController : UIViewController

@end

#pragma mark - 首次加载数据
@class LCYArtistsAndShowsFirstLoadParser;
@protocol LCYArtistsAndShowsFirstLoadParserDelegate <NSObject>
@optional
- (void)firstLoadDidEnd:(LCYArtistsAndShowsFirstLoadParser *)parser withResultInfo:(id)info;
@end
@interface LCYArtistsAndShowsFirstLoadParser : NSObject<NSXMLParserDelegate>
@property (weak, nonatomic) id<LCYArtistsAndShowsFirstLoadParserDelegate>delegate;
@property LCYArtistsAndShowsStatus currentStatus;
@end

#pragma mark - 下载头像
@protocol LCYArtistsAvatarDownloadOperationDelegate <NSObject>
@optional
- (void)avatarDownloadDidFinished;
@end
@interface LCYArtistsAvatarDownloadOperation : NSOperation
@property (weak, nonatomic) id<LCYArtistsAvatarDownloadOperationDelegate>delegate;
- (void)addAvartarURL:(NSString *)URL;
- (void)initConfigure;
@end

#pragma mark - 下拉刷新
@class LCYArtistsAndShowsPullDownRefreshParser;
@protocol LCYArtistsAndShowsPullDownRefreshParserDelegate <NSObject>
@optional
- (void)pullDownParserDidEnd:(LCYArtistsAndShowsPullDownRefreshParser *)parser withResultInfo:(id)info;
@end
@interface LCYArtistsAndShowsPullDownRefreshParser : NSObject<NSXMLParserDelegate>
@property LCYArtistsAndShowsStatus currentStatus;
@property (weak, nonatomic) id<LCYArtistsAndShowsPullDownRefreshParserDelegate>delegate;
@end

#pragma mark - 上拉加载更多
@class LCYArtistsAndShowsPushUpRefreshParser;
@protocol LCYArtistsAndShowsPushUpRefreshParserDelegate <NSObject>
@optional
- (void)pushUpParserDidEnd:(LCYArtistsAndShowsPushUpRefreshParser *)parser withResultInfo:(id)info;
@end
@interface LCYArtistsAndShowsPushUpRefreshParser : NSObject<NSXMLParserDelegate>
@property LCYArtistsAndShowsStatus currentStatus;
@property (weak, nonatomic) id<LCYArtistsAndShowsPushUpRefreshParserDelegate>delegate;
@end
