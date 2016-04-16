//
//  LYPictiureView.m
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYPictiureView.h"
#import "FriendsPicAndVideoModel.h"
#define animateTime 0.3

@interface LYPictiureView ()<UIScrollViewDelegate,UIActionSheetDelegate>{
    NSInteger _index;//滑动到第几个图片
    NSMutableArray *_imageViewArray;
    NSArray *_oldFrameArr,*_urlArray;
    NSInteger _voidIndex;//第几个按钮
    UIActionSheet *_sheet;
    CGFloat offset;
    NSMutableArray *_scrollViewArray;
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
        _urlArray = urlArray;
        _scrollViewArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        _oldFrameArr = oldFrame;
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
//        _scrollView.maximumZoomScale = 2.0;
        self.backgroundColor = RGBA(255, 255, 255, 0);
        [self addSubview:_scrollView];
        _scrollView.frame = frame;
        NSInteger count = urlArray.count;
        _scrollView.contentSize = CGSizeMake(count * SCREEN_WIDTH, 0);
        _imageViewArray = [[NSMutableArray alloc]init];

        for (int i = 0; i < count; i ++) {
            UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            [doubleTap setNumberOfTapsRequired:2];
            
            UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            s.backgroundColor = [UIColor clearColor];
            s.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
            s.showsHorizontalScrollIndicator = NO;
            s.showsVerticalScrollIndicator = NO;
            s.delegate = self;
            s.minimumZoomScale = 1.0;
            s.maximumZoomScale = 3.0;
            s.tag = i+1;
            [s setZoomScale:1.0];
            [_scrollViewArray addObject:s];
            [_scrollView addSubview:s];
            
             UIImageView *imageView = [[UIImageView alloc]init];
            SDImageCache *mamager = [SDImageCache sharedImageCache];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
            
            UIImage *localImg = [mamager imageFromMemoryCacheForKey:[MyUtil getQiniuUrl:urlArray[i] width:450 andHeight:450]] == nil? [mamager imageFromMemoryCacheForKey:[MyUtil getQiniuUrl:urlArray[i] width:0 andHeight:0]] : [mamager imageFromMemoryCacheForKey:[MyUtil getQiniuUrl:urlArray[i] width:450 andHeight:450]];
            if (localImg == nil) {
                localImg = [UIImage imageNamed:@"empyImage300"];
            }
            
        [imageView sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlArray[i] width:0 andHeight:0]] placeholderImage:localImg];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
//            imageView.contentMode = UIViewContentModeCenter;
            imageView.clipsToBounds = YES;
            imageView.tag = i+1;
            [imageView addGestureRecognizer:doubleTap];
            [s addSubview:imageView];
            [_imageViewArray addObject:imageView];
            imageView.userInteractionEnabled = YES;
        
            SDImageCache *cache = [SDImageCache sharedImageCache];
            UIImage *img = [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[i] width:0 andHeight:0]] == nil ? [cache imageFromMemoryCacheForKey:[MyUtil getQiniuUrl:_urlArray[i] width:0 andHeight:0]] : [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[i] width:0 andHeight:0]];
            if (img == nil) {
                img = [UIImage imageNamed:@"empyImage300"];
            }
           
            CGFloat imgHeight = SCREEN_WIDTH * img.size.height/img.size.width;
            imageView.frame =  CGRectMake(0, (SCREEN_HEIGHT -imgHeight)/2.f , SCREEN_WIDTH ,imgHeight);
            
            s.contentSize = CGSizeMake(0, imgHeight);
            if (imageView.frame.size.height < SCREEN_HEIGHT) {
                s.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
            }

            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes)];
            [tapGes setNumberOfTapsRequired:1];
            [imageView addGestureRecognizer:tapGes];
            [s addGestureRecognizer:tapGes];
            
            [tapGes requireGestureRecognizerToFail:doubleTap];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(savePicture:)];
//            longPress.minimumPressDuration = 1;
            [imageView addGestureRecognizer:longPress];
            
        }
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
        _scrollView.pagingEnabled = YES;
        
        if(_imageViewArray.count <= index || oldFrame.count <= index){
            return nil;
        }
        UIImageView *imgView = _imageViewArray[index];
        CGRect rect = CGRectFromString(oldFrame[index]);
        imgView.frame = rect;
        
        [UIView animateWithDuration:animateTime animations:^{
            imgView.alpha = 1;
            SDImageCache *cache = [SDImageCache sharedImageCache];
            if (_urlArray.count <= _index) {
                return ;
            }
            UIImage *img = [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[_index] width:0 andHeight:0]] == nil ? [cache imageFromMemoryCacheForKey:[MyUtil getQiniuUrl:_urlArray[_index] width:0 andHeight:0]] : [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[_index] width:0 andHeight:0]];
            if (img == nil) {
                img = [UIImage imageNamed:@"empyImage300"];
            }
            imgView.bounds = CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH * img.size.height/img.size.width);
            NSLog(@"-->%@",NSStringFromCGRect(imgView.bounds));
            imgView.center = CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT / 2.f);
            if (imgView.bounds.size.height > SCREEN_HEIGHT) {
                imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH * img.size.height/img.size.width);
            }
            
            self.backgroundColor = RGBA(255, 255, 255, 1);
        } completion:^(BOOL finished) {
            for (int i = 0 ; i< _imageViewArray.count ; i++) {
                UIImageView *imgView_ce = _imageViewArray[i];
                UIScrollView *scrollV = _scrollViewArray[i];
                SDImageCache *cache = [SDImageCache sharedImageCache];
                if(_urlArray.count > _index){
                UIImage *img = [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[i] width:0 andHeight:0]] == nil ? [cache imageFromMemoryCacheForKey:[MyUtil getQiniuUrl:_urlArray[i] width:0 andHeight:0]] : [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[i] width:0 andHeight:0]];
                    if (img == nil) {
                        img = [UIImage imageNamed:@"empyImage300"];
                    }
                imgView_ce.frame = CGRectMake(0, (SCREEN_HEIGHT -SCREEN_WIDTH * img.size.height/img.size.width )/2.f, SCREEN_WIDTH ,SCREEN_WIDTH * img.size.height/img.size.width);
                    if (imgView_ce.bounds.size.height > SCREEN_HEIGHT) {
//                        scrollV.contentSize = CGSizeMake(SCREEN_WIDTH, imgView_ce.frame.size.height);
                        imgView_ce.frame = CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH * img.size.height/img.size.width);
                    }
                //                imgView_ce.contentMode = UIViewContentModeScaleAspectFit;
              //  imgView_ce.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }
            }
        }];
        _voidIndex = index;
        
        _pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 190, 37)];
        _pageCtl.center = CGPointMake(self.center.x, SCREEN_HEIGHT - 15 - _pageCtl.frame.size.height/2.f);
        [self addSubview:_pageCtl];
        _pageCtl.numberOfPages = count;
        _pageCtl.currentPage = index;
        
        if(count == 1) _pageCtl.hidden = YES;
        
//        UITapGestureRecognizer *scroll_tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scroll_tapGes)];
//        [_scrollView addGestureRecognizer:scroll_tapGes];
    }
    return self;
}

- (void)scroll_tapGes{
    [UIView animateWithDuration:animateTime animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _index = (_scrollView.contentOffset.x / SCREEN_WIDTH);
//    NSLog(@"----->%f-------->%d",_scrollView.contentOffset.x,((int)_scrollView.contentOffset.x % (int)SCREEN_WIDTH));
//    if(((int)_scrollView.contentOffset.x % (int)SCREEN_WIDTH) != 0){
//        for (UIScrollView *s in _scrollViewArray) {
//            s.delegate = nil;
//        }
//    }
    _pageCtl.currentPage = _index;
}

#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x == offset){
            
        }
        else {
            offset = x;
            for (int i = 0; i< scrollView.subviews.count ; i ++){
                UIScrollView *s =  scrollView.subviews[i];
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
//                    image.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                    SDImageCache *cache = [SDImageCache sharedImageCache];
                    if(_urlArray.count > _index){
                        UIImage *img = [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[i] width:0 andHeight:0]] == nil ? [cache imageFromMemoryCacheForKey:[MyUtil getQiniuUrl:_urlArray[i] width:0 andHeight:0]] : [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[i] width:0 andHeight:0]];
                        if (img == nil) {
                            img = [UIImage imageNamed:@"empyImage300"];
                        }
//                        s.contentSize = CGSizeMake(0, image.frame.size.height);
                        image.frame = CGRectMake(0, (SCREEN_HEIGHT -SCREEN_WIDTH * img.size.height/img.size.width )/2.f, SCREEN_WIDTH ,SCREEN_WIDTH * img.size.height/img.size.width);
                        image.center = CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT / 2.f);
                        if (image.frame.size.height > SCREEN_HEIGHT) {
                            image.frame = CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH * img.size.height/img.size.width);
                        }
                        //                imgView_ce.contentMode = UIViewContentModeScaleAspectFit;
                        //  imgView_ce.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                    }
                }
            }
        }
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    if (_imageViewArray.count > _index || _scrollViewArray.count > _index) {
        UIImageView *imgView = [_imageViewArray objectAtIndex:_index];
        UIScrollView *scrollV = [_scrollViewArray objectAtIndex:_index];
//        imgView.center = scrollV.center;
        if (imgView.frame.size.height <= SCREEN_HEIGHT) {
            
        }
    }
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"Did zoom!");
     UIImageView *imgView = [_imageViewArray objectAtIndex:_index];
    UIScrollView *scrollV = [_scrollViewArray objectAtIndex:_index];
    if(scrollView.subviews.count){
    UIView *v = [scrollView.subviews objectAtIndex:0];
    if ([v isKindOfClass:[UIImageView class]]){
        if (scrollView.zoomScale>1.0){
            CGFloat height = 0.f;
            if (scrollView.contentSize.height <= SCREEN_HEIGHT) {
                height = SCREEN_HEIGHT;
            }else{
                height = scrollView.contentSize.height;
            }
                     v.center = CGPointMake(scrollView.contentSize.width/2.0, height/2.0); 
        }else{
            if (imgView.frame.size.height <= SCREEN_HEIGHT) {
                imgView.center = CGPointMake(scrollView.contentSize.width/2.0, SCREEN_HEIGHT/2.0);
            }
        }
        
    }
    }
}

#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale];
    if (newScale != 1) {
        newScale = 1;
        
    }else{
        newScale = 3;
    }
//    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
//    zoomRect = [self resizeImageSize:zoomRect offset:((UIScrollView*)gesture.view.superview).contentOffset.y];
    UIView *view = gesture.view.superview;
//    if ([view isKindOfClass:[UIScrollView class]]){
        UIScrollView *s = (UIScrollView *)view;
//        [s zoomToRect:zoomRect animated:YES];
        [s setZoomScale:newScale animated:YES];
//    }
}

#pragma mark - Utility methods

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    return zoomRect;
}

-(CGRect)resizeImageSize:(CGRect)rect offset:(CGFloat)offset{
    //    NSLog(@"x:%f y:%f width:%f height:%f ", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGRect newRect;
    
    CGSize newSize;
    CGPoint newOri;
    
    CGSize oldSize = rect.size;
    if (oldSize.width>=SCREEN_WIDTH || oldSize.height>=SCREEN_HEIGHT){
        float scale = (oldSize.width/SCREEN_WIDTH>oldSize.height/SCREEN_HEIGHT?oldSize.width/SCREEN_WIDTH:oldSize.height/SCREEN_HEIGHT);
        newSize.width = oldSize.width/scale;
        newSize.height = oldSize.height/scale;
    }
    else {
        newSize = oldSize;
    }
    newOri.x = (SCREEN_WIDTH-newSize.width)/2.0;
    newOri.y = (SCREEN_HEIGHT-newSize.height)/2.0;
    
    newRect.size = newSize;
    newRect.origin = newOri;
    
    return newRect;
}




- (void)savePicture:(UILongPressGestureRecognizer *)longPress{
    if(!_sheet){
        _sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到手机" otherButtonTitles:nil, nil];
        [_sheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if (_imageViewArray.count == _index) {
            return;
        }
        UIImageView *imageView = _imageViewArray[_index];
        UIImageWriteToSavedPhotosAlbum([imageView image], nil, nil, nil);
        [MyUtil showCleanMessage:@"保存成功！"];
    }
        _sheet = nil;
}

- (void)tapGes{
    if (_imageViewArray.count <= _index || _scrollViewArray.count <= _index) {
        return;
    }
    UIImageView *imgView = _imageViewArray[_index];
    UIScrollView *scrollView = _scrollViewArray[_index];
//    if (scrollView.contentSize.width > SCREEN_WIDTH) {
//        [UIView animateWithDuration:.5 animations:^{
//            scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
////            imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            if(_urlArray.count > _index){
//            SDImageCache *cache = [SDImageCache sharedImageCache];
//                UIImage *img = [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[_index] width:0 andHeight:0]] == nil ? [cache imageFromMemoryCacheForKey:[MyUtil getQiniuUrl:_urlArray[_index] width:0 andHeight:0]] : [cache imageFromDiskCacheForKey:[MyUtil getQiniuUrl:_urlArray[_index] width:0 andHeight:0]];
//                if (img == nil) {
//                    img = [UIImage imageNamed:@"empyImage300"];
//                }
////                imgView.frame = CGRectMake(0,(SCREEN_HEIGHT - SCREEN_WIDTH * img.size.height/img.size.width)/2.f , SCREEN_WIDTH ,SCREEN_WIDTH * img.size.height/img.size.width);
//                
//                imgView.frame = CGRectMake(0,(SCREEN_HEIGHT - SCREEN_WIDTH * img.size.height/img.size.width)/2.f , SCREEN_WIDTH ,SCREEN_WIDTH * img.size.height/img.size.width);
//                if (imgView.frame.size.height > SCREEN_HEIGHT) {
//                    imgView.bounds = CGRectMake(0,0 , SCREEN_WIDTH ,SCREEN_WIDTH * img.size.height/img.size.width);
//                    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, imgView.frame.size.height);
//                }
//                NSLog(@"----->%@",NSStringFromCGRect(imgView.frame));
//                  NSLog(@"----->%@",NSStringFromCGRect(scrollView.frame));
//            }
//        }];
//    }else{
        [UIView animateWithDuration:animateTime animations:^{
            if (_oldFrameArr.count <= _index) {
                return ;
            }
            scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
            CGRect rect = CGRectFromString(_oldFrameArr[_index]);
            imgView.frame = rect;
            NSLog(@"--->%@",NSStringFromCGRect(imgView.frame));
//            imgView.bounds = CGRectMake(0, 0, imgView.bounds.size.width * 1.5, imgView.bounds.size.height * 1.5);
//            imgView.center = CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f);
//            imgView.alpha = 0.f;
            self.backgroundColor = RGBA(255, 255, 255, 0);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
//    }
}

@end
