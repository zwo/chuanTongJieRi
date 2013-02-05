//
//  ZWODatePageController.h
//  ChuanTongJieRi
//
//  Created by Zhou Weiou on 12-11-24.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>

#import "FXLabel.h"

@interface ZWODatePageController : UIViewController
<EKEventEditViewDelegate, UIAlertViewDelegate>
{
    FXLabel *holidayNameLabel;
    FXLabel *gongliLabel;
    FXLabel *nongliLabel;
}
@property (nonatomic, assign, getter = isFromCalPage) BOOL isFromCalPage;
@property (nonatomic, copy) NSString *holidayName;
@property (nonatomic, copy) NSString *holidayNongliExpression;
@property (nonatomic, copy) NSDate *eventDate;

- (IBAction)addEventForHoliday;
- (IBAction)gotoBaidu;

@end
