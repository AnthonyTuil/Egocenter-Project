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
    
    self.navigationItem.title = @"My surveys";
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    [self retrieveSurveys];
    [self loadData];
}

-(void)addAction:(id)sender{
    // add survey
}

-(void)retrieveSurveys{
    
    AFHTTPRequestOperationManager *managerToken = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": [[NSUserDefaults standardUserDefaults] objectForKey:@"mail_doctor"],
                                 @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"pass_doctor"]                                 };
    
    
    [managerToken POST:@"http://egocenter.telecom-paristech.fr/egocenter/v1/retrieve_surveys" parameters:parameters success:^(AFHTTPRequestOperation *operationToken, id responseToken){
        
        NSLog(@"%@",[[responseToken objectForKey:@"surveys"] objectAtIndex:0]);
        
        NSArray *reponseArray = [[NSArray alloc] initWithArray:[responseToken objectForKey:@"surveys"]];
        
        for (int i= 0; i< [reponseArray count]; i++) {
          // save survey i into DB
        }
        
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
