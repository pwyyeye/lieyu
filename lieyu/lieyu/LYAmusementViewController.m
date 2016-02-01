//
//  LYAmusementViewController.m
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAmusementViewController.h"
#import "HotMenuButton.h"
#import "LYYUTableViewCell.h"
#import "LYYUHttpTool.h"

@interface LYAmusementViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    NSMutableArray *_tableViewArray,*_menuBtnArray,*_dataArray;
    UIVisualEffectView *_menuView;
    UILabel *_titelLabel;
    UIView *_purpleLineView;
}

@end

@implementation LYAmusementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupAllProperty];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden = YES;
}

 - (void)setupAllProperty{
     _dataArray = [[NSMutableArray alloc]initWithCapacity:4];
     for (int i = 0; i < 4; i ++) {
         [_dataArray addObject:[[NSMutableArray alloc]init]];
     }
     [self createUI];
}
                                  
- (void)createUI{
    
    _tableViewArray = [[NSMutableArray alloc]initWithCapacity:4];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < 4; i ++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i%4 * SCREEN_WIDTH, 90, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        tableView.tag = i;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerNib:[UINib nibWithNibName:@"LYYUTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYYUTableViewCell"];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_scrollView addSubview:tableView];
        [_tableViewArray addObject:tableView];
    }
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _tableViewArray.count, 0)];
    
    [self createMenuUI];
}

- (void)createMenuUI{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _menuView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    _menuView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _menuView.layer.shadowOpacity = 0.3;
    _menuView.layer.shadowRadius = 1;
    [self.view addSubview:_menuView];
    
    CGFloat btnWidth =  (SCREEN_WIDTH - 26 * 2)/4.f;
    CGFloat offSet = 26;
    _menuBtnArray = [[NSMutableArray alloc]initWithCapacity:4];
    NSArray *btnTitleArray = @[@"热门",@"附近",@"价格",@"时间"];
    for (int i = 0; i < 4; i ++) {
        HotMenuButton *btn = [[HotMenuButton alloc]init];
        if (i == 0) {
            btn.frame = CGRectMake(offSet, 63,btnWidth, 26);
            btn.isMenuSelected = YES;
        }else{
            btn.frame = CGRectMake(offSet + i%4 * btnWidth, 63, btnWidth, 26);
            btn.isMenuSelected = NO;
        }
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnMenuViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:btn];
        [_menuBtnArray addObject:btn];
    }
    _titelLabel = [[UILabel alloc]init];
    _titelLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 30);
    _titelLabel.textAlignment = NSTextAlignmentCenter;
    _titelLabel.text = @"娱";
    _titelLabel.font = [UIFont boldSystemFontOfSize:16];
    _titelLabel.textColor = [UIColor blackColor];
    [_menuView addSubview:_titelLabel];
    
    UIButton *sectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 40, 70, 19)];
    [sectionBtn addTarget:self action:@selector(sectionClick) forControlEvents:UIControlEventTouchUpInside];
    [sectionBtn setTitle:@"徐汇区" forState:UIControlStateNormal];
    sectionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sectionBtn setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
    [sectionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
    [sectionBtn setImage:[UIImage imageNamed:@"选择城市"] forState:UIControlStateNormal];
    [_menuView addSubview:sectionBtn];
    
    _purpleLineView = [[UIView alloc]init];
    HotMenuButton *hotBtn = _menuBtnArray[0];
    CGFloat hotMenuBtnWidth = hotBtn.frame.size.width;
    CGFloat offsetWidth = _scrollView.contentOffset.x;
    _purpleLineView.frame = CGRectMake(0, _menuView.size.height - 2, 42, 2);
    _purpleLineView.backgroundColor = RGBA(186, 40, 227, 1);
    _purpleLineView.center = CGPointMake(hotBtn.center.x + offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH , CGRectGetCenter(_purpleLineView.frame).y);
    [_menuView addSubview:_purpleLineView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrollView == scrollView) {
        CGFloat offX = scrollView.contentOffset.x;
        CGFloat btnWidth =  (SCREEN_WIDTH - 26 * 2)/4.f;
        HotMenuButton *btn = _menuBtnArray[0];
        _purpleLineView.center = CGPointMake(btn.center.x + offX * btnWidth / SCREEN_WIDTH, _purpleLineView.center.y);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollView == scrollView) {
        CGFloat offX = scrollView.contentOffset.x;
        NSInteger index = offX/SCREEN_WIDTH;
        for (HotMenuButton *btn in _menuBtnArray) {
            btn.isMenuSelected = NO;
        }
        ((HotMenuButton *)_menuBtnArray[index]).isMenuSelected = YES;
    }
}

#pragma mark 选择区的action
- (void)sectionClick{
    
}

#pragma mark 热门，附近，价格，时间的acrion
- (void)btnMenuViewClick:(HotMenuButton *)button{
    for (HotMenuButton *btn in _menuBtnArray) {
        btn.isMenuSelected = NO;
    }
    button.isMenuSelected = YES;
    [_scrollView setContentOffset:CGPointMake(button.tag *SCREEN_WIDTH, 0) animated:YES];
    if (!((NSArray *)_dataArray[button.tag]).count) {
      //  [self getDataForHotWith:sender.tag];
    }
    [self getData];
}

- (void)getData{
    [LYYUHttpTool yuGetDataOrderShareWithParams:nil compelte:^(NSArray *dataArray) {
        _dataArray = dataArray;
        UITableView *tableView = _tableViewArray[0];
        [tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYYUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYYUTableViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 213 + (SCREEN_WIDTH - (68 + 10 + 16 + 4 * 20))/5.f + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
