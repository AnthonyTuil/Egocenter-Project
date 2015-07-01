//
//  MasterDoctorTableViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 27/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "MasterDoctorTableViewController.h"

@interface MasterDoctorTableViewController ()
@property NSArray *objects;
@end

@implementation MasterDoctorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];

    self.navigationItem.title = @"My surveys";
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    
    [self retrieveSurveys];
    
}

-(void)addAction:(id)sender{
    // add survey
    int rand =arc4random_uniform(700000);
    NSLog(@"%i",rand);
    NSString *query = [NSString stringWithFormat:@"INSERT INTO survey values(%i, 'Survey', 'Instructions here', 0,0,0,1,1)",rand];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    [self loadData];
}


-(void)retrieveSurveys{
    
    AFHTTPRequestOperationManager *managerToken = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": [[NSUserDefaults standardUserDefaults] objectForKey:@"mail_doctor"],
                                 @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"pass_doctor"]                                 };
    
    
    [managerToken POST:@"http://egocenter.telecom-paristech.fr/egocenter/v1/retrieve_surveys" parameters:parameters success:^(AFHTTPRequestOperation *operationToken, id responseToken){
        
        
        NSArray *reponseArray = [[NSArray alloc] initWithArray:[responseToken objectForKey:@"surveys"]];
        if ([reponseArray count]) {
            for (int i= 0; i< [reponseArray count]; i++) {
                // save survey i into DB
                NSDictionary *survey = [reponseArray objectAtIndex:i];
                int token = [[survey objectForKey:@"token"] intValue];
                NSString *title = [NSString stringWithFormat:@"%@",[survey objectForKey:@"title"]];
                NSString *instru = [NSString stringWithFormat:@"%@",[survey objectForKey:@"instruction"]];
                int age = [[survey objectForKey:@"age"] intValue];
                int sex = [[survey objectForKey:@"sex"] intValue];
                int job = [[survey objectForKey:@"job"] intValue];
                int circle = [[survey objectForKey:@"circle"] intValue];
                
                NSString *query0 = [NSString stringWithFormat:@"SELECT * FROM survey WHERE token=%i",token];
                if (![[self.dbManager loadDataFromDB:query0] count]) {
                    
                    // si la survey avec ce token est déjà présente
                    NSString *query = [NSString stringWithFormat:@"INSERT INTO survey values(%i,'%@','%@',%i,%i,%i,%i,%i)",token,title,instru,age,sex,job,job,circle];
                    [self.dbManager executeQuery:query];
                }
                
                
             
                
                
            }
        }
        [self loadData];

        
    }failure:^(AFHTTPRequestOperation *operationToken, NSError *errorToken) {
        NSLog(@"Failure : %@",errorToken);
        
    }];
    
    
}
     

-(void)loadData{
    // Form the query.
    NSString *query = @"SELECT * FROM survey";
    
    // Get the results.
    if (self.objects != nil) {
        self.objects = nil;
    }
    self.objects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    // Reload the table view.
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.objects objectAtIndex:indexPath.row] objectAtIndex:1]];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int tokenToShow = [[[self.objects objectAtIndex:indexPath.row] objectAtIndex:0] intValue];

    
    DetailDoctorViewController *detailDoctorViewController = [[DetailDoctorViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.splitViewController.delegate = detailDoctorViewController;
    UINavigationController *detailNavD = [[UINavigationController alloc] initWithRootViewController:detailDoctorViewController];
    detailDoctorViewController.surveyToEdit = tokenToShow;
    [self.splitViewController setViewControllers:[NSArray arrayWithObjects:self.splitViewController.viewControllers[0],detailNavD, nil]];
    
    
    
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
        return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        int tokenToDelete = [[[self.objects objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        NSString *query = [NSString stringWithFormat:@"DELETE FROM survey WHERE token=%d", tokenToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];    }
}





@end
