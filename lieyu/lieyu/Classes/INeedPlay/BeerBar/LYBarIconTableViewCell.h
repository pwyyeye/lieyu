//
//  LYBarIconTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYBarIconTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;
@property (nonatomic,strong) UIButton *moreBtn;
@end
