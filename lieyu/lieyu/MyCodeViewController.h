//
//  MyCodeViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface MyCodeViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *QRCodebg;
@property (weak, nonatomic) IBOutlet UILabel *userNick;
@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UIView *QRCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeHeaderTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeBGBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeBGTop;

@end
