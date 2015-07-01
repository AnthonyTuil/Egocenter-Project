//
//  DetailDoctorViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 27/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "DialViewController.h"
#import "MasterDoctorTableViewController.h"
#import "QuadranViewController.h"
#import "SendSurveyViewController.h"


@interface DetailDoctorViewController : UITableViewController<UISplitViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UITextField *titleTextField;
    UITextView *instructionTextView;
    UISwitch *ageSwitch;
    UISwitch *jobSwitch;
    UISwitch *sexSwitch;
    
    UILabel* detail1;
    UILabel* detail;

}

@property (nonatomic) int surveyToEdit;
-(void)loadData;
@end
