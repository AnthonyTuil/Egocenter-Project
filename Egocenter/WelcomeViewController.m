//
//  WelcomeViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 27/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    UIButton *doctorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doctorButton.frame = CGRectMake(300, 300, 100, 20);
    [doctorButton setTitle:@"Medecin" forState:UIControlStateNormal];
    [doctorButton addTarget:self action:@selector(goToDoctor) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *patientButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    patientButton.frame = CGRectMake(600, 300, 100, 20);
    [patientButton setTitle:@"Patient" forState:UIControlStateNormal];
    [patientButton addTarget:self action:@selector(goToPatient) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self.view addSubview:doctorButton];
    [self.view addSubview:patientButton];
    
    // Do any additional setup after loading the view.
}

-(void)goToDoctor{
    // app delegate open doctor
    NSLog(@"Doctor Button Push");
    LoginDoctorViewController *loginDVC = [[LoginDoctorViewController alloc] init];
    [self.navigationController pushViewController:loginDVC animated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDoctor"];
}

-(void)goToPatient{
    // app delegate open patient
    NSLog(@"Patient Button Push");
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPatient"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
