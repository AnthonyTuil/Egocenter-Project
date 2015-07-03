//
//  MasterTableViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 03/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "MasterTableViewController.h"

#define ARC4RANDOM_MAX      0x100000000

@interface MasterTableViewController ()
@property NSArray *objects;
@end

@implementation MasterTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    
    self.navigationItem.title = @"My contacts";
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
   //NSString *deleteQuery = @"DELETE FROM groups";
   //NSString *deleteQuery1 = @"DELETE FROM relation_group";
   //[self.dbManager executeQuery:deleteQuery];
   //[self.dbManager executeQuery:deleteQuery1];

    [self loadData];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    
    
    [self loadData];
}

-(void)setTitleForNav:(NSString *)title{
    self.navigationItem.title = title;
}

-(void)loadData{
    // Form the query.
    NSString *query = @"SELECT * FROM relation";
    
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
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSInteger indexOfname = [self.dbManager.arrColumnNames indexOfObject:@"name"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.objects objectAtIndex:indexPath.row] objectAtIndex:indexOfname]];
    
    return cell;
}

-(void)addAction:(id)sender{
    
    
    
    relationToAdd = [[Relation alloc] init];
    relationToAdd.name = @"Name";
    relationToAdd.x = ((float)arc4random() / ARC4RANDOM_MAX*421);
    relationToAdd.y = ((float)arc4random() / ARC4RANDOM_MAX*421);
    relationToAdd.sex = 0;
    relationToAdd.age = 18;
    relationToAdd.job = 1;
    relationToAdd.colors = [NSMutableArray arrayWithObjects:[self colorFromHexString:@"#FB4141"], nil];
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO relation values(null, '%@', %f, %f,%i,%i,%i)", relationToAdd.name, relationToAdd.x, relationToAdd.y,relationToAdd.age ,relationToAdd.sex,relationToAdd.job];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    [self loadData];
    
    NSString *query1 = [NSString stringWithFormat:@"SELECT relationID FROM relation WHERE name='%@' AND x=%f AND y=%f", relationToAdd.name, relationToAdd.x,relationToAdd.y];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query1]];
    relationToAdd.relationID =[[[results objectAtIndex:0] objectAtIndex:0] intValue];
    
    
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController*)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[DetailViewController class]]) {

        [detail addRelation:relationToAdd];
    }
    
    
    
    RelationViewController *relationVC = [[RelationViewController alloc] init];
    relationVC.recordIDToEdit = [[[self.objects objectAtIndex:[self.objects count]-1] objectAtIndex:0] intValue];
    [self.navigationController pushViewController:relationVC animated:YES];

}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RelationViewController *relationVC = [[RelationViewController alloc] init];
    relationVC.recordIDToEdit  = [[[self.objects objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    [self.navigationController pushViewController:relationVC animated:YES];
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
    
        int recordIDToDelete = [[[self.objects objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        //NSLog(@"%@",self.objects);
        // Prepare the query.
        
        id detail = self.splitViewController.viewControllers[1];
        if ([detail isKindOfClass:[UINavigationController class]]) {
            detail = [((UINavigationController*)detail).viewControllers firstObject];
        }
        if ([detail isKindOfClass:[DetailViewController class]]) {
            // code the retrieve relation in detail
            [detail removeRelationAtIndex:recordIDToDelete];
        }

        NSString *query = [NSString stringWithFormat:@"DELETE FROM relation WHERE relationID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}




@end
