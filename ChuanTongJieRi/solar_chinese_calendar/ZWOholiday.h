//
//  ZWOholiday.h
//  ChuanTongJieRi
//
//  Created by Weiou Zhou on 12-11-4.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWOholiday : NSObject
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSUInteger nongliMonth;
@property (nonatomic, assign, readonly) NSUInteger nongliDay;

+ (ZWOholiday *)holidayNamed:(NSString *)aName Nongli:(NSString *)aNongli;
- (id)initWithName:(NSString *)aName Nongli:(NSString *)aNongli;

@end
