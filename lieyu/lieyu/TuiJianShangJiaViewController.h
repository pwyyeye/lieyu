//
//  TuiJianShangJiaViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface TuiJianShangJiaViewController : LYBaseViewController
- (IBAction)addPhotoAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *jiubaMcTex;
@property (weak, nonatomic) IBOutlet UITextField *addressTex;
@property (weak, nonatomic) IBOutlet UITextField *phoneTex;
@property (weak, nonatomic) IBOutlet UITextField *typeTex;
@property (weak, nonatomic) IBOutlet UITextField *zsJingLiTex;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
