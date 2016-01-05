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
    NSInteger _index;//滑动到第几个图片
    NSMutableArray *_imageViewArray;
    NSArray *_oldFrameArr;
    NSInteger _voidIndex;//第几个按钮
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
        self.backgroundColor = RGBA(255, 255, 255, 0);
        [self addSubview:_scrollView];
        _scrollView.frame = frame;
        NSInteger count = urlArray.count;
        _scrollView.contentSize = CGSizeMake(count * SCREEN_WIDTH, 0);
        _imageViewArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < count; i ++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i % count * SCREEN_WIDTH,(SCREEN_HEIGHT - SCREEN_WIDTH)/2.f, SCREEN_WIDTH, SCREEN_WIDTH)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:SCREEN_WIDTH andHeight:SCREEN_WIDTH]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
            [_scrollView addSubview:imageView];
            [_imageViewArray addObject:imageView];
            imageView.userInteractionEnabled = YES;
            
            imageView.center = CGPointMake(SCREEN_WIDTH *i + SCREEN_WIDTH/2.f, SCREEN_HEIGHT / 2.f);
            //imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes)];
            [imageView addGestureRecognizer:tapGes];
        }
        
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
        _scrollView.pagingEnabled = YES;
        
        UIImageView *imgView = _imageViewArray[index];
        CGRect rect = CGRectFromString(oldFrame[index]);
        imgView.frame = CGRectMake(rect.origin.x + SCREEN_WIDTH * index, rect.origin.y, rect.size.width, rect.size.height);
        NSLog(@"--%ld--->%@",index,NSStringFromCGRect(imgView.frame));
        [UIView animateWithDuration:.5 animations:^{
            imgView.alpha = 1;
            imgView.bounds = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH);
            imgView.center = CGPointMake(SCREEN_WIDTH *index + SCREEN_WIDTH/2.f, SCREEN_HEIGHT / 2.f);
            self.backgroundColor = RGBA(255, 255, 255, 1);
        }];
        _voidIndex = index;
        
        _pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 190, 37)];
        _pageCtl.center = CGPointMake(self.center.x, SCREEN_HEIGHT - 15 - _pageCtl.frame.size.height/2.f);
        [self addSubview:_pageCtl];
        _pageCtl.numberOfPages = count;
        _pageCtl.currentPage = index;
    }
    
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _index = (scrollView.contentOffset.x / SCREEN_WIDTH);
    NSLog(@"----%ld",_index);
    _pageCtl.currentPage = _index;
}

- (void)tapGes{
    UIImageView *imgView = _imageViewArray[_index];
    [UIView animateWithDuration:.5 animations:^{
        CGRect rect = CGRectFromString(_oldFrameArr[_index]);
        imgView.frame = CGRectMake(rect.origin.x + SCREEN_WIDTH * _index, rect.origin.y, rect.size.width, rect.size.height);
        self.backgroundColor = RGBA(255, 255, 255, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
