//
//  TodayViewController.m
//  lieyuWidget
//
//  Created by 王婷婷 on 16/11/12.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "RestfulConstant.h"
#import "LYHomePageUrl.h"
#import "LYFriendsPageUrl.h"
#import "TodayTableViewCell.h"

#define CellIdentifier @"TodayTableViewCell"

@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _buttonWidth;
    NSInteger _originPointX;
    
    NSInteger _dataIndex;
    
    UILabel *_kongLabel;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *barButton;
@property (nonatomic, strong) UIButton *ydButton;
@property (nonatomic, strong) UIButton *strategyButton;
@property (nonatomic, strong) UIButton *liveshowButton;

@property (nonatomic, strong) NSMutableArray *buttonsArray;

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation TodayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buttonsArray = [[NSMutableArray alloc]init];
    [self setUpKongLabel];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10) {
        self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 110);
    }else{
        self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 360);
    }
//    NSLog(@"%@",[[[NSUserDefaults alloc]initWithSuiteName:@"group.lyGroup"]objectForKey:@"group.ChooseCityLastTime"]);
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerClass:[TodayTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"TodayTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
//    });
    
    
    [self.view addSubview:self.tableView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupButtonsView];
    });
}

- (void)setUpKongLabel{
    _kongLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 220) / 2, 45, 200, 20)];
    [_kongLabel setTextAlignment:NSTextAlignmentCenter];
    [_kongLabel setText:@"暂无数据！"];
    [_kongLabel setFont:[UIFont systemFontOfSize:14]];
    [_kongLabel setTextColor:COMMON_PURPLE];
    [self.view addSubview:_kongLabel];
    _kongLabel.hidden = YES;
}

- (void)setupButtonsView{
    
    
    _buttonWidth = (SCREEN_WIDTH - 20) / 4 ;
    
    [self initYdButton];
    [self initBarButton];
    [self initStrategyButton];
    [self initLiveshowButton];

    [self getYdData:_ydButton];
    
    /*
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.huijia"];
    NSString* ChooseCityLastTime = [userDefault objectForKey:@"ChooseCityLastTime"];
    if (ChooseCityLastTime) {
    }
    NSLog(@"%@",[USER_DEFAULT objectForKey:@"ChooseCityLastTime"]);
    NSLog(@"%@",[USER_DEFAULT objectForKey:@"LastCityHasNightClub"]);
    NSLog(@"%@",[USER_DEFAULT objectForKey:@"LastCityHasBar"]);
    if (![[[NSUserDefaults alloc] initWithSuiteName:@"group.lyGroup"] objectForKey:@"ChooseCityLastTime"]) {
        _buttonWidth = (SCREEN_WIDTH - 20) / 4 ;
        [self initYdButton];
        [self initBarButton];
        [self initStrategyButton];
        [self initLiveshowButton];
    }else{
        int buttonsNumber = 4;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastCityHasNightClub"] isEqualToString:@"0"]) {
            buttonsNumber --;
        }
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastCityHasBar"] isEqualToString:@"0"]) {
            buttonsNumber --;
        }
        _buttonWidth = (SCREEN_WIDTH - 20) / buttonsNumber;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastCityHasNightClub"] isEqualToString:@"1"]) {
            [self initYdButton];
        }
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastCityHasBar"] isEqualToString:@"1"]) {
            [self initBarButton];
        }
        [self initStrategyButton];
        [self initLiveshowButton];
    }
    */
}

- (void)initYdButton{
    if (!_ydButton) {
        _ydButton = [[UIButton alloc]initWithFrame:CGRectMake(_originPointX, 320, _buttonWidth, 40)];
        [_ydButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //    [_ydButton setTitleColor:COMMON_PURPLE forState:UIControlStateSelected];
        [_ydButton setTitle:@"夜店" forState:UIControlStateNormal];
        [_ydButton addTarget:self action:@selector(getYdData:) forControlEvents:UIControlEventTouchUpInside];
        [_ydButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.view addSubview:_ydButton];
        [_buttonsArray addObject:_ydButton];
        _originPointX += _buttonWidth;
    }
}

- (void)getYdData:(UIButton *)button{
    [self setButtonStatus:button];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_ydButton setTitleColor:COMMON_PURPLE forState:UIControlStateNormal];
//        [_barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_strategyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_liveshowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    });
    NSDictionary *dict = @{@"p":@1,
                           @"subids":@"2",
                           @"per":@4,
                           @"city":[[[[NSUserDefaults alloc]initWithSuiteName:@"group.lyGroup"]objectForKey:@"group.ChooseCityLastTime"] length] > 0 ? [[[NSUserDefaults alloc]initWithSuiteName:@"group.lyGroup"]objectForKey:@"group.ChooseCityLastTime"] : @"上海"};
    _dataIndex = 0 ;
    [self PostGetData:kHttpAPI_LY_TOPLAY_HOMELIST Params:dict];
}

- (void)initBarButton{
    if (!_barButton) {
        _barButton = [[UIButton alloc]initWithFrame:CGRectMake(_originPointX, 320, _buttonWidth, 40)];
        [_barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //    [_barButton setTitleColor:COMMON_PURPLE forState:UIControlStateSelected];
        [_barButton setTitle:@"酒吧" forState:UIControlStateNormal];
        [_barButton addTarget:self action:@selector(getBarData:) forControlEvents:UIControlEventTouchUpInside];
        [_barButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.view addSubview:_barButton];
        [_buttonsArray addObject:_barButton];
        _originPointX += _buttonWidth;
    }
}

- (void)getBarData:(UIButton *)button{
    [self setButtonStatus:button];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_barButton setTitleColor:COMMON_PURPLE forState:UIControlStateNormal];
//        [_ydButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_strategyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_liveshowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    });
    NSDictionary *dict = @{@"p":@1,
                           @"subids":@"1,6,7",
                           @"per":@4,
                           @"city":[[[[NSUserDefaults alloc]initWithSuiteName:@"group.lyGroup"]objectForKey:@"group.ChooseCityLastTime"] length] > 0 ? [[[NSUserDefaults alloc]initWithSuiteName:@"group.lyGroup"]objectForKey:@"group.ChooseCityLastTime"] : @"上海"};
    _dataIndex = 1 ;
    [self PostGetData:kHttpAPI_LY_TOPLAY_HOMELIST Params:dict];
}

- (void)initStrategyButton{
    if (!_strategyButton) {
        _strategyButton = [[UIButton alloc]initWithFrame:CGRectMake(_originPointX, 320, _buttonWidth, 40)];
        [_strategyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //    [_strategyButton setTitleColor:COMMON_PURPLE forState:UIControlStateSelected];
        [_strategyButton setTitle:@"攻略" forState:UIControlStateNormal];
        [_strategyButton addTarget:self action:@selector(getStrategyData:) forControlEvents:UIControlEventTouchUpInside];
        [_strategyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.view addSubview:_strategyButton];
        [_buttonsArray addObject:_strategyButton];
        _originPointX += _buttonWidth;
    }
}

- (void)getStrategyData:(UIButton *)button{
    [self setButtonStatus:button];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_strategyButton setTitleColor:COMMON_PURPLE forState:UIControlStateNormal];
//        [_barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_ydButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_liveshowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    });
    NSDictionary *dict = @{@"page":@1};
    _dataIndex = 2 ;
//    [self PostGetData:LY_GET_STRATEGYLIST Params:dict];
    [self PostGetData:@"app/api/strategy/list" Params:dict];
}

- (void)initLiveshowButton{
    if (!_liveshowButton) {
        _liveshowButton = [[UIButton alloc]initWithFrame:CGRectMake(_originPointX, 320, _buttonWidth, 40)];
        [_liveshowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //    [_liveshowButton setTitleColor:COMMON_PURPLE forState:UIControlStateSelected];
        [_liveshowButton setTitle:@"直播" forState:UIControlStateNormal];
        [_liveshowButton addTarget:self action:@selector(getLiveshowData:) forControlEvents:UIControlEventTouchUpInside];
        [_liveshowButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.view addSubview:_liveshowButton];
        [_buttonsArray addObject:_liveshowButton];
        _originPointX += _buttonWidth;
    }
}

- (void)getLiveshowData:(UIButton *)button{
    [self setButtonStatus:button];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_liveshowButton setTitleColor:COMMON_PURPLE forState:UIControlStateNormal];
//        [_barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_strategyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_ydButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    });
    NSDictionary *dict = @{@"cityCode":@"310000",
                           @"livetype":@"live",
                           @"sort":@"hot",
                           @"page":@1};
    _dataIndex = 3;
    [self PostGetData:LY_Live_getList Params:dict];
}

- (void)setButtonStatus:(UIButton *)button{
    for (UIButton *btn in _buttonsArray) {
        if (button == btn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitleColor:COMMON_PURPLE forState:UIControlStateNormal];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            });
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count) {
        return 4;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TodayTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > indexPath.row) {
        NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
        if (_dataIndex == 0 || _dataIndex == 1) {
            cell.jiubaModel = dict;
        }else if (_dataIndex == 2){
            cell.strategyModel = dict;
        }else if (_dataIndex == 3){
            cell.liveshowModel = dict;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier;
    NSString *joinNum;
    NSString *roomImage;
    if (_dataIndex == 0 || _dataIndex == 1) {
        if (_dataArray.count > indexPath.row) {
            identifier = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"barid"];
        }
    }else if (_dataIndex == 2){
        if (_dataArray.count > indexPath.row) {
            identifier = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        }
    }else if (_dataIndex == 3){
        if (_dataArray.count > indexPath.row) {
            identifier = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"roomId"];
            joinNum = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"joinNum"];
            roomImage = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"roomImg"];
        }
    }
    [self openURLContainingAPPWith:identifier joinNum:joinNum image:roomImage];
}

//通过openURL的方式启动Containing APP
- (void)openURLContainingAPPWith:(NSString *)identifier joinNum:(NSString *)joinNum image:(NSString *)roomImg
{
    if (joinNum.length > 0 && roomImg.length > 0) {
        [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"lieyu://todayWidget?dataIndex=%ld&identifier=%@&joinNum=%@&roomImg=%@",_dataIndex,identifier,joinNum,roomImg]] completionHandler:^(BOOL success) {
            
        }];
    }else{
        [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"lieyu://todayWidget?dataIndex=%ld&identifier=%@",_dataIndex,identifier]] completionHandler:^(BOOL success) {
            
        }];
    }
}

#pragma mark - widget展示
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 110);
    }else{
        self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 360);
//        __weak __typeof(self)weakSelf = self;
////        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupButtonsView];
//        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickAction{
    self.view.backgroundColor = [UIColor redColor];
}

#pragma mark -  post获取数据
- (void)PostGetData:(NSString *)url Params:(NSDictionary *)dict{
    /*
    NSString *strHttp = [NSString stringWithFormat:@"%@%@",LY_SERVER,url];
    NSString *strPost = [NSString stringWithFormat:@"%@",dict];
    NSURL *urlHttp = [NSURL URLWithString:strHttp];
    //创建request对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"POST"];
    [request setURL:urlHttp];
    //将post传递的参数进行编码
    NSData *dataPost = [strPost dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:dataPost];
    //发出访问请求
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        NSLog(@"error:%@",error);
    }else{
        //转换json数据
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //解析json数据
        NSLog(@"dictionary:%@",dictionary);
    }*/
    //1.构造URL
    NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LY_SERVER,url]];
    //2.构造Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString];
    //(1)设置为POST请求
    [request setHTTPMethod:@"POST"];
    //(2)超时
    [request setTimeoutInterval:60];
    //(3)设置请求头
    //[request setAllHTTPHeaderFields:nil];
    
    //(4)设置请求体
    //发新浪微博
    //请求体里需要包含至少两个参数
    //指定用户的令牌 微博正文
    //access_token status
    //这里的 access_token 大家可以用自己的微博来测试 access_token->是通过自己的微博账号密码生成的 具体流程可以参照 http://www.cnblogs.com/ok-lanyan/archive/2012/07/15/2592070.html
    NSMutableString *bodyStr = [[NSMutableString alloc]init];
//    = [NSString stringWithFormat:@"%@",dict];
//    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    __weak __typeof(self)weakSelf = self;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (stop) {
            [bodyStr appendFormat:@"%@", [NSString stringWithFormat:@"%@=%@&",key,obj]];
            
        }
    }];
    if (bodyStr.length > 1) {
        [bodyStr substringWithRange:NSMakeRange(0, bodyStr.length - 1)];
        NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        //设置请求体
        [request setHTTPBody:bodyData];
    }else{
        [request setHTTPBody:nil];
    }
        NSURLSession *session = [NSURLSession sharedSession];
        //4.task
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
            }else{
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                [weakSelf setViewWithData:dataDict];
            }
        }];
        //5.
        [task resume];
}

- (void)setViewWithData:(NSDictionary *)dict{
    if (dict) {
        if (_dataIndex == 0 || _dataIndex == 1) {
            _dataArray = [NSArray arrayWithArray:[[dict objectForKey:@"data"] objectForKey:@"barlist"]];
            if (_dataArray.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _tableView.hidden = NO;
                    _kongLabel.hidden = YES;
                    [_tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    _tableView.hidden = YES;
                    _kongLabel.hidden = NO;
                });
            }
        }else if (_dataIndex == 2) {
            _dataArray = [NSArray arrayWithArray:[[dict objectForKey:@"data"] objectForKey:@"strategyList"]];
            if (_dataArray.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _tableView.hidden = NO;
                    _kongLabel.hidden = YES;
                    [_tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    _tableView.hidden = YES;
                    _kongLabel.hidden = NO;
                });
            }
        }else if (_dataIndex == 3){
            _dataArray = [NSArray arrayWithArray:[dict objectForKey:@"data"]];
            if (_dataArray.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _tableView.hidden = NO;
                    _kongLabel.hidden = YES;
                    [_tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    _tableView.hidden = YES;
                    _kongLabel.hidden = NO;
                });
            }
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            _tableView.hidden = YES;
            _kongLabel.hidden = NO;
        });
    }
}

@end
