//
//  LoginDoctorViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 27/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface LoginDoctorViewController : UIViewController<UITextFieldDelegate>{
    UITextField *emailTextField;
    UITextField *passTextField;
    UIButton *createAccount;
}

@end
