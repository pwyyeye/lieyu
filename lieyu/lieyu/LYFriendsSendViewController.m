//
//  LYFriendsSendViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsSendViewController.h"
#import "LYFriendsHttpTool.h"
#import <CoreLocation/CoreLocation.h>
#import "HTTPController.h"
#import <AVFoundation/AVFoundation.h>
#import <Reachability.h>
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "ImagePickerViewController.h"

#define IMGwidth ( [UIScreen mainScreen].bounds.size.width - 20 ) / 3

@interface LYFriendsSendViewController ()<UIImagePickerControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,ImagePickerFinish>
{
    int qiniuPages;
    AppDelegate *app;
    
    NSString *_mp4Quality;
    NSString *_mp4Path;
    
    UIImage *mediaImage;
    
    BOOL isntFirstEdit;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
//@property (nonatomic, strong) NSMutableArray *shangchuanArray;
@property (nonatomic, strong) NSMutableString *shangchuanString;
@property (nonatomic, strong) NSMutableString *city;
@property (nonatomic, strong) NSMutableString *location;
@property (nonatomic, assign) BOOL notFirstOpen;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) NSMutableArray *keysArray;

@property (nonatomic, strong) NSString *content;

@property (nonatomic,strong) IQKeyboardReturnKeyHandler *returnHandler;

@end

@implementation LYFriendsSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllProperty];
//    self.TopicTitle = @"#今晚吃什么#";
    self.pageCount = 4;
    self.initCount = 0;
    
    self.fodderArray = [[NSMutableArray alloc]init];
    self.imageViewArray = [[NSMutableArray alloc]init];
    self.shangchuanString = [[NSMutableString alloc]init];
    self.location = [[NSMutableString alloc]init];
    self.city = [[NSMutableString alloc]init];
    self.keysArray = [[NSMutableArray alloc]init];
    
    [IQKeyboardManager sharedManager].enable = NO;
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self.textView setReturnKeyType:UIReturnKeyDone];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.title = @"发布动态";
    self.textView.delegate = self;

    if(self.TopicTitle.length){
        self.textView.text = self.TopicTitle;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willexitfull) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterfull) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    if ([self.textView isFirstResponder] && [touch view] != self.textView) {
//        [self.textView resignFirstResponder];
//    }
//    [super touchesBegan:touches withEvent:event];
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FriendSendViewDidLoad" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FriendSendViewDidLoad" object:nil];
}

//退出程序以后删除tmp文件中所有内容
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
//    [self deleteFile:@""];
}

- (void)setupAllProperty{
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"daohang_fabu"] style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"发送" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)textViewDidChange:(UITextView *)textView{
    if(textView == self.textView){
        if(self.textView.text.length >= 800){
            self.textView.text = [self.textView.text substringToIndex:800];
        }else{
            self.label.text = [NSString stringWithFormat:@"%lu/800",self.textView.text.length];
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [self.textView resignFirstResponder];
        return NO;
    }else if ([text isEqualToString:@"#"] && range.location == 0 && range.length == 0){
        //每一次侦察，textview中第一个字符是＃
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"#" message:@"#" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
        alertview.tag = 100;
        [alertview show];
    }
    return YES;
}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (!isntFirstEdit) {
        self.textView.text = @"";
        isntFirstEdit = YES;
    }
//    if([self.textView.text isEqualToString:@"说点这个时刻的感受吧!"]){
//        if (self.TopicTitle.length) {
//            if ([self.textView.text isEqualToString:self.TopicTitle]) {
//                self.textView.text = @"";
//            }
//        }else{
//            self.textView.text = @"";
//        }
////        [self.textView setKeyboardAppearance:UIKeyboardAppearanceAlert];
//    }
    [self.textView becomeFirstResponder];
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    self.returnHandler = [[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
//    self.returnHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

#pragma mark 判断是否退出本次编辑
- (void)gotoBack{
    if([self.textView isFirstResponder]){
        [self.textView resignFirstResponder];
    }
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定放弃本次编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSLog(@"#");
        }
    }else{
        if([self.textView isFirstResponder]){
            [self.textView resignFirstResponder];
        }
        if(buttonIndex == 1){
            //退出编辑界面之后删除视频文件
            [self deleteFile:self.mediaUrl];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 上传玩友圈,待修改
- (void)sendClick{
    if([self.textView isFirstResponder]){
        [self.textView resignFirstResponder];
    }
    if(self.textView.text.length >= 800){
        [MyUtil showCleanMessage:@"内容过长，限800字！"];
        return;
    }
//    [app startLoading];
    //上传视频或者图片到七牛
    if(_isVedio){
        if([self.mediaUrl isEqualToString:@""]){
            [self showMessage:@"请添加照片或视频，把美好分享！"];
            [app stopLoading];
            return;
        }
        //点击发布按钮之后回到朋友圈页面并且传视频与截图给朋友圈页面
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        if(self.delegate){
            
            if([self.textView.text isEqualToString:@"说点这个时刻的感受吧!"]){
                self.content = @"";
            }else{
                self.content = [[NSString alloc]initWithString:self.textView.text];
            }
            //地址返回
            NSString *location = ([self.locationBtn.titleLabel.text isEqualToString:@"选择位置"] || [self.locationBtn.titleLabel.text isEqualToString:@"不显示位置"]) ? @"" : self.locationBtn.titleLabel.text;
            [self.delegate sendVedio:self.mediaUrl andImage:mediaImage andContent:self.content andLocation:location];
        }
        
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.mediaUrl] options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        int status = [MyUtil configureNetworkConnect];
        if(status == 1){
            //数据流量
            _mp4Quality = AVAssetExportPresetMediumQuality;
        }else if(status == 2){
            //wifi
            _mp4Quality = AVAssetExportPresetHighestQuality;
        }else{
            [MyUtil showCleanMessage:@"无网络链接！"];
            return;
        }
        if([compatiblePresets containsObject:_mp4Quality]){
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:_mp4Quality];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
            //将压缩得到的视频文件暂时保存在沙盒中，以时间命名，防止重复
            _mp4Path = [NSString stringWithFormat:@"%@/%@.mp4",
                       [NSHomeDirectory() stringByAppendingString:@"/tmp"],
                       [formatter stringFromDate:[NSDate date]]];
            exportSession.outputURL = [NSURL fileURLWithPath:_mp4Path];
            exportSession.outputFileType = AVFileTypeMPEG4;
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                switch (exportSession.status) {
                    case AVAssetExportSessionStatusCompleted:
//                        [MyUtil showCleanMessage:@"视频压缩成功！"];
                        //将新的视频地址赋给 mediaUrl
                        self.mediaUrl = [[NSMutableString alloc]initWithString:_mp4Path];
                        [self sendFilesToQiniu];
                        break;
                    case AVAssetExportSessionStatusFailed:
                        [MyUtil showCleanMessage:@"视频上传失败！"];
                        break;
                    default:
                        break;
                }
            }];
        }
        
    }else{
        if(self.fodderArray.count <= 0){
            [self showMessage:@"请添加照片或视频，把美好分享！"];
            [app stopLoading];
            return;
        }
        //点击发布按钮后将图片数组返回
        [self.navigationController popViewControllerAnimated:YES];
        if([self.textView.text isEqualToString:@"说点这个时刻的感受吧!"]){
            self.content = @"";
        }else{
            self.content = [[NSString alloc]initWithString:self.textView.text];
        }
        //地址返回
        NSString *location = ([self.locationBtn.titleLabel.text isEqualToString:@"选择位置"] || [self.locationBtn.titleLabel.text isEqualToString:@"不显示位置"]) ? @"" : self.locationBtn.titleLabel.text;
        [self.delegate sendImagesArray:self.fodderArray andContent:self.content andLocation:location];
        if([self.textView isFirstResponder]){
            [self.textView resignFirstResponder];
        }
        
        __weak __typeof(self) weakSelf = self;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            __block NSString *firstString;
            __block NSString *secondString;
            __block NSString *thirdString;
            __block NSString *forthString;
            dispatch_group_t group = dispatch_group_create();
            for (int i = 0; i < (int)weakSelf.fodderArray.count; i ++) {
                dispatch_group_async(group, queue, ^{
                    [HTTPController uploadImageToQiuNiu:[self.fodderArray objectAtIndex:i] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                        if(![MyUtil isEmptyString:key]){
                            //上传成功
                            qiniuPages ++;
                            if (i == 0) {
                                firstString = key;
//                                [self.shangchuanString appendString:key];
//                                [self.shangchuanString appendString:@","];//字符串拼接
                            }else if(i == 1){
                                secondString = key;
//                                [self.shangchuanString appendString:key];
//                                [self.shangchuanString appendString:@","];//字符串拼接
                            }else if (i == 2){
                                thirdString = key;
//                                [self.shangchuanString appendString:key];
//                                [self.shangchuanString appendString:@","];//字符串拼接
                            }else{
                                forthString = key;
//                                [self.shangchuanString appendString:key];
//                                [self.shangchuanString appendString:@","];//字符串拼接
                            }
                            if (qiniuPages == weakSelf.fodderArray.count) {
                                dispatch_group_notify(group, queue, ^{
                                    switch (weakSelf.fodderArray.count) {
                                        case 1:
                                            [weakSelf.shangchuanString appendString:firstString];
                                            break;
                                        
                                        case 2:
                                            [weakSelf.shangchuanString appendString:firstString];
                                            [weakSelf.shangchuanString appendString:@","];
                                            [weakSelf.shangchuanString appendString:secondString];
                                            break;
                                        case 3:
                                            [weakSelf.shangchuanString appendString:firstString];
                                            [weakSelf.shangchuanString appendString:@","];
                                            [weakSelf.shangchuanString appendString:secondString];
                                            [weakSelf.shangchuanString appendString:@","];
                                            [weakSelf.shangchuanString appendString:thirdString];
                                            break;
                                        case 4:
                                            [weakSelf.shangchuanString appendString:firstString];
                                            [weakSelf.shangchuanString appendString:@","];
                                            [weakSelf.shangchuanString appendString:secondString];
                                            [weakSelf.shangchuanString appendString:@","];
                                            [weakSelf.shangchuanString appendString:thirdString];
                                            [weakSelf.shangchuanString appendString:@","];
                                            [weakSelf.shangchuanString appendString:forthString];
                                            break;
                                        default:
                                            break;
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [weakSelf sendTrends:self.shangchuanString];
                                    });
                                });
                            }
                        }
                    }];
                });
            }
            
        });
        
        
        
//        //用异步串行队列进行图片的上传
////        dispatch_queue_t queue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);
//        for (int i = (int)self.fodderArray.count - 1; i >= 0 ; i --) {
//            dispatch_async(queue, ^{
//                [HTTPController uploadImageToQiuNiu:[self.fodderArray objectAtIndex:i] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                    if(![MyUtil isEmptyString:key]){//上传成功
//                        qiniuPages ++;
//                        [self.keysArray addObject:key];
//                        [self.shangchuanString appendString:key];
//                        [self.shangchuanString appendString:@","];//字符串拼接
//                        if(qiniuPages == self.fodderArray.count){
//                            [self.shangchuanString deleteCharactersInRange:NSMakeRange([self.shangchuanString length]-1, 1)];
//                            [self sendTrends:self.shangchuanString];
//                        }
//                    }else{
//                        
//                    }
//                }];
//            });
//        }
        
        
//        for(int i = (int)self.fodderArray.count - 1 ; i >= 0; i --){
//            [HTTPController uploadImageToQiuNiu:[self.fodderArray objectAtIndex:i] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                if(![MyUtil isEmptyString:key]){
//                    qiniuPages ++;
//                    [self.keysArray addObject:key];
//                    [self.shangchuanString appendString:key];
//                    [self.shangchuanString appendString:@","];
//                    if(qiniuPages == self.fodderArray.count){
////                        [self.keysArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
////                            NSString *str1 = (NSString *)obj1;
////                            NSString *str2 = (NSString *)obj2;
////                            return [str1 compare:str2];
////                        }];
////                        NSLog(@"%@",self.keysArray);
//                        [self.shangchuanString deleteCharactersInRange:NSMakeRange([self.shangchuanString length]-1, 1)];
//                        [self sendTrends:self.shangchuanString];
//                    }
//                }else{
//                    
//                }
//            }];
//        }
    }
}


#pragma mark 上传文件到七牛
- (void)sendFilesToQiniu{
    __weak __typeof(self) weakSelf = self;
    [HTTPController uploadFileToQiuNiu:self.mediaUrl complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if(![MyUtil isEmptyString:key]){
            [weakSelf sendTrends:key];
        }else{
            [MyUtil showCleanMessage:@"上传失败！"];
        }
    }];
}

- (void)sendTrends:(NSString *)string{
    NSString *userIdStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
    NSDictionary *paraDic;
    if(_isVedio){
        paraDic = @{@"userId":userIdStr,@"city":self.city,@"location":self.location,@"type":@"0",@"message":self.content,@"attachType":@"1",@"attach":string};
    }else{
        paraDic = @{@"userId":userIdStr,@"city":self.city,@"location":self.location,@"type":@"0",@"message":self.content,@"attachType":@"0",@"attach":string};
    }
    __weak __typeof(self) weakSelf = self;
    [LYFriendsHttpTool friendsSendMessageWithParams:paraDic compelte:^(bool result, NSString *messageId) {
        if(result){
//            [MyUtil showCleanMessage:@"恭喜，发布成功!"];
            [weakSelf.delegate sendSucceed:messageId];
            //发布成功后删除该文件
            //            [self deleteFile:self.mediaUrl];
        }else{
            //            [app stopLoading];
            //            [self showMessage:@"抱歉，发布失败!"];
            [MyUtil showCleanMessage:@"抱歉，发布失败!"];
        }
    }];
}

- (void)deleteFile:(NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *pngDir = [NSHomeDirectory() stringByAppendingString:@"/tmp"];
    NSArray *contents = [manager contentsOfDirectoryAtPath:pngDir error:nil];
    NSLog(@"%@",contents);
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while (filename = [e nextObject]) {
        filename = [NSString stringWithFormat:@"/%@",filename];
        [manager removeItemAtPath:[pngDir stringByAppendingString:filename] error:nil];
    }
}


- (IBAction)selectImageClick:(UIButton *)sender {
    if([self.textView isFirstResponder]){
        [self.textView resignFirstResponder];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",@"短视频", nil];
    [actionSheet showInView:self.view];
}

#pragma mark 选择地址信息
- (IBAction)selectLocation:(UIButton *)sender{
    LYFriendsChooseLocationViewController *chooseLocationVC = [[LYFriendsChooseLocationViewController alloc]init];
    chooseLocationVC.delegate = self;
    [self.navigationController pushViewController:chooseLocationVC animated:YES];
}

#pragma mark delegate
- (void)getLocationInfo:(NSString *)city Location:(NSString *)location{
    if([city isEqualToString:@""]){
        [self.locationBtn setTitle:@"不显示位置" forState:UIControlStateNormal];
    }else{
        [self.locationBtn setTitle:location forState:UIControlStateNormal];
    }
    self.city = [[NSMutableString alloc]initWithString:city];
    self.location = [[NSMutableString alloc]initWithString:location];
}

#pragma mark actionsheet的代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){//拍照
        [self takePhotoActionClick];
    }else if(buttonIndex == 1){//相册
        [self photosActionClick];
    }else if(buttonIndex == 2){//段视频
        [self filmingActionClick];
    }
}

#pragma mark 点击三个按键的相应处理方法
- (void)photosActionClick{
    if(self.pageCount <= 0){
        [MyUtil showCleanMessage:@"抱歉，无法再添加照片"];
        return;//给出提示
    }
    ImagePickerViewController *imagePicker = [[ImagePickerViewController alloc]init];
    imagePicker.imagesCount = self.pageCount;
    imagePicker.delegate = self;
    [self.navigationController pushViewController:imagePicker animated:YES];
    
//    YBImgPickerViewController *ybImagePicker = [[YBImgPickerViewController alloc]init];
//    ybImagePicker.photoCount = self.pageCount;
//    [ybImagePicker showInViewContrller:self choosenNum:0 delegate:self];
}

- (void)takePhotoActionClick{
    if(self.pageCount <= 0){
        [MyUtil showCleanMessage:@"抱歉，无法再添加照片"];
        return;//给出提示
    }
    _typeOfImagePicker = @"takePhoto";
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)filmingActionClick{
    if(self.pageCount < 4){
        [MyUtil showCleanMessage:@"抱歉，无法再添加视频"];
        return;//给出提示
    }
    _typeOfImagePicker = @"filming";
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

#pragma mark imagepicker判断要做什么事情
- (UIImagePickerController *)imagePicker{
    _imagePicker = [[UIImagePickerController alloc]init];
    if([_typeOfImagePicker isEqualToString:@"photos"]){//选择照片
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//选择照片
    }else if([_typeOfImagePicker isEqualToString:@"takePhoto"]){//拍照
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//拍照
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置摄像头
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }else if([_typeOfImagePicker isEqualToString:@"filming"]){//小视频
        _imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//摄影
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置摄像头
        int status = [MyUtil configureNetworkConnect];
        if(status == 1){
            _imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        }else if(status == 2){
//            _imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            _imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
            
        }else{
            [MyUtil showCleanMessage:@"网络无连接！"];
            return nil;
        }
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式
        
        _imagePicker.videoMaximumDuration = 10;
    }
    _imagePicker.editing = YES;
    _imagePicker.delegate = self;
    return _imagePicker;
}

- (void)ImagePickerDidFinishWithImages:(NSArray *)imageArray{
    self.pageCount = self.pageCount - (int)imageArray.count;
    [self.fodderArray addObjectsFromArray:imageArray];
    //界面刷新，重新排版
    [app startLoading];
    [self interfaceLayout];
}

#pragma mark YB的代理方法
- (void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray{
    self.pageCount = self.pageCount - (int)imageArray.count;
    [self.fodderArray addObjectsFromArray:imageArray];
    //界面刷新，重新排版
    [app startLoading];
    [self interfaceLayout];
}

- (void)interfaceLayout{
    self.initCount = 0 ;
    for (UIImageView *imageView in self.imageViewArray) {
        [imageView removeFromSuperview];
    }
    self.addButton.frame = CGRectMake(10, self.addButton.frame.origin.y, 70, 70);
    for (int i = 0 ; i < self.fodderArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5 * (i % 4 ) + 12.5 + 70 * (i % 4), 180, 70, 70)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tapClick];
        [self.view addSubview:imageView];
        imageView.image = [self.fodderArray objectAtIndex:i];
        [self.imageViewArray addObject:imageView];
        self.initCount ++;
        self.addButton.frame = CGRectMake(self.addButton.frame.origin.x + 75, self.addButton.frame.origin.y, 70, 70);
        if(self.pageCount <= 0){
            self.addButton.hidden = YES;
        }else{
            self.addButton.hidden = NO;
        }
        if(_isVedio){
            imageView.frame = CGRectMake(10, 320, 200, 150);
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            button.center = imageView.center;
            [button setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            //            [imageView addSubview:button];
            button.tag = 301;
            [self.view addSubview:button];
            button.enabled = NO;
            imageView.tag = self.initCount + 100;
            //添加按钮消失时，textview面积增加
            self.addButton.hidden = YES;
            
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.bounds.size.width, self.textView.bounds.size.height + 80);
            NSLog(@"%@",NSStringFromCGRect(self.label.frame));
            self.label.frame = CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y + 80, self.label.frame.size.width, self.label.frame.size.height);
            NSLog(@"%@",NSStringFromCGRect(self.label.frame));
        }else{
            imageView.tag = self.initCount;
        }
    }
    [app stopLoading];
}

#pragma mark imagePickerController代理事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self imagePickerSpecificOperation:info];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark imagePickerController具体事件实现
- (void)imagePickerSpecificOperation:(NSDictionary<NSString *,id> *)info{
    
    [app startLoading];
    if ([_typeOfImagePicker isEqualToString:@"takePhoto"]) {//如果是拍照
        UIImage *image;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.imagePicker.allowsEditing) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        NSArray *imageArray = @[image];
        [self YBImagePickerDidFinishWithImages:imageArray];
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
    }else if([_typeOfImagePicker isEqualToString:@"filming"]){//如果是录制视频
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
////            保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
//            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
//        }
        
        [self didFinifhFilming:urlStr];
        
    }
}

- (void)didFinifhFilming:(NSString *)videoPath{
    self.mediaUrl = [[NSMutableString alloc]initWithString:videoPath];
    NSURL *url=[NSURL fileURLWithPath:self.mediaUrl];
    self.player = [[MPMoviePlayerController alloc]initWithContentURL:url];
    self.player.shouldAutoplay = NO;
    [self.player requestThumbnailImagesAtTimes:@[@0.1] timeOption:MPMovieTimeOptionExact];
}

#pragma mark 视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        //进行提示
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        //        NSLog(@"视频保存成功.");
        self.mediaUrl = [[NSMutableString alloc]initWithString:videoPath];
        NSURL *url=[NSURL fileURLWithPath:self.mediaUrl];
        self.player = [[MPMoviePlayerController alloc]initWithContentURL:url];
        self.player.shouldAutoplay = NO;
        [self.player requestThumbnailImagesAtTimes:@[@0.1] timeOption:MPMovieTimeOptionExact];
    }
}

#pragma mark 视频截屏后的方法
- (void)mediaPlayerThumbnailRequestFinished:(NSNotification *)notification{
//    NSLog(@"%@",notification.userInfo[MPMoviePlayerThumbnailImageKey]);
    mediaImage = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    NSArray *imageArray = @[mediaImage];
    _isVedio = YES;
    self.pageCount = 1;
    [self YBImagePickerDidFinishWithImages:imageArray];
}


#pragma mark tap手势相应动作
- (void)tapClick:(UITapGestureRecognizer *)sender{
    [self.navigationController.navigationBar setHidden:YES];
    if([self.textView isFirstResponder]){
        [self.textView resignFirstResponder];
    }
//    if(!_subView){
    self.view.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
        _subView = [[[NSBundle mainBundle]loadNibNamed:@"preview" owner:nil options:nil]firstObject];
        _subView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_subView.button addTarget:self action:@selector(imageSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSubView:)];
        [_subView addGestureRecognizer:tapgesture];
//    }
    if(sender.view.tag > 100){
        [_subView.imageView removeFromSuperview];
        if(_notFirstOpen){
//            _subView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        NSLog(@"%@",NSStringFromCGRect(_subView.frame));
        _player.view.frame = CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) / 2, SCREEN_WIDTH, SCREEN_WIDTH);
        _player.controlStyle =MPMovieControlStyleEmbedded;// MPMovieControlStyleFullscreen;
        _player.shouldAutoplay = YES;
        _player.repeatMode = NO;
        _player.scalingMode = MPMovieScalingModeAspectFit;
        [_subView addSubview:_player.view];
    
        self.subView.tag = 1;
        [self.view addSubview:_subView];
        [_player prepareToPlay];
    }else{
        _subView.image = ((UIImageView *)sender.view).image;
        _subView.tag = ((UIImageView *)sender.view).tag;
        [_subView viewConfigure];
        [self.view addSubview:_subView];
    }
}

- (void)willEnterfull{
//    self.subView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    _notFirstOpen = YES;
    NSLog(@"%@",NSStringFromCGRect(_subView.frame));
}

- (void)willexitfull{
    self.subView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.subView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    NSLog(@"%@",NSStringFromCGRect(self.subView.frame));
}

#pragma mark imageSelectClick:图片取消选择或重新选择
- (void)imageSelectClick:(UIButton *)sender{
    if(sender.selected == YES){
        [sender setImage:[UIImage imageNamed:@"imageUnselected"] forState:UIControlStateNormal];
        sender.selected = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"imageSelected"] forState:UIControlStateNormal];
        sender.selected = YES;
    }
}

#pragma mark 隐藏预览图层
- (void)hideSubView:(UITapGestureRecognizer *)sender{
    [self.navigationController.navigationBar setHidden:NO];
    
    NSLog(@"----pass-1>%@ ---",NSStringFromCGRect(self.view.frame));
    self.view.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    if(_subView.button.selected == NO){
        NSLog(@"delete %d picture",(int)_subView.tag);
        [self.fodderArray removeObjectAtIndex:_subView.tag - 1];
        if(_isVedio){
            self.pageCount = 3;
            [_player stop];
            [_player.view removeFromSuperview];
            UIButton *btn = [self.view viewWithTag:301];
            [btn removeFromSuperview];
            _isVedio = NO;
            //显示添加按钮时，textview面积减小
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.bounds.size.width, self.textView.bounds.size.height - 80);
            self.label.frame = CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y - 80, self.label.frame.size.width, self.label.frame.size.height);
            //取消视频选择后删除文件并且将路径置空
            [self deleteFile:self.mediaUrl];
            self.mediaUrl = [[NSMutableString alloc]initWithString:@""];
        }
        self.addButton.hidden = NO;
        self.addButton.frame = CGRectMake(12.5, 180, 70, 70);
        self.pageCount ++;
        [self interfaceLayout];
    }else{
        if(_isVedio){
            [_player stop];
        }
    }
    [_subView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
