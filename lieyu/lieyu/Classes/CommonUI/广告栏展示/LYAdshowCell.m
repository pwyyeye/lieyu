//
//  LYAdshowCell.m
//  lieyu
//
//  Created by newfly on 9/18/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAdshowCell.h"
#import "MacroDefinition.h"

@implementation LYAdshowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _pageCtrl.numberOfPages = 0;
    _bannerScrollview.delegate = self;

}

- (void)setBannerUrlList:(NSArray *)bannerUrlList
{
    _bannerUrlList = bannerUrlList;
    _pageCtrl.numberOfPages = [bannerUrlList count];
    
    CGFloat bannerWidth = CGRectGetWidth(_bannerScrollview.frame);
    CGFloat bannerHeigth = CGRectGetHeight(_bannerScrollview.frame);
    int tagOfset = 1000;
    
    for (int i =0; i<_pageCtrl.numberOfPages;i++)
    {
        int tag = tagOfset+i;
        UIImageView * imgView = (UIImageView *)[_bannerScrollview viewWithTag:tag];
        
        if (imgView == nil) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*bannerWidth, 0, bannerWidth, bannerHeigth)];
            [_bannerScrollview addSubview:imgView];
        }

        imgView.tag = tag;
         NSString *str=bannerUrlList[i] ;
        [imgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    _bannerScrollview.contentSize = CGSizeMake(_pageCtrl.numberOfPages*bannerWidth, bannerHeigth);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView
{

}

- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
    NSInteger idx = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    if (idx <0) {
        idx = 0;
    }
    _pageCtrl.numberOfPages = idx;
}

@end







