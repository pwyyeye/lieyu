//
//  AnchorDetailView.m
//  lieyu
//
//  Created by 狼族 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AnchorDetailView.h"

@implementation AnchorDetailView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.anchorIcon.layer.cornerRadius = self.anchorIcon.frame.size.height /2;
    self.anchorIcon.layer.masksToBounds = YES;
    
    self.genderIamge.layer.cornerRadius = self.genderIamge.frame.size.height / 2;
    self.genderIamge.layer.masksToBounds = YES;
    
    self.starlabel.layer.cornerRadius = self.starlabel.frame.size.height / 2;
    self.starlabel.layer.masksToBounds = YES;
    
    self.tagLabel.layer.cornerRadius = self.tagLabel.frame.size.height / 2;
    self.tagLabel.layer.masksToBounds = YES;
}


- (IBAction)focusButtonAction:(UIButton *)sender {
}

- (IBAction)secreteMessageuttonAction:(UIButton *)sender {
}

- (IBAction)mainViewButtonAction:(UIButton *)sender {
}

- (IBAction)closeButtonAction:(UIButton *)sender {
    self.hidden = YES;
}
@end
