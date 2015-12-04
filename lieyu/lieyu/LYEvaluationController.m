//
//  LYEvaluationController.m
//  lieyu
//
//  Created by pwy on 15/12/3.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYEvaluationController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "HTTPController.h"
@interface LYEvaluationController ()

@end

@implementation LYEvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"评价";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _contentText.delegate=self;
    
    [_barImageView setImageWithURL:[NSURL URLWithString:_orderInfoModel.barinfo.baricon] placeholderImage:[UIImage imageNamed:@"emptyImage"]];
    _barNameText.text=_orderInfoModel.barinfo.barname;
    _managerNameText.text=_orderInfoModel.checkUserName;
    [_managerAvatar_img setImageWithURL:[NSURL URLWithString:_orderInfoModel.checkUserAvatar_img ] placeholderImage:[UIImage imageNamed:@"emptyImage"]];
    _submitButton.frame=CGRectMake(10, SCREEN_HEIGHT-50-64, SCREEN_WIDTH-20, 40);
    _isPickImage=NO;
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

- (IBAction)getPicture:(id)sender {
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    
    actionSheet.tag=255;
    
    [actionSheet showInView:self.view];
}
#pragma mark --评价
- (IBAction)pingjia:(id)sender {
    if (_isPickImage) {
        [HTTPController uploadImageToQiuNiu:_pingjiaImage.image complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            NSLog(@"----pass-评价图片上传%@---",key);
        }];
    }else{
    
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"爱他就给他一个好评。(140字以内)"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"爱他就给他一个好评。(140字以内)";
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    // UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//原始图
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(400, 400));  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, 400, 400)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
 
    _pingjiaImage.image=scaledImage ;
    
    _isPickImage=YES;
//    
    
    
    
    
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
