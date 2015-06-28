//
//  JobViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 24/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface JobViewController : UITableViewController{
    NSIndexPath* checkedIndexPath;
}

@property (nonatomic) int recordIDToEdit;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

@end
