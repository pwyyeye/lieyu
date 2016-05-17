//
//  ImagePickerViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageCollectionViewController.h"
@interface ImagePickerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *AssetsGroup;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
//    [self setupView];
    
    _AssetsGroup = [[NSMutableArray alloc]init];
    _assetsLibrary = [[ALAssetsLibrary alloc]init];
    
    void(^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop){
        if(assetsGroup){
            if (assetsGroup) {
                [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                if(assetsGroup.numberOfAssets > 0){
                    [_AssetsGroup addObject:assetsGroup];
                }
            }
        }
        [self.tableView reloadData];
    };
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    // Enumerate Camera Roll
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Photo Stream
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Album
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Event
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Faces
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
}

//- (void)setupView{
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = leftItem;
//}

//- (void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView的代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.AssetsGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    ALAssetsGroup *assetsGroup = [_AssetsGroup objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.imageView.image = [UIImage imageWithCGImage:assetsGroup.posterImage];
//    cell.imageView.frame = CGRectMake(10, 10, 80, 80);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    imageView.image = [UIImage imageWithCGImage:assetsGroup.posterImage];
    [cell addSubview:imageView];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, SCREEN_WIDTH - 100, 20)];
    labelName.font = [UIFont systemFontOfSize:14];
    labelName.textColor = [UIColor blackColor];
    labelName.text = [NSString stringWithFormat:@"%@",[assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    [cell addSubview:labelName];
    
    UILabel *labelNumber = [[UILabel alloc]initWithFrame:CGRectMake(100, 58, 100, 20)];
    labelNumber.font = [UIFont systemFontOfSize:12];
    labelNumber.textColor = [UIColor grayColor];
    labelNumber.text = [NSString stringWithFormat:@"(%ld)",assetsGroup.numberOfAssets];
    [cell addSubview:labelNumber];
    
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",[assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%ld)",assetsGroup.numberOfAssets];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewController *imagePickerVC = [[ImageCollectionViewController alloc]init];
    imagePickerVC.imagesCount = self.imagesCount;
    imagePickerVC.assetsGroup = [self.AssetsGroup objectAtIndex:indexPath.row];
    imagePickerVC.title = [NSString stringWithFormat:@"%@",[[self.AssetsGroup objectAtIndex:indexPath.row] valueForProperty:ALAssetsGroupPropertyName]];
//    imagePickerVC.imagesCount = 4;
    [self.navigationController pushViewController:imagePickerVC animated:YES];
    void(^pushSuccess)(NSArray *) = ^(NSArray *imagesArray){
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate ImagePickerDidFinishWithImages:imagesArray];
    };
    imagePickerVC.pushSuccessBlock = pushSuccess;
}





















@end
