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
#import "TimePickerView.h"
#import "LYTagTableViewController.h"

@interface LYUserDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LPAlertViewDelegate>
{
    LYUserDetailCameraTableViewCell *_selectcedCell;
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
    self.title=@"填写完整人信息";
    [self setSeparator];//设置tableView分割线
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
    if (!indexPath.row) {//头像
        _selectcedCell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailCameraTableViewCell" forIndexPath:indexPath];
        [_selectcedCell.btn_userImage addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
        return _selectcedCell;
    }else if(indexPath.row == 1){//昵称
        cell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailTableViewCell" forIndexPath:indexPath];
        if (cell) {
            LYUserDetailTableViewCell *detailCell = (LYUserDetailTableViewCell *)cell;
            detailCell.image_arrow.hidden = YES;
        }
    }else if(indexPath.row == 2){//性别
        cell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailSexTableViewCell" forIndexPath:indexPath];
        
        
    }else if(indexPath.row == 3){//生日
        cell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailTableViewCell" forIndexPath:indexPath];
        if (cell) {
            LYUserDetailTableViewCell *detailCell = (LYUserDetailTableViewCell *)cell;
            detailCell.label_title.text = @"生日";
            detailCell.textF_content.enabled = NO;
            detailCell.textF_content.text = @"选择生日";
        }
    }else if(indexPath.row == 4){//身份
        cell = [tableView dequeueReusableCellWithIdentifier:@"LYUserDetailTableViewCell" forIndexPath:indexPath];
        if (cell) {
            LYUserDetailTableViewCell *detailCell = (LYUserDetailTableViewCell *)cell;
            detailCell.label_title.text = @"标签";
            detailCell.textF_content.enabled = NO;
            detailCell.textF_content.text = @"选择标签";
        }
    }else {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 47, 300, 52)];
        sureBtn.backgroundColor = [UIColor redColor];
        [cell addSubview:sureBtn];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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


#pragma mark - 保存用户信息
-(void)savaUserInfo:(NSMutableDictionary *)userInfo needReload:(BOOL)isNeed{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UserModel *mod= app.userModel;
    [userInfo setObject:[NSString stringWithFormat:@"%d",mod.userid] forKey:@"userid"];
    [[LYUserHttpTool shareInstance] saveUserInfo:[userInfo copy] complete:^(BOOL result) {
        if (result) {
            [MyUtil showMessage:@"修改成功！"];
            if (isNeed) {
                [self.tableView reloadData];
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
    
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [_selectcedCell.btn_userImage setBackgroundImage:scaledImage forState:UIControlStateNormal];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {//选择生日
        LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消",@"确定",nil];
        
        TimePickerView *timeView = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerView" owner:nil options:nil] firstObject];
        timeView.tag = 11;
        timeView.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200);
        alertView.contentView = timeView;
        [alertView show];
    }else if (indexPath.row == 4){
        //标签
        LYTagTableViewController *tagVC = [[LYTagTableViewController alloc]init];
        [self.navigationController pushViewController:tagVC animated:YES];
    }
}

#pragma mark LPAlertViewDelegate
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenTime:(NSInteger)buttonIndex{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
