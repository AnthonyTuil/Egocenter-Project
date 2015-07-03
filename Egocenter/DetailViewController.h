//
//  DetailViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 03/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Relation.h"
#import "DBManager.h"
#import "RelationView.h"
#import "PopoverDoctorTableViewController.h"
#import "Link.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,UIPopoverControllerDelegate>{
    UIView *circleView;
    NSMutableArray *arrayViews;
    UIBarButtonItem *button;
    NSMutableArray *arrayLayer;
}



-(void)addRelation:(Relation*)relation;
-(void)removeRelationAtIndex:(int)index;
-(void)updateDataAtIndex:(int)index;
@end
