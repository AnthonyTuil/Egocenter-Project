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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    NSIndexPath *durPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *paths = [NSArray arrayWithObject:durPath];
    [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadData];
}

#pragma TableView Data Source 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MyIdentifier = @"Cell1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier] ;
    }

    
    if (indexPath.row == 0) {
        // Name
        
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        nameTextField = [[UITextField alloc] init];
        nameTextField.placeholder = @"Name";
        nameTextField.tag = 0;
        nameTextField.frame = CGRectMake(20, 0, self.navigationController.view.frame.size.width, cell.frame.size.height);
        nameTextField.returnKeyType = UIReturnKeyDone;
        nameTextField.delegate = self;
        nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [nameTextField becomeFirstResponder];
        
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM relation WHERE relationID=%d", self.recordIDToEdit];
        
        // Load the relevant data.
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        // Set the loaded data to the textfields.
        if ([results count]) {
            nameTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]];
            if(nameTextField.text){
                self.navigationItem.title = nameTextField.text;
            }
        }
        

        [cell.contentView addSubview:nameTextField];
        return cell;
        
    }
    if (indexPath.row == 1){
        //color
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *primaryLabel = [[UILabel alloc]init];
        primaryLabel.frame = CGRectMake(15, 0, 100, 45);
        primaryLabel.textAlignment = NSTextAlignmentLeft;
        primaryLabel.font = [UIFont boldSystemFontOfSize:17];
        primaryLabel.text =@"Groups";
        
        
        UIView * firstColor = [[UIView alloc] init];
        firstColor.frame = CGRectMake(256, 14, 20, 20);
        firstColor.backgroundColor = [UIColor whiteColor];
        firstColor.layer.cornerRadius = 10;
        
        UIView * secondColor = [[UIView alloc] init];
        secondColor.frame = CGRectMake(227, 14, 20, 20);
        secondColor.backgroundColor = [UIColor whiteColor];
        secondColor.layer.cornerRadius = 10;
        
        UIView * thirdColor = [[UIView alloc] init];
        thirdColor.frame = CGRectMake(198, 14, 20, 20);
        thirdColor.backgroundColor = [UIColor whiteColor];
        thirdColor.layer.cornerRadius = 10;
        
        
        
        [cell.contentView addSubview:primaryLabel];
        [cell.contentView addSubview:firstColor];
        [cell.contentView addSubview:secondColor];
        [cell.contentView addSubview:thirdColor];
        
        NSString *queryColor = [NSString stringWithFormat:@"SELECT groups.* FROM groups, relation_group WHERE relation_group.groupsID = groups.groupID AND relation_group.relationID = %i",self.recordIDToEdit];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryColor]];
        // Set the loaded data to the textfields.
        if ([results count]) {
            for (int i=0; i<[results count]; i++) {
                NSString *color = [[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"color"]];
                switch (i) {
                    case 0:
                        firstColor.backgroundColor =[self colorFromHexString:color];

                        break;
                    case 1:
                        secondColor.backgroundColor =[self colorFromHexString:color];
                        
                        break;
                    case 2:
                        thirdColor.backgroundColor =[self colorFromHexString:color];
                        
                        break;
                    default:
                        break;
                }
                            }
            
            
        }
        return cell;
    }
    if (indexPath.row == 2) {
     
        
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enquete_sex"]) {
            cell.textLabel.text = @"Sex";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            
            NSString *querySex = [NSString stringWithFormat:@"SELECT sex FROM relation WHERE relationID=%d",self.recordIDToEdit];
            NSArray *resutlSex = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:querySex]];
            if ([resutlSex count]) {
                int sex = [[[resutlSex objectAtIndex:0] objectAtIndex:0] intValue];
                switch (sex) {
                    case 0:
                        cell.detailTextLabel.text = @"Men";
                        break;
                    case 1:
                        cell.detailTextLabel.text = @"Women";
                        break;
                    case 2:
                        cell.detailTextLabel.text = @"Other";
                        break;
                    default:
                        break;
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
       return cell;
    }
    if (indexPath.row == 3) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enquete_age"]) {
            // YES : [[NSUserDefaults standardUserDefaults] boolForKey:@"enquete_age"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = @"Age";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            
            ageTextField = [[UITextField alloc] init];
            ageTextField.placeholder = @"32";
            ageTextField.tag = 1;
            ageTextField.frame = CGRectMake(self.navigationController.view.frame.size.width-50, 0, 40, cell.frame.size.height);
            ageTextField.returnKeyType = UIReturnKeyDone;
            ageTextField.delegate = self;
            ageTextField.textAlignment = NSTextAlignmentRight;
            ageTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            NSString *query = [NSString stringWithFormat:@"SELECT age FROM relation WHERE relationID=%d", self.recordIDToEdit];
            
            // Load the relevant data.
            NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            // Set the loaded data to the textfields.
            if ([results count]) {
                ageTextField.text = [[results objectAtIndex:0] objectAtIndex:0];
            }
            
            
            [cell addSubview:ageTextField];
            return cell;

        }
        
    }
    if (indexPath.row == 4) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enquete_job"]) {
          
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        cell.textLabel.text = @"Job";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        
        }

    }
    
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        GroupViewController *groupVC = [[GroupViewController alloc] init];
        groupVC.recordIDToEdit = self.recordIDToEdit;
        [self.navigationController pushViewController:groupVC animated:YES];
    }
    if (indexPath.row == 2) {
        
        cell1 = [tableView cellForRowAtIndexPath:indexPath];
        NSString *string = cell1.detailTextLabel.text;
        if ([string isEqualToString:@"Men"]) {
            cell1.detailTextLabel.text = @"Women";
            NSString *query = [NSString stringWithFormat:@"UPDATE relation SET sex=1 WHERE relationID=%d",self.recordIDToEdit];
            [self.dbManager executeQuery:query];
        }
        if ([string isEqualToString:@"Women"]) {
            cell1.detailTextLabel.text = @"Other";
            NSString *query = [NSString stringWithFormat:@"UPDATE relation SET sex=2 WHERE relationID=%d",self.recordIDToEdit];
            [self.dbManager executeQuery:query];
        }
        if ([string isEqualToString:@"Other"]) {
            cell1.detailTextLabel.text = @"Men";
            NSString *query = [NSString stringWithFormat:@"UPDATE relation SET sex=0 WHERE relationID=%d",self.recordIDToEdit];
            [self.dbManager executeQuery:query];
            
        }
      
    }
    if (indexPath.row == 4) {
        JobViewController *jobVC = [[JobViewController alloc] init];
        jobVC.recordIDToEdit = self.recordIDToEdit;
        [self.navigationController pushViewController:jobVC animated:YES];
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
    
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    if (textField.tag == 0) {
    
   
    NSString* query = [NSString stringWithFormat:@"UPDATE relation SET name='%@' WHERE relationID=%d", textField.text,self.recordIDToEdit];
    

    [self.dbManager executeQuery:query];
    [self upDateGraphic];
        
    }
    
    if (textField.tag == 1) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        NSNumber* numberFromString = [formatter numberFromString:textField.text];
        if (numberFromString) {
        
        NSString* query = [NSString stringWithFormat:@"UPDATE relation SET age=%i WHERE relationID=%d", [textField.text intValue],self.recordIDToEdit];
        // Execute the query.
        [self.dbManager executeQuery:query];
        }else{
            NSLog(@"not a number");
        }

    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 1) {
        
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 3;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (textField.tag == 0) {
        if(textField.text){
        self.navigationItem.title = textField.text;
        }
    
        [self upDateGraphic];
        return YES;
    }
    if (textField.tag == 1) {
        
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        if ([textField.text isEqualToString:@"Name"]) {
            textField.text = @"";
        }
    }
    
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
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
