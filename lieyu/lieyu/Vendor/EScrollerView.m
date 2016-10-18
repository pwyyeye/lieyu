//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//


#import "EScrollerView.h"
#import "UIImageView+WebCache.h"
#import "ViewController.h"
#define pageConWidth 12
#define pageConHeight 2
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface EScrollerView()

@property (nonatomic, strong) NSMutableArray *eImagesArray;

@property (nonatomic, assign) CGFloat scrollWidth;
@property (nonatomic, assign) CGFloat scrollHeight;

@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) NSMutableArray *imagePathArray;


@end

@implementation EScrollerView
@synthesize delegate;

- (void)dealloc {
    
    _daoHangArray = nil;
    delegate=nil;
    if (imageArray) {
        imageArray=nil;
    }
    _imagePathArray = nil;
}

- (void)setScrollViewFrame:(CGRect)rect{
    if (_isDragVertical == YES) {
        [scrollView setFrame:rect];
        [self setImagesFrame:rect.size.width Height:rect.size.height];
    }
}

- (void)setImagesFrame:(CGFloat)width Height:(CGFloat)height{
    int i = 0 ;
    CGFloat originX = 0 ;
    for (UIImageView *imageView in _eImagesArray) {
        if (i < currentPageIndex) {
            [imageView setFrame:CGRectMake(originX, 0, _scrollWidth, _scrollHeight)];
        }else if (i == currentPageIndex){
            [imageView setFrame:CGRectMake(originX, 0, width, height)];
            [scrollView setContentOffset:CGPointMake(originX, 0)];
        }else if (i > currentPageIndex){
            [imageView setFrame:CGRectMake(originX, 0, width, height)];
        }
        originX = originX + imageView.frame.size.width;
        i ++;
    }
}

- (id)configureImagesArray:(NSArray *)array{
    return [self initWithFrameRect:self.frame scrolArray:array needTitile:NO];
    //    _imagePathArray = [[NSMutableArray alloc] init];
    //    for(int i = 0;i<array.count;i++)
    //    {
    //        [_imagePathArray addObject:[array objectAtIndex:i]];
    //    }
    //    NSUInteger pageCount = _imagePathArray.count;
    //    scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
    //    for (int i=0; i<pageCount; i++)
    //    {
    //        UIImageView *imgView=[[UIImageView alloc] init];
    //        [imgView setContentMode:UIViewContentModeScaleAspectFill];
    //        [imgView setFrame:CGRectMake(viewSize.size.width *i, 0,viewSize.size.width, viewSize.size.height)];
    //        imgView.tag= i;
    //        imgView.backgroundColor=[UIColor grayColor];
    //        if ([[_imagePathArray objectAtIndex:i]length]>0)
    //        {
    //            [imgView sd_setImageWithURL:[NSURL URLWithString:[_imagePathArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    //        }
    //
    //        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] ;
    //        imgView.userInteractionEnabled=YES;
    //        [imgView addGestureRecognizer:Tap];
    //        [scrollView addSubview:imgView];
    //        [_eImagesArray addObject:imgView];
    //    }
    //    [self updateScrollView];
}

- (instancetype)initWithRect:(CGRect)rect{
    if (self = [super init]) {
        self.userInteractionEnabled=YES;
        viewSize=rect;
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        [scrollView setBackgroundColor:[UIColor redColor]];
        scrollView.layer.cornerRadius = 2;
        scrollView.layer.masksToBounds = YES;
        scrollView.pagingEnabled = YES;
        _scrollWidth = viewSize.size.width;
        _scrollHeight = viewSize.size.height;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        scrollView.backgroundColor=[UIColor clearColor];
        scrollView.bounces = NO;
        
        [self addSubview:scrollView];
        return self;
    }else{
        return nil;
    }
}

//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        self.userInteractionEnabled=YES;
//        viewSize=frame;
//        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
//        [scrollView setBackgroundColor:[UIColor redColor]];
//        scrollView.layer.cornerRadius = 2;
//        scrollView.layer.masksToBounds = YES;
//        scrollView.pagingEnabled = YES;
//        _scrollWidth = viewSize.size.width;
//        _scrollHeight = viewSize.size.height;
//        scrollView.showsHorizontalScrollIndicator = NO;
//        scrollView.showsVerticalScrollIndicator = NO;
//        scrollView.scrollsToTop = NO;
//        scrollView.delegate = self;
//        scrollView.backgroundColor=[UIColor clearColor];
//        scrollView.bounces = NO;
//
//        [self addSubview:scrollView];
//
//        return self;
//    }else{
//        return nil;
//    }
//}

-(id)initWithFrameRect:(CGRect)rect scrolArray:(NSArray *)array needTitile:(BOOL)isNeedTitle
{
    _eImagesArray = [[NSMutableArray alloc]init];
    imageArray=array;
    self.daoHangArray = [NSArray arrayWithArray:array];
    _imagePathArray = [[NSMutableArray alloc] init];
    for(int i = 0;i<array.count;i++)
    {
        [_imagePathArray addObject:[array objectAtIndex:i]];
    }
    if ((self=[super initWithFrame:rect]))
    {
        if (scrollView) {
            [scrollView removeFromSuperview];
        }
        if (pageControl) {
            [pageControl removeFromSuperview];
        }
        self.userInteractionEnabled=YES;
        viewSize=rect;
        NSUInteger pageCount = _imagePathArray.count;
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        [scrollView setBackgroundColor:[UIColor redColor]];
        scrollView.layer.cornerRadius = 2;
        scrollView.layer.masksToBounds = YES;
        scrollView.pagingEnabled = YES;
        _scrollWidth = viewSize.size.width;
        _scrollHeight = viewSize.size.height;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        scrollView.backgroundColor=[UIColor clearColor];
        scrollView.bounces = NO;
        
        NSInteger pageControllerWidth = 7 * pageCount + 10 * (pageCount - 1);
        
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((viewSize.size.width - pageControllerWidth) / 2, viewSize.size.height - 15, pageControllerWidth, 7)];
        pageControl.numberOfPages = pageCount;
        pageControl.currentPage = 0 ;
        
        for (int i=0; i<pageCount; i++)
        {
            UIImageView *imgView=[[UIImageView alloc] init];
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            imgView.layer.masksToBounds = YES;
            [imgView setFrame:CGRectMake(viewSize.size.width *i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag= i;
            imgView.backgroundColor=[UIColor grayColor];
            if ([[_imagePathArray objectAtIndex:i]length]>0)
            {
                [imgView sd_setImageWithURL:[NSURL URLWithString:[_imagePathArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
            }
            
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] ;
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
            [_eImagesArray addObject:imgView];
        }
        [self addSubview:scrollView];
        [self addSubview:pageControl];
    }
    [self updateScrollView];
    return self;
}

- (void) updateScrollView
{
    //    [NSTimer scheduledTimerWithTimeInterval:4 target:self
    //                                   selector:@selector(handleMaxShowTimer:)
    //                                   userInfo: nil
    //                                    repeats:YES];
}

- (void)handleMaxShowTimer:(NSTimer*)theTimer
{
    CGPoint pt = scrollView.contentOffset;
    NSInteger count = [imageArray count]+1;
    if(pt.x == viewSize.size.width * (count-2))
    {
        [scrollView setContentOffset:CGPointMake(0, 0)];
        [scrollView scrollRectToVisible:CGRectMake(0,0,viewSize.size.width,viewSize.size.height) animated:YES];
    }else{
        [scrollView scrollRectToVisible:CGRectMake(pt.x+viewSize.size.width,0,viewSize.size.width,viewSize.size.height) animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!_isDragVertical) {
        int page = (scrollView.contentOffset.x + (_scrollWidth / 2))/ _scrollWidth;
        currentPageIndex=page;
        pageControl.currentPage=page;
        //        ViewController *viewController = (ViewController *)self.delegate;
        //        viewController.tableView.scrollEnabled = NO;
        //        viewController.scrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    [self setImagesFrame:scrollView.frame.size.width Height:scrollView.frame.size.height];
    //    ViewController *viewController = (ViewController *)self.delegate;
    //    viewController.tableView.scrollEnabled = YES;
    //    viewController.scrollView.scrollEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //    ViewController *viewController = (ViewController *)self.delegate;
    //    viewController.tableView.scrollEnabled = YES;
    //    viewController.scrollView.scrollEnabled = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
}


- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [delegate EScrollerViewDidClicked:sender.view.tag];
    }
    
    //    TMGoodsDetailsViewController *goodsDetail=[[TMGoodsDetailsViewController alloc]init];
    //    TMAppDelegate *app=(TMAppDelegate*)[UIApplication sharedApplication].delegate;
    //    [app.navigationController pushViewController:goodsDetail animated:YES];
}

@end
