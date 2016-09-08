//
//  StrategyCommentListViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "StrategyCommentListViewController.h"
#import "StrategyCommentTableViewCell.h"
#import "StrategyCommentModel.h"
#import "LYHomePageHttpTool.h"
#import "LYUserLoginViewController.h"

@interface StrategyCommentListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation StrategyCommentListViewController
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    
    _textField.delegate = self;
    _textField.placeholder = @"你也说点什么吧…";
    
    _textView.layer.borderColor = [RGBA(151, 151, 151, 0.5) CGColor];
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 20;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"StrategyCommentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StrategyCommentTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self getData];
}

#pragma mark - getData
- (void)getData{
    NSDictionary *dict = @{@"strategyId":_strategyId};
    [LYHomePageHttpTool getStrategyCommentWithParam:dict complete:^(NSArray *result) {
        _dataList = [[NSMutableArray alloc]initWithArray:result];
        [_tableView reloadData];
    }];
}

#pragma mark - tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataList.count) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataList.count) {
        return _dataList.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StrategyCommentTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"StrategyCommentTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    StrategyCommentModel *commentModel = [_dataList objectAtIndex:indexPath.row];
    cell.commentModel = commentModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StrategyCommentModel *model = [_dataList objectAtIndex:indexPath.row];
    CGSize size = [model.comment boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    return size.height + 63;
//    return UITableViewAutomaticDimension;
}

#pragma mark - textField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    AppDelegate *app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    if (app.userModel.userid) {
        return YES;
    }else{
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    AppDelegate *app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    //发送
    NSDictionary *dict = @{@"strategyId":_strategyId,
                           @"toUserId":@"",
                           @"comment":_textField.text};
    [LYHomePageHttpTool addStrategyCommentWithParam:dict complete:^(BOOL result) {
        if (result) {
            StrategyCommentModel *model = [[StrategyCommentModel alloc]init];
            model.nickName = app.userModel.usernick;
            model.icon = app.userModel.avatar_img;
            model.comment = _textField.text;
            _textField.text = @"";
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            model.date = [formatter stringFromDate:[NSDate date]];
            [_dataList insertObject:model atIndex:0];
            [_tableView reloadData];
            if ([_delegate respondsToSelector:@selector(StrategySendCommentSuccess)]) {
                [_delegate StrategySendCommentSuccess];
            }
        }
    }];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
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
