//
//  UpdateLiveVideoViewController.m
//  lieyu
//
//  Created by 狼族 on 2016/12/21.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "UpdateLiveVideoViewController.h"
#import "ImagePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LYFriendsHttpTool.h"
#import "HTTPController.h"


@interface UpdateLiveVideoViewController ()<ImagePickerFinish>

{
    NSString *_sandBoxFilePath;
    NSURL *_fileUrl;
    NSString *_livename;//视频标题
    NSString *_likeNum;
    NSString *_joinNum;
    NSString *_liveChatId;
    NSString *_playbackURL;
    NSString *_liveImgUrl;
    NSString *_liveimg;
    UIImageView *_backImage;
    ImagePickerViewController *_imagepickerVC;
}

@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;
@property (weak, nonatomic) IBOutlet UITextField *liveTitle;
@property (weak, nonatomic) IBOutlet UIImageView *liveVideoImageView;
@property (weak, nonatomic) IBOutlet UITextField *likeNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *joinNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@end

@implementation UpdateLiveVideoViewController

#pragma mark 视图控制器
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

-(void)viewDidLayoutSubviews
{
    self.updateButton.layer.borderColor = RGB(187, 40, 217).CGColor;
    self.updateButton.layer.borderWidth = 1.f;
    [self setcorrnerRadius:_updateButton];
    [self setcorrnerRadius:_joinNumTextField];
    [self setcorrnerRadius:_likeNumTextField];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 界面及点击事件
-(void)initView
{
    UITapGestureRecognizer *liveImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickLiveImage)];
    
    [_liveImageView addGestureRecognizer:liveImgTap];
    [_liveImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *videoImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickVideoIamge)];
    [_liveVideoImageView addGestureRecognizer:videoImageTap];
    [_liveVideoImageView setUserInteractionEnabled:YES];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    [visualEffectView setFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ))];
    _backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackImage.png"]];
    _backImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_backImage setUserInteractionEnabled:YES];
    [_backImage addSubview:visualEffectView];
    [self.view addSubview:_backImage];
    [self.view sendSubviewToBack:_backImage];
    
    _liveTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"#给直播写个标题吧..." attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    
    
}

-(void)pickLiveImage
{
    _imagepickerVC = [[ImagePickerViewController alloc] init];
    _imagepickerVC.title = @"本地图片";
    _imagepickerVC.pickType = pickImages;
    _imagepickerVC.imagesCount = 1;
    _imagepickerVC.delegate = self;
    [self.navigationController pushViewController:_imagepickerVC animated:YES];
}

-(void)pickVideoIamge
{
    _imagepickerVC = [[ImagePickerViewController alloc] init];
    _imagepickerVC.title = @"本地视频";
    _imagepickerVC.pickType = pickVideo;
    _imagepickerVC.imagesCount = 1;
    _imagepickerVC.delegate = self;
    [self.navigationController pushViewController:_imagepickerVC animated:YES];
}

- (IBAction)updateVideoAction:(UIButton *)sender {
    
    if ([MyUtil isEmptyString:_liveTitle.text] || [MyUtil isEmptyString:_likeNumTextField.text] || [MyUtil isEmptyString:_joinNumTextField.text] || [MyUtil isEmptyString:[NSString stringWithFormat:@"%@",_fileUrl]] || [MyUtil isEmptyString:_liveImgUrl]) {
        [MyUtil showPlaceMessage:@"请输入完整信息"];
        return;
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
     [self convertVideoWithAssetFilePath:_fileUrl];//转码并上传七牛服务器
}

#pragma mark --- 削圆角
-(void) setcorrnerRadius:(UIView *)view{
    view.layer.cornerRadius = view.frame.size.height / 2;
    view.layer.masksToBounds = YES;
}

#pragma mark 选择图片和视频代理事件(回传图片和视频)
- (void)ImagePickerDidFinishWithImages:(NSArray *)imageArray
{
    if ([[imageArray objectAtIndex:0] isKindOfClass:[UIImage class]]) {
        UIImage *liveImage = [[UIImage alloc] init];
        liveImage = (UIImage *)[imageArray objectAtIndex:0];
        [_liveImageView setImage:(UIImage *)[imageArray objectAtIndex:0]];
        [HTTPController uploadImageToQiuNiu:liveImage withDegree:0.5 complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            _liveImgUrl = [NSString stringWithString: [MyUtil getQiniuUrl:key width:0 andHeight:0]];
        }];
    } else if ([[imageArray objectAtIndex:0] isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = [imageArray objectAtIndex:0];
        _fileUrl = dic[@"url"];//本地地址
        [_liveVideoImageView setImage:(UIImage *)dic[@"image"]];
        
    }
}

#pragma mark 将视频转码及上传
- (void) convertVideoWithAssetFilePath:(NSURL *) assetFilePath {
    [self creatSandBoxFilePathIfNoExist];
    //以日期命名避免重复
    NSDate *date = [NSDate date];
    NSString *filename = [NSString stringWithFormat:@"%@.mp4",[self getFormatedDateStringOfDate:date]];
    //转码的视频保存至沙盒路径
    //    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *videoPath = [NSString stringWithFormat:@"%@/UpdateVideo",tmpDir];
    NSString *sandBoxFilePath = [videoPath stringByAppendingPathComponent:filename];
    //转码配置
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:assetFilePath options:nil];
    //    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:sandBoxFilePath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        NSLog(@"%d",exportStatus);
        switch (exportStatus)         {
            case AVAssetExportSessionStatusFailed:
            {
                // log error to text view
                NSError *exportError = exportSession.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app stopLoading];
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog(@"视频转码成功");
                //                NSData *data = [NSData dataWithContentsOfFile:sandBoxFilePath];
                _sandBoxFilePath = [[NSMutableString alloc] initWithString:sandBoxFilePath];
                //                model.fileData = data;
                [self sendFilesToQiniu];
            }
        }
    }];
}

//将创建日期作为文件名
-(NSString*)getFormatedDateStringOfDate:(NSDate*)date{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"]; //注意时间的格式：MM表示月份，mm表示分钟，HH用24小时制，小hh是12小时制。
    NSString* dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

-(void)creatSandBoxFilePathIfNoExist
{
    //沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSLog(@"databse--->%@",documentDirectory);
    
    NSFileManager *filemanager = [[NSFileManager alloc] init];
    //    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *videoPath = [NSString stringWithFormat:@"%@/UpdateVideo",tmpDir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        [filemanager createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"File is Exists");
    }
}

#pragma mark 上传文件到七牛
- (void)sendFilesToQiniu{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            [HTTPController uploadFileToQiuNiu:_sandBoxFilePath complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if(![MyUtil isEmptyString:key]){
                    _playbackURL = [NSString string];
                   NSString *temp = [key stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
                    _playbackURL =[NSString stringWithString:[MyUtil getQiniuUrl:temp mediaType:QiNiuUploadTpyeMedia width:0 andHeight:0]];
                    
                    [MyUtil showCleanMessage:@"上传成功!"];
                    NSLog(@"%@",key);
                    
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    NSString *title = [NSString stringWithFormat:@"%@", _liveTitle.text];
                    NSString *likeNum =[NSString stringWithFormat:@"%@", _likeNumTextField.text];
                    NSString *joinNum = [NSString stringWithFormat:@"%@", _joinNumTextField.text];
                    NSDate* dat = [NSDate date];
                    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
                    NSString *time13 = [NSString stringWithFormat:@"%f",a];
                    NSString *times = [time13 substringToIndex:13];
                    NSString *roomid =  [NSString stringWithFormat:@"%d%@", app.userModel.userid,times];
                    NSDictionary *dict = @{@"liveimg":_liveImgUrl,@"livename":title,@"liveChatId":roomid,@"playbackURL":_playbackURL,@"likeNum":likeNum,@"joinNum":joinNum};
                    
                    [LYFriendsHttpTool updateLiveVideoWithParms:dict complete:^(NSDictionary *dic) {
                        [app stopLoading];
                        [self.navigationController popViewControllerAnimated:YES];
                        [self clearCahes];
                    }];
                }else{
                    [MyUtil showCleanMessage:@"上传失败!"];
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app stopLoading];
                    [self clearCahes];
                }
            }];
        });
    });
}

#pragma mark 删除本地转码缓存视频
-(void)clearCahes
{
    //直接删除文件
    NSFileManager *filemanager = [[NSFileManager alloc] init];
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *videoPath = [NSString stringWithFormat:@"%@/UpdateVideo",tmpDir];
    [filemanager removeItemAtPath:videoPath error:nil];
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
