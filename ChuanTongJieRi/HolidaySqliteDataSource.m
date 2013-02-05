/*
 * Created by Weiou Zhou on 12-11-3.
 * Adapted from Kal Cal
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <sqlite3.h>
#import "HolidaySqliteDataSource.h"
#import <EventKit/EventKit.h>

#define CHINESE_MONTH_NORMAL @"a"//农历的状态下，month字段中存储a-1，a表示非闰月
#define CHINESE_MONTH_LUNAR @"b"//农历的状态下，month字段中存储b-1，b表示闰月

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface HolidaySqliteDataSource ()
@property (nonatomic, assign) id kalController;
@end

@implementation HolidaySqliteDataSource
@synthesize chineseDays,chineseMonths,chineseYears;
@synthesize gregYear,jieqiDic,dateSelected;
@synthesize kalController, datePageControllerRef;

+ (HolidaySqliteDataSource *)dataSource
{
  return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
  if ((self = [super init])) {
    items = [[NSMutableArray alloc] init];
    holidays = [[NSMutableArray alloc] init];
      self.chineseYears=[NSArray arrayWithObjects:@"甲子", @"乙丑", @"丙寅",	@"丁卯",	@"戊辰",	@"己巳",	@"庚午",	@"辛未",	@"壬申",	@"癸酉",
                         @"甲戌",	@"乙亥",	@"丙子",	@"丁丑", @"戊寅",	@"己卯",	@"庚辰",	@"辛己",	@"壬午",	@"癸未",
                         @"甲申",	@"乙酉",	@"丙戌",	@"丁亥",	@"戊子",	@"己丑",	@"庚寅",	@"辛卯",	@"壬辰",	@"癸巳",
                         @"甲午",	@"乙未",	@"丙申",	@"丁酉",	@"戊戌",	@"己亥",	@"庚子",	@"辛丑",	@"壬寅",	@"癸丑",
                         @"甲辰",	@"乙巳",	@"丙午",	@"丁未",	@"戊申",	@"己酉",	@"庚戌",	@"辛亥",	@"壬子",	@"癸丑",
                         @"甲寅",	@"乙卯",	@"丙辰",	@"丁巳",	@"戊午",	@"己未",	@"庚申",	@"辛酉",	@"壬戌",	@"癸亥", nil];
      self.chineseMonths=[NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", 
                          @"九月", @"十月", @"冬月", @"腊月", nil];
      self.chineseDays=[NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", 
                        @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                        @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
      NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
      [cal setTimeZone:[NSTimeZone defaultTimeZone]];
      NSDateComponents *dateComponent=[cal components:NSYearCalendarUnit fromDate:[NSDate date]];
      [self setGregYear:dateComponent.year];
      [cal release];
  }
  return self;
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dateIdentifier = @"date";
    static NSString *holidayIdentifier=@"holiday";
    int row=[indexPath row];
    UITableViewCell *cell;
    if (row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:dateIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dateIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ([holidays count]>1) {
            cell.textLabel.textColor=[UIColor redColor];
        } else {
            cell.textLabel.textColor=[UIColor blackColor];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:holidayIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:holidayIdentifier] autorelease];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
  
    cell.textLabel.text=(NSString *)[holidays objectAtIndex:row];
  
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [holidays count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        NSString *holidayName=cell.textLabel.text;
        UITableViewCell *cell0=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *holidayNongliExpr=cell0.textLabel.text;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIViewController *controller=(UIViewController *)kalController;
        if (datePageControllerRef != nil) {
            datePageControllerRef.isFromCalPage=YES;
            datePageControllerRef.holidayName=holidayName;
            datePageControllerRef.holidayNongliExpression=holidayNongliExpr;
            datePageControllerRef.eventDate=dateSelected;
            [controller.navigationController pushViewController:datePageControllerRef animated:YES];
        }
        
//        NSString *urlString=[NSString stringWithFormat:@"http://zhidao.baidu.com/search?word=%@",text];
//        NSString *escaped=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
//        [self addEventForHoliday:text];
    }
}

#pragma mark Sqlite access

- (NSString *)databasePath
{
  return [[NSBundle mainBundle] pathForResource:@"database" ofType:@"sqlite"];
}

- (void)fetchHolidaysFromSqliteWithMonth:(NSString *)month_ day:(NSUInteger)day_
{
    sqlite3 *db;
    if (sqlite3_open([[self databasePath] UTF8String], &db) == SQLITE_OK) {
        NSString *monthQuery, *dayQuery;
        if ([month_ length]<2) {
            monthQuery=[NSString stringWithFormat:@"0%@",month_];
        } else {
            monthQuery=month_;
        }
        if (day_<10) {
            dayQuery=[NSString stringWithFormat:@"0%d",day_];
        } else {
            dayQuery=[NSString stringWithFormat:@"%d",day_];
        }
        NSString *dateQuery=[NSString stringWithFormat:@"%@-%@",monthQuery,dayQuery];
        const char *sql = "select name from jieri where date == ?";
		sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, [dateQuery UTF8String], -1, SQLITE_STATIC);
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                [holidays addObject:name];
            }
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_close(db);
}

- (void)fetchRecordsRangeForMonthsFromSqlite:(NSString *)lunarMonthRangeString withYear:(NSUInteger)year
{
    NSArray *tempArray=[lunarMonthRangeString componentsSeparatedByString:@"-"];
    sqlite3 *db;
    if (sqlite3_open([[self databasePath] UTF8String], &db) == SQLITE_OK) {
        NSString *query=[NSString stringWithFormat:@"SELECT DISTINCT month, day from jieri WHERE date between '%@' and '%@';",(NSString *)[tempArray objectAtIndex:0],(NSString *)[tempArray objectAtIndex:1]];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSUInteger lunarMonth=sqlite3_column_int(stmt, 0);
                NSUInteger lunarDay=sqlite3_column_int(stmt, 1);
                [items addObject:[ZWOChineseCalendarUtility lunarDateToGregDateWithYear:year month:lunarMonth day:lunarDay]];
            }
        }
    }
}



#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    [items removeAllObjects];
    NSString *lunarDateRangeString=[ZWOChineseCalendarUtility nongliRangeWithGregDateStart:fromDate End:toDate];
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDateComponents *dateComponent=[cal components:NSYearCalendarUnit fromDate:fromDate];
    [cal release];
    [self setGregYear:dateComponent.year];
    if ([lunarDateRangeString length]>11) {
        NSArray *tempArray=[lunarDateRangeString componentsSeparatedByString:@"#"];
        [self fetchRecordsRangeForMonthsFromSqlite:(NSString *)[tempArray objectAtIndex:0] withYear:dateComponent.year];
        [self fetchRecordsRangeForMonthsFromSqlite:(NSString *)[tempArray objectAtIndex:1] withYear:dateComponent.year];
    } else {
        [self fetchRecordsRangeForMonthsFromSqlite:lunarDateRangeString withYear:dateComponent.year];
    }
    
    //it is very dangerous!
    if (!kalController) {
        kalController=delegate;
    }
    
    [delegate loadedDataSource:self];
  //[self loadHolidaysFrom:fromDate to:toDate delegate:delegate];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{  
    //return [[self holidaysFrom:fromDate to:toDate] valueForKeyPath:@"date"];
    return items;
    //NSArray *emptyArray=[[NSArray alloc] init];
    //return emptyArray;
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
  //[items addObjectsFromArray:[self holidaysFrom:fromDate to:toDate]];
    NSDictionary *wrapper=[ZWOChineseCalendarUtility toChineseDateWithDate:fromDate];
    NSUInteger nongliYear = [[wrapper objectForKey:@"year"] intValue];
    NSString *nongliMonth = [wrapper objectForKey:@"month"];
    NSUInteger nongliDay = [[wrapper objectForKey:@"day"] intValue];
    NSString *nongliExpr=[self generateNongliExprwithYear:nongliYear month:nongliMonth day:nongliDay];
    NSString *tempString;
    if ([self isJieqiWithString:&tempString fromDate:fromDate toDate:toDate]) {
        [holidays addObject:[nongliExpr stringByAppendingFormat:@" %@",tempString]];
    } else {
        [holidays addObject:nongliExpr];
    }    
    NSArray *tempArray=[nongliMonth componentsSeparatedByString:@"-"];
    if ([[tempArray objectAtIndex:0] isEqualToString:CHINESE_MONTH_NORMAL]) {
        [self fetchHolidaysFromSqliteWithMonth:[tempArray objectAtIndex:1] day:nongliDay];
    }
    [self setDateSelected:fromDate];
}

- (void)removeAllItems
{
    [holidays removeAllObjects];
  //[items removeAllObjects];
}


#pragma mark - class functions

- (NSString *)generateNongliExprwithYear:(NSUInteger)year_ month:(NSString *)month_ day:(NSUInteger)day_
{
    NSArray *tempArray=[month_ componentsSeparatedByString:@"-"];
    NSString *NongliMonth;
    if ([[tempArray objectAtIndex:0] isEqualToString:CHINESE_MONTH_NORMAL]) {
        NongliMonth = [self.chineseMonths objectAtIndex:[[tempArray objectAtIndex:1] intValue]-1];
    } else {
        NSString *tempString=[self.chineseMonths objectAtIndex:[[tempArray objectAtIndex:1] intValue]-1];
        NongliMonth=[NSString stringWithFormat:@"閏%@",tempString];
    }
    return [NSString stringWithFormat:@"%@年 %@ %@",[self.chineseYears objectAtIndex:year_%60-4],NongliMonth,[self.chineseDays objectAtIndex:day_-1]];
}

#pragma mark - DatePageDelegate
- (NSString *)nongliExpressionForDatePageWithYear:(NSUInteger)aYear month:(NSUInteger)aMonth day:(NSUInteger)aDay
{
    NSString *NongliMonth=[self.chineseMonths objectAtIndex:aMonth-1];
    return [NSString stringWithFormat:@"%@年 %@ %@",[self.chineseYears objectAtIndex:aYear%60-4],NongliMonth,[self.chineseDays objectAtIndex:aDay-1]];
}

- (void)setGregYear:(NSUInteger)gregYearNew
{
    if (gregYear != gregYearNew) {        
        [self setJieqiDic:[ZWOChineseCalendarUtility jieqiWithGregYear:gregYearNew]];
    }
    gregYear=gregYearNew;
}

- (BOOL)isJieqiWithString:(NSString **)stringRef fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSEnumerator *enumerator=[jieqiDic keyEnumerator];
    id key,value;
    while (key=[enumerator nextObject]) {
        value=[jieqiDic objectForKey:key];
        if (IsDateBetweenInclusive((NSDate *)value, fromDate, toDate)) {
            *stringRef=(NSString *)key;
            return TRUE;
        }
    }
    return FALSE;
}

- (void)dealloc
{
  [items release];
  [holidays release];
    [chineseDays release];
    [chineseMonths release];
    [chineseYears release];
    [jieqiDic release];
    [dateSelected release];
  [super dealloc];
}

@end
