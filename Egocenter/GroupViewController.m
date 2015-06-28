//
//  GroupViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 16/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController ()
@property NSArray *objects;
@property NSArray *selected;
@property NSMutableArray *indexes;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    self.navigationItem.title = @"My groups";
    
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    
    // Do any additional setup after loading the view.
    //[self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
}

-(void)loadData{
    // Form the query.
    
    NSString *query = @"SELECT * FROM groups";

    
    // Get the results.
    if (self.objects != nil) {
        self.objects = nil;
    }
    
    self.objects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"all groups %@",self.objects);
    // Reload the table view.
    
    NSString *query1 = [NSString stringWithFormat:@"SELECT * FROM relation_group WHERE relationID=%i",self.recordIDToEdit];
     NSLog(@"On va ici");
    // Get the results.
    if (self.selected != nil) {
        self.selected = nil;
    }
    
    self.selected = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query1]];
    
    
    if (self.indexes != nil) {
        self.indexes = nil;
    }
    
    self.indexes = [[NSMutableArray alloc] init];
    
    if ([self.selected count]) {
        NSLog(@"self.selected is not vide");
        for (int i = 0; i< [self.objects count]; i++) {
            int groupID = [[[self.objects objectAtIndex:i] objectAtIndex:0] intValue];
            for (int j = 0; j <[self.selected count]; j++) {
                int groupRelationId = [[[self.selected objectAtIndex:j] objectAtIndex:0] intValue];
                if (groupID == groupRelationId) {
                    
                        NSLog(@"index %i is selected",i);
                        [self.indexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    
                }
            }
        }
        
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

    
}

-(void)addAction:(id)sender{
    //random color
    
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    int r,g,b;
    
    r = (int)(255.0 * red);
    g = (int)(255.0 * green);
    b = (int)(255.0 * blue);
    
    
    NSString *color = [NSString stringWithFormat:@"%02x%02x%02x%02x", r, g, b, 1];
    
    //add to DB
    NSString *query = [NSString stringWithFormat:@"INSERT INTO groups values(null, 'GROUP_NAME','%@')",color];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    [self loadData];

    
    
}

#pragma UITableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.objects count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    if ([self.indexes containsObject:indexPath]) {
        NSLog(@"self.indexes contain indexPath");
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *colorString = [NSString stringWithFormat:@"%@", [[self.objects objectAtIndex:indexPath.row] objectAtIndex:2]];
    
    UIView * color = [[UIView alloc] init];
    color.frame = CGRectMake(15, 14, 20, 20);
    color.backgroundColor = [self colorFromHexString:colorString];
    color.layer.cornerRadius = 10;

    
    UITextField *nameColor = [[UITextField alloc] init];
    nameColor.frame = CGRectMake(45, 0, cell.frame.size.width, cell.frame.size.height);
    nameColor.text =[NSString stringWithFormat:@"%@", [[self.objects objectAtIndex:indexPath.row] objectAtIndex:1]];
    [nameColor becomeFirstResponder];
    nameColor.returnKeyType = UIReturnKeyDone;
    nameColor.delegate = self;
    if (![nameColor.text isEqualToString:@"GROUP_NAME"]) {
        nameColor.enabled = NO;
    }
    
    [cell.contentView addSubview:color];
    [cell.contentView addSubview:nameColor];
    
    
    return cell;

    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([self.indexes containsObject:indexPath]) {
        
        NSLog(@"contains object");
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        [self.indexes removeObject:indexPath];
        
    }else if ([self.indexes count]<3){
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.indexes addObject:indexPath];
    }
}


-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
       
        
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if ([textField.text isEqualToString:@""] || [textField.text isEqualToString:@"GROUP_NAME"]) {
        NSLog(@"Vous devez rentrer un nom de group");
    }else{
        [textField resignFirstResponder];
        textField.enabled = NO;
        
        
        NSString* queryName = [NSString stringWithFormat:@"SELECT * FROM groups WHERE name='%@'", textField.text];
        if ([[self.dbManager loadDataFromDB:queryName] count]) {
            NSLog(@"Name already taken");
        }else{
            
            NSString* query = [NSString stringWithFormat:@"UPDATE groups SET name='%@' WHERE name='GROUP_NAME'", textField.text];
            [self.dbManager executeQuery:query];
            NSLog(@"Nom enregistré");

        }
             
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
   
    
    }

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        if ([textField.text isEqualToString:@"GROUP_NAME"]) {
            textField.text = @"";
        }
    }
    
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
      
        
            NSString* query = [NSString stringWithFormat:@"DELETE FROM relation_group WHERE relationID=%d",self.recordIDToEdit];
            [self.dbManager executeQuery:query];
        
        
        
        for (int i =0; i< [self.indexes count]; i++) {
            //
            NSLog(@"%lu",(unsigned long)[self.indexes count]);
            NSIndexPath *indexPathToAdd = [self.indexes objectAtIndex:i];
            
            int groupeId = [[[self.objects objectAtIndex:indexPathToAdd.row] objectAtIndex:0] intValue];
            
            
            NSString* query1 = [NSString stringWithFormat:@"INSERT INTO relation_group values(%i, %i)",groupeId, self.recordIDToEdit];
            [self.dbManager executeQuery:query1];
            
        }
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
