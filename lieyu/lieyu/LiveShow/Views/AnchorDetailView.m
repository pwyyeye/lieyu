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

-(void)layoutSubviews{
    [self setCornerRadiusView:self.anchorIcon With:self.anchorIcon.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.genderIamge With:self.genderIamge.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.starlabel With:self.starlabel.frame.size.height /2 and:YES];
    [self setCornerRadiusView:self.tagLabel With:self.tagLabel.frame.size.height /2 and:YES];
}

-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
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
