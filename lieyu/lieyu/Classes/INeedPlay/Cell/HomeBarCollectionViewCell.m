//
//  HomeBarCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomeBarCollectionViewCell.h"
#import "JiuBaModel.h"
#import "LYUserLoginViewController.h"
#import "LYHomePageHttpTool.h"
#import "LYFriendsTopicsViewController.h"
#import "LYYUHttpTool.h"
#import "BarGroupChatViewController.h"
#import "IQKeyboardManager.h"

@interface HomeBarCollectionViewCell()<LYBarCommentSuccessDelegate>

@end

@implementation HomeBarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_imgView_bg setContentMode:UIViewContentModeScaleAspectFill];
    _imgView_bg.layer.masksToBounds = YES;
    
    _bottomView.layer.shadowColor = [[UIColor blackColor]CGColor];
    _bottomView.layer.shadowOpacity = 0.3;
    _bottomView.layer.shadowOffset = CGSizeMake(0, 1);
    
    _communicateButton.layer.cornerRadius = 15;
    _communicateButton.layer.borderColor = [COMMON_PURPLE CGColor];
    _communicateButton.layer.borderWidth = 1;
}

- (void)setJiuBaM:(JiuBaModel *)jiuBaM{
    _jiuBaM = jiuBaM;
    
    _label_barName.text = jiuBaM.barname;
    if(jiuBaM.banners.count ){
        //        NSLog(@"---->%@----->%@",jiuBaM.banners,jiuBaM.banners.firstObject);
        NSString *str = jiuBaM.banners.firstObject;
        //        NSLog(@"-->%@",str);
        if(![str isKindOfClass:[NSNull class]]){
            [_imgView_bg sd_setImageWithURL:[NSURL URLWithString:jiuBaM.banners[0]] placeholderImage:[UIImage imageNamed:@"empyImageBar16_9"]];
        }
    }
    
    _label_barDescr.text = jiuBaM.subtitle;
    _label_price.text = [NSString stringWithFormat:@"%@元起",jiuBaM.lowest_consumption];
    _label_address.text = jiuBaM.addressabb;
    if([MyUtil isEmptyString:jiuBaM.addressabb]){
        _view_line_distance.hidden = YES;
        _label_disstance_left_cons.constant = -7;
    }else{
        _view_line_distance.hidden = NO;
        _label_disstance_left_cons.constant = 8;
    }
    
    if(![MyUtil isEmptyString:jiuBaM.distance] && jiuBaM.distance.floatValue != 0.f){
        CGFloat distanceStr = jiuBaM.distance.floatValue * 1000;
        if (distanceStr > 1000) {
            [_label_distance setText:[NSString stringWithFormat:@"%.0fkm",distanceStr/1000]];
        }else{
            [_label_distance setText:[NSString stringWithFormat:@"%.0fm",distanceStr]];
        }
    }
    
    if (jiuBaM.like_num) {
        int num = jiuBaM.like_num;
        if(num < 1000){
            [_collectButton setTitle:[NSString stringWithFormat:@"%d",jiuBaM.like_num] forState:UIControlStateNormal];
        }else{
            [_collectButton setTitle:[NSString stringWithFormat:@"%dk+",jiuBaM.like_num / 1000] forState:UIControlStateNormal];
        }
    }else{
        [_collectButton setTitle:@"0" forState:UIControlStateNormal];
    }
    if (jiuBaM.commentNum) {
        int num = jiuBaM.commentNum;
        if (num < 1000) {
            [_commentButton setTitle:[NSString stringWithFormat:@"%d",jiuBaM.commentNum] forState:UIControlStateNormal];
        }else{
            [_commentButton setTitle:[NSString stringWithFormat:@"%dk+",jiuBaM.commentNum / 1000] forState:UIControlStateNormal];
        }
    }
    
    [_collectButton addTarget:self action:@selector(collectBar) forControlEvents:UIControlEventTouchUpInside];
    [_commentButton addTarget:self action:@selector(commentBar) forControlEvents:UIControlEventTouchUpInside];
    [_communicateButton addTarget:self action:@selector(communicateBar) forControlEvents:UIControlEventTouchUpInside];
    
    int fanli=jiuBaM.rebate.floatValue * 100;
    
    if([jiuBaM.isSign isEqualToString:@"0"]) _imgYu.hidden = YES;
    else _imgYu.hidden = NO;
    if (!fanli) {
        _label_fanli.text = @"";
        _label_fanli.hidden = YES;
        _view_withFanli.hidden = YES;
        _label_fanli_right_const.constant = 0;
        _view_fanli_right_const.constant = 2;
        return;
    }
    _label_fanli.hidden = NO;
    _view_withFanli.hidden = NO;
    _label_fanli_right_const.constant = 10;
    _view_fanli_right_const.constant = 7;
    _label_fanli.text =[NSString stringWithFormat:@"返利%d%@",fanli,@"%"];
    
    if ([jiuBaM.recommended isEqualToString:@"1"]) {
        _img_hot.hidden = NO;
    }else{
        _img_hot.hidden = YES;
    }
}

- (void)collectBar{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.userModel.userid) {
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [app.navigationController pushViewController:loginVC animated:YES];
    }else{
        NSDictionary * param = @{@"barid":[NSString stringWithFormat:@"%d",_jiuBaM.barid]};
        if (_jiuBaM.isLiked == 1) {
            [[LYHomePageHttpTool shareInstance] unLikeJiuBa:param compelete:^(bool result) {
                //收藏过
                if(result){
                    _jiuBaM.isLiked = 0;
                    _jiuBaM.like_num --;
                    [_collectButton setTitle:[NSString stringWithFormat:@"%d",_jiuBaM.like_num] forState:UIControlStateNormal];
                }
            }];
        }else{
            [[LYHomePageHttpTool shareInstance] likeJiuBa:param compelete:^(bool result) {
                if (result) {
                    _jiuBaM.isLiked = 1;
                    _jiuBaM.like_num ++;
                    [_collectButton setTitle:[NSString stringWithFormat:@"%d",_jiuBaM.like_num] forState:UIControlStateNormal];
                }
            }];
        }
    }
}

- (void)commentBar{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.userModel.userid) {
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [app.navigationController pushViewController:loginVC animated:YES];
    }else{
        if(_jiuBaM.topicTypeId.length){
            LYFriendsTopicsViewController *friendTopicVC = [[LYFriendsTopicsViewController alloc]init];
            friendTopicVC.topicTypeId = _jiuBaM.topicTypeId;
            friendTopicVC.topicName = _jiuBaM.topicTypeName;
            friendTopicVC.commentDelegate = self;
            friendTopicVC.isFriendsTopic = NO;
            friendTopicVC.isFriendToUserMessage = YES;
            friendTopicVC.isTopic = YES;
            [app.navigationController pushViewController:friendTopicVC animated:YES];
        }
    }
}

- (void)lyBarCommentsSendSuccess{
    if (_jiuBaM.commentNum) {
        _jiuBaM.commentNum = _jiuBaM.commentNum + 1;
    }else{
        _jiuBaM.commentNum = 1;
    }
    [_commentButton setTitle:[NSString stringWithFormat:@"%d条评论",_jiuBaM.commentNum] forState:UIControlStateNormal];
}

- (void)communicateBar{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.userModel.userid) {
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [app.navigationController pushViewController:loginVC animated:YES];
    }else{
        __weak __typeof(self) weakSelf = self;
        if (!_jiuBaM.hasGroup) {//没有群组--创建
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setValue:[NSString stringWithFormat:@"%d",_jiuBaM.barid] forKey:@"groupId"];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *imuserId = app.userModel.imuserId;
            [paraDic setValue:imuserId  forKey:@"userIds"];
            [paraDic setValue:_jiuBaM.barname forKey:@"groupName"];
            [LYYUHttpTool yuCreatGroupWith:paraDic complete:^(NSDictionary *data) {
                BarGroupChatViewController *barChatVC = [[BarGroupChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:[NSString stringWithFormat:@"%d",_jiuBaM.barid]];
                barChatVC.title = [NSString stringWithFormat:@"%@",_jiuBaM.barname];
                barChatVC.groupManage = [_jiuBaM.groupManage componentsSeparatedByString:@","];
                [app.navigationController pushViewController:barChatVC animated:YES];
                [IQKeyboardManager sharedManager].enable = NO;
                [IQKeyboardManager sharedManager].isAdd = YES;
                
                barChatVC.navigationItem.leftBarButtonItem = [weakSelf getItem];
            }];
        } else {//加入群组
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setValue:[NSString stringWithFormat:@"%d",_jiuBaM.barid] forKey:@"groupId"];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *imuserId = app.userModel.imuserId;
            [paraDic setValue:imuserId  forKey:@"userId"];
            [paraDic setValue:_jiuBaM.barname forKey:@"groupName"];
            [LYYUHttpTool yuJoinGroupWith:paraDic complete:^(NSDictionary *data) {
                
                //            NSString *code = data[@"code"];
                BarGroupChatViewController *barChatVC = [[BarGroupChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:[NSString stringWithFormat:@"%d",_jiuBaM.barid]];
                barChatVC.title = [NSString stringWithFormat:@"%@",_jiuBaM.barname];
                barChatVC.groupManage = [_jiuBaM.groupManage componentsSeparatedByString:@","];
                [app.navigationController pushViewController:barChatVC animated:YES];
                [IQKeyboardManager sharedManager].enable = NO;
                [IQKeyboardManager sharedManager].isAdd = YES;
                
                barChatVC.navigationItem.leftBarButtonItem = [weakSelf getItem];
                
            }];
            
        }
    }
}

- (UIBarButtonItem *)getItem{
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    return item;
}

- (void)backForward{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [app.navigationController popViewControllerAnimated:YES];
}

@end
