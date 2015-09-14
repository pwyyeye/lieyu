//
//  LYWineBarInfoCell.h
//  lieyu
//
//  Created by newfly on 9/14/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYWineBarInfoCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView * mImageView;
@property(nonatomic,weak)IBOutlet UILabel * barNameLabel;
@property(nonatomic,weak)IBOutlet UILabel * barDescLabel;
@property(nonatomic,weak)IBOutlet UILabel * barAddrLabel;
@property(nonatomic,weak)IBOutlet UILabel * costLabel;

@property(nonatomic,weak)IBOutlet UILabel * distanceLabel;

@end
