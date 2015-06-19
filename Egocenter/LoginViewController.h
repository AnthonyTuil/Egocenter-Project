//
//  LoginViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 16/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    UITextField *emailTextField;
    UITextField *tokenTextField;
}

@end
