//
//  LYNearFriendViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYNearFriendViewController.h"
#import "WanYouInfoCell.h"
#import "CustomerModel.h"
#import "LYMyFriendDetailViewController.h"
#import "LYUserHttpTool.h"
#import "LYUserLocation.h"
@interface LYNearFriendViewController ()
{
    NSMutableArray *datalist;
    UIView  *_bgView;
    LYZSeditView *seditView;
    UIBarButtonItem *rightBtn;
    NSMutableArray *filteredListContent;
}
@end

@implementation LYNearFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more1"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAct:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    datalist =[[NSMutableArray alloc]init];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    
    __weak __typeof(self)weakSelf = self;
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    NSDictionary *dic=@{@"longitude":@(userLocation.coordinate.longitude),@"latitude":@(userLocation.coordinate.latitude)};
    [[LYUserHttpTool shareInstance]
     getFindNearFriendListWithParams:dic block:^(NSMutableArray *result) {
        [datalist removeAllObjects];
         [filteredListContent removeAllObjects];
        [datalist addObjectsFromArray:result];
         [filteredListContent addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return filteredListContent.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
        
        WanYouInfoCell *cell = (WanYouInfoCell *)[_tableView dequeueReusableCellWithIdentifier:@"WanYouInfoCell"];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"WanYouInfoCell" owner:self options:nil];
            cell = (WanYouInfoCell *)[nibArray objectAtIndex:0];
            //            cell.backgroundColor=[UIColor whiteColor];
            
            
        }
        CustomerModel *customerModel=filteredListContent[indexPath.row];
        [cell.userImageView  setImageWithURL:[NSURL URLWithString:customerModel.avatar_img]];
        cell.titleLal.text=customerModel.username;
    
        cell.detLal.text=[NSString stringWithFormat:@"%@米",customerModel.distance];
    
        if([customerModel.sex isEqualToString:@"1"]){
            cell.sexImageView.image=[UIImage imageNamed:@"manIcon"];
        }
        UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 75.5, 290, 0.5)];
        lineLal.backgroundColor=RGB(199, 199, 199);
        [cell addSubview:lineLal];
        cell.accessoryType = UITableViewCellSelectionStyleNone;
        return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 76.f;
    
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        CustomerModel *customerModel=filteredListContent[indexPath.row];
        LYMyFriendDetailViewController *friendDetailViewController=[[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
        friendDetailViewController.title=@"详细信息";
        friendDetailViewController.type=@"2";
        friendDetailViewController.customerModel=customerModel;
        [self.navigationController pushViewController:friendDetailViewController animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 更多
-(void)moreAct:(id)sender{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    rightBtn.enabled=false;
    [self.view addSubview:_bgView];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYZSeditView" owner:nil options:nil];
    seditView= (LYZSeditView *)[nibView objectAtIndex:0];
    seditView.top=SCREEN_HEIGHT;
    [seditView.quxiaoBtn addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    
    
    
    [seditView.editListBtn setHidden:NO];
    [seditView.editListBtn setImage:[UIImage imageNamed:@"scarf"] forState:0];
    seditView.secondLal.text=@"添加男生";
    [seditView.editListBtn addTarget:self action:@selector(seeBoyAct) forControlEvents:UIControlEventTouchDown];
    [seditView.secondLal setHidden:NO];
    [seditView.shenqingBtn setImage:[UIImage imageNamed:@"lipstick"] forState:0];
    seditView.firstLal.text=@"只看女生";
    //    [seditView.editListBtn addTarget:self action:@selector(editZsAct:) forControlEvents:UIControlEventTouchDown];
    [seditView.shenqingBtn addTarget:self action:@selector(seeGirlAct) forControlEvents:UIControlEventTouchDown];
    
    [_bgView addSubview:seditView];
    
    [seditView.thirdBtn setHidden:NO];
    [seditView.thirdBtn setImage:[UIImage imageNamed:@"partyHat"] forState:0];
    seditView.thirdLal.text=@"查看全部";
    [seditView.thirdLal setHidden:NO];
    [seditView.thirdBtn addTarget:self action:@selector(seeAllAct) forControlEvents:UIControlEventTouchDown];
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:seditView cache:NO];
    seditView.top=SCREEN_HEIGHT-seditView.height-64;
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT-seditView.height-64);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
}
#pragma mark - 消失
-(void)SetViewDisappear:(id)sender
{
    rightBtn.enabled=YES;
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             seditView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
    
}
#pragma mark - 只看男孩
-(void)seeBoyAct{
    [filteredListContent removeAllObjects];
    for (CustomerModel *model in datalist) {
        if([model.sex isEqualToString:@"1"]){
            [filteredListContent addObject:model];
        }
    }
    [_tableView reloadData];
    [self SetViewDisappear:nil];
}
#pragma mark - 只看女孩
-(void)seeGirlAct{
    [filteredListContent removeAllObjects];
    for (CustomerModel *model in datalist) {
        if([model.sex isEqualToString:@"0"]){
            [filteredListContent addObject:model];
        }
    }
    [_tableView reloadData];
    [self SetViewDisappear:nil];
}
#pragma mark - 看全部
-(void)seeAllAct{
    [filteredListContent removeAllObjects];
    [filteredListContent addObjectsFromArray:datalist];
    [self SetViewDisappear:nil];
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
