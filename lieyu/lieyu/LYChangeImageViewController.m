 //
//  LYChangeImageViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYChangeImageViewController.h"
#import "LYFriendsViewController.h"
#import "HttpController.h"
#import "LYFriendsHttpTool.h"

@interface LYChangeImageViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYChangeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.title = @"选择更该方式";
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"从手机相册选择";
        }
            break;
            case 1:
        {
            cell.textLabel.text = @"拍一张";
        }
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImagePickerController *pickerCtl = [[UIImagePickerController alloc]init];
    pickerCtl.allowsEditing = YES;
    pickerCtl.delegate = self;
    switch (indexPath.row) {
        case 0:
        {
           
            pickerCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
            
        case 1:
        {
           if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            pickerCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
           else pickerCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    [self presentViewController:pickerCtl animated:YES completion:^{

    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
//        for (UIViewController *vc in self.navigationController.viewControllers) {
//            if ([vc isKindOfClass:[LYFriendsViewController class]]) {
//                [self.navigationController popToViewController:vc animated:YES];
//            }
//        }
        
        [HTTPController uploadImageToQiuNiu:image complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *userIdStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
            NSDictionary *paraDic = @{@"userId":userIdStr,@"friends_img":key};
            [LYFriendsHttpTool friendsChangeBGImageWithParams:paraDic compelte:^(bool result) {
                if (result) {
                    [self.navigationController popViewControllerAnimated:YES];
                    _passImage(key,image);
                }
            }];
        }];
    }];
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

@end
