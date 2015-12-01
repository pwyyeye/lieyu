//
//  LYHotJiuBarViewController.m
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotJiuBarViewController.h"
#import "LYWineBarCell.h"
#import "LYHotBarMenuViewController.h"
#import "LYLMenuDropViewController.h"
#import "LYHotBarMenuView.h"

@interface LYHotJiuBarViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) LYLMenuDropViewController *menuDropVC;
@property (nonatomic,strong) LYHotBarMenuViewController *menuVC;
@end

@implementation LYHotJiuBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _menuDropVC = [[LYLMenuDropViewController alloc]init];
   // [self setUpMenuVC];

    LYHotBarMenuView *menuView = [[LYHotBarMenuView alloc]initWithFrame:CGRectMake(0, 64, 300, 40)];
    [menuView deploy];
//    menuView.backgroundColor = [UIColor redColor];
    [self.view addSubview:menuView];
}

/*
- (void)setUpMenuVC{
    _menuVC = [[LYHotBarMenuViewController alloc]init];
    _menuVC.view.frame = CGRectMake(0, 64, 320, 40);
    [self.view addSubview:_menuVC.view];
    [_menuVC.btn_allPlace addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuVC.btn_music addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuVC.btn_aroundMe addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
}
*/
- (void)setTableViewRefresh{
    __weak LYHotJiuBarViewController *weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    } ];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 273;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  /*
            LYHotBarMenuTableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:@"LYHotBarMenuTableViewCell" forIndexPath:indexPath];
            menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [menuCell.btn_allPlace addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
            [menuCell.btn_music addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
            [menuCell.btn_aroundMe addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
            return menuCell;
      */ 
            LYWineBarCell *wineCell = [tableView dequeueReusableCellWithIdentifier:@"wineBarCell" forIndexPath:indexPath];
                        wineCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return wineCell;
       
  
}

//- (void)menuClick:(UIButton *)sender{
//    _menuDropVC.view.frame = CGRectMake(0, 104, 320, 124);
//    [self removeMenuDropViewWith:sender.currentTitle];
//    if (sender.tag <= 3) {
//        //下拉gaiwei 456
//        [self.view addSubview:_menuDropVC.view];
//        
//        if ([sender.currentTitle isEqualToString:@"所有地区"]) {
//            for (UIButton *button in _menuDropVC.btn_menuArray) {
//                [button setTitle:@"激情夜店" forState:UIControlStateNormal];
//            }
//            [_menuVC.imageView_arrow_one setImage:[UIImage imageNamed:@"arrow drop down"]];
//            sender.tag = 4;
//        }else if([sender.currentTitle isEqualToString:@"音乐清吧"]){
//            for (UIButton *button in _menuDropVC.btn_menuArray) {
//                [button setTitle:@"音乐清吧" forState:UIControlStateNormal];
//            }
//            [_menuVC.imageView_arrow_two setImage:[UIImage imageNamed:@"arrow drop down"]];
//            sender.tag = 5;
//        }else{
//            for (UIButton *button in _menuDropVC.btn_menuArray) {
//                [button setTitle:@"所有地区" forState:UIControlStateNormal];
//            }
//            [_menuVC.imageView_arrow_three setImage:[UIImage imageNamed:@"arrow drop down"]];
//            sender.tag = 6;
//        }
//        
//    }else{
//        //上回 gaiwei 123
//        [_menuDropVC.view removeFromSuperview];
//        
//        if ([sender.currentTitle isEqualToString:@"所有地区"]) {
//             [_menuVC.imageView_arrow_one setImage:[UIImage imageNamed:@"arrow drop up"]];
//            sender.tag = 1;
//        }else if([sender.currentTitle isEqualToString:@"音乐清吧"]){
//            [_menuVC.imageView_arrow_two setImage:[UIImage imageNamed:@"arrow drop up"]];
//            sender.tag = 2;
//        }else{[_menuVC.imageView_arrow_three setImage:[UIImage imageNamed:@"arrow drop up"]];
//            sender.tag = 3;
//        }
//    }
//}

//- (void)removeMenuDropViewWith:(NSString *)title{
//    if ([title isEqualToString:@"所有地区"]) {
//        [_menuVC.imageView_arrow_two setImage:[UIImage imageNamed:@"arrow drop up"]];
//        [_menuVC.imageView_arrow_three setImage:[UIImage imageNamed:@"arrow drop up"]];
//        _menuVC.btn_music.tag = 2;
//        _menuVC.btn_aroundMe.tag = 3;
//    }else if([title isEqualToString:@"音乐清吧"]){
//        [_menuVC.imageView_arrow_one setImage:[UIImage imageNamed:@"arrow drop up"]];
//        [_menuVC.imageView_arrow_three setImage:[UIImage imageNamed:@"arrow drop up"]];
//        _menuVC.btn_allPlace.tag = 1;
//        _menuVC.btn_aroundMe.tag = 3;
//    }else{
//        [_menuVC.imageView_arrow_one setImage:[UIImage imageNamed:@"arrow drop up"]];
//        [_menuVC.imageView_arrow_two setImage:[UIImage imageNamed:@"arrow drop up"]];
//        _menuVC.btn_allPlace.tag = 1;
//        _menuVC.btn_music.tag = 2;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
