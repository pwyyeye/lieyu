//
//  LYChooseFriendsController.m
//  lieyu
//
//  Created by pwy on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYChooseFriendsController.h"
#import "LYUserHttpTool.h"
#import "CustomerCell.h"
#import "UIImageView+WebCache.h"
#import "CellSelectButon.h"
@interface LYChooseFriendsController ()

@end

@implementation LYChooseFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAct:)];
    [rightBtn setTintColor:[UIColor blackColor]];
//    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add5"] style:UIBarButtonItemStylePlain target:self action:@selector(sureAct:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    self.title=@"好友列表";

    _firendsArray=[NSMutableArray new];
    _listContent=[NSMutableArray new];
    _logDic=[NSMutableDictionary new];
    self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线
    [self getMyCustomerslist];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)getMyCustomerslist{
    [_listContent removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary *dic=@{@"userid":[NSString stringWithFormat:@"%d",app.userModel.userid]};
    [[LYUserHttpTool shareInstance] getFriendsList:dic block:^(NSMutableArray *result) {
        NSMutableArray *addressBookTemp = [[NSMutableArray array]init];
        [addressBookTemp addObjectsFromArray:result];
        
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        for (CustomerModel *addressBook in addressBookTemp) {
            NSInteger sect = [theCollation sectionForObject:addressBook
                                    collationStringSelector:@selector(friendName)];
            addressBook.sectionNumber = sect;
            
        }
        NSInteger highSection = [[theCollation sectionTitles] count];
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i=0; i<=highSection; i++) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
            [sectionArrays addObject:sectionArray];
        }
        
        for (CustomerModel *addressBook in addressBookTemp) {
            [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
        }
        
        for (NSMutableArray *sectionArray in sectionArrays) {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(friendName)];
            [_listContent addObject:sortedSection];
            
        }
        
        
        [weakSelf.tableView reloadData];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
            [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch) {
        return -1;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listContent count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
       return [[_listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return [[_listContent objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 59;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_listContent objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomerCell";
    
    CustomerCell *cell = (CustomerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    CustomerCell *cell=[[CustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CustomerCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    
    
    CustomerModel *addressBook = nil;
     addressBook = (CustomerModel *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
       
    
    if ([[addressBook.friendName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.nameLal.text = addressBook.friendName;
        
    } else {
        
        cell.nameLal.text = @"No Name";
    }
    [[cell.accessoryView viewWithTag:10000+1000*indexPath.section +indexPath.row] removeFromSuperview];
    
    [cell.smallImageView setHidden:YES];
    [cell.cusImageView sd_setImageWithURL:[NSURL URLWithString:addressBook.icon]];
    CellSelectButon *button=[[CellSelectButon alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    button.section=indexPath.section;
    button.row=indexPath.row;
    button.tag=10000+1000*indexPath.section +indexPath.row;
    [button setBackgroundImage:[UIImage imageNamed:@"icon_singleoption_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"icon_singleoption_highlightl"] forState:UIControlStateSelected];

    [button addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.accessoryView=button;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_logDic objectForKey:[NSString stringWithFormat:@"%d",addressBook.id] ]) {
        cell.isSelected=YES;
        button.selected=YES;
    }else{
        cell.isSelected=NO;
        button.selected=NO;
    }

    
    
    //    cell.backgroundColor=[UIColor clearColor];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerModel *addressBook = nil;
    addressBook = (CustomerModel*)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    CustomerCell *cell = (CustomerCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected==NO) {
        cell.isSelected=YES;
        [_logDic setObject:[NSString stringWithFormat:@"%d",addressBook.id] forKey:[NSString stringWithFormat:@"%d",addressBook.id]];
        CellSelectButon *button=(CellSelectButon *)cell.accessoryView;
        if (button) {
            button.selected=YES;
            [_firendsArray addObject:addressBook];
        }
    }else{
        cell.isSelected=NO;
        CellSelectButon *button=(CellSelectButon *)cell.accessoryView;
        if (button) {
            for (int i=0; i<_firendsArray.count; i++) {
                if (_firendsArray[i]==addressBook) {
                    [_firendsArray removeObject:addressBook];
                    [_logDic removeObjectForKey:[NSString stringWithFormat:@"%d",addressBook.id]];
                }
            }
            button.selected=NO;
        }
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

-(void)btnSelect:(CellSelectButon *)button{
    CustomerCell *cell=(CustomerCell *)[button superview];
    CustomerModel *addressBook = nil;
    addressBook = (CustomerModel*)[[_listContent objectAtIndex:button.section] objectAtIndex:button.row];
    
    if (button.selected) {
        button.selected=NO;
        cell.isSelected=NO;
        for (int i=0; i<_firendsArray.count; i++) {
            if (_firendsArray[i]==addressBook) {
                
                [_firendsArray removeObject:addressBook];
                [_logDic removeObjectForKey:[NSString stringWithFormat:@"%d",addressBook.id]];
            }
        }
        
    }else{
        button.selected=YES;
        cell.isSelected=YES;
        [_logDic setObject:[NSString stringWithFormat:@"%d",addressBook.id] forKey:[NSString stringWithFormat:@"%d",addressBook.id]];
        [_firendsArray addObject:addressBook];
    }
    
}


-(void)sureAct:(id)sender{
    if ([self.delegate respondsToSelector:@selector(chooseFriends:)]) {
        [self.delegate chooseFriends:_firendsArray];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end
