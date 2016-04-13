//
//  PinkerShareController.m
//  lieyu
//
//  Created by pwy on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PinkerShareController.h"
#import "LYUserHttpTool.h"
#import "UIImageView+WebCache.h"
#import "CustomerModel.h"
#import "UIButton+WebCache.h"
#import "LYMyOrderManageViewController.h"
#import "LPMyOrdersViewController.h"
@interface PinkerShareController ()

@end

@implementation PinkerShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"分享";
    // Do any additional setup after loading the view from its nib.
    _chooseView.hidden=YES;
    
    _heardView =[[UIView alloc] initWithFrame:CGRectMake(10, _shareTypeBtn.origin.y+_shareTypeBtn.size.height+10, 36, 36)];
    _addbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [_addbtn setBackgroundImage:[UIImage imageNamed:@"addUserIcon"] forState:UIControlStateNormal];
    _addbtn.tag=102;
    [_addbtn addTarget:self action:@selector(gotoChooseFriend) forControlEvents:UIControlEventTouchUpInside];
    [_heardView addSubview:_addbtn];
   [[_shareTypeBtn superview] addSubview:_heardView];
    _heardView.hidden=YES;
    _chooseView.hidden=NO;
    
    _shareContent.delegate=self;
    
    _allowSex=2;
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sureAct:)];
    [rightBtn setTintColor:[UIColor blackColor]];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [self getData];
}

-(void)BaseGoBack{
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"确定" pageName:@"分享组局" titleName:@"取消分享"]];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
//        if([viewController isKindOfClass:[LYMyOrderManageViewController class]]){
//            [self.navigationController popToViewController:viewController animated:YES];
//            return;
//        }
        if ([viewController isKindOfClass:[LPMyOrdersViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
//    LYMyOrderManageViewController *detailViewController =[[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
    LPMyOrdersViewController *detailViewController = [[LPMyOrdersViewController alloc]init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    _vHeight.constant=SCREEN_HEIGHT-20;
    _vWidth.constant=SCREEN_WIDTH-20;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - 获取数据
-(void)getData{
    if (![MyUtil isEmptyString:_sn]) {
       
        [[LYUserHttpTool shareInstance] getOrderDetailWithSN:@{@"sn":[NSString stringWithFormat:@"%@",_sn]} block:^(OrderInfoModel *result) {
            _orderModel=result;
            _pinkerTitle.text=_orderModel.pinkerinfo.smname;
            if (_orderModel.pinkerinfo.images.count>0) {
                NSString *url=_orderModel.pinkerinfo.images[0];
                [_pinkerImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
                
                
                
            }else if(_orderModel.pinkerinfo.linkUrl){
                [_pinkerImageView sd_setImageWithURL:[NSURL URLWithString:_orderModel.pinkerinfo.linkUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
            }
            
            //活动时间
            if (![MyUtil isEmptyString:_orderModel.reachtime]) {
                NSDate *date= [MyUtil getFullDateFromString:_orderModel.reachtime];
                if (date!=nil) {
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //设定时间格式,这里可以设置成自己需要的格式
                    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                    //用[NSDate date]可以获取系统当前时间
                    NSString *currentDateStr = [dateFormatter stringFromDate:date];
                    _pinkerTimeLabel.text=currentDateStr;
                }
            }
            
            if (_orderModel.barinfo.address) {
                _pinkerAddress.text=_orderModel.barinfo.address;
            }
            
        }];
    }else if(_orderid){
        [[LYUserHttpTool shareInstance] getMyOrderDetailWithParams:@{@"id":[NSString stringWithFormat:@"%d",_orderid]} block:^(OrderInfoModel *result) {
            _orderModel=result;
            _pinkerTitle.text=_orderModel.pinkerinfo.smname;
            if (_orderModel.pinkerinfo.images.count>0) {
                NSString *url=_orderModel.pinkerinfo.images[0];
                [_pinkerImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
                
                
                
            }else if(_orderModel.pinkerinfo.linkUrl){
                [_pinkerImageView sd_setImageWithURL:[NSURL URLWithString:_orderModel.pinkerinfo.linkUrl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
            }
            //活动时间
            if (![MyUtil isEmptyString:_orderModel.reachtime]) {
                NSDate *date= [MyUtil getFullDateFromString:_orderModel.reachtime];
                if (date!=nil) {
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //设定时间格式,这里可以设置成自己需要的格式
                    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                    //用[NSDate date]可以获取系统当前时间
                    NSString *currentDateStr = [dateFormatter stringFromDate:date];
                    _pinkerTimeLabel.text=currentDateStr;
                }
            }
            
            if (_orderModel.barinfo.address) {
                _pinkerAddress.text=_orderModel.barinfo.address;
            }
            
        }];
    }
}

#pragma mark - 发送按钮
- (void)sureAct:(UIButton *)sender {
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"确定" pageName:@"分享组局" titleName:@"分享"]];
    if ([MyUtil isEmptyString:_shareContent.text]) {
        [MyUtil showCleanMessage:@"分享内容不能为空！"];
        return;
    }
    //私人 需要选择好友
    if (_shareType==1 && [MyUtil isEmptyString:_shareUsers]) {
        [MyUtil showCleanMessage:@"选择私人，需要添加分享的好友！"];
        return;
    }
    
    if (_orderModel==nil) {
        [MyUtil showCleanMessage:@"无效分享！"];
        return;
    }
    NSLog(@"----pass-sureAct%@---",_shareUsers);
    
    [[LYUserHttpTool shareInstance] sharePinkerOrder:@{@"orderid":[NSString stringWithFormat:@"%ld",(long) _orderModel.id],@"shareType":[NSString stringWithFormat:@"%ld",(long)_shareType],@"allowSex":[NSString stringWithFormat:@"%ld",(long)_allowSex],@"shareContent":[MyUtil trim:_shareContent.text],@"shareUsers":(_shareUsers==nil?@"":_shareUsers)} complete:^(BOOL result) {
        if (result) {
            [MyUtil showCleanMessage:@"发送成功！"];
            [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"确定" pageName:@"分享组局" titleName:@"分享成功"]];
//            LYMyOrderManageViewController *detailViewController =[[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
//            
//            [self.navigationController pushViewController:detailViewController animated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToSecondViewController" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YunoticeToReload" object:nil];
        }
    }];
}

#pragma --mark 选择公开 私人
- (IBAction)chooseShareType:(id)sender{
    UIButton *button=(UIButton *)sender;
    button.selected=YES;
    if (button.tag==100) {
        UIButton *button101 =[[button superview] viewWithTag:101];
        button101.selected=NO;
        _chooseView.hidden=NO;
        _heardView.hidden=YES;
//        UIButton *button102 =[[button superview] viewWithTag:102];
//        if (button102==nil) {
////            [_heardView addSubview:_addbtn];
//           
//        }
        
    }
    if (button.tag==101) {
        UIButton *button100 =[[button superview] viewWithTag:100];
        button100.selected=NO;
        _chooseView.hidden=YES;
        
//        UIButton *button102 =[[button superview] viewWithTag:102];
//        [button102 removeFromSuperview];
        _heardView.hidden=NO;
    }

}
#pragma --mark 选择性别
- (IBAction)doAllowSex:(id)sender {
    UIButton *button=(UIButton *)sender;
    button.selected=YES;
    if (button.tag==200) {
        _allowSex=2;
        UIButton *button201 =[[button superview] viewWithTag:201];
        button201.selected=NO;
        UIButton *button202 =[[button superview] viewWithTag:202];
        button202.selected=NO;

    }
    if (button.tag==201) {
        _allowSex=1;
        UIButton *button200 =[[button superview] viewWithTag:200];
        button200.selected=NO;
        UIButton *button202 =[[button superview] viewWithTag:202];
        button202.selected=NO;
    }
    if (button.tag==202) {
        _allowSex=0;
        UIButton *button201 =[[button superview] viewWithTag:201];
        button201.selected=NO;
        UIButton *button200 =[[button superview] viewWithTag:200];
        button200.selected=NO;
    }
}
#pragma --mark 去选择好友
-(void)gotoChooseFriend{
    LYChooseFriendsController *friends=[[LYChooseFriendsController alloc] init];
    friends.delegate=self;
    [self.navigationController pushViewController:friends animated:YES];
    
}

#pragma --mark 选择好友代理
-(void)chooseFriends:(NSArray *)friendsArray{
    if (friendsArray.count==0)return;
    [self addFriendHeaders:friendsArray];
}

#pragma --mark 部署返回的代理头像

-(void)addFriendHeaders:(NSArray *)array{
    //清空上次选择
    NSArray *array2=[_heardView subviews];
    for (int j=1; j<array2.count; j++) {
        UIView *view= (UIView *)array2[j];
        [view removeFromSuperview];
    }
    CGRect rect=_addbtn.frame;
    for (int i=0; i<array.count; i++) {
        CustomerModel *model=array[i];
        if (model.userid) {
            _shareUsers=i==0?[NSString stringWithFormat:@"%d",model.userid]:[NSString stringWithFormat:@"%@,%d",_shareUsers,model.userid];
        }
        if (rect.origin.x+46<=SCREEN_WIDTH-20-46) {
            UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x+46, rect.origin.y, 36, 36)];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
            imageView.layer.masksToBounds=YES;
            imageView.layer.cornerRadius=18;
            [button addSubview:imageView];
            [_heardView addSubview:button];
            rect=button.frame;
        }else{
            UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, rect.origin.y+46, 36, 36)];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
            imageView.layer.masksToBounds=YES;
            imageView.layer.cornerRadius=18;
            [button addSubview:imageView];

            [_heardView addSubview:button];
            rect=button.frame;
        }
        
    }
}




#pragma --mark textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"说点发起活动的理由（最多30个字）"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"说点发起活动的理由（最多30个字）";
    }
}

@end
