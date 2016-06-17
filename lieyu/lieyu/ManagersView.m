//
//  ManagersView.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ManagersView.h"
#import "ZSDetailModel.h"
#import "MTA.h"
@implementation ManagersView

- (void)configure:(NSArray *)managerList{
    self.managersArray = managerList;
    _buttonsArray = [NSMutableArray array];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 20, 48, 14)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = RGBA(102, 102, 102, 1);
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"专属服务";
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(72, 1, SCREEN_WIDTH - 72, 52)];
//    if (scrollView.frame.size.width < SCREEN_WIDTH - 72) {
//        scrollView.frame = CGRectMake(72, 1, SCREEN_WIDTH - 72, 52);
//        scrollView.backgroundColor = [UIColor blueColor];
//    }
    scrollView.contentSize = CGSizeMake(142 * _managersArray.count + 10, 52);
//    scrollView.backgroundColor = [UIColor redColor];
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    int buttonX = 10;
    for (int i = 0 ; i < _managersArray.count; i ++) {
        ZSDetailModel *model = [_managersArray objectAtIndex:i];
        ManagerChooseButton *button = [[[NSBundle mainBundle]loadNibNamed:@"ManagerChooseButton" owner:nil options:nil]firstObject];
        button.frame = CGRectMake(buttonX, 1, 142, 52);
//        ManagerChooseButton *button = [[ManagerChooseButton alloc]initWithFrame:CGRectMake(buttonX, 1, 142, 52)];
        button.tag = i;
        [button configure:model];
        [_buttonsArray addObject:button];
//        button.backgroundColor = [UIColor blackColor];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        buttonX = buttonX + 142;
        if ([MyUtil isEmptyString:_choosedManagerID]) {
            //未传入选择专属经理
            if(i == 0){
                button.selected = YES;
                button.recommond.hidden = NO;
                button.maskLabel.hidden = NO;
            }
        }else{
            if (model.userid == [_choosedManagerID intValue]) {
                button.selected = YES;
                button.recommond.hidden = NO;
                button.maskLabel.hidden = NO;
            }
        }
        [scrollView addSubview:button];
    }
    [self addSubview:label1];
    [self addSubview:scrollView];
}

- (void)selectButton:(ManagerChooseButton *)sender{
    for (ManagerChooseButton *button in _buttonsArray) {
        if (button.tag == sender.tag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    if ([_delegate respondsToSelector:@selector(chooseManagerDone:)]) {
        NSDictionary *dict = @{@"actionName":@"选择",
                               @"pageName":@"预定",
                               @"titleName":((ZSDetailModel *)[_managersArray objectAtIndex:sender.tag]).usernick};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
        [_delegate chooseManagerDone:sender];
    }
}

@end
