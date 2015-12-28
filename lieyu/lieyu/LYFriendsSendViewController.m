//
//  LYFriendsSendViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsSendViewController.h"

@interface LYFriendsSendViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableArray *_imageArray;
}
@property (weak, nonatomic) IBOutlet UIButton *btnArray;

@end

@implementation LYFriendsSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupAllProperty];
    
    
}

- (void)setupAllProperty{
    _imageArray = [[NSMutableArray alloc]init];
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 34, 10, 24, 24)];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"daohang_fabu"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendClick{
    
}

- (IBAction)selectImageClick:(UIButton *)sender {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.editing = YES;
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate,UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [_imageArray addObject:image];
//    for (int i = 0; i < ; <#increment#>) {
//        <#statements#>
//    }
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
