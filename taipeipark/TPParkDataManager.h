//
//  TPParkDataManager.h
//  taipeipark
//
//  Created by Esu Tsai on 2017/4/12.
//  Copyright © 2017年 Esu Tsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPParkDataManager : NSObject

@property (nonatomic, strong) NSArray *parkList;
@property (nonatomic, strong) NSArray *resultParkList;

- (id)init;

@end
