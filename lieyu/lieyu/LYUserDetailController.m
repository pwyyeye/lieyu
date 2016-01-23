//
//  LYUserDetailController.m
//  lieyu
//
//  Created by pwy on 15/10/27.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserDetailController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UserModel.h"
#import "LYTagsViewController.h"
#import "LYUserHttpTool.h"

@interface LYUserDetailController ()<LYTagsViewControllerDelegate>{
    NSString *_tagString;
}

@end

@implementation LYUserDetailController{
    NSArray *data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor=RGB(237, 237, 237);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
    
    self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线
    self.title=@"个人信息";
    data=@[@"头像",@"昵称",@"性别",@"生日",@"标签"];
    _datePicker=[[UIDatePicker alloc] init];
    _datePicker.center = CGPointMake(SCREEN_WIDTH/2.f,_datePicker.center.y);
    _datePicker.datePickerMode=UIDatePickerModeDate;
    NSLocale *local=[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale=local;
    [_datePicker setMaximumDate:[NSDate date]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
            if (isNeed) {
                [self.tableView reloadData];
            }
            
        }
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-165, indexPath.row==0?25:10, 130, 30)];
    label.font=[UIFont systemFontOfSize:13.0];
//    label.text=data[indexPath.row];
    cell.textLabel.text=data[indexPath.row];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:13.0];
    label.tag=200+indexPath.row;
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=RGB(51, 51, 51);
    label.textAlignment=NSTextAlignmentRight;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;
    if (indexPath.row==0) {
       
        UIImageView *headerImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 5, 40, 40)];
        headerImage.contentMode = UIViewContentModeScaleAspectFit;
        headerImage.layer.masksToBounds=YES;
        headerImage.layer.cornerRadius=20;
        headerImage.tag=888;
        [cell addSubview:headerImage];
        NSURL *url=[NSURL URLWithString:mod.avatar_img];
        [headerImage setImageWithURL:url placeholderImage:[UIImage imageNamed:mod.gender.intValue==1?@"lieyu_default_male":@"lieyu_default_female"]];
        
        
    }else if(indexPath.row==1){
        
        label.text=mod.usernick;
        
    }else if(indexPath.row==2){
        label.text=mod.gender.intValue==1?@"男":@"女";
 
    }else if(indexPath.row==3){
        label.text=mod.birthday;
        if (![MyUtil isEmptyString:mod.birthday]) {
            
            NSDate *birthday;
            if (![mod.birthday isEqualToString:@"1990-04-15"]) {
                birthday=[MyUtil getDateFromString:mod.birthday];
            }else{
                birthday=[MyUtil getFullDateFromString:[NSString stringWithFormat:@"%@ 1:00:00",mod.birthday] ];
            }
            [_datePicker setDate:birthday animated:NO];
        }else{
            [_datePicker setDate:[NSDate date] animated:NO];
        }
        
    }else if(indexPath.row==4){
        NSArray *tags=mod.tags;

//        if (tags.count==0) {
//            tagname=@"选择适合自己的标签";
//        }else{
//            for (UserTagModel *tag in tags) {
//                if ([tagname isEqualToString:@""]) {
//                    tagname= [NSString stringWithFormat:@"%@",[MyUtil isEmptyString:tag.name]?tag.tagname:tag.name];
//                }else{
//                    tagname= [NSString stringWithFormat:@"%@,%@",tagname,[MyUtil isEmptyString:tag.name]?tag.tagname:tag.name];
//                }
//                
//            }
//        }
        NSMutableString *mytags=[[NSMutableString alloc] init];
        for (UserTagModel *tag in tags) {
            if (![MyUtil isEmptyString:tag.tagname]){
                if ([tag isEqual:tags.lastObject]) {
                    [mytags appendString:tag.tagname];
                }else{
                    [mytags appendString:tag.tagname];
                    [mytags appendString:@","];
                }
            }else if(![MyUtil isEmptyString:tag.name]){
                if ([tag isEqual:tags.lastObject]) {
                    [mytags appendString:tag.name];
                }else{
                    [mytags appendString:tag.name];
                    [mytags appendString:@","];
                }
            }
            
            
            
        }
        label.text = mytags;
        _tagString = mytags;
    }
    
    cell.tag=100+indexPath.row;
    [cell.contentView addSubview:label];
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.frame=CGRectMake(0,49.5,SCREEN_WIDTH,1);
    layerShadow.borderColor=[RGB(237, 237, 237) CGColor];
    layerShadow.borderWidth=0.5;
    [cell.layer addSublayer:layerShadow];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    
    return cell;
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectcedCell=[tableView viewWithTag:100+indexPath.row];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;
    if (indexPath.row==0) {
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
        actionSheet.tag=255;
        
        [actionSheet showInView:self.view];
        
        
        
        //        _selectedLabel=_selectcedCell.textLabel;//[_selectcedCell.contentView viewWithTag:200+indexPath.item];
        
    }else if(indexPath.row==1){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"修改昵称"
                               
                                                        message:@""
                               
                                                       delegate:self
                               
                                              cancelButtonTitle:@"取消"
                               
                                              otherButtonTitles:@"确定",nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        UITextField * text1 = [alert textFieldAtIndex:0];
        
        text1.text=mod.usernick;
        text1.keyboardType = UIKeyboardTypeDefault;
        
        [alert show];
    }else if(indexPath.row==2){
        [self showAlertViewForSex];
    }else if(indexPath.row==3){
        [self showAlertView];
    }else if (indexPath.row==4){
        
        LYTagsViewController *taglist=[[LYTagsViewController alloc] init];
        taglist.delegate=self;
//        //登录反馈的 id为tagid name 为tagname
//        for (UserTagModel *tag in mod.tags) {
//            if (tag.id==0) {
//                tag.id=tag.tagid;
//            }
//            if ([MyUtil isEmptyString:tag.name]) {
//                tag.name=tag.tagname;
//            }
//            
//        }
//        taglist.selectedArray=mod.tags;
        taglist.selectedTag = _tagString;
        [self.navigationController pushViewController:taglist animated:YES];
    }
}

-(void)userTagSelected:(UserTagModel *)usertag{
//    NSString *tagids=@"";
//    NSString *tagNames=@"";
//    for (UserTagModel *usertag in usertags) {
//        if ([tagids isEqualToString:@""]) {
//            tagids=[NSString stringWithFormat:@"%ld",usertag.id];
//            tagNames=[NSString stringWithFormat:@"%@",usertag.name];
//        }else{
//            tagids=[NSString stringWithFormat:@"%@,%ld",tagids,usertag.id];
//            tagNames=[NSString stringWithFormat:@"%@,%@",tagNames,usertag.name];
//        }
//    }
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    UserModel *mod= app.userModel;
//    
//    mod.tags=[usertags copy];
//    
//    UILabel *label=[_selectcedCell viewWithTag:_selectcedCell.tag+100];
//    label.text=tagNames;
//    
//    NSMutableDictionary *userinfo=[NSMutableDictionary new];
//    [userinfo setObject:tagids forKey:@"tag"];

    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        UserModel *mod= app.userModel;
        UILabel *label=[_selectcedCell viewWithTag:_selectcedCell.tag+100];
        label.text=usertag.name;
    
        NSMutableDictionary *userinfo=[NSMutableDictionary new];
        [userinfo setObject:[NSString stringWithFormat:@"%ld",usertag.id] forKey:@"tag"];
    mod.tags = [@[usertag] copy];
    [self savaUserInfo:userinfo needReload:YES];
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

-(void)showAlertViewForSex{
    if (_alertView!=nil) {
        [_alertView removeFromSuperview];
        _alertView=nil;
    }
    _alertView=[[LYAlert alloc] initWithType:LYAlertTypeDefault];
    _alertView.delegate=self;
    _alertView.customType=1;
    _alertView.shade_proportion=0.7;
    [self.view addSubview:_alertView];
    
    CGFloat maleWidth = 60;
    LYUserTagButton *male=[[LYUserTagButton alloc] initWithFrame:CGRectMake(60, 30, maleWidth, 35)];
    [male setTitle:@"男" forState:UIControlStateNormal];
    male.delegate=self;
    male.tag=2001;
    
    
    LYUserTagButton *fmale=[[LYUserTagButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 30, maleWidth, 35)];
    [fmale setTitle:@"女" forState:UIControlStateNormal];
    fmale.delegate=self;
    fmale.tag=2000;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;
    if (mod.gender.intValue==1) {
        male.selected=YES;
        fmale.selected=NO;
    }else{
        fmale.selected=YES;
        male.selected=NO;
    }
    _sex=mod.gender.intValue;
    
    [_alertView.showView addSubview:male];
    
    [_alertView.showView addSubview:fmale];
    
    
    [_alertView show];
    
    
}
-(void)chooseButton:(UIButton *)sender andSelected:(BOOL)isSelected{
    if (isSelected) {
        if (sender.tag==2000) {
            _sex=0;
           LYUserTagButton *male= (LYUserTagButton *)[_alertView viewWithTag:2001];
            male.selected=NO;
        }else if (sender.tag==2001) {
            _sex=1;
            LYUserTagButton *fmale= (LYUserTagButton *)[_alertView viewWithTag:2000];
            fmale.selected=NO;
        }
    }

}

-(void)button_cancel{
    [_alertView removeFromSuperview];
    _alertView=nil;
    return;
    
}
#pragma mark - 修改生日 / 性别
-(void)button_ok:(NSInteger) customType{
    [_alertView removeFromSuperview];
    _alertView=nil;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;
    
    if (customType==0) {
        NSDate *select  = [_datePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [dateFormatter stringFromDate:select];
        
        if ([date isEqualToString:mod.birthday]) {
            return;
        }
        UILabel *label=[_selectcedCell viewWithTag:_selectcedCell.tag+100];
        label.text=date;
        mod.birthday=date;
        NSMutableDictionary *userinfo=[NSMutableDictionary new];
        [userinfo setObject:date forKey:@"birthday"];
        [self savaUserInfo:userinfo needReload:YES];
    }else if(customType==1){
        mod.gender=[NSString stringWithFormat:@"%ld",_sex];
        NSMutableDictionary *userinfo=[NSMutableDictionary new];
        [userinfo setObject:[NSString stringWithFormat:@"%ld",_sex] forKey:@"gender"];
        [self savaUserInfo:userinfo needReload:YES];
    }
    
    
}
#pragma mark -  修改昵称
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UITextField *tf=[alertView textFieldAtIndex:0];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;
    if ([MyUtil isEmptyString:tf.text] || [tf.text isEqualToString:mod.usernick]) {
        return;
    }
    
    if(tf.text.length > 8) {
        [MyUtil showCleanMessage:@"昵称不能超过八个汉字"];
        return;
    }
    
    NSLog(@"----pass-pass%@---",tf.text);
    _modifyNick=tf.text;
    
    NSMutableDictionary *userinfo=[NSMutableDictionary new];
    [userinfo setObject:_modifyNick forKey:@"usernick"];
    mod.usernick=_modifyNick;
    [self savaUserInfo:userinfo needReload:YES];
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    // UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//原始图
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *imageView= (UIImageView *)[_selectcedCell viewWithTag:888];
    imageView.image=scaledImage ;
    
    [HTTPController uploadImageToQiuNiu:scaledImage complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (![MyUtil isEmptyString:key]) {
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            UserModel *mod= app.userModel;
            mod.avatar_img=[MyUtil getQiniuUrl:key width:80 andHeight:80];
  
            NSMutableDictionary *userinfo=[NSMutableDictionary new];
            
            [userinfo setObject:key forKey:@"avatar_img"];
            
            [self savaUserInfo:userinfo needReload:YES];
        }
    }];

    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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




@end
