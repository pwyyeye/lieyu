//
//  LYHomeSearchViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/11/2.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "JiuBaModel.h"
@protocol SearchDelegate<NSObject>
- (void)addCondition:(JiuBaModel *)model;

@end
@interface LYHomeSearchViewController : LYBaseViewController
/*
@property (weak, nonatomic) IBOutlet UIButton *hisbtn6;
@property (weak, nonatomic) IBOutlet UIButton *hisbtn5;
@property (weak, nonatomic) IBOutlet UIButton *hisbtn4;
@property (weak, nonatomic) IBOutlet UIButton *hisbtn3;
@property (weak, nonatomic) IBOutlet UIButton *hisbtn1;
@property (weak, nonatomic) IBOutlet UIButton *hisbtn2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *serchText;
@property (nonatomic, weak) id <SearchDelegate> delegate;

*/
@property (weak, nonatomic) IBOutlet UISearchBar *search;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn_historyArray;

@property (weak, nonatomic) IBOutlet UIButton *btn_clean;


@end
