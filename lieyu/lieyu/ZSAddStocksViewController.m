//
//  ZSAddStocksViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSAddStocksViewController.h"
#import "QNUploadManager.h"
#import "QNUploadOption.h"
#import "ZSManageHttpTool.h"
@interface ZSAddStocksViewController ()

@end

@implementation ZSAddStocksViewController

- (void)viewDidLoad {
    keyArr=[NSMutableArray new];
    
    [super viewDidLoad];
    chooseStr=@"瓶";
    // Do any additional setup after loading the view from its nib.
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
#pragma mark - 确定
- (IBAction)sureAct:(UIButton *)sender {
    //判断数据完整
    if (self.titleTex.text.length<1) {
        [self showMessage:@"请输入标题"];
        return;
    }
    if (self.kucunTex.text.length<1) {
        [self showMessage:@"请输入库存"];
        return;
    }
    
    if(keyArr.count<1){
        [self showMessage:@"请选择图片"];
        return;

    }
    
    NSMutableString *linkurl=[NSMutableString new];
    for (NSString *str in keyArr) {
        [linkurl appendString:str];
        [linkurl appendString:@","];
    }
    //post参数
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:self.titleTex.text forKey:@"name"];
    [dic setObject:chooseStr forKey:@"unit"];
    [dic setObject:self.kucunTex.text forKey:@"stock"];
    [dic setObject:linkurl forKey:@"linkurl"];
    [dic setObject:@"1" forKey:@"userid"];
    [dic setObject:@"1" forKey:@"barid"];
   // [dic setObject:@"" forKey:@"price"];
    //网络访问
    [[ZSManageHttpTool shareInstance] addItemProductWithParams:dic complete:^(BOOL result) {
        if (result) {
            //看缓存中是否有数据 有去掉
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSMutableArray *keyBenDiArr;
            if (userDef) {
                NSArray *arr=[userDef objectForKey:@"QINIUKEY"];
                keyBenDiArr = [[NSMutableArray alloc]initWithArray:arr];
                
                if(keyBenDiArr){
                    NSArray *arrTemp=[NSArray arrayWithArray: keyBenDiArr];
                    for (NSString *upKey in keyArr) {
                        for (NSString *keyIn in arrTemp) {
                            if([upKey isEqualToString:keyIn]){
                                [keyBenDiArr removeObject:keyIn];
                            }
                        }
                    }
                }
                [userDef setObject:keyBenDiArr forKey:@"QINIUKEY"];
                [userDef synchronize];
                
                
            }
            [self.delegate addStocks];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}
#pragma mark - 单选按钮
- (IBAction)chooseRadioAct:(id)sender {
    UIButton *btn=(UIButton *)sender;
    int z=(int)btn.tag;
    switch (z) {
        case 0:// 已消费
        {
            _firstRadioBtn.selected=YES;
            _secondRadioBtn.selected=false;
            _thirdRadioBtn.selected=false;
            _fourthRadioBtn.selected=false;
            _fifthRadioBtn.selected=false;
            _sixthRadioBtn.selected=false;
            chooseStr=_firstRadioBtn.titleLabel.text;
            break;
        }

        case 1:// 已消费
        {
            _firstRadioBtn.selected=false;
            _secondRadioBtn.selected=YES;
            _thirdRadioBtn.selected=false;
            _fourthRadioBtn.selected=false;
            _fifthRadioBtn.selected=false;
            _sixthRadioBtn.selected=false;
            chooseStr=_secondRadioBtn.titleLabel.text;
            break;
        }

        case 2:// 已消费
        {
            _firstRadioBtn.selected=false;
            _secondRadioBtn.selected=false;
            _thirdRadioBtn.selected=YES;
            _fourthRadioBtn.selected=false;
            _fifthRadioBtn.selected=false;
            _sixthRadioBtn.selected=false;
            chooseStr=_thirdRadioBtn.titleLabel.text;
            break;
        }

        case 3:// 已消费
        {
            _firstRadioBtn.selected=false;
            _secondRadioBtn.selected=false;
            _thirdRadioBtn.selected=false;
            _fourthRadioBtn.selected=YES;
            _fifthRadioBtn.selected=false;
            _sixthRadioBtn.selected=false;
            chooseStr=_fourthRadioBtn.titleLabel.text;
            break;
        }
        case 4:// 已消费
        {
            _firstRadioBtn.selected=false;
            _secondRadioBtn.selected=false;
            _thirdRadioBtn.selected=false;
            _fourthRadioBtn.selected=false;
            _fifthRadioBtn.selected=YES;
            _sixthRadioBtn.selected=false;
            chooseStr=_fifthRadioBtn.titleLabel.text;
            break;
        }
        
        default://退单
        {
            _firstRadioBtn.selected=false;
            _secondRadioBtn.selected=false;
            _thirdRadioBtn.selected=false;
            _fourthRadioBtn.selected=false;
            _fifthRadioBtn.selected=false;
            _sixthRadioBtn.selected=YES;
            chooseStr=_sixthRadioBtn.titleLabel.text;
            break;
        }

    }
    
}
#pragma mark - 添加照片
- (IBAction)addPictures:(UIButton *)sender {
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    [self.view addSubview:_bgView];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYZSeditView" owner:nil options:nil];
    seditView= (LYZSeditView *)[nibView objectAtIndex:0];
    seditView.top=SCREEN_HEIGHT;
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
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionVideo = 0;
    picker.maximumNumberOfSelectionPhoto = 5;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    [self SetViewDisappear:nil];
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
//        [picker dismissModalViewControllerAnimated:YES];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
                                    CGRectMake(50, 120, 40, 40)] ;
        
        smallimage.image = image;
        //加在视图中
        [self.view addSubview:smallimage];
        
    }
    
}
#pragma mark - 照片选择代理方法
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    NSLog(@"assets %@",assets);
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.qiniu_token){
        [keyArr removeAllObjects];
        //七牛上传
        __weak __typeof(self)weakSelf = self;
        NSMutableArray *newKey=[NSMutableArray new];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        QNUploadOption *op=[[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
        //看是否有缓存的key
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSMutableArray *keyBenDiArr;
        if (userDef) {
            NSArray *arr=[userDef objectForKey:@"QINIUKEY"];
            keyBenDiArr =[[NSMutableArray alloc]initWithArray:arr];
            
        }
        for ( int i=0;i< assets.count ;i++) {
            
            ALAsset *alasset =assets[i];
            NSString *fileName;
            if(keyBenDiArr){
                int z=(int)keyBenDiArr.count-1;
                if(z>=i){
                    fileName = keyBenDiArr[i];
                    
                }else{
                    fileName = [NSString stringWithFormat:@"ZSKC%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
                    [newKey addObject:fileName];
                }
                
            }else{
                fileName = [NSString stringWithFormat:@"ZSKC%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
                [newKey addObject:fileName];
            }
            //获取图片
            UIImage *img = [UIImage imageWithCGImage:alasset.defaultRepresentation.fullResolutionImage
                                               scale:alasset.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)alasset.defaultRepresentation.orientation];
            //上传代码
            //图片压缩到30%
            NSData *data = UIImageJPEGRepresentation(img, 0.3f);
            NSLog(@"%ld",data.length);
            [upManager putData:data key:fileName token:app.qiniu_token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                [keyArr addObject:key];
                weakSelf.imageAddlal.text=[NSString stringWithFormat:@"你选中了%ld张图片",keyArr.count];
            } option:op];
        }
        if(newKey.count>0){
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSMutableArray *keyBenDiArr;
            if (userDef) {
                NSArray *arr=[userDef objectForKey:@"QINIUKEY"];
                keyBenDiArr =[[NSMutableArray alloc]initWithArray:arr];
                if(!keyBenDiArr){
                    keyBenDiArr=[[NSMutableArray alloc]init];
                }
                
                [keyBenDiArr addObjectsFromArray:newKey];
                [userDef setObject:keyBenDiArr forKey:@"QINIUKEY"];
                [userDef synchronize];
            }
        }
        
        
    }else{
        [app doHeart];
        
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
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
#pragma mark - Helpers

- (NSString *)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}


- (NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}
- (IBAction)exitEdit:(UITextField *)sender {
    [sender resignFirstResponder];
}
@end
