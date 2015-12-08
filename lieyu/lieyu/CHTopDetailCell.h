//
//  CHTopDetailCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"
#import "CheHeModel.h"
@interface CHTopDetailCell : UITableViewCell<LYTableViewCellLayout>{
    EScrollerView *scroller;
}
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLbl;
@property (weak, nonatomic) IBOutlet UIView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *danpinLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *fanliLbl;
@property (weak, nonatomic) IBOutlet UILabel *saleLbl;

- (void)configureCell:(CheHeModel*)model;

@end
