//
//  LYChatrommAllPeopleViewController.m
//  lieyu
//
//  Created by 狼族 on 16/5/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYChatrommAllPeopleViewController.h"
#import "LYChatrommAllPeopleTableViewCell.h"
#import "LYRecentContactViewController.h"
#import "LYYUHttpTool.h"
#import "UserModel.h"
#import "LYFindConversationViewController.h"

@interface LYChatrommAllPeopleViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *_noticeView;//角标
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYChatrommAllPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView registerNib:[UINib nibWithNibName:@"LYChatrommAllPeopleTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYChatrommAllPeopleTableViewCell"];
    self.title = @"群成员";
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivesMessage) name:RECEIVES_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivesMessage) name:COMPLETE_MESSAGE object:nil];
    
    
    //最近联系
    UIButton *recentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 20)];
    [recentBtn setTitle:@"最近联系" forState:UIControlStateNormal];
    [recentBtn addTarget:self action:@selector(recentConnect) forControlEvents:UIControlEventTouchUpInside];
    [recentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    recentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:recentBtn];;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //角标
    _noticeView = [[UIView alloc]init];
    _noticeView.backgroundColor = [UIColor redColor];
    _noticeView.frame = CGRectMake(recentBtn.frame.size.width, -3, 6, 6);
    _noticeView.layer.cornerRadius = 3;
    [recentBtn addSubview:_noticeView];
    
    [self getData];
}

#pragma mark - 获取聊天室成员
- (void)getData{
    NSDictionary *dic = @{@"id":_chatRoomId};
    [LYYUHttpTool yuGetChatRoomAllStaffWith:dic complete:^(NSArray *dataArray) {
        _dataArray = dataArray;
        [_tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self receivesMessage];
}

-(void)receivesMessage{
    if([USER_DEFAULT objectForKey:@"badgeValue"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            _noticeView.hidden = NO;
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            _noticeView.hidden = YES;
        });
    }
}

#pragma mark - 最近联系
- (void)recentConnect{
    LYRecentContactViewController * chat=[[LYRecentContactViewController alloc]init];
    chat.title=@"最近联系";
    [self.navigationController pushViewController:chat animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYChatrommAllPeopleTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"LYChatrommAllPeopleTableViewCell" forIndexPath:indexPath];
    UserModel *userM = _dataArray[indexPath.row];
//        UserModel *userM = _dataArray.firstObject;
    cell.userM = userM;
    if(indexPath.row == 0) cell.isQunZhu = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserModel *userM = _dataArray[indexPath.row];
    
    
    LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
    conversationVC.targetId = userM.imuserId;
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.title = userM.usernick;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    conversationVC.navigationItem.leftBarButtonItem = [self getItem];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

- (UIBarButtonItem *)getItem{
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(BaseGoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    return item;
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
