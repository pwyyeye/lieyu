//
//  AdviserBookChooseTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/6/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePeopleNumber.h"
#import "ChooseKaZuo.h"


@interface AdviserBookChooseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseView;

@property (nonatomic, strong) ChooseKaZuo *chooseKazuo;
@property (nonatomic, strong) ChoosePeopleNumber *choosePeople;

- (void)configureChoosePeopleNumber;
- (void)configureChooseKazuo;
@end
