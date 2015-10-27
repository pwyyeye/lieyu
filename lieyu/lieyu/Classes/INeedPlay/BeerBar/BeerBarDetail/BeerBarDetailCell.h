//
//  BeerBarDetailCell.h
//  lieyu
//
//  Created by newfly on 9/20/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HCSStarRatingView/HCSStarRatingView.h>
#import "BeerBarOrYzhDetailModel.h"
@interface BeerBarDetailCell : UITableViewCell<LYTableViewCellLayout>
{
    BeerBarOrYzhDetailModel *barOrYzhDetailModel;
}
@property(nonatomic,weak)IBOutlet UIImageView * barPhoto;
@property(nonatomic,weak)IBOutlet UILabel * barName;
@property(nonatomic,weak)IBOutlet UILabel * preOrderNumber;
@property(nonatomic,weak)IBOutlet UILabel * address;
@property(nonatomic,weak)IBOutlet UIView * spectialContainer;
@property(nonatomic,weak)IBOutlet UIView * typeContainer;
@property(nonatomic,weak)IBOutlet HCSStarRatingView * serviceNumView;
@property(nonatomic,weak)IBOutlet HCSStarRatingView * envNumView;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn3;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn4;
@property (weak, nonatomic) IBOutlet UIButton *teseBtn1;
@property (weak, nonatomic) IBOutlet UIButton *teseBtn2;
@property (weak, nonatomic) IBOutlet UIButton *teseBtn3;
@property (weak, nonatomic) IBOutlet UIButton *teseBtn4;
- (IBAction)daohanAct:(UIButton *)sender;

@end


