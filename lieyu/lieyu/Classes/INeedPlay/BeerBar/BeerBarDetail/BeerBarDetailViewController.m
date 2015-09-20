//
//  BeerBarDetailViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BeerBarDetailViewController.h"
#import "MacroDefinition.h"
#import "BeerBarDetailCell.h"
#import "PacketBarCell.h"
#import "LYShareSnsView.h"
#import "LYAdshowCell.h"
#import "LYColors.h"

@interface BeerBarDetailViewController ()

@property(nonatomic,strong)NSMutableArray *aryList;
@property(nonatomic,weak)IBOutlet UITableView *tableView;
@property(nonatomic,strong)IBOutlet BeerBarDetailCell *barDetailCell;
@property(nonatomic,strong)IBOutlet UITableViewCell *orderTotalCell;

@property(nonatomic,weak)IBOutlet UIView *bottomBarView;
@property(nonatomic,assign)CGFloat dyBarDetailH;


@end

@implementation BeerBarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewStyles];
    // Do any additional setup after loading the view from its nib.
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
    [_tableView registerNib:[UINib nibWithNibName:@"PacketBarCell" bundle:nil] forCellReuseIdentifier:@"PacketBarCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"BusinessPublicNoteCell" bundle:nil] forCellReuseIdentifier:@"BusinessPublicNoteCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"LYAdshowCell" bundle:nil] forCellReuseIdentifier:@"LYAdshowCell"];

    LYShareSnsView * shareView = [LYShareSnsView loadFromNib];
    [self.view addSubview:shareView];
    CGPoint center = self.view.center;
    center.y = self.view.frame.size.height - 69-64;
    shareView.center = center;
    
    self.bottomBarView.backgroundColor = [LYColors tabbarBgColor];
    _dyBarDetailH = [BeerBarDetailCell adjustCellHeight:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 1;
        
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0) {
                            cell = [tableView dequeueReusableCellWithIdentifier:@"LYAdshowCell" forIndexPath:indexPath];
            }
            else
            {
                cell = _barDetailCell;
            }

        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell= _orderTotalCell;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"PacketBarCell" forIndexPath:indexPath];
                PacketBarCell * tCell = cell;
                {
                    
                }
            }
        }
            break;
        case 2:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessPublicNoteCell" forIndexPath:indexPath];
        }
            break;

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [LYColors commonBgColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0://广告
        {
            h =  indexPath.row == 0? 264:_dyBarDetailH;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h =  indexPath.row == 0? 40:105;
        }
            break;
        case 2:
        {
            h = 155;
        }
            break;
        default:
        {
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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

@end
