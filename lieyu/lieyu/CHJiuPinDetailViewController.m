//
//  CHJiuPinDetailViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHJiuPinDetailViewController.h"
#import "LYHomePageHttpTool.h"
#import "PTShowIntroductionsCell.h"
#import "CHTopDetailCell.h"
#import "CHBarCell.h"
#import "CHPorTypeCell.h"
#import "LYCarListViewController.h"
#import "LYUserLocation.h"

#import "AddressTableViewCell.h"

@interface CHJiuPinDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CheHeModel *chiHeModel;
}

@property (nonatomic, strong) CHTopDetailCell *danpinCell;
@property (nonatomic, strong) AddressTableViewCell *addressCell;
@property (nonatomic, strong) CHPorTypeCell *typeCell;
@property (nonatomic, strong) PTShowIntroductionsCell *showCell;

@end

@implementation CHJiuPinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self getdata];

    // Do any additional setup after loading the view.
}
#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"id":[NSString stringWithFormat:@"%d",self.shopid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHDetailWithParams:dic block:^(CheHeModel *result) {
        chiHeModel=result;
        [weakSelf.tableView reloadData];
    }];
}

#pragma tableView的各个代理方法实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(chiHeModel){
        return 5;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(section!=2){
//        return [[UIView alloc] initWithFrame:CGRectZero];
//    }else{
//        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
//        view.backgroundColor=RGB(247, 247, 247);
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
//        
//        label.text=@"酒水消费流程";
//        
//        
//        label.font=[UIFont systemFontOfSize:12];
//        label.textColor=RGB(51, 51, 51);
//        [view addSubview:label];
//        return view;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if(indexPath.section == 0){
        _danpinCell = [tableView dequeueReusableCellWithIdentifier:@"danpinCell"];
        if(!_danpinCell){
            [tableView registerNib:[UINib nibWithNibName:@"DanPinCell" bundle:nil] forCellReuseIdentifier:@"danpinCell"];
            _danpinCell = [tableView dequeueReusableCellWithIdentifier:@"danpinCell"];
        }
        [_danpinCell configureCell:chiHeModel];
        _danpinCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _danpinCell;
    }else if(indexPath.section == 1){
        _addressCell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        if(!_addressCell){
            [tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"address"];
            _addressCell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        }
        [_addressCell cellConfigure:chiHeModel.barinfo.address];
        [_addressCell.addressBtn addTarget:self action:@selector(daohang) forControlEvents:UIControlEventTouchUpInside];
        return _addressCell;
    }else if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CHPorTypeCell" forIndexPath:indexPath];
        if (cell) {
            CHPorTypeCell * porTypeCell = (CHPorTypeCell *)cell;
            [porTypeCell.typeBtn setTitle:chiHeModel.category forState:0];
            [porTypeCell.brandBtn setTitle:chiHeModel.brand forState:0];
        }
        return cell;
    }else if(indexPath.section == 3){
        NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor whiteColor];
            UILabel *lal1=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 320-30, 25)];
            [lal1 setTag:1];
            lal1.textAlignment=NSTextAlignmentLeft;
            lal1.font=[UIFont systemFontOfSize:12];
            lal1.backgroundColor=[UIColor clearColor];
            lal1.textColor= RGB(51, 51, 51);
            lal1.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
            lal1.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.contentView addSubview:lal1];
        }
        UILabel *lal = (UILabel*)[cell viewWithTag:1];
        NSString *title=[NSString stringWithFormat:@"产品说明：\n     %@",chiHeModel.introduction];
        //高度固定不折行，根据字的多少计算label的宽度
        CGSize size = [title sizeWithFont:lal.font
                        constrainedToSize:CGSizeMake(lal.width, MAXFLOAT)
                            lineBreakMode:NSLineBreakByWordWrapping];
        //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
        //根据计算结果重新设置UILabel的尺寸
        lal.height=size.height;
        lal.text=title;
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=SCREEN_WIDTH;
        cellFrame.size.height=lal.size.height+20;
        UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, lal.size.height+20-0.5, 290, 0.5)];
        lineLal.backgroundColor=RGB(199, 199, 199);
        [cell addSubview:lineLal];
        [cell setFrame:cellFrame];
        return cell;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"PTShowIntroductionsCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)daohang{
    NSDictionary *dic=@{@"title":chiHeModel.barinfo.barname,@"latitude":chiHeModel.barinfo.latitude,@"longitude":chiHeModel.barinfo.longitude};
    [[LYUserLocation instance] daoHan:dic];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = nil;
//    switch (indexPath.section)
//    {
//        case 0:
//        {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"danpinCell" forIndexPath:indexPath];
//            if (cell) {
//                CHTopDetailCell * topDetailCell = (CHTopDetailCell *)cell;
//                [topDetailCell configureCell:chiHeModel];
//            }
//        }
//            break;
//        case 1:
//        {
//            
//            if(indexPath.row==0){
//                cell = [tableView dequeueReusableCellWithIdentifier:@"CHBarCell" forIndexPath:indexPath];
//                if (cell) {
//                    CHBarCell * barCell = (CHBarCell *)cell;
//                    [barCell configureCell:chiHeModel.barinfo];
//                    
//                }
//                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 71.5, 290, 0.5)];
//                lineLal.backgroundColor=RGB(199, 199, 199);
//                [cell addSubview:lineLal];
//            }
//            if(indexPath.row==1){
//                NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
//                
//                if (cell == nil)
//                {
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] ;
//                    cell.accessoryType = UITableViewCellAccessoryNone;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.backgroundColor=[UIColor whiteColor];
//                    UILabel *lal1=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 320-30, 25)];
//                    [lal1 setTag:1];
//                    lal1.textAlignment=NSTextAlignmentLeft;
//                    lal1.font=[UIFont systemFontOfSize:12];
//                    lal1.backgroundColor=[UIColor clearColor];
//                    lal1.textColor= RGB(51, 51, 51);
//                    lal1.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
//                    lal1.lineBreakMode=UILineBreakModeWordWrap;
//                    [cell.contentView addSubview:lal1];
//                    
//                }
//                
//                
//                UILabel *lal = (UILabel*)[cell viewWithTag:1];
//                NSString *title=[NSString stringWithFormat:@"产品说明：\n     %@",chiHeModel.introduction];
//                
//                //高度固定不折行，根据字的多少计算label的宽度
//                
//                CGSize size = [title sizeWithFont:lal.font
//                                constrainedToSize:CGSizeMake(lal.width, MAXFLOAT)
//                                    lineBreakMode:NSLineBreakByWordWrapping];
//                //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
//                //根据计算结果重新设置UILabel的尺寸
//                lal.height=size.height;
//                lal.text=title;
//                CGRect cellFrame = [cell frame];
//                cellFrame.origin=CGPointMake(0, 0);
//                cellFrame.size.width=SCREEN_WIDTH;
//                cellFrame.size.height=lal.size.height+20;
//                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, lal.size.height+20-0.5, 290, 0.5)];
//                lineLal.backgroundColor=RGB(199, 199, 199);
//                [cell addSubview:lineLal];
//                [cell setFrame:cellFrame];
//                
//                
//                
//                
//                
//                
//            }
//            if(indexPath.row==2){
//                cell = [tableView dequeueReusableCellWithIdentifier:@"CHPorTypeCell" forIndexPath:indexPath];
//                if (cell) {
//                    CHPorTypeCell * porTypeCell = (CHPorTypeCell *)cell;
//                    [porTypeCell.typeBtn setTitle:chiHeModel.category forState:0];
//                    [porTypeCell.brandBtn setTitle:chiHeModel.brand forState:0];
//                    
//                }
////                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 75.5, 290, 0.5)];
////                lineLal.backgroundColor=RGB(199, 199, 199);
////                [cell addSubview:lineLal];
//            }
//            
//        }
//            break;
//        
//            
//        default:
//        {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"PTShowIntroductionsCell" forIndexPath:indexPath];
//        }
//            break;
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    if(indexPath.section == 0){
        h = 466;
    }else if(indexPath.section == 1){
        h = 60;
    }else if(indexPath.section == 2){
        h = 76;
    }else if (indexPath.section == 3){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else{
        h = 162;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        if(indexPath.row==0){
            
            NSDictionary *dic=@{@"title":chiHeModel.barinfo.barname,@"latitude":chiHeModel.barinfo.latitude,@"longitude":chiHeModel.barinfo.longitude};
            [[LYUserLocation instance] daoHan:dic];
        }
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
#pragma mark -购物车
- (IBAction)showShopCar:(UIButton *)sender {
    LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
    carListViewController.title=@"购物车";
    [self.navigationController pushViewController:carListViewController animated:YES];
}
#pragma mark -添加购物车
- (IBAction)AddToShopCar:(UIButton *)sender {
    //数量选择
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    [self.view addSubview:_bgView];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CHChooseNumView" owner:nil options:nil];
    numView= (CHChooseNumView *)[nibView objectAtIndex:0];
    numView.top=-numView.height;
    [_bgView addSubview:numView];
    //确定按钮
    surebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    surebutton.frame=CGRectMake(0 ,SCREEN_HEIGHT, SCREEN_WIDTH,45 );
    [surebutton setBackgroundColor:RGB(35, 166, 116)];
    [surebutton setTitle:@"确定" forState:0];
    [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [surebutton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [surebutton addTarget:self action:@selector(sureAct:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:surebutton aboveSubview:_bgView];
    
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:numView cache:NO];
    numView.top=0;
    surebutton.top=SCREEN_HEIGHT-45;
    [UIView commitAnimations];
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor=[UIColor redColor];
    button.frame=CGRectMake(0 ,numView.top+numView.height, SCREEN_WIDTH, SCREEN_HEIGHT-numView.top-45-numView.height);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
//    button.backgroundColor=[UIColor clearColor];
}
#pragma  mark 消失
-(void)SetViewDisappear:(id)sender{
    
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             numView.top=-numView.height;
                             surebutton.top=SCREEN_HEIGHT;
//                             _bgView.frame=CGRectMake(0, -SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
    
}
-(void)sureAct:(id)sender{
    [self SetViewDisappear:nil];
    NSDictionary *dic=@{@"product_id":[NSNumber numberWithInt:chiHeModel.id],@"quantity":numView.numLal.text};
    [[LYHomePageHttpTool shareInstance] addCarWithParams:dic block:^(BOOL result) {
        if (result) {
            [MyUtil showMessage:@"添加购物车成功!"];
        }
    }];
    
}
- (IBAction)backAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
