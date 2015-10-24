//
//  CHBarCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHBarCell : UITableViewCell<LYTableViewCellLayout>
@property (weak, nonatomic) IBOutlet UILabel *barNameLal;
@property (weak, nonatomic) IBOutlet UILabel *addressLal;
@property (weak, nonatomic) IBOutlet UIImageView *barImageView;

@end
