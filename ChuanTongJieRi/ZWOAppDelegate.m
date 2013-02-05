//
//  ZWOAppDelegate.m
//  ChuanTongJieRi
//
//  Created by Weiou Zhou on 12-11-3.
//  Copyright (c) 2012年 UNSW. All rights reserved.
//

#import "ZWOAppDelegate.h"
#import "Appirater.h"
#import "ZWOGuideView.h"

@interface ZWOAppDelegate ()
- (void)searchButtonPressed;
- (void)zoomButton;
- (void)relaxButton;
- (IBAction)buttonInfo;
@end


@implementation ZWOAppDelegate

@synthesize window = _window;
@synthesize kal, navController, kalDataSource, searchPage, datePageController;

- (void)dealloc
{
    [_window release];
    [kal release];
    [navController release];
    [kalDataSource release];
    [searchPage release];
    [datePageController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"583671375"];
    [Appirater setDaysUntilPrompt:1];//1
    [Appirater setUsesUntilPrompt:3];//3
//    [Appirater setDebug:YES];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    kal=[[KalViewController alloc] init];
    kal.title=@"日历";
    kal.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonInfo)] autorelease];
    
    //configure kal
    kalDataSource = [[HolidaySqliteDataSource alloc] init];
    navController=[[UINavigationController alloc] initWithRootViewController:kal];
    kal.dataSource=kalDataSource;
    kal.delegate=kalDataSource;
    UIImage *buttonSearchRegular=[UIImage imageNamed:@"buttonSearchRegular"];
    UIImage *buttonSearchPress=[UIImage imageNamed:@"buttonSearchPress"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonSearchRegular.size.width, buttonSearchRegular.size.height)];
    [button setImage:buttonSearchRegular forState:UIControlStateNormal];
    [button setImage:buttonSearchPress forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(zoomButton) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragInside|UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(relaxButton) forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchCancel | UIControlEventTouchDragOutside ];
    kal.navigationItem.titleView=button;
    [button release];
    
    searchPage = [[ZWOSearchPageController alloc] initWithNibName:@"ZWOSearchPageController" bundle:nil];
    searchPage.title=@"节日搜索";
    searchPage.delegate=kalDataSource;
    
    datePageController = [[ZWODatePageController alloc] initWithNibName:nil bundle:nil];
    kalDataSource.datePageControllerRef=datePageController;
    searchPage.datePageControllerRef=datePageController;
    
    self.navController.navigationBar.tintColor=[UIColor blackColor];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        ZWOGuideView *guideView=[[ZWOGuideView alloc] initWithFrame:self.navController.view.frame];
        [self.navController.view addSubview:guideView];
        [guideView release];
    }
    
    
    
    self.window.rootViewController=navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [Appirater appLaunched:YES];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)searchButtonPressed
{
    [self relaxButton];
    [kal.navigationController pushViewController:searchPage animated:YES];
}

- (void)zoomButton{
    UIButton *button=(UIButton *)kal.navigationItem.titleView;
    [UIView animateWithDuration:0.2f animations:^{
        button.transform=CGAffineTransformMakeScale(1.1f, 1.0f);}];
}

- (void)relaxButton
{
    UIButton *button=(UIButton *)kal.navigationItem.titleView;
    [UIView animateWithDuration:0.2f animations:^{
        button.transform=CGAffineTransformIdentity;
    }];
}

- (void)buttonInfo
{
    ZWOGuideView *guideView=[[ZWOGuideView alloc] initWithFrame:self.navController.view.frame];
    [self.navController.view addSubview:guideView];
    [guideView release];
}
@end
