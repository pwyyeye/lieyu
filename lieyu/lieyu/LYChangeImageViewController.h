//
//  LYChangeImageViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYChangeImageViewController : LYBaseViewController
@property (nonatomic,strong) UIImage *bgImage;
@property (nonatomic,copy) void(^passImage)(NSString * ,UIImage *);
@end
