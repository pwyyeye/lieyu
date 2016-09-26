//
//  ZSAddBirthdayViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSAddBirthdayViewController.h"
#import "LYAlert.h"
#import "HTTPController.h"
#import "AddressBookModel.h"
#import "ZSManageHttpTool.h"

@interface ZSAddBirthdayViewController ()<UIActionSheetDelegate,LYAlertDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger _sex;
    NSString *_birthday;
    UIImage *_selectedImage;
}
//弹出视图
@property(strong,nonatomic) LYAlert *alertView;
@property(strong,nonatomic) UIDatePicker *datePicker;
@end

@implementation ZSAddBirthdayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"编辑生日";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
}

- (void)initMainView{
    
    _avatarImage.layer.cornerRadius = 35;
    _avatarImage.layer.masksToBounds = YES;
    
    [_changeAvatarButton addTarget:self action:@selector(changeAvatarImage) forControlEvents:UIControlEventTouchUpInside];
    _avatarImage.layer.cornerRadius = 35;
    _usernameTextField.layer.borderColor = [RGBA(102, 102, 102, 1) CGColor];
    _usernameTextField.layer.borderWidth = 0.5;
    _usernameTextField.layer.cornerRadius = 2;
    _phoneTextField.layer.borderColor = [RGBA(102, 102, 102, 1) CGColor];
    _phoneTextField.layer.borderWidth = 0.5;
    _phoneTextField.layer.cornerRadius = 2;
    _chooseBirthdayButton.layer.cornerRadius = 2;
    _chooseBirthdayButton.layer.borderColor = [RGBA(102, 102, 102, 1)CGColor];
    _chooseBirthdayButton.layer.borderWidth = 0.5;
    [_chooseBirthdayButton addTarget:self action:@selector(chooseBirthdayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _submitButton.layer.cornerRadius = 19;
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _datePicker=[[UIDatePicker alloc] init];
    _datePicker.center = CGPointMake(SCREEN_WIDTH/2.f,_datePicker.center.y);
    _datePicker.datePickerMode=UIDatePickerModeDate;
    NSLocale *local=[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale=local;
    [_datePicker setMaximumDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if (_editModel) {
//        [_avatarImage sd_setImageWithURL:[NSURL URLWithString:_editModel.headUrl]];
        _selectedImage = _headImage;
        if (![MyUtil isEmptyString:_editModel.birthday]) {
            _birthday = [NSString stringWithFormat:@"1995-%@",_editModel.birthday];
            [_datePicker setDate:[formatter dateFromString:_birthday]];
        }else{
            NSString *nowDateString = [formatter stringFromDate:[NSDate date]];
            NSString *showDateString = [nowDateString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"1995"];
            [_datePicker setDate:[formatter dateFromString:showDateString]];
        }
        [_avatarImage setImage:_headImage];
        _usernameTextField.text = _editModel.name;
        _phoneTextField.text = _editModel.mobile;
        [_chooseBirthdayButton setTitle:_editModel.birthday forState:UIControlStateNormal];
        _sex = [_editModel.sex intValue];
    }else{
        NSString *nowDateString = [formatter stringFromDate:[NSDate date]];
        NSString *showDateString = [nowDateString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"1995"];
        [_datePicker setDate:[formatter dateFromString:showDateString]];
        
        [_avatarImage setImage:[UIImage imageNamed:@"CommonIcon"]];
    }
    for (UIButton *button in _chooseSexButton) {
        if (button.tag == _sex) {
            [button setSelected:YES];
        }
        [button addTarget:self action:@selector(chooseSexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 按钮事件
//更改头像
- (void)changeAvatarImage{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    actionSheet.tag=255;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==255) {
        NSInteger sourceType=0;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //拍照
                    sourceType=UIImagePickerControllerSourceTypeCamera;
                    
                    break;
                case 1:
                    //相册
                    sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    break;
                case 2:
                    //取消
                    return;
                    break;
                default:
                    break;
            }
        }else{
            if (buttonIndex==2) {
                return;
            }else{
                sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
        
        imagePicker.delegate=self;
        imagePicker.allowsEditing=YES;
        imagePicker.sourceType=sourceType;
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    UIGraphicsBeginImageContext(CGSizeMake(800, 800));
    [image drawInRect:CGRectMake(0, 0, 800, 800)];
    _selectedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _avatarImage.image = _selectedImage ;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
        [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//提交数据
- (void)submitButtonClick{
    if (_usernameTextField.text.length <= 0) {
        [MyUtil showPlaceMessage:@"请填写姓名！"];
        return;
    }
    if (_birthday.length <= 0) {
        [MyUtil showPlaceMessage:@"请填写生日！"];
        return;
    }
    if (_phoneTextField.text.length <= 0) {
        [MyUtil showPlaceMessage:@"请填写手机号码！"];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    NSString *modelID;
    if (_editModel) {
        modelID = _editModel.id;
    }else{
        modelID = @"";
    }
    [HTTPController uploadImageToQiuNiu:_selectedImage complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp){
        if (![MyUtil isEmptyString:key]) {
            //上传用户信息
            __block NSDictionary *dict = @{
                                   @"mobile":_phoneTextField.text,
                                   @"name":_usernameTextField.text,
                                   @"birthday":_birthday,
                                   @"headUrl":key,
                                   @"sex":[NSString stringWithFormat:@"%ld",_sex],
                                   @"id":modelID //如果传说明是更新
                                };
            [[ZSManageHttpTool shareInstance]zsAddFriendBirthdayWithParams:dict complete:^(BOOL result) {
                if (result) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [MyUtil showPlaceMessage:@"操作成功！"];
                }else{
                    [MyUtil showPlaceMessage:@"操作失败，请稍后重试！"];
                }
            }];
        }
    }];
}

//选择生日
- (void)chooseBirthdayButtonClick{
    [self showAlertView];
}

-(void)showAlertView{
    if (_alertView!=nil) {
        [_alertView removeFromSuperview];
        _alertView=nil;
    }
    _alertView=[[LYAlert alloc] initWithType:LYAlertTypeDefault];
    _alertView.customType=0;
    _alertView.delegate=self;
    [self.view addSubview:_alertView];
    
    [_alertView.showView addSubview:_datePicker];
    [_alertView show];
}

#pragma mark - LYAlert的代理事件
-(void)button_ok:(NSInteger) customType{
    [_alertView removeFromSuperview];
    _alertView=nil;
    if (customType==0) {
        NSDate *select  = [_datePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [dateFormatter stringFromDate:select];
        [_chooseBirthdayButton setTitle:date forState:UIControlStateNormal];
        _birthday = date;
    }
}

-(void)button_cancel{
    [_alertView removeFromSuperview];
    _alertView=nil;
    return;
}

//选择性别
- (void)chooseSexButtonClick:(UIButton *)button{
    _sex = button.tag;
    for (UIButton *btn in _chooseSexButton) {
        if (btn.tag == button.tag) {
            [btn setSelected:YES];
        }else{
            [btn setSelected:NO];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
