//
//  LYHotBarMenuViewController.h
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYHotBarMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn_allPlace;
@property (weak, nonatomic) IBOutlet UIButton *btn_music;
@property (weak, nonatomic) IBOutlet UIButton *btn_aroundMe;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_arrow_one;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_arrow_two;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_arrow_three;
- (instancetype)initWithFrame:(CGRect)frame :(UIViewController *)controller;

- (IBAction)test:(id)sender;
@end
