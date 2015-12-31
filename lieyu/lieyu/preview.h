//
//  preview.h
//  播放器
//
//  Created by 王婷婷 on 15/12/26.
//  Copyright © 2015年 王婷婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface preview : UIView
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIImage *image;

- (void)viewConfigure;

@end
