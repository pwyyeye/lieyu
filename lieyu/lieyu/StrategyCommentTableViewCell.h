//
//  StrategyCommentTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/2.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrategyCommentModel.h"

@interface StrategyCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCommentLabel;

@property (nonatomic, strong) StrategyCommentModel *commentModel;

@end
