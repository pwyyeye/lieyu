//
//  AdvisorBookIngoTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/5/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvisorBookIngoTableViewCell : UITableViewCell
@property (nonatomic, assign) NSUInteger cellTag;

@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIImageView *avatar_image;
@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (nonatomic, strong) NSDictionary *barDict;
@property (nonatomic, strong) NSDictionary *userDict;

@end
