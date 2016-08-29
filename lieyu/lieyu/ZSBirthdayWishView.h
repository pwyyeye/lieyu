//
//  ZSBirthdayWishView.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

@interface ZSBirthdayWishView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UITextView *wishTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendWishButton;
@property (weak, nonatomic) IBOutlet UIButton *dontCareButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@property (nonatomic, strong) AddressBookModel *bookModel;

@end
