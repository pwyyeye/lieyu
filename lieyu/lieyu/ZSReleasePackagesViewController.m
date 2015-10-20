//
//  ZSReleasePackagesViewController.m
//  lieyu
//
//  Created by SEM on 15/9/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSReleasePackagesViewController.h"
#import "FBTaoCanSectionBottom.h"
#import "FBTaoCanSectionHead.h"
#import "TaoCanMCell.h"
#import "FBTaoCanView.h"
#import "TimeChooseTwoViewController.h"
#import "ChanPinListViewController.h"
#import "QNUploadManager.h"
#import "QNUploadOption.h"
#import "ZSManageHttpTool.h"
#import "KuCunModel.h"
@interface ZSReleasePackagesViewController ()<TimeChooseDelegate,UITextFieldDelegate,UITextViewDelegate,ZSAddChanPinDelegate>
{
    FBTaoCanView *taoCanView;
    FBTaoCanSectionBottom *taoCanSectionBottom;
    FBTaoCanSectionHead *taoCanSectionHead;
}
@end

@implementation ZSReleasePackagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userModel=app.userModel;
    keyArr =[NSMutableArray new];
    _tableView.separatorColor=[UIColor clearColor];
    taocanDelList=[[NSMutableArray alloc]init];
//    [self.navigationController setNavigationBarHidden:NO];
    self.title=@"发布套餐";
    [self setViewForTableView];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 初始化页面
-(void)setViewForTableView{
    
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
#pragma mark 时间选择
-(void)timeChoose:(id)sender{
     TimeChooseTwoViewController *timeChooseViewController=[[TimeChooseTwoViewController alloc]initWithNibName:@"TimeChooseTwoViewController" bundle:nil];
    timeChooseViewController.title=@"选择时间";
    timeChooseViewController.delegate=self;
    [self.navigationController pushViewController:timeChooseViewController animated:YES];
}

#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return taocanDelList.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"今日发布套餐：15套";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(taoCanView==nil){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanView" owner:nil options:nil];
        taoCanView= (FBTaoCanView *)[nibView objectAtIndex:0];
        taoCanView.timeChooseBtn.backgroundColor=[UIColor clearColor];
        [taoCanView.timeChooseBtn addTarget:self action:@selector(timeChoose:) forControlEvents:UIControlEventTouchDown] ;
        [taoCanView.taocanTitleTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        taoCanView.taocanTitleTex.delegate=self;
        [taoCanView.fromPriceTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        taoCanView.fromPriceTex.delegate=self;
        [taoCanView.toPriceTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        taoCanView.toPriceTex.delegate=self;
        [taoCanView.addPhotoBtn addTarget:self action:@selector(addPictures:) forControlEvents:UIControlEventTouchDown] ;
        
        
        [taoCanView.addTaoCanBtn addTarget:self action:@selector(taoCanChoose:) forControlEvents:UIControlEventTouchDown] ;
        UILabel *qaLine=[[UILabel alloc] initWithFrame:CGRectMake(0, 417.5, taoCanSectionHead.width, 0.5)];
        qaLine.backgroundColor=RGB(237, 237, 237);
            [taoCanView addSubview:qaLine];
        [taoCanView.fromPopulationTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        taoCanView.fromPopulationTex.delegate=self;
        [taoCanView.toPopulationTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        taoCanView.toPopulationTex.delegate=self;
        

    }
    
    
    //            orderHeadView.detLal.text=orderInfoModel.paytime;
    //    view.backgroundColor=[UIColor yellowColor];
    return taoCanView;
    
}

#pragma mark选择套餐明细
-(void)taoCanChoose:(id)sender{
    ChanPinListViewController *chanPinListViewController=[[ChanPinListViewController alloc]initWithNibName:@"ChanPinListViewController" bundle:nil];
    chanPinListViewController.title=@"产品列表";
    chanPinListViewController.delegate=self;
    [self.navigationController pushViewController:
     chanPinListViewController animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(taoCanSectionBottom==nil){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanSectionBottom" owner:nil options:nil];
        taoCanSectionBottom= (FBTaoCanSectionBottom *)[nibView objectAtIndex:0];
        
        [taoCanSectionBottom.yjTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    
    //            orderHeadView.detLal.text=orderInfoModel.paytime;
    //    view.backgroundColor=[UIColor yellowColor];
    return taoCanSectionBottom;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 418;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 65;
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
    KuCunModel *kuCunModel = taocanDelList[indexPath.row];
    cell.nameLal.text=kuCunModel.name;
    //上方的减按钮
    cell.jianAct.tag=indexPath.row;
    [cell.jianAct addTarget:self action:@selector(delKuCunAct:) forControlEvents:UIControlEventTouchDown];
    //下方的加按钮
    cell.jiaDAct.tag=indexPath.row;
    [cell.jiaDAct addTarget:self action:@selector(jiaDAct:event:) forControlEvents:UIControlEventTouchDown];
    //下方的减按钮
    cell.jianDAct.tag=indexPath.row;
    [cell.jianDAct addTarget:self action:@selector(jianDAct:event:) forControlEvents:UIControlEventTouchDown];
    
    cell.countTex.text=[NSString stringWithFormat:@"%d",kuCunModel.useCount];
    return cell;
    
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
#pragma mark - 时间选择代理
-(void)changetime:(NSDictionary *)timeDic{
    fromTime=[timeDic objectForKey:@"fromTime"];
    toTime=[timeDic objectForKey:@"toTime"];
    taoCanView.timeLal.text=[NSString stringWithFormat:@"%@ 至 %@",fromTime,toTime];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)endEdit:(id)sender{
    [sender resignFirstResponder];
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
                taoCanView.imageAddlal.text=[NSString stringWithFormat:@"你选中了%d张图片",(int)keyArr.count];
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
                taoCanView.imageAddlal.text=[NSString stringWithFormat:@"你选中了%d张图片",(int)keyArr.count];
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
#pragma mark - 添加产品代理
- (void)addChanPin:(NSMutableArray *)arr{
    [taocanDelList removeAllObjects];
    [taocanDelList addObjectsFromArray:arr];
    [self.tableView reloadData];
}
#pragma mark - 删除明细
- (void)delKuCunAct:(UIButton *)sender{
    KuCunModel *kuCunModel = taocanDelList[sender.tag];
    [taocanDelList removeObject:kuCunModel];
    [self.tableView reloadData];
}
#pragma mark - 加
- (void)jiaDAct:(UIButton *)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    TaoCanMCell *cell =(TaoCanMCell *)[_tableView cellForRowAtIndexPath:indexPath];
    KuCunModel *kuCunModel = taocanDelList[indexPath.row];
    kuCunModel.useCount=kuCunModel.useCount+1;
    cell.countTex.text=[NSString stringWithFormat:@"%d",kuCunModel.useCount];
}
#pragma mark - 减
- (void)jianDAct:(UIButton *)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    TaoCanMCell *cell =(TaoCanMCell *)[_tableView cellForRowAtIndexPath:indexPath];
    KuCunModel *kuCunModel = taocanDelList[indexPath.row];
    if(kuCunModel.useCount!=1){
        kuCunModel.useCount=kuCunModel.useCount-1;
    }
    
    cell.countTex.text=[NSString stringWithFormat:@"%d",kuCunModel.useCount];
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
    if(keyArr.count<1){
        [self showMessage:@"请选择图片"];
        return;
        
    }
    if (taoCanView.taocanTitleTex.text.length<1) {
        [self showMessage:@"请填写标题"];
        return;
    }
    if (taoCanView.fromPriceTex.text.length<1) {
        [self showMessage:@"请填写实际价格"];
        return;
    }
    if (taoCanView.toPriceTex.text.length<1) {
        [self showMessage:@"请填写市场价格"];
        return;
    }
    if ([taoCanView.timeLal.text isEqualToString:@"请正确选择你的套餐时间"]) {
        [self showMessage:@"请选择时间"];
        return;
    }
    if (taoCanView.fromPopulationTex.text.length<1) {
        [self showMessage:@"请填写适合人数"];
        return;
    }
    if (taoCanView.toPopulationTex.text.length<1) {
        [self showMessage:@"请填写适合人数"];
        return;
    }
    if (taocanDelList.count<1) {
        [self showMessage:@"请选择套餐"];
        return;
    }
    
    if (taoCanSectionBottom.yjTex.text.length<1) {
        [self showMessage:@"请填写分销佣金"];
        return;
    }
    NSMutableString *linkurl=[NSMutableString new];
    for (NSString *str in keyArr) {
        [linkurl appendString:str];
        [linkurl appendString:@","];
    }
    NSMutableString *deStr=[NSMutableString new];
    NSMutableString *deCountStr=[NSMutableString new];
    for (KuCunModel *kuCunModel in taocanDelList) {
        NSString *str=[NSString stringWithFormat:@"%d",kuCunModel.id];
        NSString *str1=[NSString stringWithFormat:@"%d",kuCunModel.useCount];
        [deStr appendString:str];
        [deStr appendString:@","];
        [deCountStr appendString:str1];
        [deCountStr appendString:@","];
    }
    //post参数
    NSString *fxyj=[NSString stringWithFormat:@"%.2f",taoCanSectionBottom.yjTex.text.floatValue/100 ];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:taoCanView.taocanTitleTex.text forKey:@"smname"];
    [dic setObject:taoCanView.fromPriceTex.text forKey:@"price"];
    [dic setObject:taoCanView.toPriceTex.text forKey:@"marketprice"];
    [dic setObject:fxyj forKey:@"rebate"];
    [dic setObject:linkurl forKey:@"linkurl"];
    
    [dic setObject:[NSString stringWithFormat:@"%@ 00:00:00",fromTime] forKey:@"begindate"];
    [dic setObject:[NSString stringWithFormat:@"%@ 00:00:00",toTime] forKey:@"enddate"];
    [dic setObject:deStr forKey:@"goodsList"];
    [dic setObject:taoCanView.fromPopulationTex.text forKey:@"minnum"];
    [dic setObject:taoCanView.toPopulationTex.text forKey:@"maxnum"];
    [dic setObject:deCountStr forKey:@"goodsNum"];
    [dic setObject:[NSNumber numberWithInt:userModel.userid] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:userModel.barid] forKey:@"barid"];
    // [dic setObject:@"" forKey:@"price"];
    //网络访问
    [[ZSManageHttpTool shareInstance] addTaoCanWithParams:dic complete:^(BOOL result) {
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
            [self.delegate addTaoCan];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}
@end
