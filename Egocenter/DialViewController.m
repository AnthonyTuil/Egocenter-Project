//
//  DialViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 29/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "DialViewController.h"

@interface DialViewController ()

@end

@implementation DialViewController

@synthesize checkedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    self.navigationItem.title = @"Dial";
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    NSString *query = [NSString stringWithFormat:@"SELECT dial FROM survey WHERE token=%d",self.recordIDToEdit];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger intJob = [[[results objectAtIndex:0] objectAtIndex:0] integerValue]-1;
    self.checkedIndexPath = [NSIndexPath indexPathForRow:intJob inSection:0];
    
    
}

#pragma TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
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
        cell.textLabel.text = @"1";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"2";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"3";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"4";
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
        
    }
    else
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedIndexPath = indexPath;
        NSString* query = [NSString stringWithFormat:@"UPDATE survey SET dial=%li WHERE token=%d", self.checkedIndexPath.row+1,self.recordIDToEdit];
        [self.dbManager executeQuery:query];

    }
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // save job
        
           }
    [super viewWillDisappear:animated];
}



@end
