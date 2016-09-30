//
//  LYCoinShopViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/27.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@protocol coinShopQuitDelegate <NSObject>

- (void)coinShopQuitDelegate;

@end

@interface LYCoinShopViewController : LYBaseViewController

@property (nonatomic, strong) NSURL *urlString;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) id<coinShopQuitDelegate> delegate;

@end
