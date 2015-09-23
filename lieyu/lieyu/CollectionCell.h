//
//  CollectionCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *jiageLal;
@property (weak, nonatomic) IBOutlet UILabel *miaosuLal;
@property (weak, nonatomic) IBOutlet UILabel *dizhiLal;
@property (weak, nonatomic) IBOutlet UILabel *timeLal;

@end
