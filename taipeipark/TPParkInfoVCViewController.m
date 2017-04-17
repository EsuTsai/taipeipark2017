//
//  TPParkInfoVCViewController.m
//  taipeipark
//
//  Created by Esu Tsai on 2017/4/12.
//  Copyright © 2017年 Esu Tsai. All rights reserved.
//

#import "TPParkInfoVCViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>

@interface TPParkInfoVCViewController ()

@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) NSDictionary *parkInfo;
@property (nonatomic, strong) UIImageView *parkImg;
@property (nonatomic, strong) UILabel *parkName;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *openTime;
@property (nonatomic, strong) UILabel *introduction;
@property (nonatomic, strong) UIScrollView *relateLocation;

@end

@implementation TPParkInfoVCViewController

- (id)initWithParkInfo:(NSDictionary *)parkInfo
{
    self = [super init];
    if(self){
        _parkInfo = parkInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareView
{
    _baseScrollView                 = [[UIScrollView alloc] init];
    _baseScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseScrollView];
    
    //圖片
    _parkImg               = [[UIImageView alloc] init];
    _parkImg.contentMode   = UIViewContentModeScaleAspectFill;
    _parkImg.clipsToBounds = YES;
    [_parkImg sd_setImageWithURL:[_parkInfo objectForKey:@"Image"]
                placeholderImage:[UIImage imageNamed:@"img-default.png"] completed:nil];
    [_baseScrollView addSubview:_parkImg];
    
    //Park Name
    _parkName           = [[UILabel alloc] init];
    _parkName.text      = [_parkInfo objectForKey:@"ParkName"];
    _parkName.textColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.00];
    _parkName.font      = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    [_baseScrollView addSubview:_parkName];
    
    //Name
    _name           = [[UILabel alloc] init];
    _name.text      = [_parkInfo objectForKey:@"Name"];
    _name.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
    _name.font      = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
    [_baseScrollView addSubview:_name];
    
    //開放時間
    _openTime           = [[UILabel alloc] init];
    _openTime.text      = [NSString stringWithFormat:@"開放時間：%@",[_parkInfo objectForKey:@"OpenTime"]];
    _openTime.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
    _openTime.font      = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
    [_baseScrollView addSubview:_openTime];
    
    //Introduction
    _introduction               = [[UILabel alloc] init];
    _introduction.numberOfLines = 0;
    _introduction.text          = [_parkInfo objectForKey:@"Introduction"];
    _introduction.textColor     = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
    _introduction.font          = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    [_baseScrollView addSubview:_introduction];
    
    [self setupConstraints];
    
    if([[_parkInfo objectForKey:@"relateLocation"] count] > 0){
        //處理相關景點
        [self prepareRelateLocationView];
        [_baseScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_relateLocation.mas_bottom).offset(20);
        }];
    }else{
        [_baseScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_introduction.mas_bottom).offset(20);
        }];
    }
    
}

- (void)prepareRelateLocationView
{
    UILabel *relateLabel  = [[UILabel alloc] init];
    relateLabel.text      = @"相關景點";
    relateLabel.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
    relateLabel.font      = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
    [_baseScrollView addSubview:relateLabel];
    
    _relateLocation                                = [[UIScrollView alloc] init];
    _relateLocation.showsHorizontalScrollIndicator = NO;
    
    UIButton *lastBtn = nil;
    for (int i = 0; i < [[_parkInfo objectForKey:@"relateLocation"] count]; i++) {
        NSDictionary *relateDic = [[_parkInfo objectForKey:@"relateLocation"] objectAtIndex:i];
        
        UIButton *relateBtn = [[UIButton alloc] init];
        relateBtn.tag       = i;
        [relateBtn addTarget:self action:@selector(openRelateLocationVC:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *relateImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [relateImg sd_setImageWithURL:[relateDic objectForKey:@"Image"]
                    placeholderImage:[UIImage imageNamed:@"img-default.png"] completed:nil];
        [relateBtn addSubview:relateImg];
        
        UILabel *relateName  = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 80, 20)];
        relateName.text      = [relateDic objectForKey:@"Name"];
        relateName.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
        relateName.font      = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
        [relateBtn addSubview:relateName];
        
        if(lastBtn){
            relateBtn.frame = CGRectMake(lastBtn.frame.origin.x + lastBtn.frame.size.width + 8, 0, 80, 110);
        }else{
            relateBtn.frame = CGRectMake(20, 0, 80, 110);
        }
        lastBtn = relateBtn;
        [_relateLocation addSubview:relateBtn];
    }
    
    _relateLocation.contentSize = CGSizeMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+20, lastBtn.frame.size.height);
    [_baseScrollView addSubview:_relateLocation];
    
    [relateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_introduction.mas_bottom).offset(15);
        make.left.right.equalTo(_parkName);
        make.height.equalTo(@20);
    }];
    
    [_relateLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(relateLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@110);
    }];

}

- (void)setupConstraints {
    [_baseScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [_parkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_baseScrollView.mas_top);
        make.height.equalTo(@300);
    }];
    
    [_parkName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_parkImg.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_parkName.mas_bottom).offset(10);
        make.left.right.equalTo(_parkName);
    }];
    
    [_openTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_name.mas_bottom).offset(15);
        make.left.right.equalTo(_parkName);
    }];
    
    [_introduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_openTime.mas_bottom).offset(15);
        make.left.right.equalTo(_parkName);
    }];
}

- (void)openRelateLocationVC:(UIButton *)sender
{
    //到相關景點的資訊頁面
    NSDictionary *relateDic = [[_parkInfo objectForKey:@"relateLocation"] objectAtIndex:sender.tag];
    TPParkInfoVCViewController *parkInfoVC = [[TPParkInfoVCViewController alloc] initWithParkInfo:relateDic];
    [self.navigationController pushViewController:parkInfoVC animated:YES];
}

@end
