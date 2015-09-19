//
//  LYAdshowCell.h
//  lieyu
//
//  Created by newfly on 9/18/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYAdshowCell : UITableViewCell
<
    UIScrollViewDelegate
>
@property(nonatomic,weak)IBOutlet UIPageControl *pageCtrl;
@property(nonatomic,weak)IBOutlet UIScrollView *bannerScrollview;

@end
