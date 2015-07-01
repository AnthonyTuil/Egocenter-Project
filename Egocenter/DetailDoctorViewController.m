//
//  DetailDoctorViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 27/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "DetailDoctorViewController.h"

@interface DetailDoctorViewController ()
@property (nonatomic, strong) DBManager *dbManager;
@property NSArray *objects;

@end

@implementation DetailDoctorViewController
@synthesize surveyToEdit;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendToServor:)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneBtn;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStyleDone target:self action:@selector(visualise:)];
    self.navigationItem.leftBarButtonItem = button;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)visualise:(id)sender{
    
}

-(void)sendToServor:(id)sender{
    // send survey to serveur
    SendSurveyViewController *sendVC = [[SendSurveyViewController alloc] init];
    sendVC.recordIDToEdit = self.surveyToEdit;
    [self.navigationController pushViewController:sendVC animated:YES];
    
}

-(void)loadData{
    if (self.objects != nil) {
        self.objects = nil;
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM survey WHERE token=%i",self.surveyToEdit];
    self.objects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"%@",self.objects);
    self.navigationItem.title =[NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:1]];

    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 50;
            
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 100;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 50;
        }
        if (indexPath.row == 1) {
            return 50;
        }
        if (indexPath.row == 2) {
            return 50;
        }
    }

    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 3;
    }
    if (section == 3) {
        return 2;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Title";
            break;
        case 1:
            sectionName = @"Instructions";
            break;
        
        case 2:
            sectionName = @"Relation Attributes";
            break;
        case 3:
            sectionName = @"Graphic parameters";
            break;
        default:
            break;
    }
    return sectionName;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        if (indexPath.row ==0) {
             DialViewController*dialVC = [[DialViewController alloc] init];
            dialVC.recordIDToEdit = self.surveyToEdit;
            [self.navigationController pushViewController:dialVC animated:YES];
        }
        if (indexPath.row ==1) {
            QuadranViewController *quadranlVC = [[QuadranViewController alloc] init];
            quadranlVC.recordIDToEdit = self.surveyToEdit;
            [self.navigationController pushViewController:quadranlVC animated:YES];

        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (indexPath.section == 0 ) {
            if (indexPath.row == 0) {
                titleTextField = [[UITextField alloc] init];
                titleTextField.placeholder = @"Title";
                titleTextField.tag = 1;
                titleTextField.frame = CGRectMake(20, 0, self.navigationController.view.frame.size.width, cell.frame.size.height);
                titleTextField.returnKeyType = UIReturnKeyDone;
                titleTextField.delegate = self;
                titleTextField.textAlignment = NSTextAlignmentLeft;
                titleTextField.text = [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:1]];
                [cell.contentView addSubview:titleTextField];
            }
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                
                
                cell.selectionStyle =UITableViewCellSelectionStyleNone;
                
                instructionTextView = [[UITextView alloc] init];
                instructionTextView.frame = CGRectMake(20, 0, cell.frame.size.width, cell.frame.size.height);
                instructionTextView.text =[NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:2]];
                instructionTextView.delegate =self;
                [cell.contentView addSubview:instructionTextView];
                
            }
        }
    }
    
    if (indexPath.section == 0) {
    
        if (indexPath.row == 0) {
            titleTextField.text = [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:1]];
            
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            instructionTextView.text =[NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:2]];
            }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Age";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(254, 6, 51, 31)];
            ageSwitch.on = [[[self.objects objectAtIndex:0] objectAtIndex:3] boolValue];
            ageSwitch.tag = 0;
            [ageSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = ageSwitch;
            
            
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Sex";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            sexSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(254, 6, 51, 31)];
            sexSwitch.on = [[[self.objects objectAtIndex:0] objectAtIndex:4] boolValue];
            sexSwitch.tag = 1;
            [sexSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];

            cell.accessoryView = sexSwitch;
            
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Job";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            jobSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(254, 6, 51, 31)];
            jobSwitch.on = [[[self.objects objectAtIndex:0] objectAtIndex:5] boolValue];
            jobSwitch.tag = 2;
            [jobSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];

            cell.accessoryView = jobSwitch;
            
        }
    }
    if (indexPath.section == 3) {

        if (indexPath.row == 0) {
            cell.textLabel.text = @"Number on Dial";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Number on Quadran";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
    }
    

    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *newString = [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:1]];
    if (![newString isEqualToString:textField.text]) {
        NSString *query = [NSString stringWithFormat:@"UPDATE survey SET title='%@' WHERE token=%i",textField.text,self.surveyToEdit];
        [self.dbManager executeQuery:query];
        self.navigationItem.title = newString;
        
        id master = self.splitViewController.viewControllers[0];
        if ([master isKindOfClass:[UINavigationController class]]) {
            master = [((UINavigationController*)master).viewControllers firstObject];
        }
        if ([master isKindOfClass:[MasterDoctorTableViewController class]]) {
            // code the retrieve relation in detail
            [master loadData];
        }
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSString *newString = [NSString stringWithFormat:@"%@",[[self.objects objectAtIndex:0] objectAtIndex:2]];
    if (![newString isEqualToString:textView.text]) {
        NSLog(@"didend diff");
        NSString *query = [NSString stringWithFormat:@"UPDATE survey SET instruction='%@' WHERE token=%i",textView.text,self.surveyToEdit];
        [self.dbManager executeQuery:query];
        self.navigationItem.title = newString;
    }

}

- (void)setState:(id)sender
{
    NSInteger tag = ((UISwitch*)sender).tag;
    BOOL state = [sender isOn];
    if (tag == 0) {
        NSString *query = [NSString stringWithFormat:@"UPDATE survey SET age=%i WHERE token=%i",state,self.surveyToEdit];
        [self.dbManager executeQuery:query];
    }
    if (tag == 1) {
        NSString *query = [NSString stringWithFormat:@"UPDATE survey SET sex=%i WHERE token=%i",state,self.surveyToEdit];
        [self.dbManager executeQuery:query];
    }
    if (tag == 2) {
        NSString *query = [NSString stringWithFormat:@"UPDATE survey SET job=%i WHERE token=%i",state,self.surveyToEdit];
        [self.dbManager executeQuery:query];
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
