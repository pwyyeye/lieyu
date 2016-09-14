//
//  MineGroupCodeViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface MineGroupCodeViewController :LYBaseViewController

@property (nonatomic, strong) NSString *codeString;

@property (weak, nonatomic) IBOutlet UIView *codeView;

- (IBAction)downloadQRCode:(UIButton *)sender;
@end
