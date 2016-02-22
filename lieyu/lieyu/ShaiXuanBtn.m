//
//  ShaiXuanBtn.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ShaiXuanBtn.h"

@implementation ShaiXuanBtn
- (void)awakeFromNib{
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 2, SCREEN_WIDTH / 5 - 30, 2)];
    [self addSubview:_lineLabel];
}

- (void)setSelected:(BOOL)selected{
    if(selected){//选择了
        _lineLabel.backgroundColor = RGBA(186, 40, 227, 1);
    }else{//未选择或取消选择
        _lineLabel.backgroundColor = [UIColor clearColor];
    }
}
@end
