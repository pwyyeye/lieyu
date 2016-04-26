//
//  LYYuAllWishesViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBaseViewController.h"
#import "LYYuWishesListTableViewCell.h"

@interface LYYuAllWishesViewController : LYBaseViewController<LYYuWishesCellDelegate>
@property (nonatomic, assign) BOOL isChanged;//是否改变状态
@property (nonatomic, assign) int type;//0是所有，1是个人


@property (nonatomic, assign) id<LYYuWishesCellDelegate> delegate;
@end
