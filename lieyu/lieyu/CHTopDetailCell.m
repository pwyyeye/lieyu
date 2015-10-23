//
//  CHTopDetailCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHTopDetailCell.h"
#import "CheHeModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation CHTopDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(CheHeModel*)model
{
    
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    _barNameLal.text=model.fullname;
    _priceLal.text=[NSString stringWithFormat:@"￥%@",model.price];
     NSString *flTem=[NSString stringWithFormat:@"再返利%.f%%",model.rebate*100];
    _flLal.text=flTem;
    NSString *uintStr=[NSString stringWithFormat:@"%@%@%@%@",model.num,model.unit,model.product_item.num,model.product_item.unit];
    _unitLal.text=uintStr;
    //banner
    NSMutableArray *bigArr=[[NSMutableArray alloc]init];
    
    for (NSString *iconStr in model.goodsList) {
        NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
        [dicTemp setObject:iconStr forKey:@"ititle"];
        [dicTemp setObject:@"" forKey:@"mainHeading"];
        [bigArr addObject:dicTemp];
    }
    
    scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height)
                                           scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
    [self.topView addSubview:scroller];
}
@end
