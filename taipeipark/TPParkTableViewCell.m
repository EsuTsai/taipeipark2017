//
//  TPParkTableViewCell.m
//  taipeipark
//
//  Created by Esu Tsai on 2017/4/12.
//  Copyright © 2017年 Esu Tsai. All rights reserved.
//

#import "TPParkTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>

@implementation TPParkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(id)data
{
    if(![data isKindOfClass:[NSDictionary class]]){
        return;
    };
    
    //圖片
    _parkImg                    = [[UIImageView alloc] init];
    _parkImg.contentMode        = UIViewContentModeScaleAspectFill;
    _parkImg.clipsToBounds      = YES;
    _parkImg.layer.cornerRadius = 32.0f;
    [_parkImg sd_setImageWithURL:[data objectForKey:@"Image"]
                placeholderImage:[UIImage imageNamed:@"img-default.png"] completed:nil];
    [self.contentView addSubview:_parkImg];
    
    //Park Name
    _parkName           = [[UILabel alloc] init];
    _parkName.text      = [data objectForKey:@"ParkName"];
    _parkName.textColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.00];
    _parkName.font      = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    [self.contentView addSubview:_parkName];
    
    //Name
    _name           = [[UILabel alloc] init];
    _name.text      = [data objectForKey:@"Name"];
    _name.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
    _name.font      = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
    [self.contentView addSubview:_name];
    
    //Indroduction
    _introduction               = [[UILabel alloc] init];
    _introduction.numberOfLines = 0;
    _introduction.text          = [data objectForKey:@"Introduction"];
    _introduction.textColor     = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
    _introduction.font          = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    [self.contentView addSubview:_introduction];
    
    [self updateViewConstraints];
    
}

- (void)updateViewConstraints
{
    [_parkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.height.equalTo(@64);
    }];
    
    [_parkName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_parkImg.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.equalTo(_parkImg.mas_centerY);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_parkName);
        make.top.equalTo(_parkName.mas_bottom).offset(2);
    }];
    
    [_introduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_parkImg.mas_bottom).offset(10);
        make.left.equalTo(_parkImg.mas_left);
        make.right.equalTo(_parkName.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}
@end
