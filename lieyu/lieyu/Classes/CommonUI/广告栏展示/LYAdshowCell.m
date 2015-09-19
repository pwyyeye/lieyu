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
    // Initialization code
    _pageCtrl.numberOfPages = 4;
    _bannerScrollview.delegate = self;

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

}

@end
