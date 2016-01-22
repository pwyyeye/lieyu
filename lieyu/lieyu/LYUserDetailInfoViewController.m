//
//  LYUserDetailInfoViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/6.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserDetailInfoViewController.h"
#import "LYUserDetailCameraTableViewCell.h"
#import "LYUserDetailTableViewCell.h"
#import "LYUserDetailSexTableViewCell.h"
#import "LYUserHttpTool.h"
#import "HTTPController.h"
#import "LPAlertView.h"
#import "UserTagModel.h"
#import "UIButton+WebCache.h"
#import "TimePickerView.h"
#import "LYUserLoginViewController.h"
#import "LYTagsViewController.h"
#import "UserTagModel.h"

@interface LYUserDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LPAlertViewDelegate,LYTagsViewControllerDelegate>
{
    LYUserDetailCameraTableViewCell *_selectcedCell;
    LYUserDetailTableViewCell *_nickCell;
    LYUserDetailSexTableViewCell *_sexCell;
    LYUserDetailTableViewCell *_birthCell;
     LYUserDetailTableViewCell *_tagCell;
    NSString *_keyStr;
    NSDate *_chooseBirthDate;
    NSString *_tagNames;
    UIImage *_imageIcon;
    UserTagModel *_userTag;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYUserDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registeTableViewCell];
    //self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||[[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        _tableView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 431);
    }
    self.title=@"填写完整信息";
    [self setSeparator];//设置tableView分割线
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes)];
    [_selectcedCell addGestureRecognizer:tapGes];
    
//    if (_isAutoLogin) {
//        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
//        _isAutoLogin = NO;
//        [loginVC autoLogin];
//    }
}

- (void)tapGes{
    [_nickCell.textF_content endEditing:NO];
}

- (void)setSeparator{
    self.tableView.separatorColor = RGBA(230, 230, 230, 1);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView     respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark 注册单元格
- (void)registeTableViewCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"LYUserDetailCameraTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYUserDetailCameraTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LYUserDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LYUserDetailTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LYUserDetailSexTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYUserDetailSexTableViewCell"];
}

#pragma mark UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;//获取当前用户信息
    if (!indexPath.row) {//头像
        _selectcedCell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailCameraTableViewCell" forIndexPath:indexPath];
        NSString *avatarImgStr = nil;
        if(_userM) {
            
            avatarImgStr = _userM.avatar_img;
            mod.avatar_img = _userM.avatar_img;
        }
        else avatarImgStr = mod.avatar_img;
        [_selectcedCell.btn_userImage sd_setBackgroundImageWithURL:[NSURL URLWithString:avatarImgStr] forState:UIControlStateNormal];
        [_selectcedCell.btn_userImage addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
        _selectcedCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _selectcedCell;
    }else if(indexPath.row == 1){//昵称
        _nickCell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailTableViewCell" forIndexPath:indexPath];
            _nickCell.image_arrow.hidden = YES;
//        if (mod.usernick.length){
//            _nickCell.textF_content.text = mod.usernick;
//            _nickCell.textF_content.textColor = RGBA(114, 5, 145, 1);
//        }
        _nickCell.textF_content.text = _userM.usernick;
        _nickCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _nickCell;
        
    }else if(indexPath.row == 2){//性别
        _sexCell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailSexTableViewCell" forIndexPath:indexPath];
//            if (!mod.gender.integerValue) {
//                [_sexCell.btn_man setImage:[UIImage imageNamed:@"circleWhiteSelect"] forState:UIControlStateNormal];
//                [_sexCell.btn_women setImage:[UIImage imageNamed:@"circleWhite"] forState:UIControlStateNormal];
//                _sexCell.btn_women.tag = 0;
//                _sexCell.btn_man.tag = 3;
//            }
        _sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
         return _sexCell;
    }else if(indexPath.row == 3){//生日
        _birthCell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailTableViewCell" forIndexPath:indexPath];

        
            _birthCell.label_title.text = @"生日";
            _birthCell.textF_content.enabled = NO;
            _birthCell.textF_content.text = @"选择生日";
            if (mod.birthday.length) {
                _birthCell.textF_content.text = mod.birthday;
                _birthCell.textF_content.textColor = RGBA(114, 5, 145, 1);
        }
        _birthCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _birthCell;
    }else if(indexPath.row == 4){//标签
        _tagCell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailTableViewCell" forIndexPath:indexPath];
            _tagCell.label_title.text = @"标签";
            _tagCell.textF_content.enabled = NO;
            _tagCell.textF_content.text = @"选择标签";
            if (mod.tags.count) {
                if (mod.tags.count == 1) {
                    _tagCell.textF_content.text = ((UserTagModel *) mod.tags[0]).tagname;
                }else{
                for (int i = 1;i < mod.tags.count ; i ++) {
                    UserTagModel *usertag = mod.tags[i];
                    if (!_tagNames.length) {
                        _tagNames = ((UserTagModel *) mod.tags[0]).tagname == nil ?((UserTagModel *) mod.tags[0]).name : ((UserTagModel *) mod.tags[0]).tagname;

                    }
                    _tagNames = [NSString stringWithFormat:@"%@,%@",_tagNames,usertag.tagname == nil ? usertag.name : usertag.tagname];
                        
                        NSLog(@"---->%@",usertag.tagname);
                    }
                    _tagCell.textF_content.text = _tagNames;
                }
                _tagCell.textF_content.textColor = RGBA(114, 5, 145, 1);
            }
        _tagCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _tagCell;
    }else {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 47, SCREEN_WIDTH - 20, 52)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        sureBtn.layer.cornerRadius = 4;
        sureBtn.layer.masksToBounds = YES;
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"purpleBtnBG"] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:sureBtn];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, LONG_LONG_MAX);
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = 0.0;
    switch (indexPath.row) {
        case 0:
        {
            h = 127;
        }
            break;
        case 5:
        {
            h = 113;
        }
            break;
        default:
        {
            h = 52;
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;
    if (indexPath.row == 3) {//选择生日
        LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消",@"确定",nil];
        
        TimePickerView *timeView = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerView" owner:nil options:nil] firstObject];
        timeView.timePicker.datePickerMode = UIDatePickerModeDate;
        timeView.timePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        timeView.timePicker.maximumDate = [NSDate date];
        timeView.label_title.text = @"请选择出生年日";
        timeView.tag = 11;
        timeView.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200);
        alertView.contentView = timeView;
        [alertView show];
    }else if (indexPath.row == 4){
        //标签
//        LYTagTableViewController *tagVC = [[LYTagTableViewController alloc]init];
//        tagVC.delegate = self;
//        for (UserTagModel *tag in mod.tags) {
//            if (tag.id==0) {
//                tag.id=tag.tagid;
//            }
//            if ([MyUtil isEmptyString:tag.name]) {
//                tag.name=tag.tagname;
//            }
//            
//        }
//        tagVC.selectedArray=mod.tags;
//        [self.navigationController pushViewController:tagVC animated:YES];
        LYTagsViewController *tagsVC = [[LYTagsViewController alloc]init];
         tagsVC.delegate=self;
        [self.navigationController pushViewController:tagsVC animated:YES];
    }else if (indexPath.row == 1){
        return;
    }
    [_nickCell.textF_content endEditing:NO];
}

- (void)userTagSelected:(UserTagModel *)usertag{
//    UILabel *label=[_selectcedCell viewWithTag:_selectcedCell.tag+100];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserModel *mod = app.userModel;
    _tagCell.textF_content.text=usertag.name;
    
    _userTag = usertag;
    mod.tags = [@[usertag] copy];
}

#pragma mark LYUserTagSelectedDelegate
/*
- (void)userTagSelected:(NSMutableArray *)usertags{
    NSString *tagids=@"";
    NSString *tagNames=@"";
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    UserModel *mod= app.userModel;
    for (UserTagModel *usertag in usertags) {

        if ([tagids isEqualToString:@""]) {
            tagids=[NSString stringWithFormat:@"%ld",usertag.id];
            tagNames=[NSString stringWithFormat:@"%@",usertag.name];
        }else{
            tagids=[NSString stringWithFormat:@"%@,%ld",tagids,usertag.id];
            tagNames=[NSString stringWithFormat:@"%@,%@",tagNames,usertag.name];
        }
        
    }
   
    
    mod.tags=[usertags copy];
    
    _tagCell.textF_content.text=tagNames;
    NSMutableDictionary *userinfo=[NSMutableDictionary new];
    [userinfo setObject:tagids forKey:@"tag"];
    [self savaUserInfo:userinfo needReload:NO];
}
*/

#pragma mark - 保存用户信息
-(void)savaUserInfo:(NSMutableDictionary *)userInfo needReload:(BOOL)isNeed{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;
    [userInfo setObject:[NSString stringWithFormat:@"%d",mod.userid] forKey:@"userid"];
    [[LYUserHttpTool shareInstance] saveUserInfo:[userInfo copy] complete:^(BOOL result) {
        if (result) {
            [MyUtil showMessage:@"修改成功！"];
            app.userModel.gender = [NSString stringWithFormat:@"%d",_sexCell.btn_man.tag == 3 ? 1 : 0];
            app.userModel.usernick = _nickCell.textF_content.text;
            app.userModel.birthday = _birthCell.textF_content.text;
            app.userModel.age = [MyUtil getAgefromDate:_birthCell.textF_content.text];
            NSLog(@"----->%@------%@-----%@----%@",app.userModel.gender,app.userModel.usernick,app.userModel.birthday,app.userModel.avatar_img);
            if (_chooseBirthDate) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *date = [dateFormatter stringFromDate:_chooseBirthDate];
                app.userModel.age=[MyUtil getAgefromDate:date];
            }
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
            
            if (isNeed) {
              //  [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark 选择头像
- (void)chooseImage{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    actionSheet.tag=255;
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
    
    // UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//原始图
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    _imageIcon = image;
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [_selectcedCell.btn_userImage setBackgroundImage:scaledImage forState:UIControlStateNormal];
    
    [HTTPController uploadImageToQiuNiu:scaledImage complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        _keyStr = key;
        if (![MyUtil isEmptyString:key]) {
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            UserModel *mod= app.userModel;
            mod.avatar_img=[MyUtil getQiniuUrl:key width:80 andHeight:80];
            
            NSMutableDictionary *userinfo=[NSMutableDictionary new];
            
            [userinfo setObject:key forKey:@"avatar_img"];
            
           
        }
    }];
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark LPAlertViewDelegate
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenTime:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        _chooseBirthDate = ((TimePickerView *)alertView.contentView).timePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _birthCell.textF_content.text = [formatter stringFromDate:_chooseBirthDate];
    }
}


-(void)sureClick{
    
//    if (customType==0) {
//        NSDate *select  = [_datePicker date];
    if (!_nickCell.textF_content.text.length) {
        [MyUtil showMessage:@"昵称不能为空"];
        [_nickCell.textF_content endEditing:NO];
        return;
    }else if(_nickCell.textF_content.text.length >= 12){
        [MyUtil showMessage:@"昵称不能超过八个字符"];
        [_nickCell.textF_content endEditing:NO];
        return;
    }
    
    
    
    NSMutableDictionary *userinfo=[NSMutableDictionary new];
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [dateFormatter stringFromDate:_chooseBirthDate];
    if (date){
    [userinfo setObject:date forKey:@"birthday"];
    }else{
        [MyUtil showMessage:@"请选择生日"];
        return;
    }
    
    [userinfo setObject:_nickCell.textF_content.text forKey:@"usernick"];
    
    NSNumber *sexNum;
    if (_sexCell.btn_man.tag == 3) {
        sexNum = @(1);
    }else if(_sexCell.btn_women.tag == 3){
        sexNum = @(0);
    }else{
        [MyUtil showMessage:@"请选择性别"];
        return;
    }
    
    if([MyUtil isEmptyString:_userTag.name]){
        [MyUtil showMessage:@"请选择标签"];
        return;
    }
    if(_keyStr == nil) [userinfo setObject:_userM.avatar_img forKey:@"avatar_img"];
    
    if(_selectcedCell.btn_userImage.currentBackgroundImage == nil){
        [MyUtil showMessage:@"请选择头像"];
        
        return;
    }
    
    [userinfo setObject:[NSString stringWithFormat:@"%@",sexNum] forKey:@"gender"];
    
    [userinfo setObject:[NSString stringWithFormat:@"%ld",_userTag.id] forKey:@"tag"];
    NSLog(@"-----%@---->%@",_userTag.tagname,userinfo);
    
    [self savaUserInfo:userinfo needReload:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

   
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
