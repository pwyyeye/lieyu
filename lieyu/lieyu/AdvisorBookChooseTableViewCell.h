//
//  AdvisorBookChooseTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/5/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvisorBookChooseTableViewCell : UITableViewCell
@property (nonatomic, assign) NSUInteger cellTag;

@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *content_label;
@property (weak, nonatomic) IBOutlet UIView *subView;

@property (weak, nonatomic) IBOutlet UIButton *anvance_button;

- (void)configureTime;
- (void)configureNumber;
- (void)configureType;
@end
