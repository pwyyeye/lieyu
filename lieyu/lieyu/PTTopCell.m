//
//  PTTopCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PTTopCell.h"

#import "JiuBaModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LYUserLocation.h"
@implementation PTTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_daohanBtn setBackgroundColor:[UIColor clearColor]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)configureCell:(PinKeModel*)model
{
    pinKeModel=model;
    NSMutableArray *bigArr=[[NSMutableArray alloc]init];
    
    for (NSString *iconStr in model.banner) {
        NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
        [dicTemp setObject:iconStr forKey:@"ititle"];
        [dicTemp setObject:@"" forKey:@"mainHeading"];
        [bigArr addObject:dicTemp];
    }
    
    scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height)
                                           scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
    [self.topView addSubview:scroller];
    
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    NSString *str=model.barinfo.baricon ;
    [_jiubaImageView  setImageWithURL:[NSURL URLWithString:str]];
    
    _jiubaNameLal.text=model.barinfo.barname;
    _taoCanNameLal.text=model.title;
    _addressLal.text=model.barinfo.address;
    _shoucangCountLal.text=[NSString stringWithFormat:@"%d",model.barinfo.fav_num];
    _price.text=[NSString stringWithFormat:@"¥%@",pinKeModel.price] ;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",pinKeModel.marketprice] attributes:attribtDic];
    _marketprice.attributedText=attribtStr;
    _fitNum.text=[NSString stringWithFormat:@"套餐预定人数：%@~%@人（根据个人需求可调整套餐人数）",pinKeModel.minnum,pinKeModel.maxnum];
    
    
}
- (IBAction)daohan:(UIButton *)sender {
    NSDictionary *dic=@{@"title":pinKeModel.barinfo.barname,@"latitude":pinKeModel.barinfo.latitude,@"longitude":pinKeModel.barinfo.longitude};
    [[LYUserLocation instance] daoHan:dic];
}
@end
