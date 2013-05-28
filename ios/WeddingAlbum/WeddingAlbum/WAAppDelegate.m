//
//  WAAppDelegate.m
//  WeddingAlbum
//
//  Created by Tonny on 5/28/13.
//  Copyright (c) 2013 SlowsLab. All rights reserved.
//

#import "WAAppDelegate.h"

#import "WAViewController.h"
#import "WAMenuViewController.h"
#import "MMDrawerController.h"
#import "WAAlbumViewController.h"
#import "MMExampleDrawerVisualStateManager.h"

@implementation WAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self.viewController = [[WAViewController alloc] initWithNibName:@"WAViewController_iPhone" bundle:nil];
        
        UIViewController * leftSideDrawerViewController = [[WAMenuViewController alloc] initWithNibName:@"WAMenuViewController" bundle:nil];
        
        UIViewController * centerViewController = [[WAAlbumViewController alloc] initWithNibName:@"WAAlbumViewController" bundle:nil];
        
//        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
        
        MMDrawerController * drawerController = [[MMDrawerController alloc]
                                                 initWithCenterViewController:centerViewController
                                                 leftDrawerViewController:leftSideDrawerViewController
                                                 rightDrawerViewController:nil];
        [drawerController setMaximumRightDrawerWidth:200.0];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [drawerController
         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
             MMDrawerControllerDrawerVisualStateBlock block;
             block = [[MMExampleDrawerVisualStateManager sharedManager]
                      drawerVisualStateBlockForDrawerSide:drawerSide];
             if(block){
                 block(drawerController, drawerSide, percentVisible);
             }
         }];
        
        self.window.rootViewController = drawerController;
//    } else {
////        self.viewController = [[WAViewController alloc] initWithNibName:@"WAViewController_iPad" bundle:nil];
//        UISplitViewController *vc = [[UISplitViewController alloc] initWithNibName:@"WAViewController_iPad" bundle:nil];
//        
//        WAAlbumViewController * centerViewController = [[WAAlbumViewController alloc] initWithNibName:@"WAAlbumViewController" bundle:nil];
//        
//        WAMenuViewController * leftSideDrawerViewController = [[WAMenuViewController alloc] initWithNibName:@"WAMenuViewController" bundle:nil];
//        leftSideDrawerViewController.albumVC = centerViewController;
//        
//        vc.viewControllers = @[leftSideDrawerViewController, centerViewController];
//        
//        self.window.rootViewController = vc;
//    }

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;
}

@end
