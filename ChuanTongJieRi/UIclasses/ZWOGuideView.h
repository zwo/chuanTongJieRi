#import <UIKit/UIKit.h>

@interface ZWOGuideView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL pageControlUsed;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *imageViews;

- (IBAction)changePage:(id)sender;

@end

/*
*At applicationDidLaunch function add below:
if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) { 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"]; 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"]; 
    }
    
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        ViewController *appStartController = [[ViewController alloc] init];
        self.window.rootViewController = appStartController;
        [appStartController release];
    }else {
        NextViewController *mainViewController = [[NextViewController alloc] init];
        self.window.rootViewController=mainViewController;
        [mainViewController release];
        
    }
    */