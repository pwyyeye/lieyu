//
//  LYFriendsCommentTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYFriendsCommentButton.h"
@class FriendsCommentModel;

@interface LYFriendsCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet LYFriendsCommentButton *btn_headerImg;
@property (weak, nonatomic) IBOutlet UILabel *label_comment;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_comment;
@property (nonatomic,strong) FriendsCommentModel *commentM;
@end
