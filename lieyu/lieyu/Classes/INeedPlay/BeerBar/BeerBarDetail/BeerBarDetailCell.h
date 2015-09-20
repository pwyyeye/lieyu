//
//  BeerBarDetailCell.h
//  lieyu
//
//  Created by newfly on 9/20/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeerBarDetailCell : UITableViewCell<LYTableViewCellLayout>

@property(nonatomic,weak)IBOutlet UIImageView * barPhoto;
@property(nonatomic,weak)IBOutlet UILabel * barName;
@property(nonatomic,weak)IBOutlet UILabel * preOrderNumber;
@property(nonatomic,weak)IBOutlet UILabel * address;
@property(nonatomic,weak)IBOutlet UIView * spectialContainer;
@property(nonatomic,weak)IBOutlet UIView * typeContainer;


@end


