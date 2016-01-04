//
//  LYNewMessageTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsNewsModel;

@interface LYNewMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_headerImg;
@property (weak, nonatomic) IBOutlet UIButton *btn_name;
@property (weak, nonatomic) IBOutlet UILabel *label_message;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UILabel *label_myMessage;

@property (nonatomic,strong) FriendsNewsModel *friendsNesM;
@end
