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
    passTextField.returnKeyType = UIReturnKeyDone;
    nameTextField.returnKeyType = UIReturnKeyDone;
    
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
    emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    passTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    emailTextField.placeholder = @"Enter your email";
    passTextField.placeholder = @"Choose a password";
    nameTextField.placeholder = @"Enter your name";

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont fontWithName:@"GothamBold" size:25];
    closeBtn.frame = CGRectMake(5, 5, 200, 100);
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setImage:[UIImage imageNamed:@"Create_account_button.png"] forState:UIControlStateNormal];
    confirmBtn.frame = CGRectMake(370, 490, 287, 82);
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
    if (emailTextField.text && nameTextField.text && passTextField.text) {
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
                        [self closeAction];
                        
                        
                    }else{
                        NSLog(@"%@",[[responseToken objectForKey:@"message"] stringValue]);
                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operationToken, NSError *errorToken) {
                    NSLog(@"Failure : %@",errorToken);
                    // failure
                }];
            }else{
                NSLog(@"Email not valid");
            }
        }else{
            NSLog(@"pass not long enought");
        }
    }else{
        NSLog(@"one field empty");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
