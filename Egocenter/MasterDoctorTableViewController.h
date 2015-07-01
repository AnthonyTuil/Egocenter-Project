//
//  MasterDoctorTableViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 27/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "AFNetworking.h"
#import "DetailDoctorViewController.h"
#import <stdlib.h>

@interface MasterDoctorTableViewController : UITableViewController



@property (nonatomic, strong) DBManager *dbManager;
-(void)loadData;
@end
