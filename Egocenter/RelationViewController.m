//
//  RelationViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 06/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "RelationViewController.h"

@interface RelationViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@end

@implementation RelationViewController
@synthesize relationArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    // Do any additional setup after loading the view.
}


#pragma TableView Data Source 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MyIdentifier = @"Cell1";
    static NSString *MyIdentifier2 = @"Cell2";
    
    
    
    if (indexPath.row == 0) {
        // Name
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier] ;
        }
        nameTextField = [[UITextField alloc] init];
        nameTextField.placeholder = @"Name";
        
        nameTextField.frame = CGRectMake(20, 0, self.navigationController.view.frame.size.width, cell.frame.size.height);
        nameTextField.returnKeyType = UIReturnKeyDone;
        nameTextField.delegate = self;
        nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [nameTextField becomeFirstResponder];
        
        NSString *query = [NSString stringWithFormat:@"select * from relation where relationID=%d", self.recordIDToEdit];
        
        // Load the relevant data.
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        // Set the loaded data to the textfields.
        if ([results count]) {
            nameTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]];
            if(nameTextField.text){
                self.navigationItem.title = nameTextField.text;
            }
        }
        

        [cell addSubview:nameTextField];
        return cell;
        
    }
    if (indexPath.row == 1){
        //color
    
        GroupTableViewCell *cell = (GroupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier2];
        
        if (cell == nil)
        {
            cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier2];
        }
        
        cell.primaryLabel.text = @"Groups";
        NSString *queryColor = [NSString stringWithFormat:@"select *from groups where ID_relation=%d",self.recordIDToEdit];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryColor]];
        // Set the loaded data to the textfields.
        if ([results count]) {
            for (int i=0; i<[results count]; i++) {
                NSString *color = [[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"color"]];
                
            }
            
            
        }
        return cell;
    }
   
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        GroupViewController *groupVC = [[GroupViewController alloc] init];
        groupVC.recordIDToEdit = self.recordIDToEdit;
        [self.navigationController pushViewController:groupVC animated:YES];
    }
    
}


-(void)upDateGraphic{
    
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController*)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[DetailViewController class]]) {
        
       [detail updateDataAtIndex:self.recordIDToEdit];
    }

    
}


#pragma TextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    // Changer le titre de la vue
    
    NSLog(@"endediting");
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    
   
    NSString* query = [NSString stringWithFormat:@"update relation set name='%@' where relationID=%d", nameTextField.text,self.recordIDToEdit];
    
    
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
            }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    [self upDateGraphic];
    // Changer le nom sur le graphique
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [nameTextField resignFirstResponder];
    if(nameTextField.text){
        self.navigationItem.title = nameTextField.text;
    }
    
    [self upDateGraphic];
    return YES;
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
