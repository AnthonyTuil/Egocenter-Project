//
//  LoginDoctorViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 27/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "LoginDoctorViewController.h"

@interface LoginDoctorViewController ()

@end

@implementation LoginDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationItem setTitle:@"Login"];
    [self configureView];
    // Do any additional setup after loading the view.
}



-(void)configureView{
    
    emailTextField = [[UITextField alloc] init];
    passTextField = [[UITextField alloc] init];
    
    
    emailTextField.returnKeyType = UIReturnKeyNext;
    passTextField.returnKeyType = UIReturnKeyDone;
    
    emailTextField.borderStyle = UITextBorderStyleNone;
    passTextField.borderStyle = UITextBorderStyleNone;
    
    emailTextField.delegate = self;
    passTextField.delegate = self;
    passTextField.secureTextEntry = YES;
    
    emailTextField.tag = 1;
    passTextField.tag = 2;
    
    UILabel *emailLabel = [[UILabel alloc] init];
    UILabel *tokenLabel = [[UILabel alloc] init];
    
    emailLabel.text = @"email";
    tokenLabel.text = @"Password";
    
    emailTextField.frame = CGRectMake(self.view.frame.size.width*0.3, 200, self.view.frame.size.width*0.4, 50);
    passTextField.frame = CGRectMake(self.view.frame.size.width*0.3, 255, self.view.frame.size.width*0.4, 50);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mail_doctor_register"]) {
        emailTextField.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"mail_doctor_register"];
    }
    
    emailTextField.placeholder = @"Email adress";
    emailTextField.textAlignment = NSTextAlignmentCenter;
    [emailTextField setFont:[UIFont boldSystemFontOfSize:20]];
    passTextField.placeholder = @"Password";
    passTextField.textAlignment = NSTextAlignmentCenter;
    [passTextField setFont:[UIFont boldSystemFontOfSize:20]];
    
    UIButton *logInbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logInbutton setImage:[UIImage imageNamed:@"Login_button.png"] forState:UIControlStateNormal];
    [logInbutton setImage:[UIImage imageNamed:@"Login_button_pressed.png"] forState:UIControlStateHighlighted]      ;
    logInbutton.frame = CGRectMake(400, 280, 207, 82);
    logInbutton.center = CGPointMake(self.view.frame.size.width/2, 380);
    [logInbutton addTarget:self action:@selector(logInAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setImage:[UIImage imageNamed:@"Create_account_button.png"] forState:UIControlStateNormal];
    [registerBtn setImage:[UIImage imageNamed:@"Create_account_button_pressed.png"] forState:UIControlStateHighlighted];
    registerBtn.frame = CGRectMake(370, 450, 287, 82);
    registerBtn.center = CGPointMake(self.view.frame.size.width/2, registerBtn.frame.origin.y);
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:emailTextField];
    [self.view addSubview:passTextField];
    [self.view addSubview:logInbutton];
    [self.view addSubview:registerBtn];

    
    
    
}

-(void)registerAction{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController presentViewController:registerVC animated:YES completion:nil];
    
}

-(void)logInAction{
    // send request
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    alert.backgroundType = Blur;
    
    if ([emailTextField.text length]>0 && [passTextField.text length] >0) {
        // les deux champs sont remplis
        if ([self isValidEmail:emailTextField.text]) {
            // l'email est bien de type email
            
            AFHTTPRequestOperationManager *managerToken = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"email": emailTextField.text,
                                         @"password": passTextField.text
                                         };
            
            
            [managerToken POST:@"http://egocenter.telecom-paristech.fr/egocenter/v1/login" parameters:parameters success:^(AFHTTPRequestOperation *operationToken, id responseToken) {
                
                // get reponse serveur
                if (![[responseToken objectForKey:@"error"] boolValue]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"mail_doctor"];
                    [[NSUserDefaults standardUserDefaults] setObject:passTextField.text forKey:@"pass_doctor"];

                    // app delegate present splitviewcontroller
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate setSplitViewController];
                    
                }else{
                    [alert showWarning:self title:@"Oops" subTitle:[NSString stringWithFormat:@"%@",[responseToken objectForKey:@"message"]] closeButtonTitle:@"Done" duration:0.0f]; // Warning
                }
                
                
            } failure:^(AFHTTPRequestOperation *operationToken, NSError *errorToken) {
                [alert showWarning:self title:@"Connection issue" subTitle:@"Couldn't reach servor. Please try again." closeButtonTitle:@"Done" duration:0.0f];
            }]; 
            
            
            
            
            
        }else{
            [alert showWarning:self title:@"Invalid Email" subTitle:@"Please type your email adress again." closeButtonTitle:@"Done" duration:0.0f]; // Warning
        }
        
    }else{
        [alert showWarning:self title:@"Empty field" subTitle:@"One or more field is empty. Please type your infos again." closeButtonTitle:@"Done" duration:0.0f]; // Warning
    }
    
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isDoctor"];
            }
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"mail_doctor_register"]) {
        emailTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"mail_doctor_register"];
    }
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
