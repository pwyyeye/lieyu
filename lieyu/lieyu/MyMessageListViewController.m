//
//  MyMessageListViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/28.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MyMessageListViewController.h"
#import "LYUserHttpTool.h"
#import "MessageCell.h"
#import "CustomerModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface MyMessageListViewController ()
{
    NSMutableArray *dataList;

}
@end

@implementation MyMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataList=[[NSMutableArray alloc]init];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=RGB(237, 237, 237);
    [self setupViewStyles];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupViewStyles
{
    [_tableView registerNib:[UINib nibWithNibName:@"PacketBarCell" bundle:nil] forCellReuseIdentifier:@"PacketBarCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"BusinessPublicNoteCell" bundle:nil] forCellReuseIdentifier:@"BusinessPublicNoteCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"LYAdshowCell" bundle:nil] forCellReuseIdentifier:@"LYAdshowCell"];
    
  
}
-(void)getData{
    [dataList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    [[LYUserHttpTool shareInstance]getAddMeListWithParams:nil block:^(NSMutableArray *result) {
        [dataList addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [dataList  count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 68;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    
    MessageCell *cell = (MessageCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (MessageCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    CustomerModel * model =dataList[indexPath.section];
    [cell.userImageView setImageWithURL:[NSURL URLWithString:model.avatar_img]];
    cell.titleLal.text=model.username;
    cell.detLal.text=@"一起玩吧";
    
    [cell.okBtn addTarget:self action:@selector(okAct:) forControlEvents:UIControlEventTouchDown];
    cell.okBtn.tag=indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    cell.timeLal.text=myBarModel.c;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 14)];
    view.backgroundColor=RGB(239, 239, 244);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)okAct:(UIButton *)sender{
    __weak __typeof(self)weakSelf = self;
    CustomerModel * model =dataList[sender.tag];
    NSDictionary *dic=@{@"user":[NSNumber numberWithInt:self.userModel.userid],@"friend":[NSNumber numberWithInt:model.userid],@"makeWay":@"1"};
    [[LYUserHttpTool shareInstance] addFriends:dic complete:^(BOOL result) {
        if(result){
            
            [MyUtil showMessage:@"你们已成为朋友"];
            [weakSelf getData];
        }
    }];
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
