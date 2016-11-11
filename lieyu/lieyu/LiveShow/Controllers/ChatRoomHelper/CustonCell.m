//
//  CustonCell.m
//  PresentDemo
//
//  Created by 狼族 on 16/10/10.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CustonCell.h"
#import "PresentModel.h"

@interface CustonCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *senderName;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *gift;

@end

@implementation CustonCell

//- (instancetype)init
//{
//    if (self = [super init]) {
//        self = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:0].firstObject;
//        self.bgView.clipsToBounds = YES;
//        self.icon.clipsToBounds = YES;
//        self.icon.layer.borderWidth = 1;
//        self.icon.layer.borderColor = [UIColor cyanColor].CGColor;
//    }
//    return self;
//}

- (instancetype)initWithRow:(NSInteger)row
{
    if (self = [super initWithRow:row]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"CustonCell" owner:self options:0].firstObject;
        self.bgView.clipsToBounds   = YES;
        self.icon.clipsToBounds     = YES;
        self.icon.layer.borderWidth = 1;
        self.icon.layer.borderColor = [UIColor cyanColor].CGColor;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgView.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5;
    self.icon.layer.cornerRadius   = CGRectGetHeight(self.icon.frame) * 0.5;
}

- (void)setModel:(PresentModel *)model
{
    _model = model;
    if (self.icon.image) {
        [self.icon setImage:nil];
    }
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    self.senderName.text    = model.sender;
    self.giftNameLable.text = [NSString stringWithFormat:@"%@", model.giftName];
    if (self.gift.image) {
        [self.gift setImage:nil];
    }
    [self.gift sd_setImageWithURL:[NSURL URLWithString:model.giftImageName] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
//    self.gift.image         = [UIImage imageNamed:model.giftImageName];
}

//自定义cell的展示动画
- (void)customDisplayAnimationOfShowShakeAnimation:(BOOL)flag
{
    //这里是直接使用父类中的动画，如果用户想自定义可这里实现动画，不调用父类的方法(这个方法在UIView动画的animations回调中执行)
    [super customDisplayAnimationOfShowShakeAnimation:flag];
}

//自定义cell的隐藏动画
- (void)customHideAnimationOfShowShakeAnimation:(BOOL)flag
{
    [super customHideAnimationOfShowShakeAnimation:flag];
}

@end
