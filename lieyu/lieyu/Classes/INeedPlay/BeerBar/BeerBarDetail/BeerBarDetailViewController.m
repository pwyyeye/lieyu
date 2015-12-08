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

#import "CHViewController.h"
#import "ChiHeViewController.h"

@interface BeerBarDetailViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)NSMutableArray *aryList;
@property(nonatomic,weak)IBOutlet UITableView *tableView;
//@property(nonatomic,strong)IBOutlet BeerBarDetailCell *barDetailCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *orderTotalCell;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *label_count;
@property (weak, nonatomic) IBOutlet UIImageView *image_like;

@property(nonatomic,weak)IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIButton *btn_like;
@property(nonatomic,assign)CGFloat dyBarDetailH;

@property(nonatomic,strong) BeerBarOrYzhDetailModel *beerBarDetail;

@end

@implementation BeerBarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,self.tableView.frame.size.height);
    self.tableView.scrollEnabled = NO;
    
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    [self setupViewStyles];                                                     //tableView registe cell
    [self loadBarDetail];                                                       //load data
    
    //喜欢按钮圆角
    self.btn_like.layer.cornerRadius = CGRectGetWidth(self.btn_like.frame)/2.0;
    self.btn_like.layer.masksToBounds = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
- (void)loadBarDetail
{
    __weak __typeof(self ) weakSelf = self;
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    [bus getBearBarOrYzhDetail:_beerBarId results:^(LYErrorMessage *erMsg, BeerBarOrYzhDetailModel *detailItem)
    {
        if (erMsg.state == Req_Success) {
            weakSelf.beerBarDetail = detailItem;
            weakSelf.label_count.text = detailItem.like_num;
            NSLog(@"-------->%ld",detailItem.recommend_package.count);
            if(!detailItem.recommend_package.count){
                _bottomBarView.hidden = YES;
                _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
            [weakSelf.tableView reloadData];
            //加载webview
            
            [self loadWebView];
        }
    }];
}

// load webView
- (void)loadWebView{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    
    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '310';imgs[i].style.height = 'auto';}</script></body>",self.beerBarDetail.descriptions];
    NSLog(@"%@",webStr);
   //  CGFloat scrollHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    webView.delegate = self;
    [webView sizeToFit];
    [webView.scrollView setScrollEnabled:NO];
    webView.scalesPageToFit = YES;
    [webView loadHTMLString:webStr baseURL:nil];
    [self.scrollView addSubview:webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 返回按钮
- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 喜欢按钮
- (IBAction)likeClick:(UIButton *)sender {
    
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



#pragma mark-- webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight"];//scroll
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
     webView.frame = CGRectMake(0,0, SCREEN_WIDTH, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    //获取内容实际高度（像素）
//    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight;"];
//    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
//    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
//    NSLog(@"--->%f",height);
    webView.frame = CGRectMake(0, self.tableView.frame.size.height-70, 320, frame.height);
    webView.backgroundColor = [UIColor redColor];
    
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, self.tableView.frame.size.height+webView.frame.size.height);
    
    
//  CGFloat offsetHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    
//    NSLog(@"----pass-pass%f---",offsetHeight);
//     webView.frame = CGRectMake(0, self.tableView.frame.size.height-70, 320, offsetHeight+100);
//    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, self.tableView.frame.size.height+webView.frame.size.height);
    
  

}


#pragma mark -- tableviewDelegate

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
            EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)
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
            
            [barSpecialCell configureCell:self.beerBarDetail];
            
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
            return 220;
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

        }
            break;
    }
        return h;
}

#pragma mark 分享按钮
- (IBAction)shareClick:(id)sender {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:self.beerBarDetail.baricon
                                     shareImage:self.beerBarDetail.baricon
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToSms,UMShareToLWTimeline,nil]
                                       delegate:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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


#pragma mark-- 底部三个按钮方法

- (IBAction)dianweiAct:(UIButton *)sender {
    LYwoYaoDinWeiMainViewController *woYaoDinWeiMainViewController=[[LYwoYaoDinWeiMainViewController alloc]initWithNibName:@"LYwoYaoDinWeiMainViewController" bundle:nil];
    woYaoDinWeiMainViewController.barid=_beerBarDetail.barid.intValue;
    [self.navigationController pushViewController:woYaoDinWeiMainViewController animated:YES];
}

- (IBAction)chiHeAct:(UIButton *)sender {
    ChiHeViewController *CHDetailVC = [[ChiHeViewController alloc]initWithNibName:@"ChiHeViewController" bundle:[NSBundle mainBundle]];
    CHDetailVC.title=@"吃喝专场";
    CHDetailVC.barid=_beerBarDetail.barid.intValue;
    CHDetailVC.barName=_beerBarDetail.barname;
    [self.navigationController pushViewController:CHDetailVC animated:YES];
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
