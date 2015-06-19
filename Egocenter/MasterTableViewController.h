//
//  MasterTableViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 03/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Relation.h"
#import "RelationViewController.h"
#import "DetailViewController.h"
#import "DBManager.h"


@interface MasterTableViewController : UITableViewController{
    Relation *relationToAdd;
}

@property (nonatomic, strong) DBManager *dbManager;
-(void)setTitleForNav:(NSString *)title;
@end
