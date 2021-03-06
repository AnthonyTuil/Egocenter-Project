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
    
    splitViewControllerDoctor = [[UISplitViewController alloc] init];
    
    MasterTableViewController *masterViewController = [[MasterTableViewController alloc] init];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    MasterDoctorTableViewController *masterDoctorViewController = [[MasterDoctorTableViewController alloc] init];
    //DetailDoctorViewController *detailDoctorViewController = [[DetailDoctorViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *rootNavD = [[UINavigationController alloc] initWithRootViewController:masterDoctorViewController];
    //UINavigationController *detailNavD = [[UINavigationController alloc] initWithRootViewController:detailDoctorViewController];
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    splitViewController.viewControllers = [NSArray arrayWithObjects:rootNav,detailNav, nil];
    splitViewController.delegate = detailViewController;
    
    splitViewControllerDoctor.viewControllers = [NSArray arrayWithObjects:rootNavD, nil];
    
    //splitViewControllerDoctor.delegate = detailDoctorViewController;
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    LoginDoctorViewController *loginDoctorViewController = [[LoginDoctorViewController alloc] init];
    WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
    
    welcomeNav = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
    //UINavigationController *loginNavD = [[UINavigationController alloc] initWithRootViewController:loginDoctorViewController];
    //UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"mail"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    NSString *emailDoctor = [[NSUserDefaults standardUserDefaults] stringForKey:@"mail_doctor"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"pass_doctor"];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isPatient"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"isDoctor"] ) {
        // deja passé le welcome
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isPatient"]) {
            // c'est un patient
            if (token && email) {
                // deja connecté avec un token et mail
                [self.window setRootViewController:(UIViewController*)splitViewController];
            }else {
                
                [self.window setRootViewController:(UIViewController*)welcomeNav];
                [welcomeNav pushViewController:loginViewController animated:NO];
                
            }
        }else if([[NSUserDefaults standardUserDefaults] boolForKey:@"isDoctor"]){
            // c'est un docteur
            if (emailDoctor && password) {
                // deja connecté avec mail et pass
                
                [self.window setRootViewController:(UIViewController*)splitViewControllerDoctor];
                
            }else{
                [self.window setRootViewController:(UIViewController*)welcomeNav];
                [welcomeNav pushViewController:loginDoctorViewController animated:NO];
                
            }
            
        }
        
        
    }else{
        
        [self.window setRootViewController:(UIViewController*)welcomeNav];
    }
    
    
    
    
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}


-(void)logOut{
    // init nsuser defaut
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isPatient"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isDoctor"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mail"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mail_doctor"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pass_doctor"];

    
    // set WelcomeVC
    [self.window setRootViewController:(UIViewController*)welcomeNav];

    
}


-(void)setSplitViewController{
    
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"mail"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    NSString *emailDoctor = [[NSUserDefaults standardUserDefaults] stringForKey:@"mail_doctor"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"pass_doctor"];
    
    if (email && token) {
         [self.window setRootViewController:splitViewController];
    }
    if (emailDoctor && password) {
        [self.window setRootViewController:splitViewControllerDoctor];
    }
    
   
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
