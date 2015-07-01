//
//  LoginViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 16/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationItem.title = @"Patient";

    [self configureView];
    
    // Do any additional setup after loading the view.
}

-(void)configureView{
    
    emailTextField = [[UITextField alloc] init];
    tokenTextField = [[UITextField alloc] init];
    
    emailTextField.returnKeyType = UIReturnKeyNext;
    tokenTextField.returnKeyType = UIReturnKeyDone;
    
    emailTextField.delegate = self;
    tokenTextField.delegate = self;
    
    emailTextField.tag = 1;
    tokenTextField.tag = 2;
    
    UILabel *emailLabel = [[UILabel alloc] init];
    UILabel *tokenLabel = [[UILabel alloc] init];
    
    emailLabel.text = @"email";
    tokenLabel.text = @"Token";
    
    emailTextField.frame = CGRectMake(self.view.frame.size.width*0.3, 200, self.view.frame.size.width*0.4, 50);
    tokenTextField.frame = CGRectMake(self.view.frame.size.width*0.3, 250, self.view.frame.size.width*0.4, 50);
    
    emailTextField.placeholder = @"Enter your email";
    tokenTextField.placeholder = @"Enter the token";
    
    UIButton *logInbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logInbutton setTitle:@"Login" forState:UIControlStateNormal];
    logInbutton.frame = CGRectMake(self.view.frame.size.width*0.3, 400, 200, 100);
    [logInbutton addTarget:self action:@selector(logInAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:emailTextField];
    [self.view addSubview:tokenTextField];
    [self.view addSubview:logInbutton];
    
    
    
}



-(void)logInAction{
    // send request
    
     if (emailTextField.text && tokenTextField.text) {
         // les deux champs sont remplis
         NSLog(@"champs bien remplis");
         if ([self isValidEmail:emailTextField.text]) {
             // l'email est bien de type email
         
             NSLog(@"email valid");
         AFHTTPRequestOperationManager *managerToken = [AFHTTPRequestOperationManager manager];
         NSDictionary *parameters = @{@"email": emailTextField.text,
                                 @"token": tokenTextField.text
                                      };
         
        
         [managerToken POST:@"http://egocenter.telecom-paristech.fr/egocenter/v1/get_survey" parameters:parameters success:^(AFHTTPRequestOperation *operationToken, id responseToken) {
        
             // get reponse serveur
             if ([[responseToken objectForKey:@"error"] intValue] == 0) {
             
        
        // recuperer infos enquete
        
        //Sauvegarde des infos sur l'enquête
             
            [[NSUserDefaults standardUserDefaults]
             setInteger:[[[responseToken objectForKey:@"survey"] objectForKey:@"dial"] intValue] forKey:@"enquete_nb_cadran"];
             
            [[NSUserDefaults standardUserDefaults]
             setInteger:[[[responseToken objectForKey:@"survey"] objectForKey:@"circle"] intValue] forKey:@"enquete_nb_zone"];
             
             int ageInt = [[[responseToken objectForKey:@"survey"] objectForKey:@"age"] intValue];
             BOOL ageBool = ageInt != 0;
            [[NSUserDefaults standardUserDefaults] setBool:ageBool forKey:@"enquete_age"];
             
             int sexInt = [[[responseToken objectForKey:@"survey"] objectForKey:@"sex"] intValue];
             BOOL sexBool = sexInt != 0;
             NSLog(@"%i",sexBool);
            [[NSUserDefaults standardUserDefaults] setBool:sexBool forKey:@"enquete_sex"];
             
             int jobInt = [[[responseToken objectForKey:@"survey"] objectForKey:@"job"] intValue];
             BOOL jobBool = jobInt != 0;
            [[NSUserDefaults standardUserDefaults] setBool:jobBool forKey:@"enquete_job"];
             
             
             
            [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"mail"];
            [[NSUserDefaults standardUserDefaults] setObject:tokenTextField.text forKey:@"token"];
             
             // app delegate present splitviewcontroller

            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate setSplitViewController];
            
             }else{
                 NSLog(@"%@",[[responseToken objectForKey:@"message"] stringValue]);
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

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isPatient"];
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
