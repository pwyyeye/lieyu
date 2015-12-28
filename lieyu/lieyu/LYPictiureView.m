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
    NSInteger _voidIndex;
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
       // self.alpha = 0;
        [self addSubview:_scrollView];
        _scrollView.frame = frame;
        NSInteger count = urlArray.count;
        _scrollView.contentSize = CGSizeMake(count * SCREEN_WIDTH, 0);
        _imageViewArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < count; i ++) {
            FriendsPicAndVideoModel *pvModel = urlArray[i];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i % count * SCREEN_WIDTH,(SCREEN_HEIGHT - SCREEN_WIDTH)/2.f, SCREEN_WIDTH, SCREEN_WIDTH)];
            NSLog(@"---->%@",NSStringFromCGRect(imageView.frame));
            imageView.backgroundColor = [UIColor redColor];
            [imageView sd_setImageWithURL:[NSURL URLWithString:pvModel.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
            [_scrollView addSubview:imageView];
            [_imageViewArray addObject:imageView];
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes)];
            [imageView addGestureRecognizer:tapGes];
        }
        
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
        
        UIImageView *imgView = _imageViewArray[index];
        //imgView.alpha = 0;
        CGRect rect = CGRectFromString(oldFrame[index]);
        imgView.frame = CGRectMake(rect.origin.x + SCREEN_WIDTH * index, rect.origin.y, rect.size.width, rect.size.height);
        NSLog(@"--%ld--->%@",index,NSStringFromCGRect(imgView.frame));
        [UIView animateWithDuration:2 animations:^{
            imgView.alpha = 1;
            imgView.frame = CGRectMake(index % count * SCREEN_WIDTH,(SCREEN_HEIGHT - SCREEN_WIDTH)/2.f, SCREEN_WIDTH, SCREEN_WIDTH);
            self.alpha = 1;
        }];
        _voidIndex = index;
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _index = (scrollView.contentOffset.x / SCREEN_WIDTH);
}

- (void)tapGes{
    UIImageView *imgView = _imageViewArray[_index];
    [UIView animateWithDuration:3 animations:^{
        CGRect rect = CGRectFromString(_oldFrameArr[_voidIndex]);
        imgView.frame = CGRectMake(rect.origin.x + SCREEN_WIDTH * _voidIndex, rect.origin.y, rect.size.width, rect.size.height);
        imgView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
