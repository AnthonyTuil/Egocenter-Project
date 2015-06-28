//
//  JobViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 24/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "JobViewController.h"

@interface JobViewController ()

@end

@implementation JobViewController
@synthesize checkedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    self.navigationItem.title = @"Jobs";

    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    NSString *query = [NSString stringWithFormat:@"SELECT job FROM relation WHERE relationID=%d",self.recordIDToEdit];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger intJob = [[[results objectAtIndex:0] objectAtIndex:0] integerValue]-1;
    self.checkedIndexPath = [NSIndexPath indexPathForRow:intJob inSection:0];
   

}

#pragma TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    
    if([self.checkedIndexPath isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"1 - Agriculteurs exploitants";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"2 - Artisans, commerçants et chefs d'entreprise";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"3 - Cadres et professions intellectuelles supérieures";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"4 - Professions Intermédiaires";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"5 - Employés";
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = @"6 - Ouvriers";
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = @"7 - Retraités";
    }
    if (indexPath.row == 7) {
        cell.textLabel.text = @"8 - Autres personnes sans activité professionnelle";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Uncheck the previous checked row
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
    }
    else
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedIndexPath = indexPath;
    }
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // save job
       
        NSString* query = [NSString stringWithFormat:@"UPDATE relation SET job=%li WHERE relationID=%d", self.checkedIndexPath.row+1,self.recordIDToEdit];
        
        
        [self.dbManager executeQuery:query];
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
