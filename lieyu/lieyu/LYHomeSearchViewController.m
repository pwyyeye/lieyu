//
//  LYHomeSearchViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/11/2.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHomeSearchViewController.h"
#import "LYWineBarInfoCell.h"
#import "BeerBarDetailViewController.h"
#import "NetPublic.h"
#import "LYToPlayRestfulBusiness.h"
#import "MReqToPlayHomeList.h"

#import "BiaoQianBtn.h"
#import "TypeChooseCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#define PAGESIZE 20
@interface LYHomeSearchViewController ()
{
    NSArray *datalist;
    NSMutableArray *searchlist;
    NSString *keyStr;
    NSMutableArray *hisSerchArr;
    NSMutableArray *hisRoute;
    NSArray *btnArr;
}
@property(nonatomic,assign) NSInteger curPageIndex;
@end

@implementation LYHomeSearchViewController
- (IBAction)hisKeyAct:(UIButton *)sender {
    _serchText.text=hisSerchArr[sender.tag];
    [_serchText resignFirstResponder];
    

        [self.tableView setHidden:NO];
        _curPageIndex=1;
        keyStr=_serchText.text;
        [self getData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    hisSerchArr=[[NSMutableArray alloc]init];
    self.curPageIndex = 1;
    [self setupViewStyles];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.hidden=YES;
    datalist=[[NSMutableArray alloc]init];
    searchlist=[[NSMutableArray alloc]init];
    [_serchText becomeFirstResponder];
    _serchText.returnKeyType=UIReturnKeySearch;
    [_serchText addTarget:self action:@selector(valueChangeAct:) forControlEvents:UIControlEventEditingChanged];
    btnArr=@[_hisbtn1,_hisbtn2,_hisbtn3,_hisbtn4,_hisbtn5,_hisbtn6];
    [self getHisUI];
    
//    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getHisUI{
    [self loadHisData];
    for (UIButton *btn in btnArr) {
        [btn setHidden:YES];
    }
    for (int i=0; i<hisSerchArr.count; i++) {
        if(i<hisSerchArr.count){
            UIButton *btn=btnArr[i];
            [btn setHidden:NO];
            [btn setTitle:hisSerchArr[i] forState:0];
            btn.tag=i;
        }else{
            break;
        }
    }
    
}
#pragma mark 获取历史搜索数据
-(void)loadHisData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
    if([fileManager fileExistsAtPath:filename]){
        hisSerchArr= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    }else{
        hisSerchArr = [[NSMutableArray alloc]initWithCapacity:6];
        
    }
    
}
#pragma mark清空记录
-(IBAction)delHisData:(UIButton *)sendid{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除历史记录" message:@"确定删除？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
    
}
#pragma mark清空记录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
        if([fileManager fileExistsAtPath:filename]){
            hisSerchArr= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
            [hisSerchArr removeAllObjects];
            [NSKeyedArchiver archiveRootObject:hisSerchArr toFile:filename];
        }
        [self getHisUI];
    }
}
#pragma mark 保存历史数据
-(void)saveHisData:(NSString *)strKey{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
    if([fileManager fileExistsAtPath:filename]){
        hisRoute= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    }else{
        hisRoute = [[NSMutableArray alloc]initWithCapacity:6];
        
    }
    bool ishis=false;
    for (NSString *arrtemp in hisRoute) {
        
        if([arrtemp isEqualToString:strKey]){
            ishis=true;
            break;
        }
    }
    if(!ishis){
        if(hisRoute.count==6){
            [hisRoute removeObjectAtIndex:hisRoute.count-1];
        }
        [hisRoute insertObject:strKey atIndex:0];
        [NSKeyedArchiver archiveRootObject:hisRoute toFile:filename];
    }
    
}
- (IBAction)valueChangeAct:(UITextField *)sender {
    if(sender.text.length <=0){
        [self.tableView setHidden:YES];
    }
}
#pragma mark return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *searchTex=_serchText.text;
    [_serchText resignFirstResponder];
    
    if(searchTex.length>0)
    {
        [self saveHisData:searchTex];
        [self.tableView setHidden:NO];
        _curPageIndex=1;
        keyStr=_serchText.text;
        [self getData];
        [self getHisUI];
    }
    
    return YES;
}
- (void)setupViewStyles
{
   
    __weak LYHomeSearchViewController * weakSelf = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarInfoCell" bundle:nil] forCellReuseIdentifier:@"LYWineBarInfoCell"];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
            if (Req_Success == ermsg.state) {
                if (barList.count == PAGESIZE)
                {
                    weakSelf.tableView.footer.hidden = NO;
                }
                else
                {
                    weakSelf.tableView.footer.hidden = YES;
                }
                weakSelf.curPageIndex ++;
                [self.tableView.footer endRefreshing];
            }
            
        }];
    }];
    
    
}
-(void)getData{
    __weak LYHomeSearchViewController * weakSelf = self;
    //    __weak UITableView *tableView = self.tableView;
    [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
         if (Req_Success == ermsg.state)
         {
             if (barList.count == PAGESIZE)
             {
                 weakSelf.curPageIndex = 2;
                 weakSelf.tableView.footer.hidden = NO;
             }
             else
             {
                 weakSelf.tableView.footer.hidden = YES;
             }
             //             [weakSelf.tableView.header endRefreshing];
         }
     }];
    
}
- (void)loadItemList:(void(^)(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList))block

{
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    
//    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
//    hList.longitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue];
//    hList.latitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue];
//    hList.city = [LYUserLocation instance].city;
    
    
#if 1
    hList.barname = keyStr;
    hList.need_page = @(1);
    hList.p = @(_curPageIndex);
    hList.per = @(PAGESIZE);
#endif
    
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList:hList results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList, NSArray * newbanner)
     {
         if (ermsg.state == Req_Success)
         {
             if (weakSelf.curPageIndex == 1) {
                 [searchlist removeAllObjects];
                 //                [weakSelf.bannerList removeAllObjects];
             }
             
             [searchlist addObjectsFromArray:barList];
             
             [weakSelf.tableView reloadData];
         }
         block !=nil? block(ermsg,bannerList,barList):nil;
     }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchlist.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
        
        LYWineBarInfoCell * barCell = [tableView dequeueReusableCellWithIdentifier:@"LYWineBarInfoCell" forIndexPath:indexPath];
        
        
       
        [barCell configureCell:[searchlist objectAtIndex:indexPath.row]];
        
        UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 103.5, 290, 0.5)];
        lineLal.backgroundColor=RGB(199, 199, 199);
        [barCell addSubview:lineLal];
        barCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return barCell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 104;
    
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
        
        JiuBaModel *model=[searchlist objectAtIndex:indexPath.row ];
        controller.beerBarId = @(model.barid);
    [self dismissViewControllerAnimated:false completion:^{
            [self.delegate addCondition:model];
    }];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)typeChoose:(BiaoQianBtn *)button event:(id)event{
    
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

- (IBAction)backAct:(UIButton *)sender {
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}
@end
