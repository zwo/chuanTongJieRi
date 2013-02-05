/*
 * Created by Weiou Zhou on 12-11-3.
 * Adapted from Kal Cal
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal.h"
#import "ZWOChineseCalendarUtility.h"
#import "ZWOSearchPageController.h"
#import "ZWODatePageController.h"


/*
 *    HolidaySqliteDataSource
 *    ---------------------
 *
 *  This example data source retrieves world holidays
 *  from an Sqlite database stored locally in the application bundle.
 *  When the presentingDatesFrom:to:delegate message is received,
 *  it queries the database for the specified date range and
 *  instantiates a Holiday object for each row in the result set.
 *
 */
@interface HolidaySqliteDataSource : NSObject <KalDataSource,ZWOSearchPageDataSource,UITableViewDelegate>
{
  NSMutableArray *items;//to put holiday NSDates into this array to be marked in cal
  NSMutableArray *holidays;
}

@property (nonatomic, strong) NSArray *chineseYears;
@property (nonatomic, strong) NSArray *chineseMonths;
@property (nonatomic, strong) NSArray *chineseDays;
@property (nonatomic, assign) NSUInteger gregYear;//update solar terms wrt gregYear.
@property (nonatomic, strong) NSDictionary *jieqiDic;
@property (nonatomic, copy) NSDate *dateSelected;
@property (nonatomic, assign) ZWODatePageController *datePageControllerRef;

+ (HolidaySqliteDataSource *)dataSource;
- (NSString *)generateNongliExprwithYear:(NSUInteger)year_ month:(NSString *)month_ day:(NSUInteger)day_;
- (void)fetchHolidaysFromSqliteWithMonth:(NSString *)month_ day:(NSUInteger)day_;
- (void)fetchRecordsRangeForMonthsFromSqlite:(NSString *)lunarMonthRangeString withYear:(NSUInteger)year;
- (BOOL)isJieqiWithString:(NSString **)stringRef fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end
