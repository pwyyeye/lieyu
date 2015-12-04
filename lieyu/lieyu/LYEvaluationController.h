//
//  LYEvaluationController.h
//  lieyu
//
//  Created by pwy on 15/12/3.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import <HCSStarRatingView.h>
#import "OrderInfoModel.h"
#import "LYUserHttpTool.h"
@interface LYEvaluationController : LYBaseViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
//酒吧icon
@property (weak, nonatomic) IBOutlet UIImageView *barImageView;
//专属经理头像
@property (weak, nonatomic) IBOutlet UIImageView *managerAvatar_img;
//评价图片
@property (weak, nonatomic) IBOutlet UIImageView *pingjiaImage;
@property(assign,nonatomic) BOOL isPickImage;


@property (weak, nonatomic) IBOutlet HCSStarRatingView *barStar;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *managerStar;

@property (weak, nonatomic) IBOutlet UILabel *barNameText;
@property (weak, nonatomic) IBOutlet UILabel *managerNameText;

@property (weak, nonatomic) IBOutlet UITextView *contentText;

@property(strong,nonatomic) OrderInfoModel *orderInfoModel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)getPicture:(id)sender;
- (IBAction)pingjia:(id)sender;
@end
