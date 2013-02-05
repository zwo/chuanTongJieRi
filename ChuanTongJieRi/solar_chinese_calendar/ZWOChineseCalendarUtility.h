//
//  ZWOChineseCalendarUtility.h
//  uitest1
//
//  Created by Weiou Zhou on 12-10-28.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDJCalendarUtil.h"

#define CALENDAR_UNIT_FLAGS (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit)

@interface ZWOChineseCalendarUtility : NSObject
+ (NSDictionary *)toChineseDateWithDate:(NSDate *)aDate;
+ (void)testJieqiWithDate:(NSDate *)aDate;

//获取某一年的24个节气，数组中的每一项为1-6-小寒，1-6为农历正月初六
//返回对应的阳历NSDate
//This function was added by ZHOU Weiou
+ (NSMutableDictionary *)jieqiWithGregYear:(NSUInteger)_year;

// to give the lunar cal date range for a given Greg Date range, and return the
// format as "01-32*02-15".
// Two issues to consider: 1, The range is between the two lunar year, will use
// a symbol to split the two ranges as "12-20*12-30#01-01*01-14", NSArray will help
// 2, leap month
+ (NSString *)nongliRangeWithGregDateStart:(NSDate *)startDate End:(NSDate *)endDate;

// to convert a lunar date to greg date
+ (NSDate *)lunarDateToGregDateWithYear:(NSUInteger)lunarYear month:(NSUInteger)lunarMonth day:(NSUInteger)lunarDay;
@end
