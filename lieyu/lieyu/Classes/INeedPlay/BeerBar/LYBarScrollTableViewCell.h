//
//  LYBarScrollTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYBarScrollTableViewCell : UITableViewCell{
    UIScrollView *_scrollView;
}

@property (nonatomic,strong) NSArray *activtyArray;
@property (nonatomic,strong) NSMutableArray *activtyBtnArray;
@end
