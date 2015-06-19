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
    
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"enquete_nb_cadran"];
            [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"enquete_nb_zone"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enquete_age"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enquete_sex"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enquete_job"];
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"mail"];
            [[NSUserDefaults standardUserDefaults] setObject:tokenTextField.text forKey:@"token"];
            
            // app delegate present splitviewcontroller
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate setSplitViewController];

    
    
}
/*
-(void)logInAction{
    // send request
    
     if (emailTextField.text && tokenTextField.text) {
         // les deux champs sont remplis
         if ([self isValidEmail:emailTextField.text]) {
             // l'email est bien de type email
         
         
         AFHTTPRequestOperationManager *managerToken = [AFHTTPRequestOperationManager manager];
         NSDictionary *parameters = @{@"email": emailTextField.text,
                                 @"token": tokenTextField.text
                                      };
         
         [managerToken POST:@"adresse serveur" parameters:parameters success:^(AFHTTPRequestOperation *operationToken, id responseToken) {
        
             // get reponse serveur
        NSLog(@"%@",[responseToken objectForKey:@"result"]);
        
        // recuperer infos enquete
        
        //Sauvegarde des infos sur l'enquête
             
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"enquete_nb_cadran"];
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"enquete_nb_zone"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enquete_age"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enquete_sex"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enquete_job"];
             
             
             
            [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"mail"];
            [[NSUserDefaults standardUserDefaults] setObject:tokenTextField.text forKey:@"token"];
             
             // app delegate present splitviewcontroller

            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate setSplitViewController];
            
        

    
        } failure:^(AFHTTPRequestOperation *operationToken, NSError *errorToken) {
            
            // failure
            }]; 
    
    
    if (emailTextField.text && tokenTextField.text) {
        [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"mail"];
        [[NSUserDefaults standardUserDefaults] setObject:tokenTextField.text forKey:@"token"];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate setSplitViewController];
        
    }
    
     }else{
         NSLog(@"Mail not valid");
     }
        
     }else{
         NSLog(@"One field is empty");

     }
         
    
    
}
*/

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
    NSLog(@"ici");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
