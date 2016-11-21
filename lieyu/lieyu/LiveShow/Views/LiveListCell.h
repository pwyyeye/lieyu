//
//  LiveListCell.h
//  lieyu
//
//  Created by 狼族 on 2016/11/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYLiveShowListModel.h"

@interface LiveListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *lookNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *liveTypeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) LYLiveShowListModel *listModel;


@end
