//
//  LYTaoCanListTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTaoCanListTableViewCell : UITableViewCell
@property (nonatomic,strong) NSArray *goodListArray;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (nonatomic,unsafe_unretained) BOOL isProgress;
@end
