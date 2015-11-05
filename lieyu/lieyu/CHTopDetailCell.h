//
//  CHTopDetailCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"
@interface CHTopDetailCell : UITableViewCell<LYTableViewCellLayout>{
    EScrollerView *scroller;
}
@property (weak, nonatomic) IBOutlet UILabel *markPriceLal;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *barNameLal;
@property (weak, nonatomic) IBOutlet UILabel *priceLal;
@property (weak, nonatomic) IBOutlet UILabel *flLal;
@property (weak, nonatomic) IBOutlet UILabel *unitLal;
@end
