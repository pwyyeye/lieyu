//
//  LYBarSpecialTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYBarSpecialTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *label_specialArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *label_classArray;

@end
