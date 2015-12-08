//
//  LYTagTableViewCell.m
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTagTableViewCell.h"

@interface LYTagTableViewCell()<UIAlertViewDelegate>

@end

@implementation LYTagTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.btn_custom setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    self.btn_custom.layer.masksToBounds=YES;
    self.btn_custom.layer.cornerRadius=2;
    self.btn_custom.layer.borderWidth=0.5;
    self.btn_custom.layer.borderColor=RGB(233, 233, 233).CGColor;
    
}

- (IBAction)customTagClick:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"自定义标签" message:@"好的标枪会给你带来更多精彩" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        if ([_delegate respondsToSelector:@selector(tagTableViewCellAlertViewClick)]) {
            [_delegate tagTableViewCellAlertViewClick];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
