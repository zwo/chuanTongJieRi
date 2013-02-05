//
//  ZWOSearchPageController.h
//  ChuanTongJieRi
//
//  Created by Zhou Weiou on 12-11-17.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWODatePageController.h"

@protocol ZWOSearchPageDataSource <NSObject>

@optional
- (NSString *)nongliExpressionForDatePageWithYear:(NSUInteger)aYear month:(NSUInteger)aMonth day:(NSUInteger)aDay;
@end

@interface ZWOSearchPageController : UITableViewController<UISearchBarDelegate>

@property (nonatomic, assign) id<ZWOSearchPageDataSource> delegate;
@property (nonatomic, assign) ZWODatePageController *datePageControllerRef;
@property (nonatomic, strong) NSDictionary *allHolidaysDic;
@property (nonatomic, strong) NSMutableArray *names;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
