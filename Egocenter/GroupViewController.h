//
//  GroupViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 16/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "Group.h"
#import "DetailViewController.h"

@interface GroupViewController : UITableViewController<UITextFieldDelegate>{
    
}

@property (nonatomic) int recordIDToEdit;
@property (nonatomic, strong) DBManager *dbManager;


@end
