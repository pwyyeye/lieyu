//
//  LYTaoCanListTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTaoCanListTableViewCell.h"
#import "KuCunModel.h"

@implementation LYTaoCanListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setGoodListArray:(NSArray *)goodListArray{
    _goodListArray = goodListArray;
    NSInteger x = _goodListArray.count;
    for (int i = 0; i < x * 3; i ++) {
        KuCunModel *model = _goodListArray[i/3];
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGBA(76, 76, 76, 1);

        CGFloat offsetX;
        CGFloat offsetZ;
        if (i%3 == 0) {
            offsetX = 30;
        }else{
            offsetX = 0;
        }
        if (i%3 == 1) {
            offsetZ = 40;
        }else{
            offsetZ = 0;
        }
        label.frame = CGRectMake( i%3 * 100 + 10 + offsetZ, i/3 * 50 + 40, 100 + offsetX, 55);
        NSString *str;
        if (i%3 == 0) {
            str = model.name;
            label.numberOfLines = 0;
             label.font = [UIFont systemFontOfSize:12];
        }else if(i%3 == 1){
            str = [NSString stringWithFormat:@"%@%@",model.num,model.unit];
            label.textAlignment = NSTextAlignmentCenter;
        }else{
            NSString *priceTotle = [NSString stringWithFormat:@"%d",model.price.integerValue * model.num.integerValue];
            str = [NSString stringWithFormat:@"¥%@",priceTotle];
            label.textColor = RGBA(114, 5, 147, 1);
            label.textAlignment = NSTextAlignmentRight;
        }
        label.text = str;
        [self addSubview:label];
    }
}

- (void)setIsProgress:(BOOL)isProgress{
    _isProgress = isProgress;
    UIImageView *progressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 52, 304, 155)];
    self.label_title.text = @"套餐消费流程";
    progressImageView.image = [UIImage imageNamed:@"套餐"];
    [self addSubview:progressImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
