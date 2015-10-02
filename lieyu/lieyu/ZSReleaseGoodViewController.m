//
//  ZSReleaseGoodViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSReleaseGoodViewController.h"
#import "FBDanPinView.h"
#import "ChanPinListViewController.h"
#import "FBTaoCanSectionHead.h"
#import "FBTaoCanSectionBottom.h"
#import "TaoCanMCell.h"
#import "BiaoQianChooseViewController.h"
#import "QNUploadManager.h"
#import "QNUploadOption.h"
#import "ZSManageHttpTool.h"
@interface ZSReleaseGoodViewController ()<UITextFieldDelegate,UITextViewDelegate,UITextViewDelegate>
{
    FBDanPinView *danPinView;
}
@end

@implementation ZSReleaseGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    chanPinDelList=[[NSMutableArray alloc]init];
    biaoQianList=[[NSMutableArray alloc]init];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBDanPinView" owner:nil options:nil];
    danPinView= (FBDanPinView *)[nibView objectAtIndex:0];

    [danPinView.jiageTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    danPinView.jiageTex.delegate=self;
    [danPinView.danpinTitleTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    danPinView.danpinTitleTex.delegate=self;
    
    danPinView.shuoMingTextView.delegate=self;
    [danPinView.addPhotoBtn addTarget:self action:@selector(addPictures:) forControlEvents:UIControlEventTouchDown] ;
    self.tableView.tableHeaderView=danPinView;
    // Do any additional setup after loading the view from its nib.
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
#pragma mark选择套餐明细
-(void)taoCanChoose:(id)sender{
    ChanPinListViewController *chanPinListViewController=[[ChanPinListViewController alloc]initWithNibName:@"ChanPinListViewController" bundle:nil];
    [self.navigationController pushViewController:chanPinListViewController animated:YES];
}
#pragma mark选择产品
-(void)chanPinChoose:(id)sender{
    BiaoQianChooseViewController *biaoQianChooseViewController=[[BiaoQianChooseViewController alloc]initWithNibName:@"BiaoQianChooseViewController" bundle:nil];
    biaoQianChooseViewController.title=@"产品标签";
    [self.navigationController pushViewController:biaoQianChooseViewController animated:YES];
}

#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return biaoQianList.count;
    }
    return chanPinDelList.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"今日发布套餐：15套";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanSectionHead" owner:nil options:nil];
        FBTaoCanSectionHead *taoCanSectionHead= (FBTaoCanSectionHead *)[nibView objectAtIndex:0];
        taoCanSectionHead.titleLal.text=@"产品标签";
        [taoCanSectionHead.addTaoCanBtn addTarget:self action:@selector(chanPinChoose:) forControlEvents:UIControlEventTouchDown] ;
        
        //            orderHeadView.detLal.text=orderInfoModel.paytime;
        //    view.backgroundColor=[UIColor yellowColor];
        return taoCanSectionHead;
    }else{
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanSectionHead" owner:nil options:nil];
        FBTaoCanSectionHead *taoCanSectionHead= (FBTaoCanSectionHead *)[nibView objectAtIndex:0];
        taoCanSectionHead.titleLal.text=@"添加吃喝";
        [taoCanSectionHead.addTaoCanBtn addTarget:self action:@selector(taoCanChoose:) forControlEvents:UIControlEventTouchDown] ;
        
        //            orderHeadView.detLal.text=orderInfoModel.paytime;
        //    view.backgroundColor=[UIColor yellowColor];
        return taoCanSectionHead;
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==1){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanSectionBottom" owner:nil options:nil];
        FBTaoCanSectionBottom *taoCanSectionBottom= (FBTaoCanSectionBottom *)[nibView objectAtIndex:0];
        
        
        //            orderHeadView.detLal.text=orderInfoModel.paytime;
        //    view.backgroundColor=[UIColor yellowColor];
        return taoCanSectionBottom;
    }
    UIView *viewtemp=[[UIView alloc]initWithFrame:CGRectZero];
    return viewtemp;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==1){
        return 65;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *taoCanCellIdentifier = @"TaoCanMCell";
    
    TaoCanMCell *cell = (TaoCanMCell *)[_tableView dequeueReusableCellWithIdentifier:taoCanCellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:taoCanCellIdentifier owner:self options:nil];
        cell = (TaoCanMCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    
    return cell;
    
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
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
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {//七牛上传
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if(app.qiniu_token){
            
            //            __weak __typeof(self)weakSelf = self;
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
            NSString *fileName;
            if(keyBenDiArr){
                int z=(int)keyBenDiArr.count-1;
                if(z>=0){
                    fileName = keyBenDiArr[0];
                    
                }else{
                    fileName = [NSString stringWithFormat:@"ZSKC%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
                    [newKey addObject:fileName];
                }
                
            }else{
                fileName = [NSString stringWithFormat:@"ZSKC%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
                [newKey addObject:fileName];
            }
            //先把图片转成NSData
            UIImage* img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
            //图片压缩到30%
            NSData *data = UIImageJPEGRepresentation(img, 0.3f);
            [upManager putData:data key:fileName token:app.qiniu_token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                [keyArr addObject:key];
                danPinView.imageAddlal.text=[NSString stringWithFormat:@"你选中了%d张图片",(int)keyArr.count];
            } option:op];
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
}
#pragma mark - 照片选择代理方法
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    NSLog(@"assets %@",assets);
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.qiniu_token){
        [keyArr removeAllObjects];
        //七牛上传
        //        __weak __typeof(self)weakSelf = self;
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
            
            //            fileName=@"ZSKC2015-09-30_22:45:04_OoIkxuCe.jpg";
            [upManager putData:data key:fileName token:app.qiniu_token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                [keyArr addObject:key];
                danPinView.imageAddlal.text=[NSString stringWithFormat:@"你选中了%d张图片",(int)keyArr.count];
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

-(void)endEdit:(id)sender{
    [sender resignFirstResponder];
}
- (IBAction)sureAct:(UIButton *)sender {
}
@end
