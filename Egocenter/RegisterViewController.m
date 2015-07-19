//
//  RegisterViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 01/07/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    emailTextField = [[UITextField alloc] init];
    passTextField = [[UITextField alloc] init];
    nameTextField = [[UITextField alloc] init];
    
    emailTextField.returnKeyType = UIReturnKeyNext;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    passTextField.returnKeyType = UIReturnKeyNext;
    nameTextField.returnKeyType = UIReturnKeyDone;
    
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    emailTextField.delegate = self;
    passTextField.delegate = self;
    nameTextField.delegate = self;
    passTextField.secureTextEntry = YES;
    
    emailTextField.tag = 1;
    passTextField.tag = 2;
    nameTextField.tag = 3;
    
    UILabel *emailLabel = [[UILabel alloc] init];
    UILabel *tokenLabel = [[UILabel alloc] init];
    UILabel *nameLabel = [[UILabel alloc] init];
    
    emailLabel.text = @"Email";
    tokenLabel.text = @"Password";
    nameLabel.text = @"Name";
    
    emailTextField.frame = CGRectMake(self.view.frame.size.width*0.3, 200, self.view.frame.size.width*0.4, 50);
    passTextField.frame = CGRectMake(self.view.frame.size.width*0.3, 255, self.view.frame.size.width*0.4, 50);
    nameTextField.frame = CGRectMake(self.view.frame.size.width*0.3, 310, self.view.frame.size.width*0.4, 50);
    emailTextField.borderStyle = UITextBorderStyleNone;
    passTextField.borderStyle = UITextBorderStyleNone;
    nameTextField.borderStyle = UITextBorderStyleNone;
    emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    passTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameTextField.autocorrectionType =UITextAutocorrectionTypeNo;
    
    emailTextField.placeholder = @"Email adress";
    passTextField.placeholder = @"Choose a password";
    nameTextField.placeholder = @"Enter your name";
    
    emailTextField.textAlignment = NSTextAlignmentCenter;
    [emailTextField setFont:[UIFont boldSystemFontOfSize:20]];
    
    passTextField.textAlignment = NSTextAlignmentCenter;
    [passTextField setFont:[UIFont boldSystemFontOfSize:20]];
    
    nameTextField.textAlignment = NSTextAlignmentCenter;
    [nameTextField setFont:[UIFont boldSystemFontOfSize:20]];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    closeBtn.titleLabel.textColor = [UIColor colorWithRed:217.0/255.0 green:84.0/255.0 blue:58.0/255.0 alpha:1.0];
    closeBtn.frame = CGRectMake(0, 5, 200, 100);
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setImage:[UIImage imageNamed:@"Create_account_button.png"] forState:UIControlStateNormal];
    confirmBtn.frame = CGRectMake(370, 450, 287, 82);
    confirmBtn.center = CGPointMake(self.view.frame.size.width/2, confirmBtn.frame.origin.y);

    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:emailTextField];
    [self.view addSubview:nameTextField];
    [self.view addSubview:passTextField];
    [self.view addSubview:closeBtn];
    [self.view addSubview:confirmBtn];
    // Do any additional setup after loading the view.
}

-(void)confirmAction{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    alert.backgroundType = Blur;

    if ([emailTextField.text length] >0 && [nameTextField.text length] >0 && [passTextField.text length] >0) {
        if (passTextField.text.length >5) {
            if ([self isValidEmail:emailTextField.text]) {
                AFHTTPRequestOperationManager *managerToken = [AFHTTPRequestOperationManager manager];
                NSDictionary *parameters = @{@"first_name": nameTextField.text,
                                             @"email": emailTextField.text,
                                             @"password": passTextField.text
                                             };
                
                
                [managerToken POST:@"http://egocenter.telecom-paristech.fr/egocenter/v1/register" parameters:parameters success:^(AFHTTPRequestOperation *operationToken, id responseToken) {
                    
                    // get reponse serveur
                    if (![[responseToken objectForKey:@"error"] boolValue]) {
                        
                        NSLog(@"%@",[responseToken objectForKey:@"message"]);
                        [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"mail_doctor_register"];
                        
                        // app delegate present splitviewcontroller
                        [alert showSuccess:self title:@"Account created" subTitle:@"your account has been successfully created. Please login woth your password" closeButtonTitle:nil duration:0.0f];
                        [alert addButton:@"Done" actionBlock:^(void) {
                              [self closeAction];
                        }];
                      
                        
                        
                    }else{
                        NSString *alertString = [NSString stringWithFormat:@"%@",[responseToken objectForKey:@"message"]];
                        if ([alertString isEqualToString:@"Sorry, this email is already existing"]) {
                            alertString = [NSString stringWithFormat:@"%@, try to connect with your account",alertString];
                        }
                        [alert showWarning:self title:@"Oops" subTitle:alertString closeButtonTitle:@"Done" duration:0.0f];
                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operationToken, NSError *errorToken) {
                    [alert showWarning:self title:@"Connection issue" subTitle:@"Couldn't reach servor. Please try again." closeButtonTitle:@"Done" duration:0.0f];
                }];
            }else{
              [alert showWarning:self title:@"Invalid Email" subTitle:@"Please type your email adress again." closeButtonTitle:@"Done" duration:0.0f];
            
            }
        }else{
            [alert showWarning:self title:@"Password too short" subTitle:@"Please choose a longer password." closeButtonTitle:@"Done" duration:0.0f]; 
        }
    }else{
  [alert showWarning:self title:@"Empty field" subTitle:@"One or more field is empty. Please type your infos again." closeButtonTitle:@"Done" duration:0.0f];
    }
    
}

-(void)closeAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == emailTextField) {
        [passTextField becomeFirstResponder];
    }
    else if (textField == passTextField) {
        [nameTextField becomeFirstResponder];
    }
    else if (textField == nameTextField) {
        [nameTextField resignFirstResponder];
        
        
    }
    return true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
