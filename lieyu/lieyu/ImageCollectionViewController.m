//
//  ImageCollectionViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HTTPController.h"
#import "preview.h"
#import "MyCell.h"

@interface ImageCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    int selectedPages;
    BOOL isRemoved;
    NSString *_sandBoxFilePath;
}
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *collectionData;
@property (nonatomic, strong) NSMutableArray *cellsArray;
@property (nonatomic, strong) NSMutableArray *tagsArray;
@property (nonatomic, strong) preview *subView;

@end

@implementation ImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-3) / 4, (SCREEN_WIDTH-3) / 4);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(1, 0, 20, 0);
    
    self.imagesArray = [[NSMutableArray alloc]init];
    self.cellsArray = [[NSMutableArray alloc]init];
    self.tagsArray = [[NSMutableArray alloc]init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"完成0/%d",self.imagesCount] style:UIBarButtonItemStylePlain target:self action:@selector(pickOK)];
    self.navigationItem.rightBarButtonItem = rightItem;
    rightItem.enabled = NO;
    rightItem.tintColor = [UIColor grayColor];
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = layout;
    //    self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentSize.height - self.view.frame.size.height);
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellWithReuseIdentifier:@"mycell"];
    self.collectionData = [[NSMutableArray alloc]init];
    __weak __typeof(self)weakSelf = self;
    [_assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            if([type isEqualToString:ALAssetTypePhoto] || [type isEqualToString:ALAssetTypeVideo]){
                //                [self.collectionData addObject:[UIImage imageWithCGImage:[result aspectRatioThumbnail ]]];
                [weakSelf.collectionData addObject:result];
            }
        }
        [weakSelf.collectionView reloadData];
    }];
}

//- (void)setupView{
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = leftItem;
//}
//
//- (void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if(isRemoved == NO && self.collectionView.contentSize.height > 0){
        if(self.collectionView.contentSize.height >= self.view.frame.size.height){
            self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentSize.height - self.view.frame.size.height);
            if(self.collectionView.contentOffset.y > -self.view.frame.size.height){
                isRemoved = YES;
            }
        }else{
            isRemoved = YES;
        }
        
    }
    NSLog(@"%@",NSStringFromCGPoint(self.collectionView.contentOffset));
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - collectionView layout代理
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

#pragma mark -collectionView的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    __weak typeof(cell) weakcell = cell;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakcell.cellImage.contentMode = UIViewContentModeScaleAspectFill;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakcell.cellImage.image = [UIImage imageWithCGImage:[((ALAsset *)[weakSelf.collectionData objectAtIndex:indexPath.item]) aspectRatioThumbnail]];
            //            weakcell.cellImage.image = [self.collectionData objectAtIndex:indexPath.item % 10];
            //            weakcell.selectBtn.tag = indexPath.item;
            //            [weakcell.imageTap setBackgroundImage:[self.collectionData objectAtIndex:indexPath.item % 10] forState:UIControlStateNormal];
        });
    });
    
    cell.cellButton.tag = indexPath.item;
    cell.tag = indexPath.item;
    NSString *tagString = [NSString stringWithFormat:@"%ld",cell.tag];
    for (NSString *imCell in self.tagsArray) {
        NSLog(@"%@---%@",imCell,tagString);
        if ([imCell isEqualToString:tagString]) {
            cell.cellButton.selected = YES;
            [cell.cellButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            cell.cellButton.selected = NO;
        }
    }
    [cell.cellButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.navigationController.navigationBarHidden = YES;
    _subView = [[[NSBundle mainBundle]loadNibNamed:@"preview" owner:nil options:nil]firstObject];
    _subView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _subView.button.hidden = YES;
    _subView.image = [UIImage imageWithCGImage:[[((ALAsset *)[self.collectionData objectAtIndex:indexPath.item]) defaultRepresentation] fullScreenImage]];
    //    _subView.image = [self.collectionData objectAtIndex:indexPath.item];
    [_subView viewConfigure];
    _subView.imageView.center = _subView.center;
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSubView:)];
    [_subView addGestureRecognizer:tapgesture];
    
    [self.view addSubview:_subView];
    
}

- (void)hideSubView:(UIButton *)button{
    self.navigationController.navigationBarHidden = NO;
    [_subView removeFromSuperview];
}

#pragma mark - 完成后
- (void)pickOK{
    if(selectedPages > 0){
        for (int i = 0 ; i < self.cellsArray.count; i ++) {
//            int tag = (int)((MyCell *)[self.cellsArray objectAtIndex:i]).tag;
            int tag = [[self.tagsArray objectAtIndex:i]intValue];
            
            ALAsset *asset = ((ALAsset *)[self.collectionData objectAtIndex:tag]);
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            if ([type isEqualToString:ALAssetTypeVideo]) {
                NSDictionary *dic = @{@"url":asset.defaultRepresentation.url,@"image":[UIImage imageWithCGImage:asset.thumbnail]};
                [self.imagesArray addObject:dic];
            } else if ([type isEqualToString:ALAssetTypePhoto]) {
                [self.imagesArray addObject:[UIImage imageWithCGImage:[[((ALAsset *)[self.collectionData objectAtIndex:tag]) defaultRepresentation] fullScreenImage]]];
            }
            //            [self.imagesArray addObject:[self.collectionData objectAtIndex:tag]];
        }
        [self.navigationController popViewControllerAnimated:NO];
        self.pushSuccessBlock(self.imagesArray);
    }else{
        [MyUtil showCleanMessage:@"请选择图片"];
        return;
    }
}

#pragma mark - 跳转出去以后

#pragma mark - 选择图片
- (void)pickImage:(UIButton *)button{
    if (button.selected) {
        selectedPages --;
        button.selected = NO;
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"选择%d/%d",selectedPages,_imagesCount];
        if(selectedPages == 0){
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        for(int i = 0 ; i < self.cellsArray.count ; i ++){
            if(button.tag == ((MyCell *)[self.cellsArray objectAtIndex:i]).tag){
                [self.cellsArray removeObjectAtIndex:i];
            }
            NSString *tagString = [NSString stringWithFormat:@"%ld",button.tag];
            if ([tagString isEqualToString:[self.tagsArray objectAtIndex:i]]) {
                [self.tagsArray removeObjectAtIndex:i];
            }
        }
        return;
    }
    if(selectedPages < self.imagesCount){
        selectedPages ++;
        button.selected = YES;
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"选择%d/%d",selectedPages,_imagesCount];
        self.navigationItem.rightBarButtonItem.tintColor = RGBA(0, 0, 0, 1);
        self.navigationItem.rightBarButtonItem.enabled = YES;
        MyCell *cell = ((MyCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]]);
        [self.cellsArray addObject:cell];
        [self.tagsArray addObject:[NSString stringWithFormat:@"%ld",cell.tag]];
    }
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
                    break;
                }
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"视频转码成功");
                    //                NSData *data = [NSData dataWithContentsOfFile:sandBoxFilePath];
                    _sandBoxFilePath = [[NSMutableString alloc] initWithString:sandBoxFilePath];
                    //                model.fileData = data;
                }
            }
        }];
}

#pragma mark 上传文件到七牛
- (void)sendFilesToQiniu{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        __block NSString *videoUrl ;
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            [HTTPController uploadFileToQiuNiu:_sandBoxFilePath complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if(![MyUtil isEmptyString:key]){
                    videoUrl = key;
                    [MyUtil showCleanMessage:@"上传成功!"];
                    NSLog(@"%@",key);
                   
                }else{
                    [MyUtil showCleanMessage:@"上传失败!"];
                }
            }];
        });
    });
}

-(void)clearCahes
{
    //直接删除文件
    NSFileManager *filemanager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *videoPath = [NSString stringWithFormat:@"%@/Video",pathDocuments];
    [filemanager removeItemAtPath:videoPath error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
