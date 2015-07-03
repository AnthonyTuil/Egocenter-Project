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
    
    self.navigationController.navigationItem.title = @"Doctor";
    [self configureView];
    // Do any additional setup after loading the view.
}



-(void)configureView{
    
    emailTextField = [[UITextField alloc] init];
    passTextField = [[UITextField alloc] init];
    
    
    emailTextField.returnKeyType = UIReturnKeyNext;
    passTextField.returnKeyType = UIReturnKeyDone;
    
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
    passTextField.frame = CGRectMake(self.view.frame.size.width*0.3, 250, self.view.frame.size.width*0.4, 50);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mail_doctor_register"]) {
        emailTextField.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"mail_doctor_register"];
    }
    
    emailTextField.placeholder = @"Enter your email";
    passTextField.placeholder = @"Enter your password";
        
    UIButton *logInbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logInbutton setTitle:@"Login" forState:UIControlStateNormal];
    logInbutton.frame = CGRectMake(self.view.frame.size.width*0.3, 400, 200, 100);
    [logInbutton addTarget:self action:@selector(logInAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerBtn setTitle:@"Create an account" forState:UIControlStateNormal];
    registerBtn.frame = CGRectMake(self.view.frame.size.width*0.5, 400, 200, 100);
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:emailTextField];
    [self.view addSubview:passTextField];
    [self.view addSubview:logInbutton];
    [self.view addSubview:registerBtn];

    
    
    
}

-(void)registerAction{
    NSLog(@"yes papi");
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController presentViewController:registerVC animated:YES completion:nil];
    
}

-(void)logInAction{
    // send request
    
    if (emailTextField.text && passTextField.text) {
        // les deux champs sont remplis
        NSLog(@"champs bien remplis");
        if ([self isValidEmail:emailTextField.text]) {
            // l'email est bien de type email
            
            NSLog(@"email valid");
            AFHTTPRequestOperationManager *managerToken = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"email": emailTextField.text,
                                         @"password": passTextField.text
                                         };
            
            
            [managerToken POST:@"http://egocenter.telecom-paristech.fr/egocenter/v1/login" parameters:parameters success:^(AFHTTPRequestOperation *operationToken, id responseToken) {
                
                // get reponse serveur
                if (![[responseToken objectForKey:@"error"] boolValue]) {
                    
                    NSLog(@"%@",[responseToken objectForKey:@"message"]);
                    [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"mail_doctor"];
                    [[NSUserDefaults standardUserDefaults] setObject:passTextField.text forKey:@"pass_doctor"];

                    // app delegate present splitviewcontroller
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate setSplitViewController];
                    
                }else{
                    NSLog(@"%@",[responseToken objectForKey:@"message"]);
                }
                
                
            } failure:^(AFHTTPRequestOperation *operationToken, NSError *errorToken) {
                NSLog(@"Failure : %@",errorToken);
                // failure
            }]; 
            
            
            
            
            
        }else{
            NSLog(@"Ce n'est pas de la forme email");
        }
        
    }else{
        NSLog(@"un des deux champs vide");
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
