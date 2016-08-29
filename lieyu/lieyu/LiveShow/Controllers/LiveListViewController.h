//
//  LiveListViewController.h
//  lieyu
//
//  Created by 狼族 on 16/8/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LiveListViewController : LYBaseViewController
{
    NSMutableArray *_tableViewArray;//表的数组
    NSInteger _pageCount;//每页数
    NSString *_useridStr;//用户id
    NSInteger _index;//判断是0最热，1最新
    CGFloat _contentOffSetY;//表的偏移量
}
@end
