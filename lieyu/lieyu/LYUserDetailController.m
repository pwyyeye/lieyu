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
@interface LYUserDetailController ()

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
    _datePicker.datePickerMode=UIDatePickerModeDate;
    NSLocale *local=[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale=local;

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
    label.tag=200+indexPath.row;
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=RGB(51, 51, 51);
    label.textAlignment=NSTextAlignmentRight;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;
    if (indexPath.row==0) {
       
        UIImageView *headerImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 50, 50)];
        headerImage.contentMode = UIViewContentModeScaleAspectFit;
        headerImage.layer.masksToBounds=YES;
        headerImage.layer.cornerRadius=25;
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
            NSDate *birthday=[MyUtil getDateFromString:mod.birthday];
            [_datePicker setDate:birthday animated:NO];
        }else{
            [_datePicker setDate:[NSDate date] animated:NO];
        }
        
    }else if(indexPath.row==4){
        NSArray *tags=mod.tags;
        NSString *tagname=@"";
        if (tags.count==0) {
            tagname=@"选择适合自己的标签";
        }else{
            for (NSDictionary *tag in tags) {
                if ([tagname isEqualToString:@""]) {
                    tagname= [NSString stringWithFormat:@"%@",[tag objectForKey:@"tagname"]];
                }else{
                    tagname= [NSString stringWithFormat:@"%@,%@",tagname,[tag objectForKey:@"tagname"]];
                }
                
            }
        }
        label.text=tagname;
        
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
        
        text1.text=[USER_DEFAULT objectForKey:@"user_nick"];
        text1.keyboardType = UIKeyboardTypeDefault;
        
        [alert show];
    }else if(indexPath.row==2){
//        [self showAlertView];
    }else if(indexPath.row==3){
        [self showAlertView];
    }
    
    
    
}

-(void)showAlertView{
    if (_alertView!=nil) {
        [_alertView removeFromSuperview];
        _alertView=nil;
    }
    _alertView=[[LYAlert alloc] initWithType:LYAlertTypeDefault];
    _alertView.delegate=self;
    [self.view addSubview:_alertView];
    
    [_alertView.showView addSubview:_datePicker];
    [_alertView show];
    

}

-(void)button_cancel{
    [_alertView removeFromSuperview];
    _alertView=nil;
    return;
    
}

-(void)button_ok{
    NSDate *select  = [_datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:select];
    NSLog(@"----pass-pass%@---",date);
    [_alertView removeFromSuperview];
    _alertView=nil;
    UILabel *label=[_selectcedCell viewWithTag:_selectcedCell.tag+100];
    label.text=date;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UITextField *tf=[alertView textFieldAtIndex:0];
    
    if ([MyUtil isEmptyString:tf.text] || [tf.text isEqualToString:[USER_DEFAULT objectForKey:@"user_nick"]]) {
        return;
    }
    
    NSLog(@"----pass-pass%@---",tf.text);
    _modifyNick=tf.text;
    
//    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_modifyUserNick withType:POSTURL withPam:@{@"user_nick":tf.text} withUrlName:@"modifyNick"];
//    httpController.delegate = self;
//    
//    [httpController onSearchForPostJson];
    
    
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
    
    UIGraphicsBeginImageContext(CGSizeMake(120, 120));  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, 120, 120)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *imageView= (UIImageView *)[_selectcedCell viewWithTag:888];
    imageView.image=scaledImage ;
    
    
//    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_modifyUserAvatar withType:POSTURL withPam:nil withUrlName:@"modifyAvata"];
//    httpController.delegate = self;
//    
//    [httpController onFileForPostJson:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:UIImagePNGRepresentation(scaledImage) name:@"avatar_img" fileName:@"avatar_img.png" mimeType:@"image/png"];
//    } error:nil];
    
    
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
