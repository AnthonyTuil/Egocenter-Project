//
//  DetailViewController.m
//  Egocenter
//
//  Created by Anthony Tuil on 03/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "DetailViewController.h"

#define d ((self.view.frame.size.width)*0.6)
#define DEG2RAD(degrees) (degrees * 0.01745327)

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
 
    button = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self action:@selector(visualise:)];
    self.navigationItem.leftBarButtonItem = button;
    
    self.navigationItem.rightBarButtonItem = doneBtn;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"egocenter.sql"];
    
    [self configureView];
    [self loadData];
    
    
    // Do any additional setup after loading the view.
}

-(void)visualise:(id)sender{
    
    PopoverDoctorTableViewController *podVC = [[PopoverDoctorTableViewController alloc] init];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:podVC];
    popover.delegate = self;
    popover.popoverContentSize = CGSizeMake(200, 100); //your custom size.
    UIBarButtonItem *item = button ;
    UIView *view = [item valueForKey:@"view"];
    
    [popover presentPopoverFromRect:view.frame inView:self.view permittedArrowDirections: UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionUp animated:YES];

    
}

-(void)configureView{
    
    //int nb_cadran = [[NSUserDefaults standardUserDefaults] integerForKey:@"enquete_nb_cadran"];
    int nb_zone = [[NSUserDefaults standardUserDefaults] integerForKey:@"enquete_nb_zone"];
    
    
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
        float x = [[[self.objects_relation objectAtIndex:i] objectAtIndex:2] floatValue];
        float y = [[[self.objects_relation objectAtIndex:i] objectAtIndex:3] floatValue];
        int id_relation = [[[self.objects_relation objectAtIndex:i] objectAtIndex:0] intValue];

        
        Relation *relationToLoad = [[Relation alloc] init];
        relationToLoad.name =test;
        relationToLoad.x = x;
        relationToLoad.y = y;
        relationToLoad.relationID = id_relation;
        
        NSString *queryColor = [NSString stringWithFormat:@"SELECT groups.* FROM groups, relation_group WHERE relation_group.groupsID = groups.groupID AND relation_group.relationID = %i",id_relation];
        NSArray *result = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryColor]];
        if (result) {
            relationToLoad.colors =[[NSMutableArray alloc] init];
            for (int i=0; i<[result count]; i++) {
                [relationToLoad.colors insertObject:[self colorFromHexString:[[result objectAtIndex:i] objectAtIndex:2]] atIndex:i];
            }
            
        }
        
        // relation.colors add array colors from db 
        RelationView *relationViewToLoad = [[RelationView alloc] initRelationViewWithRelation:relationToLoad];
        
        [arrayViews addObject:relationViewToLoad];
        
        [circleView addSubview:relationViewToLoad];
    }
   
    
    
    
    
    
    // Reload the view.
    
    
}

-(void)doneEditing:(id)sender{
    // send form to serveur
}

#pragma add / remove

-(void)removeRelationAtIndex:(int)index
{
    
 
    
    for (int i =0; i< [arrayViews count]; i++) {
        RelationView *test = [arrayViews objectAtIndex:i];
        NSLog(@"index : %i // arrayview : %i count : %i",index,test.relation_id,[arrayViews count]);
        if (test.relation_id == index) {
            [test removeFromSuperview];
            [arrayViews removeObjectAtIndex:i];
        }
    }
    
    
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
       
        // check the nearest relation
                
        
        
        
        
        
    }else if (hasStarted){
        // updatecoordinate
       
        //CGPoint new = [self convertCoordinate:touchLocation];
        NSString* query = [NSString stringWithFormat:@"UPDATE relation SET x=%f, y=%f WHERE name='%@'", touchLocation.x,touchLocation.y,viewToMove.name.text];
        
        //NSLog(@"%@",query);
        
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // redraw all link for viewtoMove
        
        

        
        
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
        NSString *queryColor = [NSString stringWithFormat:@"SELECT groups.* FROM groups, relation_group WHERE relation_group.groupsID = groups.groupID AND relation_group.relationID = %i",index];
        NSArray *result = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryColor]];
        

        RelationView *relationToUpdate;
        for (int i = 0; i<[arrayViews count]; i++) {
            RelationView *test = [arrayViews objectAtIndex:i];
            if (test.relation_id == index) {
                relationToUpdate = test;
                test.name.text = nameToUpdate;
                if ([result count]) {
                    if ([result count] == 1) {
                        test.circle.layer.sublayers = nil;
                        test.circle.backgroundColor = [self colorFromHexString:[[result objectAtIndex:0] objectAtIndex:2]];
                        
                    }
                    if ([result count] == 2){
                        test.circle.layer.sublayers = nil;
                        test.circle.backgroundColor = [self colorFromHexString:[[result objectAtIndex:0] objectAtIndex:2]];
                        [test.circle.layer addSublayer:[self createPieSliceWithStartAngle:-90.0 andEndAngle:90.0 andColor:[self colorFromHexString:[[result objectAtIndex:1] objectAtIndex:2]]]];
                        
                        
                    }if ([result count] == 3){
                        test.circle.layer.sublayers = nil;
                        test.circle.backgroundColor = [self colorFromHexString:[[result objectAtIndex:0] objectAtIndex:2]];
                        [test.circle.layer addSublayer:[self createPieSliceWithStartAngle:0 andEndAngle:120.0 andColor:[self colorFromHexString:[[result objectAtIndex:1] objectAtIndex:2]]]];
                       [test.circle.layer addSublayer:[self createPieSliceWithStartAngle:120.0 andEndAngle:240.0 andColor:[self colorFromHexString:[[result objectAtIndex:2] objectAtIndex:2]]]];
                        
                    }
                }else{
                    test.circle.backgroundColor = [UIColor grayColor];
                    
                }
                [arrayViews replaceObjectAtIndex:i withObject:test];
                
                
            }
        }
        
    }
    
    
    
    
}

                                               

-(CGPoint)convertCoordinate:(CGPoint)point{
    return  CGPointMake((point.x-circleView.frame.size.width/2)/(circleView.frame.size.width/2) , (circleView.frame.size.height/2-point.y)/(circleView.frame.size.height/2));
}



-(CAShapeLayer *)createPieSliceWithStartAngle:(float)angleStart andEndAngle:(float)angleEnd andColor:(UIColor*)color {
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.fillColor = color.CGColor;
    slice.strokeColor = [UIColor clearColor].CGColor;
    slice.lineWidth = 1.0;
    
    CGFloat angle = DEG2RAD(angleStart);
    CGPoint center = CGPointMake(d/40,d/40);
    CGFloat radius = d/40;
    
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center];
    
    [piePath addLineToPoint:CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle))];
    
    [piePath addArcWithCenter:center radius:radius startAngle:angle endAngle:DEG2RAD(angleEnd) clockwise:YES];
    
    //  [piePath addLineToPoint:center];
    [piePath closePath]; // this will automatically add a straight line to the center
    slice.path = piePath.CGPath;
    
    return slice;
}

                                               
                                               
                                               


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
