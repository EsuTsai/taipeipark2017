//
//  QFLoadingView.m
//
//  Created by Esu Tsai on 2016/2/21.
//  Copyright © 2016年 Esu Tsai. All rights reserved.
//

#import "QFLoadingView.h"

@implementation QFLoadingView

- (id)init {
    self = [super init];
    if (self != nil) {
        self.hasBackground = NO;
    }
    
    return self;
}

- (void)startHud:(UIView *) contentView
{
    spinner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    spinner.lineWidth = 1.5f;
    spinner.tintColor = [UIColor colorWithRed:0.31 green:0.77 blue:0.81 alpha:1];
    [spinner startAnimating];
    
    hud            = [MBProgressHUD showHUDAddedTo:contentView animated:YES];
    hud.square     = YES;
    hud.mode       = MBProgressHUDModeCustomView;
    hud.customView = spinner;
    hud.color      = [UIColor clearColor];
    hud.labelText  = @"讀取中...";
    hud.labelColor = [UIColor colorWithRed:0.31 green:0.77 blue:0.81 alpha:1];
    hud.margin     = 12.0f;
    
    hud.labelFont     = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    if(self.hasBackground){
        hud.color   = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
}

- (void)stopHud
{
    [hud hide:YES];
}

@end
