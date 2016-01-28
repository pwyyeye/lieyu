//
//  TimeView.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeView : UIView
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

- (void)congigure;
@end
