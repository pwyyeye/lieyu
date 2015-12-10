//
//  CHDetailCollectionCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheHeModel.h"
@protocol RefreshGoodsNum<NSObject>

- (void)refreshGoodsNum;
- (void)getNumLess;
- (void)getNumAdd;

@end

@interface chiheDetailCollectionCell : UICollectionViewCell

@property (nonatomic, strong) CheHeModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *goodImage;

@property (weak, nonatomic) IBOutlet UILabel *fanliLbl;
@property (weak, nonatomic) IBOutlet UIImageView *fanliImage;
@property (weak, nonatomic) IBOutlet UILabel *ProfitLbl;

@property (weak, nonatomic) IBOutlet UILabel *PriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *MarketPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *GoodNameLbl;

@property (weak, nonatomic) IBOutlet UIButton *lessBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UIButton *addToShoppingCarBtn;

@property (nonatomic, assign) id<RefreshGoodsNum> delegate;

- (IBAction)ChangeGoodsNumberClick:(UIButton *)sender;

- (IBAction)AddToShoppingCarClick:(UIButton *)sender;


-(void)configureCell:(CheHeModel *)model;
@end
