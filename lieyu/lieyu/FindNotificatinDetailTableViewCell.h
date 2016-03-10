//
//  FindNotificatinDetailTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/3/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FindNewMessageList;

@interface FindNotificatinDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_icon;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_detail;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UILabel *label_state;
@property (nonatomic,strong) FindNewMessageList *findMessList;
@end
