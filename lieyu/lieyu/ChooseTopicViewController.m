//
//  ChooseTopicViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChooseTopicViewController.h"
#import "LYUserHttpTool.h"
#import "TopicModel.h"

@interface ChooseTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray *dataArray;
    NSMutableArray *newDataArr;//进行筛选的新的话题数组
    NSMutableArray *newBarTopic;//实时更新酒吧话题
    NSMutableArray *newHotTopic;//实时更新热门话题
}
@end

@implementation ChooseTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.searchBar becomeFirstResponder];
    self.searchBar.delegate = self;
    [self getData];
    self.searchBar.placeholder = @"#话题#";
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.searchBar.text = @"";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)getData{
    NSDictionary *dict;
    if (_type) {
        if (_barid) {
            dict = @{@"barid":_barid,
                     @"type":_type};
        }else{
            dict = @{@"type":_type};
        }
    }else if(_barid){
        dict = @{@"barid":_barid};
    }else{
        dict = nil;
    }
    __weak __typeof(self)weakSelf = self;
    [LYUserHttpTool getTopicList:dict complete:^(NSArray *dataList) {
        for(TopicModel *model in dataList){
            model.name = [NSString stringWithFormat:@"#%@#",model.name];
        }
        dataArray = dataList;
        newDataArr = [[NSMutableArray alloc]initWithArray:dataArray];
        [weakSelf.myTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    int i = 0 ;
    newBarTopic = [[NSMutableArray alloc]init];
    newHotTopic = [[NSMutableArray alloc]init];
    for (TopicModel *model in newDataArr) {
        if (![model.barid isEqualToString:@"0"] && model.barname.length) {
//            i ++;
            [newBarTopic addObject:model];
        }else{
            [newHotTopic addObject:model];
        }
    }
    if (section == 0) {
//        return newDataArr.count - i ;
        return newHotTopic.count;
    }else{
//        return i;
        return newBarTopic.count;
    }
//    return newDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    [sectionView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 9, SCREEN_WIDTH - 16, 16)];
    [label setTextColor:RGBA(128, 128, 128, 1)];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setBackgroundColor:[UIColor clearColor]];
    if (section == 1) {
        label.text = @"酒吧话题";
    }else if (section == 0){
        label.text = @"热门话题";
    }
    [sectionView addSubview:label];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchTopicCell"];
    
    UIImageView *imgV = (UIImageView *) [cell viewWithTag:10086];
    if (imgV) {
        [imgV removeFromSuperview];
    }
    
    UILabel *label = (UILabel *) [cell viewWithTag:10010];
    if (label) {
        [label removeFromSuperview];
    }
    
    UIImageView *imageView;
    UILabel *TopicLabel;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchTopicCell"];
    }
    
    
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
    imageView.layer.cornerRadius = 17.5;
    imageView.layer.masksToBounds = YES;
    imageView.tag = 10086;
    
    TopicLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 18, SCREEN_WIDTH - 75, 15)];
    TopicLabel.tag = 10010;
    [TopicLabel setTextColor:[UIColor blackColor]];
    [TopicLabel setFont:[UIFont systemFontOfSize:14]];
    
    [cell addSubview:imageView];
    [cell addSubview:TopicLabel];
    if (indexPath.section == 0) {
        TopicModel *model = [newHotTopic objectAtIndex:indexPath.row];
        TopicLabel.text = model.name;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.linkurl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    }else if (indexPath.section == 1){
        TopicModel *model = [newBarTopic objectAtIndex:indexPath.row];
        TopicLabel.text = model.name;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.linkurl] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    }
    return cell;
}

- (void)returnTopicID:(ReturnTopicID)block{
    self.returnTopicID = block;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    TopicModel *model ;
    if (indexPath.section == 0) {
        model = [newHotTopic objectAtIndex:indexPath.row];
    }else if (indexPath.section == 1) {
        model = [newBarTopic objectAtIndex:indexPath.row];
    }
    self.returnTopicID(model.id,model.name);
}

#pragma mark - searchBar代理
//当前输入值
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"shouldChange:%@",text);
    if([text isEqualToString:@""]){
        NSLog(@"delete");
    }
    return YES;
}

//文本框已有值
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    NSLog(@"didChange:%@",searchText);
    [self searchTextWithSearchBar];
}

- (void)searchTextWithSearchBar{
    NSString *searchText = self.searchBar.text;
    [newDataArr removeAllObjects];
    if ([searchText isEqualToString:@""]) {
        [newDataArr addObjectsFromArray:dataArray];
    }else{
        NSString *regEx = [NSString stringWithFormat:@"%@", searchText];
        for (TopicModel *model in dataArray) {
            NSRange r = [model.name rangeOfString:regEx options:NSCaseInsensitiveSearch];
            if (r.location != NSNotFound) {
                [newDataArr addObject:model];
            }
        }
        NSLog(@"%@",newDataArr);
    }
    [self.myTableView reloadData];
}

#pragma mark - 键盘收起
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self searchTextWithSearchBar];
}

#pragma mark - 拖动表
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (IBAction)cancelClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
