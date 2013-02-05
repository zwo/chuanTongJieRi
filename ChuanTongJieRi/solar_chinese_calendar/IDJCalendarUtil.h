//
//  日历的工具类
//  IDJCalendarUtil.h
//
//  Created by Lihaifeng on 11-11-30, QQ:61673110.
//  Copyright (c) 2011年 www.idianjing.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CHINESE_MONTH_NORMAL @"a"//农历的状态下，month字段中存储a-1，a表示非闰月
#define CHINESE_MONTH_LUNAR @"b"//农历的状态下，month字段中存储b-1，b表示闰月

@interface IDJCalendarUtil : NSObject
//农历转公历，这里只是借助NSDateComponents存放转换后的年月日
+ (NSDateComponents *)toSolarDateWithYear:(NSUInteger)_year month:(NSString *)_month day:(NSUInteger)_day;
//公历转农历，这里只是借助NSDateComponents存放转换后的年月日
+ (NSDateComponents *)toChineseDateWithYear:(NSUInteger)_year month:(NSString *)_month day:(NSUInteger)_day;
//依据公历日期计算星期
+ (int)weekDayWithSolarYear:(NSUInteger)_year month:(NSString *)_month day:(NSUInteger)_day;
//依据农历日期计算星期
+ (int)weekDayWithChineseYear:(NSUInteger)_year month:(NSString *)_month day:(NSUInteger)_day;
//这里把a-1、b-1的月份转换为1 - 13
+ (NSUInteger)monthFromMineToCppWithYear:(NSUInteger)_year month:(NSString *)_month;
//这里把1 - 13的月份转换为a-1、b-1
+ (NSString *)monthFromCppToMineWithYear:(NSUInteger)_year month:(NSUInteger)_month;
//通过甲子年份获取生肖
+ (NSString *)animalWithJiazi:(NSUInteger)jiazi;
//通过年份获取农历的年代和甲子年份，对C++里的ChineseCalendarDB::GetEraAndYearOfLunar()的再次封装，避免视图层介入C++的API
+ (void)jiaziWithYear:(NSUInteger)_year outEra:(int *)era outJiazi:(int *)jiazi;
//获取某一年的24个节气，数组中的每一项为1-6-小寒，1-6为农历正月初六
+ (NSMutableDictionary *)jieqiWithYear:(NSUInteger)_year;

/*
 *查询农历某年某月的天数
 * @param year: 要查询的年份，有效取值范围1901~2050
 * @param month: 要查询的月份，有效取值范围为1~12或1~13（有闰月）
 * @return: 返回该月的天数（30或29）
 * This function was added by ZHOU Weiou
 */
+ (NSUInteger)LunarMonthDaysWithYear:(NSUInteger)_year month:(NSUInteger)_month;

//获取某一年的24个节气，数组中的每一项为1-6-小寒，1-6为农历正月初六
//返回对应的阳历NSDate
//This function was added by ZHOU Weiou
+ (NSMutableDictionary *)jieqiWithGregYear:(NSUInteger)_year;
@end