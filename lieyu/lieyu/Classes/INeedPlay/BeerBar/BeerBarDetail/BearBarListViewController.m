//
//  BearBarListViewController.m
//  lieyu
//
//  Created by newfly on 9/26/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BearBarListViewController.h"
#import "LYWineBarInfoCell.h"
#import "BeerBarDetailViewController.h"
#import "LYCustomSegmentControl.h"
#import "MJRefresh.h"

@interface BearBarListViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,weak)IBOutlet UIView * topView;
@property(nonatomic,strong) NSMutableArray *aryList;
@property(nonatomic,strong) LYCustomSegmentControl *segmentCtrl;

@end

@implementation BearBarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aryList = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource =self ;
    [self setupViewStyles];
    // Do any additional setup after loading the view from its nib.
}

- (void)setwineBarTop
{
    CGFloat w = _topView.frame.size.width;
    self.segmentCtrl =
    [[LYCustomSegmentControl alloc] initWithTitleItems:@[@"闹吧",@"清吧",@"演艺吧",@"音乐吧"] frame:_topView.frame];
    
    [self.topView addSubview:_segmentCtrl];
    self.segmentCtrl.selectedColor = [UIColor whiteColor];
    self.segmentCtrl.backgroundColor = UIColorFromRGB(0xe5fff5);
    self.segmentCtrl.titleColor = UIColorFromRGB(0x666666);
    self.segmentCtrl.font = [UIFont systemFontOfSize:13];
    self.segmentCtrl.selectedIndex = 0;
    [self.segmentCtrl setSelectedItem:^(NSInteger index)
     {
         
     }];
}



- (void)setYzhTop
{
    CGFloat w = _topView.frame.size.width;
    self.segmentCtrl =
    [[LYCustomSegmentControl alloc] initWithTitleItems:@[@"商业会所",@"夜总会"] frame:_topView.frame];
    
    [self.topView addSubview:_segmentCtrl];
    self.segmentCtrl.selectedColor = [UIColor whiteColor];
    self.segmentCtrl.backgroundColor = UIColorFromRGB(0xe5fff5);
    self.segmentCtrl.titleColor = UIColorFromRGB(0x666666);
    self.segmentCtrl.font = [UIFont systemFontOfSize:13];
    self.segmentCtrl.selectedIndex = 0;
    [self.segmentCtrl setSelectedItem:^(NSInteger index)
     {
         
     }];

}

- (void)installFreshEvent
{
    
    self.tableView.header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
    }];
    
    self.tableView.footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        
    }];
}

- (void)setupViewStyles
{
    UINib * adCellNib = [UINib nibWithNibName:@"LYAdshowCell" bundle:nil];
    [self.tableView registerNib:adCellNib forCellReuseIdentifier:@"LYAdshowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarInfoCell" bundle:nil] forCellReuseIdentifier:@"LYWineBarInfoCell"];
    
    if (self.entryType == BaseEntry_WineBar)
    {
        self.title = @"酒吧";
        [self setwineBarTop];
    }
    
    if (self.entryType == BaseEntry_Yzh)
    {
        self.title = @"夜总会";
        [self setYzhTop];
    }
    
    [self installFreshEvent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryList.count+4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYAdshowCell" forIndexPath:indexPath];
        }
            break;

        default:
        {
            LYWineBarInfoCell * barCell = [tableView dequeueReusableCellWithIdentifier:@"LYWineBarInfoCell" forIndexPath:indexPath];
            
            cell = barCell;
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.row) {
        case 0://广告
        {
            h = 150;
        }
            break;

        default:
        {
            h = 122.8;
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 1) {
        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
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




