//
//  JoinedTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinedTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) NSMutableArray *buttons_array;

- (void)configureJoinedNumber;
- (void)configureMessage;
- (void)configureMoreAction;

@end
