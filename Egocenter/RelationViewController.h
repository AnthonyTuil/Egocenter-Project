//
//  RelationViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 06/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Relation.h"
#import "MasterTableViewController.h"
#import "DBManager.h"
#import "GroupViewController.h"
#import "GroupTableViewCell.h"


@interface RelationViewController : UITableViewController <UITextFieldDelegate>{
    UITextField *nameTextField;
    UITableViewCell *cell1;
    
}


@property (nonatomic) int recordIDToEdit;



@end
