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
    _danpinLbl.text = model.name;
    _priceLbl.text=[NSString stringWithFormat:@"￥%@",model.price];
    if(model.marketprice){
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.marketprice] attributes:attribtDic];
        _marketPriceLbl.attributedText=attribtStr;
    }
     NSString *flTem=[NSString stringWithFormat:@"返利%.f%%",model.rebate*100];
    _fanliLbl.text=flTem;
    _saleLbl.text = [NSString stringWithFormat:@"已售%@人",model.sales];
    _saleLbl.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    _saleLbl.layer.borderWidth = 0.5;
    _saleLbl.layer.masksToBounds = YES;
    //banner
    NSMutableArray *bigArr=[[NSMutableArray alloc]init];
    
    for (NSString *iconStr in model.goodsList) {
        NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
        [dicTemp setObject:iconStr forKey:@"ititle"];
        [dicTemp setObject:@"" forKey:@"mainHeading"];
        [bigArr addObject:dicTemp];
    }
    scroller = [[EScrollerView alloc]initWithFrameRect:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
    
    [self.scrollView addSubview:scroller];
}
@end
