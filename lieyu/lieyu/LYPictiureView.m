//
//  LYPictiureView.m
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYPictiureView.h"
#import "FriendsPicAndVideoModel.h"

@interface LYPictiureView ()<UIScrollViewDelegate>{
    NSInteger _index;
    NSMutableArray *_imageViewArray;
    NSArray *_oldFrameArr;
}

@end

@implementation LYPictiureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame urlArray:(NSArray *)urlArray oldFrame:(NSArray *)oldFrame with:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"--->%@-----%@",urlArray,oldFrame);
        _oldFrameArr = oldFrame;
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.delegate = self;
        self.alpha = 0;
        [self addSubview:_scrollView];
        _scrollView.frame = frame;
        NSInteger count = 2;
        _scrollView.contentSize = CGSizeMake(count * SCREEN_WIDTH, 0);
        _imageViewArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < count; i ++) {
           // FriendsPicAndVideoModel *pvModel = urlArray[i];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i % count * SCREEN_WIDTH,(SCREEN_HEIGHT - SCREEN_WIDTH)/2.f, SCREEN_WIDTH, SCREEN_WIDTH)];
            NSLog(@"---->%@",NSStringFromCGRect(imageView.frame));
            imageView.backgroundColor = [UIColor redColor];
           // [imageView sd_setImageWithURL:[NSURL URLWithString:pvModel.imageLink] ];
            [_scrollView addSubview:imageView];
            [_imageViewArray addObject:imageView];
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes)];
            [imageView addGestureRecognizer:tapGes];
        }
        
        UIImageView *imgView = _imageViewArray[index - 1];
        imgView.alpha = 0;
        imgView.frame = CGRectFromString(oldFrame[index - 1]);
        [UIView animateWithDuration:1 animations:^{
            imgView.alpha = 1;
            imgView.frame = CGRectMake((index - 1) % count * SCREEN_WIDTH,(SCREEN_HEIGHT - SCREEN_WIDTH)/2.f, SCREEN_WIDTH, SCREEN_WIDTH);
            self.alpha = 1;
        }];
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _index = (scrollView.contentOffset.x / SCREEN_WIDTH);
}

- (void)tapGes{
    UIImageView *imgView = _imageViewArray[_index];
    [UIView animateWithDuration:2 animations:^{
        imgView.frame = CGRectFromString(_oldFrameArr[_index]);
        imgView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
