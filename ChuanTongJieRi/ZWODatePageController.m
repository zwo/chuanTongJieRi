//
//  ZWODatePageController.m
//  ChuanTongJieRi
//
//  Created by Zhou Weiou on 12-11-24.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import "ZWODatePageController.h"
#define colorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define kFutureLabel 224

@interface ZWODatePageController ()
- (NSString *)gongliTextWithDate:(NSDate *)aDate;
@end

@implementation ZWODatePageController
@synthesize isFromCalPage,holidayName,holidayNongliExpression,eventDate;

- (void)dealloc
{
    [holidayNongliExpression release];
    [holidayName release];
    [eventDate release];
    [holidayName release];
    [gongliLabel release];
    [nongliLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"taskBackground"]];
    
    //create label
    holidayNameLabel=[[FXLabel alloc] init];
    holidayNameLabel.frame = CGRectMake(85, 30, 140, 95-30);
    holidayNameLabel.backgroundColor = [UIColor clearColor];
    holidayNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:35];
    holidayNameLabel.text = @"第1种效果";
    holidayNameLabel.shadowColor = [UIColor blackColor];
    holidayNameLabel.shadowOffset = CGSizeZero;
    holidayNameLabel.shadowBlur = 20.0f;
    holidayNameLabel.innerShadowColor = [UIColor yellowColor];
    holidayNameLabel.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    holidayNameLabel.gradientStartColor = [UIColor redColor];
    holidayNameLabel.gradientEndColor = [UIColor yellowColor];
    holidayNameLabel.gradientStartPoint = CGPointMake(0.0f, 0.5f);
    holidayNameLabel.gradientEndPoint = CGPointMake(1.0f, 0.5f);
    holidayNameLabel.textAlignment=NSTextAlignmentCenter;
    holidayNameLabel.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:holidayNameLabel];
    
    FXLabel * secondLabel = [[FXLabel alloc] init];
    secondLabel.frame = CGRectMake(95, 92, 215-95, 110-82);
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.minimumFontSize=8;
    secondLabel.text = @"将会出现在";
    secondLabel.textColor = colorWithRGB(255, 52, 131);
    secondLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    secondLabel.shadowOffset = CGSizeMake(0.0f, 5.0f);
    secondLabel.shadowBlur = 5.0f;
    secondLabel.adjustsFontSizeToFitWidth=YES;
    secondLabel.textAlignment=NSTextAlignmentCenter;
    secondLabel.tag=kFutureLabel;
    [self.view addSubview:secondLabel];
    [secondLabel release];
    
    gongliLabel=[[FXLabel alloc] init];
    gongliLabel.frame = CGRectMake(72, 126, 238-72, 177-126);
    gongliLabel.backgroundColor = [UIColor clearColor];
//    gongliLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:35];
    gongliLabel.minimumFontSize=8;
    gongliLabel.text = @"第2种效果";
    gongliLabel.shadowColor = [UIColor blackColor];
    gongliLabel.shadowOffset = CGSizeZero;
    gongliLabel.shadowBlur = 20.0f;
    gongliLabel.innerShadowColor = [UIColor yellowColor];
    gongliLabel.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    gongliLabel.gradientStartColor = [UIColor redColor];
    gongliLabel.gradientEndColor = [UIColor yellowColor];
    gongliLabel.gradientStartPoint = CGPointMake(0.0f, 0.5f);
    gongliLabel.gradientEndPoint = CGPointMake(1.0f, 0.5f);
    gongliLabel.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:gongliLabel];
    
    nongliLabel=[[FXLabel alloc] init];
    nongliLabel.frame = CGRectMake(72, 181, 238-72, 230-181);
    nongliLabel.backgroundColor = [UIColor clearColor];
//    nongliLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:35];
    nongliLabel.minimumFontSize=8;
    nongliLabel.text = @"第3种效果";
    nongliLabel.shadowColor = [UIColor blackColor];
    nongliLabel.shadowOffset = CGSizeZero;
    nongliLabel.shadowBlur = 20.0f;
    nongliLabel.innerShadowColor = [UIColor yellowColor];
    nongliLabel.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    nongliLabel.gradientStartColor = [UIColor redColor];
    nongliLabel.gradientEndColor = [UIColor yellowColor];
    nongliLabel.gradientStartPoint = CGPointMake(0.0f, 0.5f);
    nongliLabel.gradientEndPoint = CGPointMake(1.0f, 0.5f);
    nongliLabel.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:nongliLabel];
    
    FXLabel * eventLabel = [[FXLabel alloc] init];
    eventLabel.frame = CGRectMake(193, 250, 320-193, 40);
    eventLabel.backgroundColor = [UIColor clearColor];
    eventLabel.minimumFontSize=8;
    eventLabel.text = @"把此节日加入提醒";
    eventLabel.textColor = [UIColor yellowColor];
    eventLabel.shadowColor = colorWithRGB(178, 147, 42);
    eventLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);
    eventLabel.shadowBlur = 1.0f;
    eventLabel.innerShadowColor = colorWithRGB(178, 147, 42);
    eventLabel.innerShadowOffset = CGSizeMake(0.5f, 0.5f);
    eventLabel.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:eventLabel];
    [eventLabel release];
    
    FXLabel * baiduLabel = [[FXLabel alloc] init];
    baiduLabel.frame = CGRectMake(193, 340, 320-193, 40);
    baiduLabel.minimumFontSize=8;
    baiduLabel.backgroundColor = [UIColor clearColor];
    baiduLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:35];
    baiduLabel.text = @"百度知道相关词条";
    baiduLabel.textColor = [UIColor yellowColor];
    baiduLabel.shadowColor = colorWithRGB(178, 147, 42);
    baiduLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);
    baiduLabel.shadowBlur = 1.0f;
    baiduLabel.innerShadowColor = colorWithRGB(178, 147, 42);
    baiduLabel.innerShadowOffset = CGSizeMake(0.5f, 0.5f);
    baiduLabel.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:baiduLabel];
    [baiduLabel release];
    
    UIImage *buttonBulb1=[UIImage imageNamed:@"buttonBulb1"];
    UIImage *buttonBulb2=[UIImage imageNamed:@"buttonBulb2"];
    UIImage *buttonClock1=[UIImage imageNamed:@"buttonClock1"];
    UIImage *buttonClock2=[UIImage imageNamed:@"buttonClock2"];
    UIButton *buttonBaidu=[UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *buttonEvent=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonEvent.frame=CGRectMake(124,238, 60, 60);
    buttonBaidu.frame=CGRectMake(124, 320, 60, 60);
    [buttonEvent setImage:buttonClock1 forState:UIControlStateNormal];
    [buttonEvent setImage:buttonClock2 forState:UIControlStateHighlighted];
    [buttonBaidu setImage:buttonBulb1 forState:UIControlStateNormal];
    [buttonBaidu setImage:buttonBulb2 forState:UIControlStateHighlighted];
    
    [buttonEvent addTarget:self action:@selector(addEventForHoliday) forControlEvents:UIControlEventTouchUpInside];
    [buttonBaidu addTarget:self action:@selector(gotoBaidu) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonEvent];
    [self.view addSubview:buttonBaidu];
}

- (void)viewDidUnload
{
    holidayName=nil;
    gongliLabel=nil;
    nongliLabel=nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    holidayNameLabel.text=holidayName;
    nongliLabel.text=[NSString stringWithFormat:@"农历%@",holidayNongliExpression];
    gongliLabel.text=[self gongliTextWithDate:eventDate];
    FXLabel *futurelabel=(FXLabel *)[self.view viewWithTag:kFutureLabel];
    futurelabel.hidden=isFromCalPage;
}

- (NSString *)gongliTextWithDate:(NSDate *)aDate
{
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp=[cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:aDate];
    [cal release];
    return [NSString stringWithFormat:@"公历%d年%d月%d日",comp.year,comp.month,comp.day];
}

- (void)addEventForHoliday
{
    EKEventStore *eventStore=[[EKEventStore alloc] init];
    EKEvent *event=[EKEvent eventWithEventStore:eventStore];
    //endDate is 1 day = 60x60x24 seconds = 86400 seconds
    //to prevent it from across a day, I set it to 86000
    NSDate *endDate=[NSDate dateWithTimeInterval:86000 sinceDate:eventDate];
    event.title=holidayName;
    event.startDate=eventDate;
    event.endDate=endDate;
    event.allDay=YES;
    //    event.timeZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    //    NSError *err;
    //    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    EKEventEditViewController *controller=[[EKEventEditViewController alloc] init];
    controller.eventStore=eventStore;
    controller.editViewDelegate=self;
    controller.event=event;    
    [self presentModalViewController:controller animated:YES];
    [eventStore release];
    [controller release];
}

- (void)gotoBaidu
{
    UIAlertView *av=[[UIAlertView alloc] initWithTitle:@"提示" message:@"将用浏览器打开百度知道" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
    [av show];
    [av release];    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex) {
        NSString *urlString=[NSString stringWithFormat:@"http://zhidao.baidu.com/search?word=%@",holidayName];
        NSString *escaped=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
    }
}

#pragma mark - EKEventEditViewDlegate
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    if (action != EKEventEditViewActionSaved) {
        [controller dismissModalViewControllerAnimated:YES];
        return;
    }
    [controller dismissModalViewControllerAnimated:YES];
    UIAlertView *av=[[UIAlertView alloc] initWithTitle:@"提示" message:@"该节日已加入提醒中，可在系统日历中编辑" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [av show];
    [av release];
}


@end
