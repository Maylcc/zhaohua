//
//  ArtDetailCommentViewController.h
//  ArtSearching
//
//  Created by developer on 14-5-19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtDetailCommentViewController : UIViewController<UITextViewDelegate>
{
    
    __weak IBOutlet UITextView *commentText;
}
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (nonatomic,strong)NSString *workID;
@end
