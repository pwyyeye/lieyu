//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//
#import "DejalActivityView.h"
#import "EScrollerView.h"
#import "UIImageView+WebCache.h"
#define pageConWidth 12
#define pageConHeight 2
@implementation EScrollerView
@synthesize delegate;

- (void)dealloc {

    _daoHangArray = nil;
	delegate=nil;
    if (imageArray) {
        
        imageArray=nil;
    }
    if (titleArray) {
        
        titleArray=nil;
    }
    
}
-(id)initWithFrameRect:(CGRect)rect scrolArray:(NSArray *)array needTitile:(BOOL)isNeedTitle
{
    
    imageArray=array;
    self.daoHangArray = [NSArray arrayWithArray:array];
    titleArray = [[NSMutableArray alloc] init];
    NSMutableArray *imagePathArray = [[NSMutableArray alloc] init];
//    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    for(int i = 0;i<array.count;i++)
    {
        NSDictionary *dic = [array objectAtIndex:i];
        [imagePathArray addObject:[dic objectForKey:@"ititle"]];
        [titleArray addObject:[dic objectForKey:@"mainHeading"]];
//        [idArray addObject:[dic objectForKey:@"id"]];
    }
	if ((self=[super initWithFrame:rect]))
    {
        self.userInteractionEnabled=YES;
		viewSize=rect;
//        NSUInteger pageCount=3;
        NSUInteger pageCount = titleArray.count;
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.layer.cornerRadius = 2;
        scrollView.layer.masksToBounds = YES;
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        scrollView.backgroundColor=[UIColor clearColor];
//        scrollView.bounces = NO;
        for (int i=0; i<pageCount; i++)
        {
            UIImageView *imgView=[[UIImageView alloc] init];
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            [imgView setFrame:CGRectMake(viewSize.size.width *i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag= i;
            imgView.backgroundColor=[UIColor grayColor];
            if ([[imagePathArray objectAtIndex:i]length]>0)
            {
                NSString *urlStr = [imagePathArray objectAtIndex:i];
                [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
            }
//            [imgView setImage:[UIImage imageNamed:@"default_01.png"]];
            imgView.contentMode = UIViewContentModeScaleToFill;

            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] ;
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
            
        }
        
//        [scrollView scrollRectToVisible:CGRectMake(self.frame.size.width, 0, viewSize.size.width, viewSize.size.height) animated:YES];
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//        [scrollView scrollRectToVisible:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height ) animated:YES];

        [self addSubview:scrollView];
        
        //说明文字层
        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-25,self.bounds.size.width,25)];
        noteView.backgroundColor = [UIColor  colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        float pageControlWidth = pageCount * 10;
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-pageControlWidth-20,scrollView.frame.size.height-15,pageControlWidth,10)];
        pageControl.currentPage=0;
        if (pageCount>1) {
            pageControl.currentPageIndicatorTintColor=[UIColor lightTextColor];
        }else{
            pageControl.currentPageIndicatorTintColor=[UIColor lightTextColor];
        }
//        pageControl.currentPageIndicatorTintColor=[UIColor redColor];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.numberOfPages=pageCount;
        
        
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-pageControlWidth-80, 25)];
        [self addSubview:scrollView];
        [self addSubview:pageControl];
        
        if(isNeedTitle)
        {
            if(titleArray.count>0)
            {
                NSString *str = [titleArray objectAtIndex:0];
                noteTitle.text = str;
                [noteTitle setBackgroundColor:[UIColor  colorWithRed:.95 green:.95 blue:.95 alpha:1.0]];
                [noteTitle setFont:[UIFont systemFontOfSize:13]];
                noteTitle.textColor = [UIColor grayColor];
                [noteView addSubview:noteTitle];
            }
        }
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
    int count = [imageArray count]+1;
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
//    NSLog(@"contentOffset:%@",NSStringFromCGPoint(scrollView.contentOffset));
//    NSLog(@"contentSize:%@",NSStringFromCGSize(scrollView.contentSize));
//    NSLog(@"%f",scrollView.frame.size.width *(imageArray.count - 1));
//    if(scrollView.contentOffset.x > scrollView.frame.size.width *(imageArray.count - 1)){
//        [scrollView setContentOffset:CGPointMake(-scrollView.frame.size.width, 0)];
//    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    pageControl.currentPage=page;
//    [noteTitle setText:[titleArray objectAtIndex:page]];
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
