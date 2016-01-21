//
//  ImageCollectionViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "preview.h"
#import "MyCell.h"

@interface ImageCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    int selectedPages;
}
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *collectionData;
@property (nonatomic, strong) NSMutableArray *cellsArray;

@property (nonatomic, strong) preview *subView;

@end

@implementation ImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 30) / 3, (SCREEN_WIDTH - 30) / 3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.imagesArray = [[NSMutableArray alloc]init];
    self.cellsArray = [[NSMutableArray alloc]init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"完成0/%d",self.imagesCount] style:UIBarButtonItemStylePlain target:self action:@selector(pickOK)];
    self.navigationItem.rightBarButtonItem = rightItem;
    rightItem.enabled = NO;
    rightItem.tintColor = [UIColor grayColor];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellWithReuseIdentifier:@"mycell"];
    self.collectionData = [[NSMutableArray alloc]init];
    [_assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            if([type isEqualToString:ALAssetTypePhoto]){
//                [self.collectionData addObject:[UIImage imageWithCGImage:[result aspectRatioThumbnail ]]];
                [self.collectionData addObject:result];
            }
        }
        [self.collectionView reloadData];
    }];
}

- (void)setupView{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftBackItem"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentSize.height - self.view.frame.size.height);
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -collectionView的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    __weak typeof(cell) weakcell = cell;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakcell.cellImage.contentMode = UIViewContentModeScaleAspectFill;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakcell.cellImage.image = [UIImage imageWithCGImage:[((ALAsset *)[self.collectionData objectAtIndex:indexPath.item]) aspectRatioThumbnail]];
//            weakcell.cellImage.image = [self.collectionData objectAtIndex:indexPath.item % 10];
            //            weakcell.selectBtn.tag = indexPath.item;
            //            [weakcell.imageTap setBackgroundImage:[self.collectionData objectAtIndex:indexPath.item % 10] forState:UIControlStateNormal];
        });
    });
    cell.cellButton.tag = indexPath.item;
    cell.tag = indexPath.item;
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
            int tag = (int)((MyCell *)[self.cellsArray objectAtIndex:i]).tag;
            [self.imagesArray addObject:[UIImage imageWithCGImage:[[((ALAsset *)[self.collectionData objectAtIndex:tag]) defaultRepresentation] fullScreenImage]]];
//            [self.imagesArray addObject:[self.collectionData objectAtIndex:tag]];
        }
    }else{
        [MyUtil showCleanMessage:@"请选择图片"];
        return;
    }
//    if(self.delegate){
        [self.navigationController popViewControllerAnimated:NO];
        self.pushSuccessBlock(self.imagesArray);
//    }
}

#pragma mark - 跳转出去以后
//- (void)completed()^{
//    
//}

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
        }
        return;
    }
    if(selectedPages < self.imagesCount){
        selectedPages ++;
        button.selected = YES;
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"选择%d/%d",selectedPages,_imagesCount];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.cellsArray addObject:((MyCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0]])];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
