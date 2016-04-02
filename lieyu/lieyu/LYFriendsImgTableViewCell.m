//
//  LYFriendsImgTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsImgTableViewCell.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"
#import "UIButton+WebCache.h"
@implementation LYFriendsImgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecentModel:(FriendsRecentModel *)recentModel{
    _recentModel = recentModel;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = recentModel.lyMomentsAttachList;
    _btnArray = [[NSMutableArray alloc]init];
    if(array.count){
    FriendsPicAndVideoModel *pvModel = array[0];
    NSArray *urlArray = [pvModel.imageLink componentsSeparatedByString:@","];
    if(!urlArray.count) return;
    switch (urlArray.count) {
        case 1:
        {
            UIButton *btn_imgOne = [[UIButton alloc]initWithFrame:CGRectMake(60, self.bounds.origin.y, self.bounds.size.width - 70, self.bounds.size.width - 70 )];
            btn_imgOne.adjustsImageWhenHighlighted = NO;
            NSLog(@"--->%@",[MyUtil getQiniuUrl:urlArray[0] width:0 andHeight:0]);
            [btn_imgOne sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[0] width:0 andHeight:0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage300"]];
            btn_imgOne.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:btn_imgOne];
            [_btnArray addObject:btn_imgOne];
        }
            break;
        case 2:
        {
            CGFloat btnW = (SCREEN_WIDTH - 75) / 2.f;
            NSInteger picWidth = 450;
            if (recentModel.isMeSendMessage) picWidth = 0;
            for (int i = 0; i < 2; i ++) {
                if(urlArray.count <= i) return;
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i%2 *(btnW + 5) + 60, 0, btnW, btnW)];
                [btn sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:picWidth andHeight:picWidth]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                btn.adjustsImageWhenHighlighted = NO;
                            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:btn];
                [_btnArray addObject:btn];
            }
        }
            break;
        case 3:{
            CGFloat btnW = (SCREEN_WIDTH - 75) / 2.f;
            NSInteger picWidth = 0;
            if (recentModel.isMeSendMessage) picWidth = 0;
            for (int i = 0; i < 3; i ++) {
                if(urlArray.count <= i) return;
                UIButton *btn = nil;
                if (i == 0) {
                    btn  = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 70, SCREEN_WIDTH - 70)];
                    
                }else{
                    btn = [[UIButton alloc]initWithFrame:CGRectMake((i - 1)%3 *(btnW + 5) + 60, SCREEN_WIDTH - 65, btnW, btnW)];
                }
                [btn sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:picWidth andHeight:picWidth]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                btn.adjustsImageWhenHighlighted = NO;
                btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:btn];
                [_btnArray addObject:btn];
            }
        }
            break;
        
            
        default:
        {
            CGFloat btnW = (SCREEN_WIDTH - 75) / 2.f;
            NSInteger picWidth = 450;
            if (recentModel.isMeSendMessage) picWidth = 0;
            for (int i = 0; i < 4; i ++) {
                if(urlArray.count <= i) return;
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i%2 *(btnW + 5) + 60, i / 2 * (btnW + 5), btnW, btnW)];
                [btn sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:picWidth andHeight:picWidth]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                btn.adjustsImageWhenHighlighted = NO;
                btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:btn];
                [_btnArray addObject:btn];
            }
        }
            break;
    }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
