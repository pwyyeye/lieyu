//
//  PTzsjlCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTzsjlCell : UITableViewCell<LYTableViewCellLayout>

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *ageLal;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@end
