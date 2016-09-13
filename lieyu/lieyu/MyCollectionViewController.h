//
//  MyCollectionViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface MyCollectionViewController : LYBaseViewController{
    NSMutableArray *collectionList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString *subTitle;

@end
