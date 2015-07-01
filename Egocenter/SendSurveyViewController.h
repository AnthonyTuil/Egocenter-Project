//
//  SendSurveyViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 29/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "DBManager.h"
#import <MessageUI/MessageUI.h>
#import "THContactPickerView.h"

@interface SendSurveyViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    UIButton *sendToPatient;
}

@property (nonatomic, strong) THContactPickerView *contactPickerView;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic, strong) DBManager *dbManager;

@end
