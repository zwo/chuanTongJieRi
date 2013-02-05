//
//  ZWOChineseCalendarUtility.m
//  uitest1
//
//  Created by Weiou Zhou on 12-10-28.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import "ZWOChineseCalendarUtility.h"

#define CHINESE_MONTH_NORMAL @"a"//农历的状态下，month字段中存储a-1，a表示非闰月
#define CHINESE_MONTH_LUNAR @"b"//农历的状态下，month字段中存储b-1，b表示闰月
#define numberToString(number) number>9?[NSString stringWithFormat:@"%d",number]:[NSString stringWithFormat:@"0%d",number]

static NSUInteger getLunarMonthNumber(NSString *monthString)
{
    NSArray *tempArray=[monthString componentsSeparatedByString:@"-"];
    if ([[tempArray objectAtIndex:0] isEqualToString:CHINESE_MONTH_NORMAL]) {
        return [[tempArray objectAtIndex:1] intValue];
    } else {
        return 0;
    }
}

@implementation ZWOChineseCalendarUtility

+ (NSDictionary *)toChineseDateWithDate:(NSDate *)aDate
{
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDateComponents *dateComponent=[cal components:CALENDAR_UNIT_FLAGS fromDate:aDate];
    [cal release];
    NSDateComponents *chineseCalComponent=[IDJCalendarUtil toChineseDateWithYear:dateComponent.year month:[NSString stringWithFormat:@"%d",dateComponent.month] day:dateComponent.day];
    //NSLog(@"%d, %@, %d",chineseCalComponent.year, [IDJCalendarUtil monthFromCppToMineWithYear:chineseCalComponent.year month:chineseCalComponent.month],chineseCalComponent.day);
    NSNumber *year=[NSNumber numberWithUnsignedInteger:chineseCalComponent.year];
    NSNumber *day=[NSNumber numberWithUnsignedInteger:chineseCalComponent.day];
    return [NSDictionary dictionaryWithObjectsAndKeys:year,@"year", [IDJCalendarUtil monthFromCppToMineWithYear:chineseCalComponent.year month:chineseCalComponent.month],@"month",day,@"day", nil];
}

+ (NSString *)nongliRangeWithGregDateStart:(NSDate *)startDate End:(NSDate *)endDate
{
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDateComponents *startDateComponent=[cal components:CALENDAR_UNIT_FLAGS fromDate:startDate];
    NSDateComponents *endDateComponent=[cal components:CALENDAR_UNIT_FLAGS fromDate:endDate];
    [cal release];
    NSDateComponents *chineseCalStartComponent=[IDJCalendarUtil toChineseDateWithYear:startDateComponent.year month:[NSString stringWithFormat:@"%d",startDateComponent.month] day:startDateComponent.day];
    NSDateComponents *chineseCalEndComponent=[IDJCalendarUtil toChineseDateWithYear:endDateComponent.year month:[NSString stringWithFormat:@"%d",endDateComponent.month] day:endDateComponent.day];
    NSString *chineseCalStartMonthString=[IDJCalendarUtil monthFromCppToMineWithYear:chineseCalStartComponent.year month:chineseCalStartComponent.month];
    NSString *chineseCalEndMonthString=[IDJCalendarUtil monthFromCppToMineWithYear:chineseCalEndComponent.year month:chineseCalEndComponent.month];
    NSUInteger lunarMonthNumberStart=getLunarMonthNumber(chineseCalStartMonthString);
    NSUInteger lunarMonthNumberEnd=getLunarMonthNumber(chineseCalEndMonthString);
    if (chineseCalStartComponent.year == chineseCalEndComponent.year) {
        if (0==lunarMonthNumberStart && 0==lunarMonthNumberEnd) {
            return @"00-00*00-00";
        }
        if (0==lunarMonthNumberStart) {
            return [NSString stringWithFormat:@"%@-01*%@-%@",numberToString(lunarMonthNumberEnd),numberToString(lunarMonthNumberEnd),numberToString(chineseCalEndComponent.day)];
        }
        if (0==lunarMonthNumberEnd) {
            NSUInteger lunarMonthStartDays=[IDJCalendarUtil LunarMonthDaysWithYear:chineseCalStartComponent.year month:lunarMonthNumberStart];
            return [NSString stringWithFormat:@"%@-%@*%@-%@",numberToString(lunarMonthNumberStart),numberToString(chineseCalStartComponent.day),numberToString(lunarMonthNumberStart),numberToString(lunarMonthStartDays)];
        }
        return [NSString stringWithFormat:@"%@-%@*%@-%@",numberToString(lunarMonthNumberStart),numberToString(chineseCalStartComponent.day),numberToString(lunarMonthNumberEnd),numberToString(chineseCalEndComponent.day)];
    }
    //不存在农历12月或1月是闰月的情况
    NSUInteger lunarMonthStartDays=[IDJCalendarUtil LunarMonthDaysWithYear:chineseCalStartComponent.year month:lunarMonthNumberStart];
    return [NSString stringWithFormat:@"12-%@*12-%@#01-01*01-%@",numberToString(chineseCalStartComponent.day),numberToString(lunarMonthStartDays),numberToString(chineseCalEndComponent.day)];
}

+ (NSDate *)lunarDateToGregDateWithYear:(NSUInteger)lunarYear month:(NSUInteger)lunarMonth day:(NSUInteger)lunarDay
{
    NSString *tempString=[NSString stringWithFormat:@"a-%d",lunarMonth];
    NSDateComponents *gregComponet=[IDJCalendarUtil toSolarDateWithYear:lunarYear month:tempString day:lunarDay];
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
    return [cal dateFromComponents:gregComponet];
}

+ (void)testJieqiWithDate:(NSDate *)aDate
{
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDateComponents *dateComponent=[cal components:CALENDAR_UNIT_FLAGS fromDate:aDate];
    [cal release];
    NSDictionary *dict=[IDJCalendarUtil jieqiWithYear:dateComponent.year];
    NSEnumerator *enumerator=[dict keyEnumerator];
    id key,value;
    while (key=[enumerator nextObject]) {
        value=[dict objectForKey:key];
        NSLog(@"Key:%@, value:%@",key, value);
    }
}

+ (NSMutableDictionary *)jieqiWithGregYear:(NSUInteger)_year
{
    return [IDJCalendarUtil jieqiWithGregYear:_year];
}

@end
