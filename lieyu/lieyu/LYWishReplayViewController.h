//
//  LYWishReplayViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/5/14.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUWishesModel.h"
#import "LYBaseViewController.h"

@protocol WishReplayDelegate <NSObject>

- (void)delegateReply:(YUWishesModel *)model;

@end

@interface LYWishReplayViewController : LYBaseViewController

@property (nonatomic, strong) YUWishesModel *model;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextView *replayLabel;

@property (nonatomic, strong) id<WishReplayDelegate> delegate;

@end
