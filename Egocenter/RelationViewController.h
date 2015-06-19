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
    NSMutableArray *relationArray;
    UITextField *nameTextField;
    
}


@property (nonatomic) int recordIDToEdit;
@property (nonatomic, strong) NSMutableArray * relationArray;



@end
