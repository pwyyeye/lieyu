//
//  LYYUChooseLocationViewController.m
//  lieyu
//
//  Created by 狼族 on 16/4/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYYUChooseLocationViewController.h"

@implementation LYYUChooseLocationViewController
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    if(indexPath.row == 0){
        cell.textLabel.text = [NSString stringWithFormat:@"%@",((AMapPOI *)poisArray[0]).city];
        cell.detailTextLabel.text = @"";
    }else{
        int i = (int)indexPath.row;
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",((AMapPOI *)poisArray[i-1]).city,((AMapPOI *)poisArray[i-1]).district,((AMapPOI *)poisArray[i-1]).address];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",((AMapPOI *)poisArray[i-1]).city,((AMapPOI *)poisArray[i-1]).district,((AMapPOI *)poisArray[i-1]).name];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row == 0){
        [self.delegate getLocationInfo:cell.textLabel.text Location:cell.textLabel.text];
    }else{
        [self.delegate getLocationInfo:((AMapPOI *)poisArray[0]).city Location:cell.textLabel.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
