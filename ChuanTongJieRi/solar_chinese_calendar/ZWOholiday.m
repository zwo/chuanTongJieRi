//
//  ZWOholiday.m
//  ChuanTongJieRi
//
//  Created by Weiou Zhou on 12-11-4.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import "ZWOholiday.h"

@implementation ZWOholiday
@synthesize name,nongliMonth,nongliDay;

- (void)dealloc
{
    [name release];
    [super dealloc];
}

+ (ZWOholiday *)holidayNamed:(NSString *)aName Nongli:(NSString *)aNongli
{
    return [[[ZWOholiday alloc] initWithName:aName Nongli:aNongli] autorelease];
}

- (id)initWithName:(NSString *)aName Nongli:(NSString *)aNongli
{
    if (self=[super init]) {
        name=[aName copy];
        NSArray *tempArray=[aNongli componentsSeparatedByString:@"-"];
        nongliMonth=[[tempArray objectAtIndex:0] intValue];
        nongliDay=[[tempArray objectAtIndex:1] intValue];
    }
    return self;
}

@end
