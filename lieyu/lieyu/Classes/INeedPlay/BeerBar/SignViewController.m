
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

@interface SignViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"所有签到";
    // Do any additional setup after loading the view from its nib.
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"SignDateTableViewCell" bundle:nil] forCellReuseIdentifier:@"SignDateTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SignIconTableViewCell" bundle:nil] forCellReuseIdentifier:@"SignIconTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SignDateTableViewCell *dateCell = [_tableView dequeueReusableCellWithIdentifier:@"SignDateTableViewCell" forIndexPath:indexPath];
        
        return dateCell;
    }else{
        SignIconTableViewCell *iconCell = [_tableView dequeueReusableCellWithIdentifier:@"SignIconTableViewCell" forIndexPath:indexPath];
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
