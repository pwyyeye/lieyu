
//
//  SignViewController.m
//  lieyu
//
//  Created by 狼族 on 16/2/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "SignViewController.h"
#import "SignDateTableViewCell.h"
#import "SignIconTableViewCell.h"
#import "LYHomePageHttpTool.h"
#import "CustomerModel.h"
#import "UIButton+WebCache.h"
#import "SignButton.h"
#import "LYMyFriendDetailViewController.h"

@interface SignViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _currentPage;
    NSInteger PAGESIZE;
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 0;
    PAGESIZE = 20;
    self.navigationController.title = @"所有签到";
    // Do any additional setup after loading the view from its nib.
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"SignDateTableViewCell" bundle:nil] forCellReuseIdentifier:@"SignDateTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SignIconTableViewCell" bundle:nil] forCellReuseIdentifier:@"SignIconTableViewCell"];
    [self getData];
    
    [self setupRefresh];
}

- (void)getData{
    NSDictionary *dic = @{@"start":[NSString stringWithFormat:@"%ld",_currentPage ],@"limit":[NSString stringWithFormat:@"%ld",PAGESIZE],@"barid":_barid};
    [LYHomePageHttpTool getSignListWidth:dic complete:^(NSMutableArray *result) {
        
        NSMutableArray *dateMutablearray = [@[] mutableCopy];
        /*NSArray *array1 = @[@"2014-04-01",@"2014-04-02",@"2014-04-03",
                            @"2014-04-01",@"2014-04-02",@"2014-04-03",
                            @"2014-04-01",@"2014-04-02",@"2014-04-03",
                            @"2014-04-01",@"2014-04-02",@"2014-04-03",
                            @"2014-04-01",@"2014-04-02",@"2014-04-03",
                            @"2014-04-01",@"2014-04-02",@"2014-04-03",
                            @"2014-04-04",@"2014-04-06",@"2014-04-08",
                            @"2014-04-05",@"2014-04-07",@"2014-04-09",]; */
        NSMutableArray *array = [NSMutableArray arrayWithArray:result];
        for (int i = 0; i < array.count; i ++) {
            CustomerModel *cuM = array[i];
            NSString *string = cuM.signdate;
            NSMutableArray *tempArray = [@[] mutableCopy];
            [tempArray addObject:cuM];
            for (int j = i+1; j < array.count; j ++) {
                CustomerModel *cuM2 = array[j];
                NSString *jstring = cuM2.signdate;
                if([string isEqualToString:jstring]){
                    [tempArray addObject:cuM2];
                    [array removeObjectAtIndex:j];
                    j = j -1;
                }
            }
            [dateMutablearray addObject:tempArray];
        }
        
        _dataArray = dateMutablearray;
        
        
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)setupRefresh{
    __weak SignViewController *weakSelf = self;
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        [weakSelf getData];
    }];
    MJRefreshGifHeader *header=(MJRefreshGifHeader *)_tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _currentPage ++;
        [weakSelf getData];
    }];
    MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)_tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _dataArray[section];
    return (array.count - 1) / 5 + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SignDateTableViewCell *dateCell = [_tableView dequeueReusableCellWithIdentifier:@"SignDateTableViewCell" forIndexPath:indexPath];
        NSArray *array = _dataArray[indexPath.section];
        CustomerModel *cum = array.firstObject;
        dateCell.label_time.text = cum.signdate;
        return dateCell;
    }else{
        SignIconTableViewCell *iconCell = [_tableView dequeueReusableCellWithIdentifier:@"SignIconTableViewCell" forIndexPath:indexPath];
         NSArray *array = _dataArray[indexPath.section];
        for (int i = 0; i < array.count; i ++) {
            CustomerModel *cum = array[5 * (indexPath.row-1) + i];
            SignButton *btn = iconCell.btnArray[i];
            btn.section = indexPath.section;
            btn.tag = 5 * (indexPath.row-1) + i;
            btn.hidden = NO;
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:cum.userInfo.avatar_img] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        return iconCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 34;
    }else{
        return 51;
    }
}

- (void)iconClick:(SignButton *)button{
    NSArray *array = _dataArray[button.section];
    CustomerModel *cum = array[button.tag];
    CustomerModel *addressBook = [[CustomerModel alloc]init];
    addressBook.userid = cum.userid;
    addressBook.username = cum.userInfo.username;
    addressBook.userTag = cum.tag;
    addressBook.tag = cum.tag;
    addressBook.avatar_img = cum.userInfo.avatar_img;
    addressBook.birthday = cum.userInfo.birthday;
    addressBook.sex = cum.userInfo.sex;
    addressBook.usernick = cum.userInfo.usernick;
    LYMyFriendDetailViewController *friendDetailViewController=[[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    friendDetailViewController.title=@"详细信息";
    friendDetailViewController.type=@"4";
    friendDetailViewController.customerModel=addressBook;
    [self.navigationController pushViewController:friendDetailViewController animated:YES];
}

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