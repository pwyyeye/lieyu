//
//  LYFriendsImgVTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/1/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsImgVTableViewCell.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"

@implementation LYFriendsImgVTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecentModel:(FriendsRecentModel *)recentModel{
    _recentModel = recentModel;
    NSArray *array = recentModel.lyMomentsAttachList;
    _imgVArray = [[NSMutableArray alloc]init];
    FriendsPicAndVideoModel *pvModel = array[0];
    NSArray *urlArray = [pvModel.imageLink componentsSeparatedByString:@","];
    switch (urlArray.count) {
        case 1:
        {
            UIImageView *btn_imgOne = [[UIImageView alloc]initWithFrame:self.bounds];
            [btn_imgOne sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[0] width:SCREEN_WIDTH andHeight:SCREEN_WIDTH]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
            btn_imgOne.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:btn_imgOne];
            [_imgVArray addObject:btn_imgOne];
        }
            break;
        case 2:
        {
            CGFloat btnW = (SCREEN_WIDTH - 2) / 2.f;
            for (int i = 0; i < 2; i ++) {
                
                UIImageView *btn = [[UIImageView alloc]initWithFrame:CGRectMake(i%2 *(btnW + 2) , 0, btnW, btnW)];
                [btn sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:SCREEN_WIDTH andHeight:SCREEN_WIDTH]]  placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                btn.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:btn];
                [_imgVArray addObject:btn];
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
                UIImageView *btn = nil;
                switch (i) {
                    case 0:
                    {
                        btn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
                    }
                        break;
                        
                    default:
                    {
                        btn = [[UIImageView alloc]initWithFrame:CGRectMake((i - 1)%3 *(btnW + 2) , SCREEN_WIDTH + 2, btnW, btnW)];
                    }
                        break;
                        
                }
                btn.userInteractionEnabled = YES;
                
                [btn sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:SCREEN_WIDTH andHeight:SCREEN_WIDTH]]  placeholderImage:[UIImage imageNamed:@"empyImage120"]];
                btn.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:btn];
                [_imgVArray addObject:btn];
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
