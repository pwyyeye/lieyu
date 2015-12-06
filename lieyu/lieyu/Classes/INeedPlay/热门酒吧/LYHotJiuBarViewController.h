//
//  LYHotJiuBarViewController.h
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageEntryConstant.h"

@interface LYHotJiuBarViewController : UIViewController
@property(nonatomic,assign)BaseEntry entryType;
@property(nonatomic,copy)NSString *cityStr;
@property (nonatomic,copy) NSString *middleStr;
@end
