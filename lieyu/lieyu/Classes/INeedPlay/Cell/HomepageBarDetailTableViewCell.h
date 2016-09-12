//
//  HomepageBarDetailTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiuBaModel.h"

@interface HomepageBarDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *barImage;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *barDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *barAddressShortLabel;
@property (weak, nonatomic) IBOutlet UILabel *barDistanceLabel;
@property (weak, nonatomic) IBOutlet UIView *seperateView;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *communicateButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) JiuBaModel *barModel;


@end
