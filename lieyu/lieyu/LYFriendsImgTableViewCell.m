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
    NSArray *array = recentModel.lyMomentsAttachList;
    _btnArray = [[NSMutableArray alloc]init];
    FriendsPicAndVideoModel *pvModel = array[0];
    NSArray *urlArray = [pvModel.imageLink componentsSeparatedByString:@","];
    switch (urlArray.count) {
        case 1:
        {
            UIButton *btn_imgOne = [[UIButton alloc]initWithFrame:self.bounds];
            btn_imgOne.adjustsImageWhenHighlighted = NO;
            [btn_imgOne sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[0] width:0 andHeight:0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage300"]];
            btn_imgOne.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:btn_imgOne];
            [_btnArray addObject:btn_imgOne];
        }
            break;
        case 2:
        {
            CGFloat btnW = (SCREEN_WIDTH - 2) / 2.f;
            NSInteger picWidth = 450;
            if (recentModel.isMeSendMessage) picWidth = 0;
            for (int i = 0; i < 2; i ++) {
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i%2 *(btnW + 2) , 0, btnW, btnW)];
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
            NSInteger count = 0;
            CGFloat btnW = 0.0;
            switch (urlArray.count) {
                case 3:
                {
                    count = 3;
                    btnW = (SCREEN_WIDTH - 2) / 2.f;
                }
                    break;
                case 4:
                {
                    count = 4;
                    btnW = (SCREEN_WIDTH - 6) / 3.f;
                }
                    break;
                    
                default:
                    break;
            }
            
            for(int i = 0 ; i< count ; i ++ ){
                UIButton *btn = nil;
                UIImageView *imgView = nil;
                NSInteger picWidth = 0;
                switch (i) {
                    case 0:
                    {
                        btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
                        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
                        picWidth = 0;
                    }
                        break;
                        
                    default:
                    {
                        btn = [[UIButton alloc]initWithFrame:CGRectMake((i - 1)%3 *(btnW + 2) , SCREEN_WIDTH + 2, btnW, btnW)];
                        imgView = [[UIImageView alloc]initWithFrame:CGRectMake((i - 1)%3 *(btnW + 2) , SCREEN_WIDTH + 2, btnW, btnW)];
                        picWidth = 450;
                    }
                        break;
                        
                }
//                imgView.userInteractionEnabled = YES;
                imgView.clipsToBounds = YES;
                if( recentModel.isMeSendMessage ){
                    picWidth = 0;
                }
                [btn sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:picWidth andHeight:picWidth]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                NSLog(@"---->%@",[MyUtil getQiniuUrl:urlArray[i] width:picWidth andHeight:picWidth]);
                //[imgView sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:picWidth andHeight:picWidth]]   placeholderImage:[UIImage imageNamed:@"empyImage120"]];
                btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                imgView.contentMode = UIViewContentModeScaleAspectFill;
//                btn.contentMode = UIViewContentModeScaleAspectFill;
                btn.adjustsImageWhenHighlighted = NO;
//                [self addSubview:imgView];
                [self addSubview:btn];
                [_btnArray addObject:btn];
            }
        }
            break;
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
