//
//  LYBaseViewController.m
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYBaseViewController ()

@end

@implementation LYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=0;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor=RGB(35, 166, 116);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
//    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
//    [self.navigationItem setLeftBarButtonItem:item];
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];

    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    

    // Do any additional setup after loading the view.
}
-(void)showMessage:(NSString*) message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView setBackgroundColor:[UIColor clearColor]];
    
    //必须在这里调用show方法，否则indicator不在UIAlerView里面
    [alertView show];
    
}
-(void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setCustomTitle:(NSString *)title
{
    int titleTag = 1000000;
    self.title = nil;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UILabel *label = (UILabel *)[self.navigationController.navigationBar viewWithTag:titleTag];
    if (label)
    {
        [label removeFromSuperview];
    }
    
    if (title == nil)
    {
        return ;
    }
    
    UIFont * font = navBar.titleTextAttributes[NSFontAttributeName];
    UIColor * textColor = navBar.titleTextAttributes[NSForegroundColorAttributeName];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, navBar.frame.size.width, 44)];
    labelTitle.font = font;
    labelTitle.textColor = textColor;
    labelTitle.tag = titleTag;
    labelTitle.text = title;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    
    [self.navigationController.navigationBar addSubview:labelTitle];
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
