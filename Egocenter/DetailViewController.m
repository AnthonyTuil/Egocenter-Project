//
//  DetailViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 03/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "DetailViewController.h"

#define d ((self.view.frame.size.width)*0.6)

@interface DetailViewController ()
@property (nonatomic, strong) DBManager *dbManager;
@property NSArray *objects_relation;
@property NSArray *objects_link;
@property NSArray *objects_group;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayViews = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing:)];
 
    self.navigationItem.rightBarButtonItem = doneBtn;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    
    [self configureView];
    [self loadData];
    
    
    // Do any additional setup after loading the view.
}

-(void)configureView{
    
    //int nb_cadran = [[NSUserDefaults standardUserDefaults] integerForKey:@"enquete_nb_cadran"];
    int nb_zone = 3;
    
    
    circleView = [[UIView alloc] init];
    circleView.frame = CGRectMake(0, 0, d, d);
    circleView.layer.cornerRadius = circleView.frame.size.width/2;
    circleView.backgroundColor = [UIColor grayColor];
    circleView.center = CGPointMake(self.view.center.x*0.7, self.view.center.y*1.1);
    
    
    UIView *littleCircle = [[UIView alloc] init];
    littleCircle.frame = CGRectMake(0, 0, d/10, d/10);
    littleCircle.layer.cornerRadius = littleCircle.frame.size.width/2;
    littleCircle.backgroundColor = [UIColor whiteColor];
    littleCircle.center = CGPointMake(circleView.frame.size.width/2, circleView.frame.size.height/2);
    
    if (nb_zone > 1) {
        
    
    for (int i=0; i<nb_zone-1; i++) {
        UIView *circle = [[UIView alloc] init];
        float width = ((float)(nb_zone-i-1)/(float)(nb_zone))*d;
        
        circle.frame = CGRectMake(0, 0,width, width);
        circle.layer.cornerRadius = circle.frame.size.width/2;
        
        float red = 100+100/(i+1);
        circle.backgroundColor = [UIColor colorWithRed:red/255.0 green:red/255.0 blue:red/255.0 alpha:1.0];
        circle.center = CGPointMake(circleView.frame.size.width/2, circleView.frame.size.height/2);
        
        [circleView addSubview:circle];
    }
        
    }

    
    [circleView addSubview:littleCircle];
    [self.view addSubview:circleView];
    
    // load previous relation
    
    
    
    
}



-(void)loadData{
    // Form the query.
    NSString *query_relation = @"SELECT * FROM relation";
    
    // Get the results.
    if (self.objects_relation != nil) {
        self.objects_relation = nil;
    }
    self.objects_relation = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query_relation]];
    
    NSInteger indexOfname = [self.dbManager.arrColumnNames indexOfObject:@"name"];
    
    
    for (int i =0; i< [self.objects_relation count]; i++) {
        
        NSString *test = [NSString stringWithFormat:@"%@", [[self.objects_relation objectAtIndex:i] objectAtIndex:indexOfname]];
        float x = [[[self.objects_relation objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"x"]] floatValue];
        float y = [[[self.objects_relation objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"y"]] floatValue];

        
        Relation *relationToLoad = [[Relation alloc] init];
        relationToLoad.name =test;
        relationToLoad.x = x;
        relationToLoad.y = y;
        // relation.colors add array colors from db 
        RelationView *relationViewToLoad = [[RelationView alloc] initRelationViewWithRelation:relationToLoad];
        
        [arrayViews addObject:relationViewToLoad];
        
        [circleView addSubview:relationViewToLoad];
    }
   
    
    
    /*
    NSString *query_link = @"select * from link";
    
    // Get the results.
    if (self.objects_link != nil) {
        self.objects_link = nil;
    }
    self.objects_link = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query_link]];
    
    NSString *query_group = @"select * from groups";
    
    // Get the results.
    if (self.objects_group != nil) {
        self.objects_group = nil;
    }
    self.objects_group = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query_group]];
    */
    
    
    
    
    // Reload the view.
    
    
}

-(void)doneEditing:(id)sender{
    // send form to serveur
}

#pragma add / remove

-(void)removeRelationAtIndex:(int)index
{
        RelationView *viewToRemove = [arrayViews objectAtIndex:index];
    
    
    [viewToRemove removeFromSuperview];
    [arrayViews removeObjectAtIndex:[arrayViews count]-index-1];
    
    
}


-(void)addRelation:(Relation*)relation{
    
    RelationView *relationView = [[RelationView alloc] initRelationViewWithRelation:relation];
    
    [arrayViews addObject:relationView];
    [circleView addSubview:relationView];
    
    
}

#pragma moove relation

BOOL hasStarted;
BOOL isLinking;
int indexMoving;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:circleView];
    
    // fire event for long press
    [self performSelector:@selector(fireLongPress)
               withObject:nil
               afterDelay:1.0];

    double distance = self.view.frame.size.width;
    int indexToMove = 0;
    
    // get the nearest relation
    if ([arrayViews count]) {
     
    for (int i =0; i<[arrayViews count]; i++) {
        RelationView *viewToCompare = [arrayViews objectAtIndex:i];
        double distanceToCompare = sqrt( (viewToCompare.center.x-touchLocation.x)*(viewToCompare.center.x-touchLocation.x)
                                        + (viewToCompare.center.y-touchLocation.y)*(viewToCompare.center.y-touchLocation.y));
        if (distanceToCompare < distance) {
            distance = distanceToCompare;
            indexToMove = i;
            indexMoving = i;
        }
    }
    if (distance < 30) {
       // check if the relation is close enought
        
        RelationView *viewToMove = [arrayViews objectAtIndex:indexToMove];
        viewToMove.center = touchLocation;
        isLinking = NO;
        hasStarted = YES;
    }
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:circleView];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(fireLongPress) object:nil];

    if (hasStarted) {
        RelationView *viewToMove = [arrayViews objectAtIndex:indexMoving];
        
        if (isLinking) {
           
            
            
        }else{
            // short press to move the relation
            viewToMove.center = touchLocation;

        }
    }
    
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:circleView];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(fireLongPress) object:nil];
    
    RelationView *viewToMove = [arrayViews objectAtIndex:indexMoving];
    
    // has long press for linking two relation
    if (isLinking) {
        // draw link
        
        
        
        
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        // end line point
        [path moveToPoint:CGPointMake(touchLocation.x, touchLocation.y)];
        // start line point
        [path addLineToPoint:CGPointMake(viewToMove.center.x, viewToMove.center.y)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
        shapeLayer.lineWidth = 2.0;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        
        [circleView.layer addSublayer:shapeLayer];
        
    }else if (hasStarted){
        // updatecoordinate
       
        //CGPoint new = [self convertCoordinate:touchLocation];
        NSString* query = [NSString stringWithFormat:@"UPDATE relation SET x=%f, y=%f WHERE name='%@'", touchLocation.x,touchLocation.y,viewToMove.name.text];
        
        //NSLog(@"%@",query);
        
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        

        
        
    }
    
    hasStarted = NO;
    isLinking = NO;
    
}

-(void)fireLongPress{
    
    if (hasStarted) {
        isLinking = YES;
        NSLog(@"drag to the relation you want to link");
    }
    
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

-(void)updateDataAtIndex:(int)index{
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM relation WHERE relationID=%d", index];
    
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    // Set the loaded data to the textfields.
    if ([results count]) {
        NSString* nameToUpdate = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]];
        

        RelationView *relationToUpdate;
        for (int i = 0; i<[arrayViews count]; i++) {
            RelationView *test = [arrayViews objectAtIndex:i];
            if (test.relation_id == index) {
                relationToUpdate = test;
                test.name.text = nameToUpdate;
                [arrayViews replaceObjectAtIndex:i withObject:test];
                
                
            }
        }
        
    }
    
    
    
    
}

                                               

-(CGPoint)convertCoordinate:(CGPoint)point{
    return  CGPointMake((point.x-circleView.frame.size.width/2)/(circleView.frame.size.width/2) , (circleView.frame.size.height/2-point.y)/(circleView.frame.size.height/2));
}
                                               
                                               
                                               
                                               
                                               


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
