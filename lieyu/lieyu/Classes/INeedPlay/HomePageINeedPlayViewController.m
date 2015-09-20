//
//  HomePageINeedPlayViewController.m
//  lieyu
//
//  Created by newfly on 9/14/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "LYAdshowCell.h"
#import "LYWineBarInfoCell.h"
#import "HomePageINeedPlayViewController.h"
#import "MJRefresh.h"
#import "BeerBarDetailViewController.h"

@interface HomePageINeedPlayViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,

    UITextFieldDelegate
>

@property(nonatomic,strong)NSMutableArray *aryList;
@property(nonatomic,strong) IBOutlet UIView * topView;
@property(nonatomic,weak) IBOutlet UIButton * myFllowButton;
@property(nonatomic,weak) IBOutlet UITableView * tableView;
@property(nonatomic,weak) IBOutlet UITextField * searchTextField;
//@property(nonatomic,weak) IBOutlet UITabBarItem * tabBarItem;

@end

@implementation HomePageINeedPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    [self setupViewStyles];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated
{
    CGRect rc = _topView.frame;
    rc.origin.x = 0;
    rc.origin.y = 0;
    _topView.frame = rc;
    [self.navigationController.navigationBar addSubview:_topView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_topView removeFromSuperview];
}

- (void)initialize
{
    
}

- (void)setupViewStyles
{
    [self setupToViewStyles];
    UINib * adCellNib = [UINib nibWithNibName:@"LYAdshowCell" bundle:nil];
    [self.tableView registerNib:adCellNib forCellReuseIdentifier:@"LYAdshowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarInfoCell" bundle:nil] forCellReuseIdentifier:@"LYWineBarInfoCell"];
   


}


- (void)setupToViewStyles
{

}

//---TODO: add action

- (IBAction)myFllowClick:(id)sender
{

}

- (IBAction)beerBarClick:(id)sender
{

}


- (IBAction)yzhClick:(id)sender
{

}

- (IBAction)selectAreaClick:(id)sender
{


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
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"spaceEntryCell" forIndexPath:indexPath];
        }
            break;
        case 2:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"jiujiBeerBarCell" forIndexPath:indexPath];
            cell.backgroundColor = RGBA(250, 250, 250, 1.0);
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
            h = 143;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h = 78;
        }
            break;
        case 2:
        {
            h = 50;
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
    if (indexPath.row >= 3) {
        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{


}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
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
