//
//  ContentView.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentView : UIView
@property (weak, nonatomic) IBOutlet UIButton *redioButton1;
@property (weak, nonatomic) IBOutlet UIButton *radioButton2;
@property (weak, nonatomic) IBOutlet UIButton *radioButton3;

@property (nonatomic, strong) NSArray *radioButtons;
@property (nonatomic, strong) NSArray *selectButton;
@property (nonatomic, strong) NSMutableArray *buttonStatusArray;

@property (nonatomic, strong) NSString *defaultString;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn1;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn2;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn3;

- (IBAction)BtnClick:(UIButton *)sender;

- (void)contentViewChooseBtn;
@end
