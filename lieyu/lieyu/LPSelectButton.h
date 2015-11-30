//
//  SelectButton.h
//  lieyu
//
//  Created by 王婷婷 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPSelectButton : UIButton

@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIImageView *imageIcon;

@property (nonatomic, strong) NSDictionary *dict;

- (id)initWithFrame:(CGRect)frame AndDictionary:(NSDictionary *)dict;

@end
