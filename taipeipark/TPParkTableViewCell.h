//
//  TPParkTableViewCell.h
//  taipeipark
//
//  Created by Esu Tsai on 2017/4/12.
//  Copyright © 2017年 Esu Tsai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPParkTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *parkName;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIImageView *parkImg;
@property (nonatomic, strong) UILabel *introduction;
- (void)setContent:(id)data;

@end
