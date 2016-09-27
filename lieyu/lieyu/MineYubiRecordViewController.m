//
//  MineYubiRecordViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineYubiRecordViewController.h"
#import "ZSTiXianRecordMonthTableViewCell.h"
#import "ZSTiXianRecordTableViewCell.h"
#import "ZSManageHttpTool.h"
#import "ZSTiXianRecord.h"
#import "MJRefresh.h"

#define ZSTiXianRecordMonthTableViewCellID @"ZSTiXianRecordMonthTableViewCell"
#define ZSTiXianRecordTableViewCellID @"ZSTiXianRecordTableViewCell"
@interface MineYubiRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _pageStart;
    NSInteger _pageSize;
    NSMutableArray *_beforeDataArray,*_dataArray;
}

@property (strong, nonatomic) UITableView *tableview;

@end

@implementation MineYubiRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"充值记录";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _beforeDataArray = [[NSMutableArray alloc]init];
    _pageSize = 20;
    _pageStart = 0;
    [self setupTableViewRefresh];
    [self getData];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [self.view addSubview:_tableview];
    [_tableview registerNib:[UINib nibWithNibName:ZSTiXianRecordMonthTableViewCellID bundle:nil] forCellReuseIdentifier:ZSTiXianRecordMonthTableViewCellID];
    [_tableview registerNib:[UINib nibWithNibName:ZSTiXianRecordTableViewCellID bundle:nil] forCellReuseIdentifier:ZSTiXianRecordTableViewCellID];
}

- (void)setupTableViewRefresh{
    __weak __typeof(self) weakSelf = self;
    _tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _pageStart = 0;
        [weakSelf getData];
    }];
    MJRefreshGifHeader *header=(MJRefreshGifHeader *)_tableview.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    _tableview.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _pageStart ++;
        [weakSelf getData];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)_tableview.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)getData{
    NSDictionary *paraDic = @{@"start":[NSString stringWithFormat:@"%ld",_pageStart * _pageSize],@"limit":[NSString stringWithFormat:@"%ld",_pageSize]};
    
    [[ZSManageHttpTool shareInstance] getPersonTiXianRecordWithParams:paraDic complete:^(NSArray *tempArray) {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        for (ZSTiXianRecord *model in tempArray) {
            if ([model.wtype integerValue] == 4) {
                [dataArray addObject:model];
            }
        }
        if(_pageStart == 0) _beforeDataArray = dataArray.mutableCopy;
        else [_beforeDataArray addObjectsFromArray:dataArray];
        NSMutableArray *dateMutablearray = [@[] mutableCopy];
        NSMutableArray *array = [NSMutableArray arrayWithArray:_beforeDataArray];
        for (int i = 0; i < array.count; i ++) {
            ZSTiXianRecord *ZSTiXianRM = array[i];
            NSArray *strArray = [ZSTiXianRM.create_date componentsSeparatedByString:@"-"];
            if(strArray.count < 2) continue;
            NSString *string = [NSString stringWithFormat:@"%@-%@",strArray.firstObject,strArray[1]];
            NSMutableArray *tempArray = [@[] mutableCopy];
            [tempArray addObject:ZSTiXianRM];
            CGFloat tiXianSum = ZSTiXianRM.amount.floatValue;
            CGFloat receiveddTiXianSum = ZSTiXianRM.checkMark.integerValue == 0 ? 0 : ZSTiXianRM.amount.floatValue;
            for (int j = i+1; j < array.count; j ++) {
                ZSTiXianRecord *ZSTiXianRM2 = array[j];
                NSArray *strArray2 =  [ZSTiXianRM2.create_date componentsSeparatedByString:@"-"];
                if(strArray2.count < 2) continue;
                NSString *jstring = [NSString stringWithFormat:@"%@-%@",strArray2.firstObject,strArray2[1]];
                if([string isEqualToString:jstring]){
                    [tempArray addObject:ZSTiXianRM2];
                    [array removeObjectAtIndex:j];
                    j = j -1;
                    tiXianSum += ZSTiXianRM2.amount.floatValue;
                    receiveddTiXianSum += ZSTiXianRM2.checkMark.integerValue == 0 ? 0 : ZSTiXianRM2.amount.floatValue;
                }
            }
            ZSTiXianRecord *tiXianR = [[ZSTiXianRecord alloc]init];
            tiXianR.month = string;
            tiXianR.amountSum = [NSString stringWithFormat:@"%.2f",tiXianSum];
            tiXianR.receivedAmountSum = [NSString stringWithFormat:@"%.2f",receiveddTiXianSum];
            [tempArray insertObject:tiXianR atIndex:0];
            [dateMutablearray addObject:tempArray];
        }
        
        _dataArray = dateMutablearray;
        [_tableview reloadData];
        [_tableview.mj_header endRefreshing];
        if(dataArray.count == 0) [_tableview.mj_footer endRefreshingWithNoMoreData];
        else [_tableview.mj_footer endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _dataArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = _dataArray[indexPath.section];
    ZSTiXianRecord *tiXianRecord = array[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            ZSTiXianRecordMonthTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:ZSTiXianRecordMonthTableViewCellID forIndexPath:indexPath];
            NSArray *strArray = [tiXianRecord.month componentsSeparatedByString:@"-"];
            if (strArray.count == 2) {
                cell.label_time.text = [NSString stringWithFormat:@"%@年%@月",strArray.firstObject,strArray[1]];
            }
            cell.label_tiXianSum.text = [NSString stringWithFormat:@"共充值:¥%@", tiXianRecord.amountSum];
            cell.label_receivedSum.text = [NSString stringWithFormat:@"已到账:¥%@",tiXianRecord.receivedAmountSum];
            return cell;
        }
            break;
            
        default:{
            ZSTiXianRecordTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:ZSTiXianRecordTableViewCellID forIndexPath:indexPath];
            cell.chongzhiR = tiXianRecord;
            return cell;
        }
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 46;
            break;
            
        default:
            return 78;
            break;
    }
}


@end
