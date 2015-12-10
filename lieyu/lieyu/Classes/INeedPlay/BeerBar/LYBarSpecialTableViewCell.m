//
//  LYBarSpecialTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBarSpecialTableViewCell.h"

@implementation LYBarSpecialTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _typeBtn1.layer.cornerRadius = 2;
    _typeBtn1.layer.borderWidth = 0.5;
    _typeBtn1.layer.borderColor = RGBA(114, 5, 147, 1).CGColor;
    
    _typeBtn2.layer.cornerRadius = 2;
    _typeBtn2.layer.borderWidth = 0.5;
    _typeBtn2.layer.borderColor = RGBA(114, 5, 147, 1).CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(BeerBarOrYzhDetailModel *)model
{
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    
    if(model.bartypename){
        [_typeBtn1 setHidden:NO];
        _typeBtn1.text=model.bartypename;
    }
    if(model.barlevelname){
        [_typeBtn2 setHidden:NO];
        _typeBtn2.text=model.barlevelname;
    }
    NSArray *teseArr=@[_teseBtn1,_teseBtn2,_teseBtn3,_teseBtn4];
    for (int i=0; i<model.tese.count; i++) {
        UILabel *teseBtnTemp=teseArr[i];
        if(i<=teseArr.count){
            NSDictionary *dic=model.tese[i];
            teseBtnTemp.layer.cornerRadius = 2;
            teseBtnTemp.layer.borderWidth = 0.5;
            teseBtnTemp.layer.borderColor = RGBA(114, 5, 147, 1).CGColor;
            [teseBtnTemp setHidden:NO];
            teseBtnTemp.text=[dic objectForKey:@"name"];
        }else{
            break;
        }
    }
}

@end
