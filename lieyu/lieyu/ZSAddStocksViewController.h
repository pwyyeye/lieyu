//
//  ZSAddStocksViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYZSeditView.h"
#import "UzysAssetsPickerController.h"
@protocol ZSAddStocksDelegate<NSObject>
- (void)addStocks;

@end

@interface ZSAddStocksViewController : LYBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UzysAssetsPickerControllerDelegate>
{
    NSString *chooseStr;
    LYZSeditView *seditView;
    UIView  *_bgView;
     NSString* filePath;
    NSMutableArray *keyArr;
}
- (IBAction)sureAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *firstRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifthRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixthRadioBtn;
- (IBAction)chooseRadioAct:(id)sender;
- (IBAction)addPictures:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleTex;
@property (weak, nonatomic) IBOutlet UITextField *kucunTex;

- (IBAction)exitEdit:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UILabel *imageAddlal;
@property (nonatomic, weak) id <ZSAddStocksDelegate> delegate;
@end
