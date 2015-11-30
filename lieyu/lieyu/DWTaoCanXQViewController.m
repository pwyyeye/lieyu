//
//  DWTaoCanXQViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DWTaoCanXQViewController.h"
#import "LYTitleInfoCell.h"
#import "LYHomePageHttpTool.h"
#import "TaoCanModel.h"
#import "DWSureOrderViewController.h"
#import "LYTaoCanHeaderTableViewCell.h"
#import "LYBarPointTableViewCell.h"
#import "LYTaoCanContentTableViewCell.h"
#import "LYTaoCanListTableViewCell.h"
@interface DWTaoCanXQViewController ()
{
    TaoCanModel *taoCanModel;
}
@end

@implementation DWTaoCanXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self getdata];
    // Do any additional setup after loading the view.
    [self setTableViewCell];
    self.navigationController.navigationBarHidden = YES;
    [self createButton];
}

- (void)createButton{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 30, 40, 40)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_huanhui_action"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(216, 30, 40, 40)];
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_star_normal"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(272, 30, 40, 40)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 收藏按钮action
- (void)collectClick{
    
}

- (void)shareClick{
    
}

- (void)setTableViewCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"LYTaoCanHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYTaoCanHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYBarPointTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarPointTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYTaoCanContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYTaoCanContentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYTaoCanListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYTaoCanListTableViewCell"];
}
#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"smid":[NSString stringWithFormat:@"%d",self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiTaoCanDetailWithParams:dic block:^(TaoCanModel *result) {
        taoCanModel = result;
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(taoCanModel){
        return 6;
    }else{
        return 0;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return LONG_LONG_MIN;
    }
    return 8;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            LYTaoCanHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"LYTaoCanHeaderTableViewCell" forIndexPath:indexPath];
            headerCell.model = taoCanModel;
            return headerCell;
        }
            break;
        case 1:
        {
            /*
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYTitleInfoCell" forIndexPath:indexPath];
            if (cell) {
                LYTitleInfoCell * titleInfoCell = (LYTitleInfoCell *)cell;
                titleInfoCell.titleLal.text=@"套餐时间";
                titleInfoCell.delLal.text=_dateStr;
                
            }
             */
            LYBarPointTableViewCell *pointCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarPointTableViewCell" forIndexPath:indexPath];
            pointCell.label_point.text = taoCanModel.barinfo.address;
            pointCell.selectionStyle = UITableViewCellSelectionStyleNone;
            pointCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return pointCell;
        }
            break;
        case 2:
        {
//            套餐时间
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYTitleInfoCell" forIndexPath:indexPath];
            if (cell) {
                LYTitleInfoCell * titleInfoCell = (LYTitleInfoCell *)cell;
                titleInfoCell.titleLal.text=@"套餐时间";
                titleInfoCell.delLal.text= [NSString stringWithFormat:@"%@ %@",_dateStr,_weekStr];
            }
            /*
            NSArray *taocanArr=taoCanModel.goodsList;
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTTaoCanCell" forIndexPath:indexPath];
            if (cell) {
                PTTaoCanCell * taocanCell = (PTTaoCanCell *)cell;
                [taocanCell configureCell:taocanArr[indexPath.row]];
            }
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 43.5, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
             */
        }
            break;
        case 3:
        {

//            cell = [tableView dequeueReusableCellWithIdentifier:@"PTTaoCanCell" forIndexPath:indexPath];
//            if (cell) {
//               PTTaoCanCell * taocanCell = (PTTaoCanCell *)cell;
//                [taocanCell configureCell:taocanArr[indexPath.row]];
//            }
//            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 43.5, 290, 0.5)];
//            lineLal.backgroundColor=RGB(199, 199, 199);
//            [cell addSubview:lineLal];
            
            LYTaoCanListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"LYTaoCanListTableViewCell" forIndexPath:indexPath];
            listCell.goodListArray = taoCanModel.goodsList;
            return listCell;
        }
            break;
        case 4:
        {
//            NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
//            
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] ;
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.backgroundColor=[UIColor whiteColor];
//                UILabel *lal1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-20, 25)];
//                [lal1 setTag:1];
//                lal1.textAlignment=NSTextAlignmentLeft;
//                lal1.font=[UIFont boldSystemFontOfSize:12];
//                lal1.backgroundColor=[UIColor clearColor];
//                lal1.textColor= RGB(128, 128, 128);
//                lal1.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
//                lal1.lineBreakMode=UILineBreakModeWordWrap;
//                [cell.contentView addSubview:lal1];
//                
//            
//            
//            
//            UILabel *lal = (UILabel*)[cell viewWithTag:1];
//            NSString *title=taoCanModel.introduction;
//            
//            //高度固定不折行，根据字的多少计算label的宽度
//            
//            CGSize size = [title sizeWithFont:lal.font
//                            constrainedToSize:CGSizeMake(lal.width, MAXFLOAT)
//                                lineBreakMode:NSLineBreakByWordWrapping];
//            //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
//            //根据计算结果重新设置UILabel的尺寸
//            lal.height=size.height;
//            lal.text=title;
//            CGRect cellFrame = [cell frame];
//            cellFrame.origin=CGPointMake(0, 0);
//            cellFrame.size.width=SCREEN_WIDTH;
//            cellFrame.size.height=lal.size.height+20;
//            
//            [cell setFrame:cellFrame];

            LYTaoCanContentTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"LYTaoCanContentTableViewCell" forIndexPath:indexPath];
            contentCell.label_desrc.text = taoCanModel.introduction;
            return contentCell;
        
        }
            break;
            
        default:
        {
            LYTaoCanListTableViewCell *progressCell = [tableView dequeueReusableCellWithIdentifier:@"LYTaoCanListTableViewCell" forIndexPath:indexPath];
            progressCell.isProgress = YES;
            progressCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return progressCell;
        }
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0://广告
        {
            h = 466;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h = 60;
        }
            break;
        case 2:// 选项卡 ，酒吧或夜总会
        {
            h = 40;
        }
            break;
        case 3:// 选项卡 ，酒吧或夜总会
        {
            h = 187;
        }
            break;
        case 4:// 选项卡 ，酒吧或夜总会
        {
            CGSize size = [taoCanModel.introduction boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                                                                                                                                    return size.height+44+22;
        }
            break;
        default:
        {
            h = 229;
        }
            break;
    }
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    //        [self.navigationController pushViewController:controller animated:YES];
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
#pragma mark - 咨询


- (IBAction)queryAct:(UIButton *)sender {
    
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"02136512128"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    
}

#pragma mark - 注意事项
- (IBAction)warnAct:(UIButton *)sender {
    [MyUtil showMessage:@"1. 关于退款：若专属经理未确认留位前退款，则我们将全额退款；若专属经理确认给予您留位后退款，则退款需收20%卡座占用费（100元封顶）。由于占用卡位时间会对酒吧造成经济损失，所以敬请谅解！\n2.若有任何疑问？投诉和建议，欢迎拨打客户热线；\n3.商品图片为参考，具体以实物为准；\n4.客户热线：021-36512128"];
}
#pragma mark - 马上购买
- (IBAction)payAct:(UIButton *)sender {
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    DWSureOrderViewController *sureOrderViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWSureOrderViewController"];
    sureOrderViewController.title=@"确认订单";
    sureOrderViewController.smid=taoCanModel.smid;
    sureOrderViewController.dateStr=self.dateStr;
    [self.navigationController pushViewController:sureOrderViewController animated:YES];
}
@end
