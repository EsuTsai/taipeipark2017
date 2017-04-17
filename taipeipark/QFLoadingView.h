//
//  QFLoadingView.h
//
//  Created by Esu Tsai on 2016/2/21.
//  Copyright © 2016年 Esu Tsai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import <MMMaterialDesignSpinner.h>

@interface QFLoadingView : UIView
{
    MMMaterialDesignSpinner *spinner;
    MBProgressHUD *hud;
}

@property (nonatomic, assign) BOOL hasBackground;
- (id)init;
- (void)startHud:(UIView *) contentView;
- (void)stopHud;


@end
