//
//  PTTaoCanCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PTTaoCanCell.h"
#import "KuCunModel.h"
@implementation PTTaoCanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(KuCunModel*)model
{
        //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    self.titleLal.text=model.name;
    self.countLal.text=[NSString stringWithFormat:@"%@ %@",model.num,model.unit]; ;
    double d=model.price.doubleValue*model.num.intValue;
    self.jiagelal.text=[NSString stringWithFormat:@"￥%.2f",d];
}
@end
