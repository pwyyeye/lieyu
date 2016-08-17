//
//  MineMenuButton.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineMenuButton : UIButton

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *menuLabel;

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *menuName;

@end
