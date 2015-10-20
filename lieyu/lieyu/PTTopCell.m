//
//  PTTopCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PTTopCell.h"
#import "PinKeModel.h"
#import "JiuBaModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation PTTopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(PinKeModel*)model
{
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
    _shoucangCountLal.text=model.barinfo.fav_num;
    
}
@end
