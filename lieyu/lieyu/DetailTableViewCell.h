//
//  DetailTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *wineName;
@property (weak, nonatomic) IBOutlet UILabel *wineNumber;
@property (weak, nonatomic) IBOutlet UILabel *winePrice;


- (void)configureCell:(NSDictionary *)wineInfo;

@end
