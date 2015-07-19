//
//  RegisterViewController.h
//  Egocenter
//
//  Created by Anthony Tuil on 01/07/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>{
    UITextField *emailTextField;
    UITextField *passTextField;
    UITextField *nameTextField;
}

@end
