//
//  ZWOSearchPageController.m
//  ChuanTongJieRi
//
//  Created by Zhou Weiou on 12-11-17.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import "ZWOSearchPageController.h"
#import "ZWOChineseCalendarUtility.h"
#import <sqlite3.h>

@interface ZWOSearchPageController()
- (void)initializeDatabase;
@property (nonatomic, assign) NSUInteger currentYear;
@property (nonatomic, strong) NSDate *today;
@end

@implementation ZWOSearchPageController
@synthesize allHolidaysDic, names, datePageControllerRef;
@synthesize currentYear,today,delegate;

- (void)dealloc
{
    [allHolidaysDic release];
    [_searchBar release];
    [names release];
    [today release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self initializeDatabase];
        names=[[NSMutableArray alloc] initWithCapacity:200];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initializeDatabase];
        names=[[NSMutableArray alloc] initWithCapacity:200];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.today=[NSDate date];
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp=[cal components:NSYearCalendarUnit fromDate:today];
    self.currentYear=comp.year;
    [cal release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self resetSearch];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - class functions

- (void)initializeDatabase
{
    sqlite3 *db;
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:200];
    if (sqlite3_open([[[NSBundle mainBundle]  pathForResource:@"database" ofType:@"sqlite"] UTF8String], &db) == SQLITE_OK) {
        NSString *query=@"SELECT name, date from jieri;";
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                [dictionary setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)] forKey:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)]];
            }
        }
        else
        {
            NSException *e=[NSException exceptionWithName:@"database" reason:@"problem with sqlite" userInfo:nil];
            @throw e;
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_close(db);
    allHolidaysDic=dictionary;
}

- (void)resetSearch
{
    [names removeAllObjects];
    [names addObjectsFromArray:[allHolidaysDic allKeys]];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *stringsToRemove=[[NSMutableArray alloc] initWithCapacity:200];
    [self resetSearch];
    NSEnumerator *enumerator=[self.allHolidaysDic keyEnumerator];
    NSString *key;
    while (key=[enumerator nextObject]) {
        if ([key rangeOfString:searchTerm].location==NSNotFound) {
            [stringsToRemove addObject:key];
        }
    }
    [self.names removeObjectsInArray:stringsToRemove];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    cell.textLabel.text=(NSString *)[self.names objectAtIndex:[indexPath row]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSString *holidayName=cell.textLabel.text;
    NSString *nongliDate=[allHolidaysDic objectForKey:holidayName];
    NSArray *dateArray=[nongliDate componentsSeparatedByString:@"-"];
    NSString *monthString=[dateArray objectAtIndex:0];
    NSString *dayString=[dateArray objectAtIndex:1];
    NSUInteger yearTemp=currentYear; //to check if the date has passed
    NSDate *dateTemp=[ZWOChineseCalendarUtility lunarDateToGregDateWithYear:yearTemp month:[monthString integerValue] day:[dayString integerValue]];
    if ([dateTemp compare:self.today]==NSOrderedAscending)//if dateTemp isn't today's future
    {
        yearTemp++;
        dateTemp=[ZWOChineseCalendarUtility lunarDateToGregDateWithYear:yearTemp month:[monthString integerValue] day:[dayString integerValue]];
    }
    NSString *nongliExpression=[delegate nongliExpressionForDatePageWithYear:yearTemp month:[monthString integerValue] day:[dayString integerValue]];
    datePageControllerRef.isFromCalPage=NO;
    datePageControllerRef.eventDate=dateTemp;
    datePageControllerRef.holidayName=holidayName;
    datePageControllerRef.holidayNongliExpression=nongliExpression;
    [self.navigationController pushViewController:datePageControllerRef animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    return indexPath;
}

#pragma mark - Search Bar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    [self resetSearch];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]==0) {
        [self resetSearch];
        [self.tableView reloadData];
        return;
    }
    [self handleSearchForTerm:searchText];
    
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
