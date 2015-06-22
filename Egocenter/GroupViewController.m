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
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
   self.navigationItem.title = @"My groups";
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData{
    // Form the query.
    NSString *query = @"SELECT * FROM groups";
    
    // Get the results.
    if (self.objects != nil) {
        self.objects = nil;
    }
    self.objects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
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
    NSString *query = [NSString stringWithFormat:@"INSERT INTO groups values(%i, 'GROUP_NAME','%@')", self.recordIDToEdit,color];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    [self loadData];

    
    
}

#pragma Uitableview

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
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    NSInteger indexOfColor = [self.dbManager.arrColumnNames indexOfObject:@"color"];
    NSString *colorString = [NSString stringWithFormat:@"%@", [[self.objects objectAtIndex:indexPath.row] objectAtIndex:indexOfColor]];
    
    UIView * color = [[UIView alloc] init];
    color.frame = CGRectMake(15, 14, 20, 20);
    color.backgroundColor = [self colorFromHexString:colorString];
    color.layer.cornerRadius = 10;

    NSInteger indexOfname = [self.dbManager.arrColumnNames indexOfObject:@"name_group"];
    UITextField *nameColor = [[UITextField alloc] init];
    nameColor.frame = CGRectMake(45, 0, cell.frame.size.width, cell.frame.size.height);
    nameColor.text =[NSString stringWithFormat:@"%@", [[self.objects objectAtIndex:indexPath.row] objectAtIndex:indexOfname]];
    
    
    [cell.contentView addSubview:color];
    [cell.contentView addSubview:nameColor];
    
    
    return cell;

    

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
