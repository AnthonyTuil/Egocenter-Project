//
//  AppDelegate.m
//  Egocenter
//
//  Created by Anthony Tuil on 03/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    splitViewController = [[UISplitViewController alloc] init];
    
    MasterTableViewController *masterViewController = [[MasterTableViewController alloc] init];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    splitViewController.viewControllers = [NSArray arrayWithObjects:rootNav,detailNav, nil];
    splitViewController.delegate = detailViewController;
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"mail"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    NSLog(@"%@,%@",email,token);
    
    if (token && email) {
        [self.window setRootViewController:(UIViewController*)splitViewController];
    }else {
        
        [self.window setRootViewController:(UIViewController*)loginViewController];

    }
    
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

-(void)setSplitViewController{
    [self.window setRootViewController:splitViewController];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


@end
