//
//  JoinedTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "JoinedTableViewCell.h"
#import "YUPinkerListModel.h"
#import "LYFriendsPersonMessageViewController.h"
#import "UIImageView+WebCache.h"

@implementation JoinedTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureMoreAction{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 55, 20, 110, 28)];
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [RGB(153, 50, 204)CGColor];
    button.layer.borderWidth = 0.5;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:RGB(153, 50, 204) forState:UIControlStateNormal];
    button.titleLabel.text = @"更多拼客活动";
    button.hidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"YUGroup"]];
    imageView.frame = CGRectMake(SCREEN_WIDTH / 2 - 57, 20, 114, 114);
    [self addSubview:imageView];
    [self addSubview:button];
}

- (void)configureMessage{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
}

- (void)configureJoinedNumber:(int)number andPeople:(YUOrderInfo *)OrderInfo{
    _pinkeModelList = OrderInfo.pinkerList;
    _view = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16, self.frame.size.height)];
    _view.image = [UIImage imageNamed:@"backViewWithCorner"];
    _view.layer.shadowColor = [[UIColor blackColor]CGColor];
    _view.layer.shadowOffset = CGSizeMake(0, 1);
    _view.layer.shadowOpacity = 0.1;
    _view.layer.shadowRadius = 1;
    
    [self addSubview:_view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 200, 16)];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = [NSString stringWithFormat:@"已参加( %d/%d )",OrderInfo.pinkerCount,number];
    label.font = [UIFont systemFontOfSize:12];
    [_view addSubview:label];
    
    int x = 8;
    int y = 34;
    for (int i = 0 ; i < _pinkeModelList.count; i ++) {
//        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:((YUPinkerListModel *)[pinkeList objectAtIndex:i]).inmenberAvatar_img]]]];
        UIImageView *image = [[UIImageView alloc]init];
        [image sd_setImageWithURL:[NSURL URLWithString:((YUPinkerListModel *)[_pinkeModelList objectAtIndex:i]).inmenberAvatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        image.layer.cornerRadius = 20;
        image.clipsToBounds = YES;
        
        YUPinkerListModel *model = [_pinkeModelList objectAtIndex:i];
//        model.quantity = @"2";
        if([model.quantity intValue] > 1){
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x + 30,y + 0, 16, 16)];
            label.layer.cornerRadius = 8;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            label.layer.masksToBounds = YES;
            label.backgroundColor = RGB(186, 40, 227);
            label.textColor = [UIColor whiteColor];
            label.text = model.quantity;
            [_view addSubview:label];
            label.layer.zPosition = 2.0;
        }
//        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lieyuIcon"]];
//        UIImageView *hot_image = [UIImageView alloc]ini
        if( x + 40 > SCREEN_WIDTH - 16){
            y = y + 50;
            x = 8;
        }
        image.frame = CGRectMake(x, y, 40, 40);
        
        [_view addSubview:image];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x + 8 , y, 40, 40)];
        [button addTarget:self.delegate action:@selector(gotoUserPage:) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = [UIColor clearColor];
        button.enabled = YES;
        button.tag = i;
        [self addSubview:button];
        
        x = x + 50;
    }
    _view.frame = CGRectMake(8, 0, SCREEN_WIDTH - 16, y + 50);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, y + 50);
}

//- (void)gotoUserPage:(UIButton *)button{
//    NSInteger index = button.tag;
//    if ([self.delegate respondsToSelector:@selector(HDDetailJumpToFriendDetail:)]) {
//        [self.delegate HDDetailJumpToFriendDetail:((YUPinkerListModel *)[_pinkeModelList objectAtIndex:index]).inmember];
//    }
//}

- (void)gotoUserPage:(UITapGestureRecognizer *)tap{
//    NSInteger index = button.tag;
    NSInteger index = tap.view.tag;
    if ([self.delegate respondsToSelector:@selector(HDDetailJumpToFriendDetail:)]) {
        [self.delegate HDDetailJumpToFriendDetail:((YUPinkerListModel *)[_pinkeModelList objectAtIndex:index]).inmember];
    }
}

@end
