//
//  LCYMyCollectionViewController.h
//  ArtSearching
//
//  Created by 李超逸 on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCYMyCollectionViewControllerDelegate <NSObject>
@optional
- (void)didGetImageInfoArray:(NSArray *)infoArray;
@end

@interface LCYMyCollectionViewController : UIViewController
@property (weak, nonatomic) id<LCYMyCollectionViewControllerDelegate>delegate;
@property NSInteger maxImageCount;
@property NSInteger minImageCount;
@end

@interface ImageInfo : NSObject
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *imageName;
+ (id)infoWithURL:(NSString *)URL name:(NSString *)name;
@end
