//
//  HomepageMenuTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepageMenuTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *imagesArray;
@property (weak, nonatomic) IBOutlet UIButton *strategyButton;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIButton *recentButton;


@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *filterArray;

@end
