//
//  FBTaoCanView.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBTaoCanView : UIView

@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet UITextField *taocanTitleTex;
@property (weak, nonatomic) IBOutlet UITextField *fromPriceTex;
@property (weak, nonatomic) IBOutlet UITextField *toPriceTex;
@property (weak, nonatomic) IBOutlet UIButton *timeChooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLal;
@property (weak, nonatomic) IBOutlet UILabel *imageAddlal;
@property (weak, nonatomic) IBOutlet UITextField *fromPopulationTex;
@property (weak, nonatomic) IBOutlet UITextField *toPopulationTex;
@property (weak, nonatomic) IBOutlet UIButton *addTaoCanBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLal;
@end
