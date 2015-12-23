//
//  LYTagsViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/22.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@class UserTagModel;

@protocol LYTagsViewControllerDelegate <NSObject>

-(void)userTagSelected:(UserTagModel *)usertag;

@end

@interface LYTagsViewController : LYBaseViewController
@property(unsafe_unretained,nonatomic) id<LYTagsViewControllerDelegate>delegate;
@property (nonatomic,copy) NSString *selectedTag;
@end
