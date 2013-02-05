//
//  ZWOAppDelegate.h
//  ChuanTongJieRi
//
//  Created by Weiou Zhou on 12-11-3.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kal.h"
#import "HolidaySqliteDataSource.h"
#import "ZWOSearchPageController.h"
#import "ZWODatePageController.h"

@interface ZWOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KalViewController *kal;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) HolidaySqliteDataSource *kalDataSource;
@property (strong, nonatomic) ZWOSearchPageController *searchPage;
@property (strong, nonatomic) ZWODatePageController *datePageController;

@end
