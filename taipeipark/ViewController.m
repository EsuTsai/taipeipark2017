//
//  ViewController.m
//  taipeipark
//
//  Created by Esu Tsai on 2017/4/12.
//  Copyright © 2017年 Esu Tsai. All rights reserved.
//

#import "ViewController.h"
#import "TPDataRequest.h"
#import "TPParkInfoVCViewController.h"
#import "TPParkTableViewCell.h"
#import "QFLoadingView.h"
#import <Masonry.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *resultParkData;
@property (nonatomic, strong) UITableView *parkTableView;
@property (nonatomic, strong) QFLoadingView *loadingView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self prepareView];
    [self prepareData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    _resultParkData = @[];
}

- (void)prepareView
{
    _parkTableView                    = [[UITableView alloc] init];
    _parkTableView.delegate           = self;
    _parkTableView.dataSource         = self;
    _parkTableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    _parkTableView.estimatedRowHeight = 80.f;
    _parkTableView.rowHeight          = UITableViewAutomaticDimension;
    [self.view addSubview:_parkTableView];
    
    [_parkTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    _loadingView = [[QFLoadingView alloc] init];
    
    _refreshControl                 = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor colorWithRed:0.92 green:0.96 blue:0.96 alpha:1.00];
    _refreshControl.tintColor       = [UIColor lightGrayColor];
    [_refreshControl addTarget:self
                       action:@selector(prepareData)
             forControlEvents:UIControlEventValueChanged];
    [_parkTableView addSubview:_refreshControl];
}

- (void)prepareData
{
    if(!_refreshControl.refreshing){
        [_loadingView startHud:self.view];
    }
    
    NSString *apiUrl = @"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=bf073841-c734-49bf-a97f-3757a6013812";
    
    [[TPDataRequest sharedInstance] apiGetWithPath:apiUrl params:nil success:^(NSArray *successData) {
        //資料連線處理成功
        [self initData];
        _resultParkData = successData;
        [_parkTableView reloadData];
        
    } failure:^(NSDictionary *errorData) {
        //連線失敗alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[errorData objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } completion:^{
        [_loadingView stopHud];
        if (_refreshControl) {
            [_refreshControl endRefreshing];
        }
    }];
}

#pragma mark - UITableViewDataSourece
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; //optional
{
    return [_resultParkData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TPParkTableViewCell";
    
    TPParkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell                = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setContent:[_resultParkData objectAtIndex:indexPath.section]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    sectionView.backgroundColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.00];
    
    UILabel *parkSectionName        = [[UILabel alloc] init];
    parkSectionName.backgroundColor = [UIColor whiteColor];
    parkSectionName.text            = [NSString stringWithFormat:@" %@",[[_resultParkData objectAtIndex:section] objectForKey:@"ParkName"]];
    parkSectionName.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
    parkSectionName.font      = [UIFont fontWithName:@"AvenirNext-Medium" size:12];

    [sectionView addSubview:parkSectionName];
    
    [parkSectionName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView.mas_left).offset(10);
        make.right.top.bottom.equalTo(sectionView);
        
    }];
    
    return sectionView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_refreshControl.refreshing){
        return;
    }
    TPParkInfoVCViewController *parkInfoVC = [[TPParkInfoVCViewController alloc] initWithParkInfo:[_resultParkData objectAtIndex:indexPath.section]];
    [self.navigationController pushViewController:parkInfoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
    
}
@end
