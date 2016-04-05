//
//  checkUnpassedViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/2.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "checkUnpassedViewController.h"
#import "LYUserHttpTool.h"
#import "unPassesModel.h"
#import "LYZSApplicationViewController.h"
#import "LyZSuploadIdCardViewController.h"
#import "JiuBaModel.h"
#import "LYChooseJiuBaViewController.h"
#import "LYZSeditView.h"
#import "wechatCheckAccountViewController.h"
@interface checkUnpassedViewController ()<LYChooseJiuBaDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    JiuBaModel *jiuBaNow;
    NSString *barid;
    NSString *idcard;//1.2.3
    NSString *wechatName;//1
    NSString *alipayaccount;//2
    NSString *alipayAccountName;//2
    NSString *bankCard;//3
    NSString *bankCardDeposit;//3
    NSString *bankCardUsername;//3
    
    LYZSApplicationViewController *applicationVC;
    LyZSuploadIdCardViewController *suploadVC;
    
    int height;
    
    int picTag;
    UIView *_bgView;
    LYZSeditView *seditView;
    UIImage *idcard_zhengmian;
    UIImage *idcard_fanmian;
    
    BOOL notEdit;
}
@property (nonatomic, strong)unPassesModel *checkModel;
@property (nonatomic, assign) int applyType;
@end

@implementation checkUnpassedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initThisView];
    [self getCheckData];
    [self.submitBtn addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initThisView{
    [self.scrollerView setBackgroundColor:RGBA(245, 245, 245, 1)];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 60, 10, 120, 33)];
    [titleLbl setTextColor:RGBA(186, 40, 227, 1)];
    [titleLbl setText:@"审核未通过"];
    [titleLbl setFont:[UIFont systemFontOfSize:24]];
    [self.scrollerView addSubview:titleLbl];
    
    _submitBtn.layer.cornerRadius = 21;
}

- (void)getCheckData{
    __weak __typeof(self) weakSelf = self;
    [LYUserHttpTool getUnpassedReasonComplete:^(unPassesModel *model) {
        _checkModel = model;
        barid = _checkModel.barid;
        [weakSelf initOtherView];
    }];
}

- (void)setApplyType:(int)applyType{
    _applyType = applyType;
    int height2;
    if (_applyType == 1) {
        height2 = 264;
        applicationVC.viewLine2.hidden = NO;
        [applicationVC.viewLabel2 setText:@"真实姓名"];
        if (notEdit) {
            [applicationVC.yhkkhTex setText:@""];
            [applicationVC.yhkkhTex setPlaceholder:@"请输入您的真实姓名"];
        }else{
            [applicationVC.yhkkhTex setText:_checkModel.wechatName];
            notEdit = YES;
        }
        
        applicationVC.viewLine3.hidden = YES;
        applicationVC.viewLine4.hidden = YES;
    }else if (_applyType == 2){
        height2 = 309;
        applicationVC.viewLine2.hidden = NO;
        [applicationVC.viewLabel2 setText:@"支付宝账号"];
        
        applicationVC.viewLine3.hidden = NO;
        [applicationVC.viewLabel3 setText:@"绑定姓名"];
        if (notEdit) {
            [applicationVC.yhkkhTex setText:@""];
            [applicationVC.yhkkhTex setPlaceholder:@"请输入正确的帐号"];
            [applicationVC.yhkKhmYhmTex setText:@""];
            [applicationVC.yhkKhmYhmTex setPlaceholder:@"用户支付宝绑定姓名"];
        }else{
            [applicationVC.yhkkhTex setText:_checkModel.alipayaccount];
            [applicationVC.yhkKhmYhmTex setText:_checkModel.alipayAccountName];
            notEdit = YES;
        }
        
        applicationVC.viewLine4.hidden = YES;
    }else if (_applyType == 3){
        height2 = 353;
        applicationVC.viewLine2.hidden = NO;
        [applicationVC.viewLabel2 setText:@"银行卡号"];
        applicationVC.yhkkhTex.keyboardType = UIKeyboardTypeNumberPad;
        
        applicationVC.viewLine3.hidden = NO;
        [applicationVC.viewLabel3 setText:@"开户支行"];
        
        applicationVC.viewLine4.hidden = NO;
        [applicationVC.viewLabel4 setText:@"开户姓名"];
        if (notEdit) {
            [applicationVC.yhkkhTex setText:@""];
            [applicationVC.yhkkhTex setPlaceholder:@"请输入您的卡号"];
            [applicationVC.yhkKhmYhmTex setText:@""];
            [applicationVC.yhkKhmYhmTex setPlaceholder:@"请输入您的开户支行"];
            [applicationVC.yhkyhmTex setText:@""];
            [applicationVC.yhkyhmTex setPlaceholder:@"请输入您的开户姓名"];
        }else{
            [applicationVC.yhkkhTex setText:_checkModel.bankCard];
            [applicationVC.yhkKhmYhmTex setText:_checkModel.bankCardDeposit];
            [applicationVC.yhkyhmTex setText:_checkModel.bankCardUsername];
            notEdit = YES;
        }
    }
    [applicationVC.view setFrame:CGRectMake(0, 65 + height, SCREEN_WIDTH, height2)];
    if (![applicationVC.jiubaButton respondsToSelector:@selector(chooseJiuBaAct:)]) {
        [applicationVC.jiubaButton addTarget:self action:@selector(chooseJiuBaAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    for (UIButton *button in applicationVC.chooseButtons) {
        if (![button respondsToSelector:@selector(chooseAccount:)]) {
            [button addTarget:self action:@selector(chooseAccount:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            break;
        }
    }
    if (![suploadVC.zmAddBtn respondsToSelector:@selector(addPictures:)]) {
        [suploadVC.zmAddBtn addTarget:self action:@selector(addPictures:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (![suploadVC.fmAddBtn respondsToSelector:@selector(addPictures:)]) {
        [suploadVC.fmAddBtn addTarget:self action:@selector(addPictures:) forControlEvents:UIControlEventTouchUpInside];
    }
//    [self.scrollerView addSubview:applicationVC.view];
    
//    suploadVC = [[LyZSuploadIdCardViewController alloc]initWithNibName:@"LyZSuploadIdCardViewController" bundle:nil];
    [suploadVC.view setFrame:CGRectMake(0, 80 + height + height2, SCREEN_WIDTH, 312)];
    suploadVC.nextStepBtn.hidden = YES;
//    [self.scrollerView addSubview:suploadVC.view];
    self.scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, 450 + height + height2);
}

- (void)initOtherView{
    UILabel *reasonLabel = [[UILabel alloc]init];
    [reasonLabel setText:_checkModel.note];
//    [reasonLabel setText:@"el setFont:[UIFont systemFontOfSize:14]];[reasonLabel setTextColor:RGBA(101, 101, 101, 1)];[reasonLabel setBackgroundColor:[UIColor c"];
//    [reasonLabel setText: @"el setFont:[UIFont systemFontOfSize:14]];[reasonLabel setTextColor:RGBA(101, 101, 101, 1)];[reasonLabel setBackgroun dCosetFont:[UIFont systemFontOfSize:14]];[reasonLabel setTextColor:RGBA(101, 101, 101, 1)];[reasonLabel setBackgroun dColor:[UIColor clor:[UIColor c"];
    [reasonLabel setFont:[UIFont systemFontOfSize:14]];
    [reasonLabel setTextColor:RGBA(101, 101, 101, 1)];
    [reasonLabel setBackgroundColor:[UIColor clearColor]];
    [reasonLabel setNumberOfLines:0];
    CGRect rect = [reasonLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 46, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    height = rect.size.height + 10;
    [reasonLabel setFrame:CGRectMake(23, 54, SCREEN_WIDTH - 46, height)];
    [self.scrollerView addSubview:reasonLabel];
    int i;
    if ([_checkModel.applyType isEqualToString:@"1"]) {
        i = 2;
    }else if ([_checkModel.applyType isEqualToString:@"2"]){
        i = 3;
    }else if ([_checkModel.applyType isEqualToString:@"3"]){
        i = 1;
    }
    applicationVC = [[LYZSApplicationViewController alloc]initWithNibName:@"LYZSApplicationViewController" bundle:nil];
    applicationVC.checkModel = _checkModel;
    
//    [applicationVC.view setFrame:CGRectMake(0, 65 + height, SCREEN_WIDTH, height2)];
    [self.scrollerView addSubview:applicationVC.view];
//
    suploadVC = [[LyZSuploadIdCardViewController alloc]initWithNibName:@"LyZSuploadIdCardViewController" bundle:nil];
//    [suploadVC.view setFrame:CGRectMake(0, 80 + height + height2, SCREEN_WIDTH, 312)];
//    suploadVC.nextStepBtn.hidden = YES;
    suploadVC.checkUpload = YES;
    [self.scrollerView addSubview:suploadVC.view];
//    self.scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, 450 + height + height2);
    
    [self setApplyType:i];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark－ 选择酒吧
- (void)chooseJiuBaAct:(UIButton *)sender{
    LYChooseJiuBaViewController *chooseJiuBaViewController=[[LYChooseJiuBaViewController alloc]initWithNibName:@"LYChooseJiuBaViewController" bundle:nil];
    chooseJiuBaViewController.title=@"选择酒吧";
    chooseJiuBaViewController.delegate=self;
    [self.navigationController pushViewController:chooseJiuBaViewController animated:YES];
}

//delegate
- (void)chooseJiuBa:(JiuBaModel *)jiuBaModel{
    jiuBaNow=jiuBaModel;
    barid = [NSString stringWithFormat:@"%d",jiuBaNow.barid];
    [applicationVC.jiubaLal setTextColor:RGBA(186, 40, 227, 1)];
    applicationVC.jiubaLal.text=jiuBaModel.barname;
}

#pragma mark - 选择支付方式
- (void)chooseAccount:(UIButton *)sender{
    for (UIButton *btn in applicationVC.chooseButtons) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
            [self setApplyType:btn.tag];
        }else{
            btn.selected = NO;
        }
    }
}

#pragma mark -填完textFiled
- (void)exitEdit:(UITextField *)sender{
    [sender resignFirstResponder];
}

#pragma mark - 添加照片
- (IBAction)addPictures:(UIButton *)sender {
    picTag=(int)sender.tag;
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    [self.view addSubview:_bgView];
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYZSeditView" owner:nil options:nil];
    seditView= (LYZSeditView *)[nibView objectAtIndex:0];
    seditView.top=SCREEN_HEIGHT;
    seditView.frame = CGRectMake(0, SCREEN_HEIGHT - 287, SCREEN_WIDTH, 287);
    [seditView.quxiaoBtn addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [seditView.editListBtn addTarget:self action:@selector(paizhaoAct:) forControlEvents:UIControlEventTouchDown];
    seditView.editListBtn.hidden=NO;
    seditView.secondLal.hidden=NO;
    [seditView.editListBtn setImage:[UIImage imageNamed:@"paizhao"] forState:0];
    [seditView.shenqingBtn setImage:[UIImage imageNamed:@"xiangce"] forState:0];
    seditView.firstLal.text=@"相册";
    seditView.secondLal.text=@"拍照";
    [seditView.shenqingBtn addTarget:self action:@selector(xiangceAct:) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:seditView];
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:seditView cache:NO];
    seditView.top=SCREEN_HEIGHT-seditView.height-64;
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT-seditView.height-64);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
}
#pragma mark - 消失
-(void)SetViewDisappear:(id)sender
{
    
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             seditView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
    
}

#pragma mark - 拍照
-(void)paizhaoAct:(id)sender{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
    [self SetViewDisappear:nil];
}
#pragma mark - 相册
-(void)xiangceAct:(id)sender{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    
    imagePicker.delegate=self;
    
    imagePicker.allowsEditing=YES;
    
    imagePicker.sourceType=sourceType;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
    [self SetViewDisappear:nil];
}
//imagepicker 的delegate事件
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    // UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//原始图
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    if(picTag==100){//正面
        //压缩0.3倍以后
        idcard_zhengmian=[[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.3)];
        [suploadVC.zmAddBtn setImage:idcard_zhengmian forState:0];
    }else if(picTag==101){
        idcard_fanmian=[[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.3)];
        [suploadVC.fmAddBtn setImage:idcard_fanmian forState:0];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 检验
- (bool)checkData{
    if(!barid.length){
        [MyUtil showMessage:@"请选择酒吧"];
        return false;
    }
    if(![MyUtil validateIdentityCard:applicationVC.sfzTex.text]){
        [MyUtil showMessage:@"你输入身份证有误"];
        return false;
    }
    if (self.applyType == 0) {
        [MyUtil showMessage:@"至少选一种支付方式！"];
        return false;
    }else if (self.applyType == 1){
        idcard = applicationVC.sfzTex.text;
        wechatName = applicationVC.yhkkhTex.text;
        if (!idcard.length || !wechatName.length) {
            [MyUtil showMessage:@"请将信息填写完整"];
            return false;
        }else{
//            return true;
        }
    }else if (self.applyType == 2){
        idcard = applicationVC.sfzTex.text;
        alipayaccount = applicationVC.yhkkhTex.text;
        alipayAccountName = applicationVC.yhkKhmYhmTex.text;
        if (!idcard.length || !alipayAccountName.length || !alipayaccount.length) {
            [MyUtil showMessage:@"请将信息填写完整"];
            return false;
        }else{
//            return true;
        }
    }else if (self.applyType == 3){
        idcard = applicationVC.sfzTex.text;
        bankCard = applicationVC.yhkkhTex.text;
        bankCardDeposit = applicationVC.yhkKhmYhmTex.text;
        bankCardUsername = applicationVC.yhkyhmTex.text;
        if (!idcard.length || !bankCard.length || !bankCardDeposit.length || !bankCardUsername.length) {
            [MyUtil showMessage:@"请将信息填写完整"];
            return false;
        }else{
//            return true;
        }
    }
    if (!idcard_zhengmian) {
        [MyUtil showMessage:@"请上传身份证正面"];
        return false;
    }
    if(!idcard_fanmian){
        [MyUtil showMessage:@"请上传身份证反面"];
        return false;
    }
    return YES;
}


- (void)submitData{
    if(![self checkData]){
        return;
    }
    NSString *applyTypeString;
    if (_applyType == 1) {
        applyTypeString = @"3";
    }else if (_applyType == 2){
        applyTypeString = @"1";
    }else if (_applyType == 3){
        applyTypeString = @"2";
    }
    NSMutableDictionary *dic=
    [[NSMutableDictionary alloc]initWithDictionary:@{@"id":_checkModel.id,@"idcard":idcard,@"barid":[NSNumber numberWithInt:jiuBaNow.barid],@"userid":[NSNumber numberWithInt:self.userModel.userid],@"applyType":applyTypeString}];
    if (_applyType == 1) {
        if (wechatName.length) {
            [dic setObject:wechatName forKey:@"wechatName"];
        }
    }else if (_applyType == 2){
        if (alipayaccount.length && alipayAccountName.length) {
            [dic setObject:alipayAccountName forKey:@"alipayAccountName"];
            [dic setObject:alipayaccount forKey:@"alipayaccount"];
        }
    }else if (_applyType == 3){
        if (bankCardUsername.length && bankCardDeposit.length && bankCard.length) {
            [dic setObject:bankCard forKey:@"bankCard"];
            [dic setObject:bankCardDeposit forKey:@"bankCardDeposit"];
            [dic setObject:bankCardUsername forKey:@"bankCardUsername"];
        }
    }
    [[LYUserHttpTool shareInstance]updateApplyVip:dic block:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(idcard_zhengmian) name:@"idcardImagesFile" fileName:@"idcard_1.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:UIImagePNGRepresentation(idcard_fanmian) name:@"idcardImagesFileBack" fileName:@"idcard_2.png" mimeType:@"image/png"];
    } complete:^(BOOL result) {
        if(result){
            [MyUtil showMessage:@"申请成功!"];
            self.userModel.applyStatus = 1;
            if([[dic objectForKey:@"applyType"] isEqualToString:@"3"]){
                if (_checkModel.wechatAccount.length) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    wechatCheckAccountViewController *wechatCheckVC = [[wechatCheckAccountViewController alloc]initWithNibName:@"wechatCheckAccountViewController" bundle:nil];
                    [self.navigationController pushViewController:wechatCheckVC animated:YES];
                }
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }];
}


@end
