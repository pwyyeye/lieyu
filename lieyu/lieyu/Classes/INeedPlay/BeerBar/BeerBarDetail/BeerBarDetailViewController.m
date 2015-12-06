//
//  BeerBarDetailViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BeerBarDetailViewController.h"
#import "MacroDefinition.h"
//#import "BeerBarDetailCell.h"
//#import "PacketBarCell.h"
#import "LYShareSnsView.h"
#import "UMSocial.h"
//#import "LYAdshowCell.h"
#import "LYColors.h"
#import "LYToPlayRestfulBusiness.h"
#import "BeerBarOrYzhDetailModel.h"
#import "RecommendPackageModel.h"
#import "LYwoYaoDinWeiMainViewController.h"
#import "CHshowDetailListViewController.h"
#import "DWTaoCanXQViewController.h"
#import "LYUserLocation.h"
#import "MyZSManageViewController.h"
#import "LYHeaderTableViewCell.h"
#import "LYBarTitleTableViewCell.h"
#import "LYBarPointTableViewCell.h"
#import "LYBarSpecialTableViewCell.h"
#import "LYBarDescTitleTableViewCell.h"
#import "LYBarDesrcTableViewCell.h"
#import "LYUserHttpTool.h"

@interface BeerBarDetailViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)NSMutableArray *aryList;
@property(nonatomic,weak)IBOutlet UITableView *tableView;
//@property(nonatomic,strong)IBOutlet BeerBarDetailCell *barDetailCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *orderTotalCell;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,weak)IBOutlet UIView *bottomBarView;
@property(nonatomic,assign)CGFloat dyBarDetailH;

@property(nonatomic,strong) BeerBarOrYzhDetailModel *beerBarDetail;

@end

@implementation BeerBarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self setupViewStyles];
    [self loadBarDetail];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(320, 628.5 + 800);
    self.tableView.scrollEnabled = NO;
}

- (void)loadBarDetail
{
    __weak __typeof(self ) weakSelf = self;
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    [bus getBearBarOrYzhDetail:_beerBarId results:^(LYErrorMessage *erMsg, BeerBarOrYzhDetailModel *detailItem)
    {
        if (erMsg.state == Req_Success) {
            weakSelf.beerBarDetail = detailItem;
            NSLog(@"%@",self.beerBarDetail.description);
            [weakSelf.tableView reloadData];
            [self loadWebView];
        }
    }];
}

- (void)loadWebView{
    UIWebView *webView = [[UIWebView alloc]init];

    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" /></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '310';imgs[i].style.height = 'auto';}</script></body>",self.beerBarDetail.descriptions];
    NSLog(@"%@",webStr);
   //  CGFloat scrollHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    webView.delegate = self;
    [webView sizeToFit];
    [webView.scrollView setScrollEnabled:NO];
    //  [_webView setFrame:CGRectMake(0, 628.5, 320, 0)];
    webView.scalesPageToFit = YES;
    [webView loadHTMLString:webStr baseURL:nil];
    [self.scrollView addSubview:webView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupViewStyles
{
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LYHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYHeaderTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LYBarTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarTitleTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LYBarPointTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarPointTableViewCell"];
     [_tableView registerNib:[UINib nibWithNibName:@"LYBarSpecialTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarSpecialTableViewCell"];
     [_tableView registerNib:[UINib nibWithNibName:@"LYBarDescTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarDescTitleTableViewCell"];
     [_tableView registerNib:[UINib nibWithNibName:@"LYBarDesrcTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarDesrcTableViewCell"];

//    LYShareSnsView * shareView = [LYShareSnsView loadFromNib];
//    [self.view addSubview:shareView];
//    CGPoint center = self.view.center;
//    center.y = self.view.frame.size.height - 69-64;
//    shareView.center = center;
    
    self.bottomBarView.backgroundColor = [LYColors tabbarBgColor];
    //_dyBarDetailH = [BeerBarDetailCell adjustCellHeight:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            LYHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"LYHeaderTableViewCell" forIndexPath:indexPath];
            //[headerCell.imageView_header sd_setImageWithURL:[NSURL URLWithString:self.beerBarDetail.banners[0]]];
            headerCell.label_laBa.text = self.beerBarDetail.announcement.content;
            
            
            NSMutableArray *bigArr=[[NSMutableArray alloc]init];
            for (NSString *iconStr in self.beerBarDetail.banners) {
                NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
                [dicTemp setObject:iconStr forKey:@"ititle"];
                [dicTemp setObject:@"" forKey:@"mainHeading"];
                [bigArr addObject:dicTemp];
            }
            EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, 122)
                                                                  scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];

            [headerCell addSubview:scroller];

            
            headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return headerCell;

        }
            break;
        case 1:
        {
           
            LYBarTitleTableViewCell *barTitleCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarTitleTableViewCell" forIndexPath:indexPath];
            [barTitleCell.imageView_header sd_setImageWithURL:[NSURL URLWithString:self.beerBarDetail.baricon]];
            barTitleCell.label_name.text = self.beerBarDetail.barname;
            
            NSString *priceStr = [NSString stringWithFormat:@"¥%@起",self.beerBarDetail.lowest_consumption];
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, 3)];
            if ([self.beerBarDetail.lowest_consumption integerValue] > 999) {
                 [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, 4)];
            }
            
            
            barTitleCell.label_price.attributedText = attributedStr;
            
            for (int i = 0;i < 5;i ++) {
                UIImageView *imageView = barTitleCell.imageView_starArray[i];
                imageView.image = [UIImage imageNamed:@"starGray"];
            }
            if ([self.beerBarDetail.star_num integerValue]) {
                for (int y = 0; y < [self.beerBarDetail.star_num integerValue]; y++) {
                    UIImageView *imageView = barTitleCell.imageView_starArray[y];
                    imageView.image = [UIImage imageNamed:@"starRed"];
                }
            }
            barTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return barTitleCell;
            
        }
            break;
            case 2:
        {
            LYBarPointTableViewCell *barPointCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarPointTableViewCell" forIndexPath:indexPath];
            barPointCell.label_point.text = self.beerBarDetail.address;
            barPointCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        barPointCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return barPointCell;
        }
            break;
            case 3:
        {
            LYBarSpecialTableViewCell *barSpecialCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarSpecialTableViewCell" forIndexPath:indexPath];
            for (int i = 0;i < 4; i ++) {
                UILabel *label = barSpecialCell.label_specialArray[i];
                label.layer.cornerRadius = 2;
                label.layer.borderWidth = 0.5;
                label.layer.borderColor = RGBA(114, 5, 147, 1).CGColor;
                //label.text = self.beerBarDetail.tese[i];
                NSLog(@"-------%@",self.beerBarDetail.tese);
            }
            for (int i = 0;i < 2; i ++) {
                UILabel *label = barSpecialCell.label_classArray[i];
                label.layer.cornerRadius = 2;
                label.layer.borderWidth = 0.5;
                label.layer.borderColor = RGBA(114, 5, 147, 1).CGColor;
                label.text = self.beerBarDetail.subtypename;
            }
                        barSpecialCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return barSpecialCell;
        }
            break;
        case 4:
        {
            LYBarDescTitleTableViewCell *barDescTitleCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarDescTitleTableViewCell" forIndexPath:indexPath];
            barDescTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return barDescTitleCell;
            
        }
            break;
        default:
        {
            
            
                    
//                    LYBarDesrcTableViewCell *barDescCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarDesrcTableViewCell" forIndexPath:indexPath];
//                    barDescCell.label_content.text = self.beerBarDetail.announcement.content;
//                    barDescCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
//                    if (indexPath.row == 1 || indexPath.row == 5) {
//                        barDescCell.imageView_content.hidden = YES;
//                        barDescCell.label_content.text = self.beerBarDetail.announcement.content;
//                    }else{
//                        barDescCell.imageView_content.image = [UIImage imageNamed:@"jiuBarContent.jpg"];
//                        barDescCell.label_content.hidden = YES;
//                    }
                    
//                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//                    UIWebView *oldWebView = (UIWebView *)[cell viewWithTag:100];
//                    if (oldWebView) {
//                        [oldWebView removeFromSuperview];
//                    }
//                    
//                    UIWebView *webView = [[UIWebView alloc]init];
//                    webView.tag = 100;
//                    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" /></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '310';imgs[i].style.height = 'auto';}</script></body>",self.beerBarDetail.descriptions];
//                   // CGFloat scrollHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//                    webView.delegate = self;
//                    [webView sizeToFit];
//                    [webView.scrollView setScrollEnabled:NO];
//                    [webView setFrame:CGRectMake(0, 0, 320, 100)];
//                    webView.scalesPageToFit = YES;
//                    [webView loadHTMLString:webStr baseURL:nil];
//                    [cell addSubview:webView];
//                    return cell;
            
            
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
//            }
//            
//            
//            UILabel *lal = (UILabel*)[cell viewWithTag:1];
//            NSString *title;
//            if(_beerBarDetail.announcement){
//               title=[NSString stringWithFormat:@"%@：\n     %@",_beerBarDetail.announcement.title,_beerBarDetail.announcement.content];
//            }else{
//                title=@"暂无公告";
//            }
//            
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
        }
            break;

    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0;
    switch (indexPath.section) {
        case 0:
        {
            return 271;
        }
            break;
        case 1:
        {
            return 77;
        }
            break;
        case 2:
        {
            return 60;
        }
            break;
        case 3:
        {
            return 105;
        }
            break;
            
        default:
        {
            return 76;
//            switch (indexPath.row) {
//                case 0:
//                {
//                    return 76;
//                }
//                    break;
//                    
//                default:
//                {
//                    return 145 + 4;
//                }
//                    break;
//            }
        }
            break;
    }
        return h;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
   // webView.frame = CGRectMake(0, 0, self.view.frame.size.width, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    NSLog(@"--->%f",height);
  //  webView.frame = CGRectMake(0, 628.5, 320, height);
    webView.backgroundColor = [UIColor redColor];
}

- (IBAction)shareClick:(id)sender {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:@"你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                       delegate:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section==1){
//        
//        RecommendPackageModel * model = nil;
//        model = indexPath.row < _beerBarDetail.recommend_package.count ?[_beerBarDetail.recommend_package objectAtIndex:indexPath.row]:nil;
//        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
//        DWTaoCanXQViewController *taoCanXQViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWTaoCanXQViewController"];
//        taoCanXQViewController.title=@"套餐详情";
//        taoCanXQViewController.smid=model.smid.intValue;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        taoCanXQViewController.dateStr=[dateFormatter stringFromDate:[NSDate new]];
//        [self.navigationController pushViewController:taoCanXQViewController animated:YES];
//    }
    if (indexPath.section == 2) {
        [self daohang];
    }
}

#pragma 进入地图
- (void)daohang{
    NSDictionary *dic=@{@"title":self.beerBarDetail.barname,@"latitude":self.beerBarDetail.latitude,@"longitude":self.beerBarDetail.longitude};
    [[LYUserLocation instance] daoHan:dic];
}

- (void)dealloc
{
    NSLog(@"dealoc bardetail viewcontroller");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dianweiAct:(UIButton *)sender {
    LYwoYaoDinWeiMainViewController *woYaoDinWeiMainViewController=[[LYwoYaoDinWeiMainViewController alloc]initWithNibName:@"LYwoYaoDinWeiMainViewController" bundle:nil];
    woYaoDinWeiMainViewController.barid=_beerBarDetail.barid.intValue;
    [self.navigationController pushViewController:woYaoDinWeiMainViewController animated:YES];
}

- (IBAction)chiHeAct:(UIButton *)sender {
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    CHshowDetailListViewController *showDetailListViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"CHshowDetailListViewController"];
    showDetailListViewController.title=@"吃喝专场";
    showDetailListViewController.barid=_beerBarDetail.barid.intValue;
    showDetailListViewController.barName=_beerBarDetail.barname;
    [self.navigationController pushViewController:showDetailListViewController animated:YES];
}

- (IBAction)zsliAct:(UIButton *)sender {
    MyZSManageViewController *myZSManageViewController=[[MyZSManageViewController alloc]initWithNibName:@"MyZSManageViewController" bundle:nil];
    myZSManageViewController.title=@"专属经理";
    myZSManageViewController.barid=_beerBarDetail.barid.intValue;
    myZSManageViewController.isBarVip=true;
    [self.navigationController pushViewController:myZSManageViewController animated:YES];
}

- (IBAction)soucangAct:(UIButton *)sender {
    NSDictionary *dic=@{@"barid":self.beerBarDetail.barid};
    [[LYUserHttpTool shareInstance] addMyBarWithParams:dic complete:^(BOOL result) {
        if(result){
            [MyUtil showMessage:@"收藏成功"];
        }
    }];
}
@end
