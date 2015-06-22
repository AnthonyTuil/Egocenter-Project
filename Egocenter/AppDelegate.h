//
//  AppDelegate.h
//  Egocenter
//
//  Created by Anthony Tuil on 03/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MasterTableViewController.h"
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UISplitViewController *splitViewController;

}

@property (strong, nonatomic) UIWindow *window;



-(void)setSplitViewController;


@end

