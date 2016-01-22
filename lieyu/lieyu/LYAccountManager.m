//
//  LYAccountManager.m
//  lieyu
//
//  Created by pwy on 16/1/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAccountManager.h"
#import "LYResetPasswordViewController.h"
@implementation LYAccountManager

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"账户管理";
    _data=@[@"修改密码",@"绑定微信",@"绑定QQ",@"绑定微博"];
    self.tableView.backgroundColor=RGB(237, 237, 237);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
     self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 70;
    }else{
        return 50;
    }
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    

    if(indexPath.row==0){
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10 , SCREEN_WIDTH, 50)];
        titleLabel.font=[UIFont systemFontOfSize:15.0];
        titleLabel.text=_data[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.frame=CGRectMake(0, cell.frame.origin.y, SCREEN_WIDTH,10);
        layerShadow.borderColor=[RGB(237, 237, 237) CGColor];
        layerShadow.borderWidth=10;
        [cell.layer addSublayer:layerShadow];
        
        CALayer *layerShadow2=[[CALayer alloc]init];
        layerShadow2.frame=CGRectMake(0, cell.frame.origin.y+60, SCREEN_WIDTH,10);
        layerShadow2.borderColor=[RGB(237, 237, 237) CGColor];
        layerShadow2.borderWidth=10;
        [cell.layer addSublayer:layerShadow2];
    }else{
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 0 , SCREEN_WIDTH, 50)];
        titleLabel.font=[UIFont systemFontOfSize:15.0];
        titleLabel.text=_data[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        
        NSString *imageName;
        NSString *isBingding;
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        if (indexPath.row==1) {
            imageName=@"wechat_s";
            if (![MyUtil isEmptyString: app.userModel.wechat]) {
                isBingding=@"已绑定";
            }else{
                isBingding=@"立即绑定";
            }
        }else if (indexPath.row==2){
            imageName=@"qq_s";
            if (![MyUtil isEmptyString: app.userModel.qq]) {
                isBingding=@"已绑定";
            }else{
                isBingding=@"立即绑定";
            }
        }else if (indexPath.row==3){
            imageName=@"sina_weibo_s";
            if (![MyUtil isEmptyString: app.userModel.weibo]) {
                isBingding=@"已绑定";
            }else{
                isBingding=@"立即绑定";
            }
        }
        imageView.image=[UIImage imageNamed:imageName];
        [cell.contentView addSubview:imageView];
        
        
        UILabel *titleLabel2=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130, 0 , 100, 50)];
        titleLabel2.font=[UIFont systemFontOfSize:14.0];
        titleLabel2.text=isBingding;
        titleLabel2.textAlignment=NSTextAlignmentRight;
        titleLabel2.textColor=RGB(101, 11, 138);
        [cell.contentView addSubview:titleLabel2];
        
        CALayer *layerShadow=[[CALayer alloc]init];
        layerShadow.frame=CGRectMake(0, cell.frame.origin.y, SCREEN_WIDTH,1);
        layerShadow.borderColor=[RGB(237, 237, 237) CGColor];
        layerShadow.borderWidth=1;
        [cell.layer addSublayer:layerShadow];
        
        
    }
    
    
//    if(indexPath.row==0){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    UIViewController *detailViewController;
    
    if (indexPath.row==0) {
        detailViewController=[[LYResetPasswordViewController alloc] initWithNibName:@"LYResetPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }else if (indexPath.row==1) {
        
    }else if(indexPath.row==2){
      
    }else if(indexPath.row==3){
    
    }
    
    
    
}

@end
