//
//  BeerBarDetailCell.m
//  lieyu
//
//  Created by newfly on 9/20/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BeerBarDetailCell.h"
#import "JiuBaModel.h"

#import "TeseModel.h"
#import "MJExtension.h"
#import "LYUserLocation.h"
@interface BeerBarDetailCell()

@end

@implementation BeerBarDetailCell

- (void)awakeFromNib {
    // Initialization code
//    [self initializeStar:_serviceNumView];
//    [self initializeStar:_envNumView];
    
}

//- (void)initializeStar:(HCSStarRatingView *)starView
//{
//    starView.maximumValue = 5;
//    starView.minimumValue = 0;
//    starView.allowsHalfStars = YES;
//    
//    starView.emptyStarImage = [UIImage imageNamed:@"icon_flowers_disable"];
//    starView.halfStarImage = [UIImage imageNamed:@"icon_flowers_half_normal"]; // optional
//    starView.filledStarImage = [UIImage imageNamed:@"icon_flowers_normal"];
//    starView.userInteractionEnabled = NO;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat )adjustCellHeight:(id)model
{
    return 220;
}

- (void)configureCell:(BeerBarOrYzhDetailModel *)model
{
//--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    barOrYzhDetailModel=model;
    _barName.text = model.barname;
    [_barPhoto sd_setImageWithURL:[NSURL URLWithString:model.baricon] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [_preOrderNumber setText:model.today_sm_buynum];
    [_address setText:model.address];

    if(model.bartypename){
        [_typeBtn1 setHidden:NO];
        [_typeBtn1 setTitle:model.bartypename forState:0];
    }
    if(model.barlevelname){
        [_typeBtn2 setHidden:NO];
        [_typeBtn2 setTitle:model.barlevelname forState:0];
    }
    NSArray *teseArr=@[_teseBtn1,_teseBtn2,_teseBtn3,_teseBtn4];
    for (int i=0; i<model.tese.count; i++) {
        if(i<=teseArr.count){
            NSDictionary *dic=model.tese[i];
            [_teseBtn1 setHidden:NO];
            [_teseBtn1 setTitle:[dic objectForKey:@"name"] forState:0];
        }else{
            break;
        }
    }
}

- (IBAction)daohanAct:(UIButton *)sender {

    NSDictionary *dic=@{@"title":barOrYzhDetailModel.barname,@"latitude":barOrYzhDetailModel.latitude,@"longitude":barOrYzhDetailModel.longitude};
    [[LYUserLocation instance] daoHan:dic];
}
@end





