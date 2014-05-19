//
//  ArtDetailContentArtCell.h
//  ArtSearching
//
//  Created by developer on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ArtToAuthorDelegate<NSObject>
- (void)artToAuthorDelegateWithID:(NSNumber *)artistID;
- (void)toShareWithWXWBView;
- (void)payAttention;
- (void)addComment;
@end
@interface ArtDetailContentArtCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *authodLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *concerdNum;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UIImageView *concerdNumImage;
@property (nonatomic,strong)NSNumber *indexNum;
@property (nonatomic,strong)id<ArtToAuthorDelegate>delegate;
- (IBAction)toAuthodDetail:(id)sender;
- (IBAction)actionForSharing:(id)sender;
- (IBAction)actionCollect:(id)sender;
- (IBAction)addComment:(id)sender;
@end
