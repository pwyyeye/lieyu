//
//  ManagerInfoCell.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/3.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerInfoCell.h"
#import "ZSDetailModel.h"
//#import "zs"

@interface ManagerInfoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIButton *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UIButton *radioButon;

@property (nonatomic, strong) ZSDetailModel *zsDetail;


@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


@property (nonatomic, strong) NSArray *starsArray;
//
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
//
//- (IBAction)selectManager:(UIButton *)sender;
- (void)cellConfigureWithImage:(NSString *)imageUrl name:(NSString *)name stars:(NSString *)stars;
- (void)cellConfigure:(int)index;
@end
