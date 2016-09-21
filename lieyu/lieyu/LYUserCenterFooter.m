//
//  LYUserCenterFooter.m
//  lieyu
//
//  Created by pwy on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserCenterFooter.h"
#import "ZSMaintViewController.h"

@implementation LYUserCenterFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"LYUserCenterFooter" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
- (IBAction)gotoManagerCenter:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ZSMaintViewController *maintViewController=[[ZSMaintViewController alloc]initWithNibName:@"ZSMaintViewController" bundle:nil];
    
    [app.navigationController pushViewController:maintViewController animated:YES];
}
@end
