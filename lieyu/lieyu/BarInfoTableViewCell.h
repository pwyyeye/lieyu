//
//  BarInfoTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *barInfoDict;
@property (weak, nonatomic) IBOutlet UIImageView *barImage;
@property (weak, nonatomic) IBOutlet UILabel *barNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;
@property (weak, nonatomic) IBOutlet UIImageView *icon4;
@property (weak, nonatomic) IBOutlet UIImageView *icon5;

- (void)cellConfigure:(NSDictionary *)dict;

@end
