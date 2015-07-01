//
//  SendSurveyViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 29/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "SendSurveyViewController.h"

@interface SendSurveyViewController ()<THContactPickerDelegate>
@property NSArray *objects;
@property (nonatomic, strong) NSMutableArray *privateSelectedContacts;

@end

@implementation SendSurveyViewController
@synthesize contactPickerView = _contactPickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    sendToPatient = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendToPatient.frame = CGRectMake(200, 200, 200, 50);
    [sendToPatient setTitle:@"Send to patient" forState:UIControlStateNormal];
    [sendToPatient addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    sendToPatient.enabled = NO;
    
    self.privateSelectedContacts = [[NSMutableArray alloc] init];
    
    self.contactPickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 60, 300, 200)];
    [self.contactPickerView setPlaceholderLabelText:@"Enter the patients email here"];
    self.contactPickerView.delegate = self;
    [self.contactPickerView setPromptLabelText:@"To:"];
    
    [self.view addSubview:self.contactPickerView];
    
    [self.view addSubview:sendToPatient];
    
    
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)send{
    // send to patient
    
  
    
    for (int i =0; i< [self.privateSelectedContacts count]; i++) {
        if ([self isValidEmail:[self.privateSelectedContacts objectAtIndex:i]]) {
            if (i == [self.privateSelectedContacts count]-1) {
                [self sendMailsToServor];
            }
            
            }else{
            NSLog(@"one or more email is not valid");
        }
    }
    
    
    
    
   
}

-(void)sendMailsToServor{
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self indexKeyedDictionaryFromArray:self.privateSelectedContacts] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    
    AFHTTPRequestOperationManager *managerToken = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"emails": jsonString,
                                 @"token": [NSString stringWithFormat:@"%i",self.recordIDToEdit]
                                 };
    
    
    [managerToken POST:@"http://egocenter.telecom-paristech.fr/egocenter/v1/add_patients" parameters:parameters success:^(AFHTTPRequestOperation *operationToken, id responseToken) {
        
        NSLog(@"%@",responseToken);
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            
            [mailCont setSubject:@"TITLE_TEXT"];
            [mailCont setToRecipients:self.privateSelectedContacts];
            [mailCont setMessageBody:@"BODY_TEXT " isHTML:NO];
            
            [self.navigationController presentViewController:mailCont animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operationToken, NSError *errorToken) {
        NSLog(@"Failure : %@",errorToken);
        // requete non envoyé
    }];
    


}

- (NSDictionary *)indexKeyedDictionaryFromArray:(NSMutableArray *)array
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (int i =0; i<[array count]; i++) {
        [dic setObject:[array objectAtIndex:i] forKey:[NSString stringWithFormat:@"%i",i+1]];
    }
    
    return dic;
}

#pragma mark - THContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
  
}

- (void)contactPickerDidRemoveContact:(id)contact {
    [self.privateSelectedContacts removeObject:contact];

}

- (BOOL)contactPickerTextFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0){
        
        NSString *contact = [[NSString alloc] initWithString:textField.text];
        [self.privateSelectedContacts addObject:contact];
        [self.contactPickerView addContact:contact withName:textField.text];
    }
    return YES;
}


// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)addToDB{
    
    AFHTTPRequestOperationManager *managerToken = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": [[NSUserDefaults standardUserDefaults] objectForKey:@"mail_doctor"],
                                 @"token": [NSString stringWithFormat:@"%i",self.recordIDToEdit],
                                 @"title": [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:1]] ,
                                 @"instruction": [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:2]],
                                 @"age": [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:3]],
                                 @"sex": [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:4]],
                                 @"job": [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:5]],
                                 @"dial": [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:6]],
                                 @"circle": [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:7]]
                                 };
    
    
    [managerToken POST:@"http://egocenter.telecom-paristech.fr/egocenter/v1/add_survey" parameters:parameters success:^(AFHTTPRequestOperation *operationToken, id responseToken) {
        
        // get reponse serveur
        if (![[responseToken objectForKey:@"error"] boolValue]) {
            NSLog(@"well saved in DB");
            // pas d'erreur
            sendToPatient.enabled = YES;
            
        }else{
            // erreur
            NSLog(@"%@",[responseToken objectForKey:@"message"]);
            sendToPatient.enabled = YES;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operationToken, NSError *errorToken) {
        NSLog(@"Failure : %@",errorToken);
        // requete non envoyé
    }];
    

}



-(void)loadData{
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM survey WHERE token=%i",self.recordIDToEdit];

    // Get the results.
    if (self.objects != nil) {
        self.objects = nil;
    }
    self.objects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    // Reload the table view.
    
    [self addToDB];
    
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
