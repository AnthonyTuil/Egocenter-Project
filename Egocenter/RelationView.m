//
//  RelationView.m
//  Egocenter
//
//  Created by Anthony Tuil on 14/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "RelationView.h"

#define d (421.0)

@implementation RelationView
@synthesize name;
@synthesize arrayColor;
@synthesize arrayLink;
@synthesize circle;
@synthesize relation_id;

#define DEG2RAD(degrees) (degrees * 0.01745327)

-(void)setCircleWithColor{
    // split the circle into X color
}



-(RelationView*)initRelationViewWithRelation:(Relation*)relation{
    
    self = [super init];
   
    self.frame = CGRectMake(0, 0, d*3/20, d*3/20);
    
    
    circle = [[UIView alloc] init];
    circle.frame = CGRectMake(d/20, d/20, d/20, d/20);
    circle.layer.cornerRadius = circle.frame.size.width/2;
    
    if ([relation.colors count]) {
      
    if ([relation.colors count] == 1) {
        circle.backgroundColor = relation.colors[0];

    }
    if ([relation.colors count] == 2){
     circle.backgroundColor = relation.colors[0];
     [circle.layer addSublayer:[self createPieSliceWithStartAngle:-90.0 andEndAngle:90.0 andColor:relation.colors[1]]];

     
    }if ([relation.colors count] == 3){
        circle.backgroundColor = relation.colors[0];
        [circle.layer addSublayer:[self createPieSliceWithStartAngle:0.0 andEndAngle:120.0 andColor:relation.colors[1]]];
        [circle.layer addSublayer:[self createPieSliceWithStartAngle:120.0 andEndAngle:240.0 andColor:relation.colors[2]]];
        
    }
    }else{
        circle.backgroundColor = [UIColor grayColor];

    }
    
    
    

    
    name = [[UILabel alloc] init];
    name.frame = CGRectMake(0, 0, self.frame.size.width, d/20);
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentCenter;
    name.adjustsFontSizeToFitWidth = YES;
    
    
    name.text = relation.name;
    self.center = CGPointMake(relation.x,relation.y);
    self.relation_id = relation.relationID;
   
    
    [self addSubview:name];
    [self addSubview:circle];

    
    return self;
    
}

-(CAShapeLayer *)createPieSliceWithStartAngle:(float)angleStart andEndAngle:(float)angleEnd andColor:(UIColor*)color {
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.fillColor = color.CGColor;
    slice.strokeColor = [UIColor clearColor].CGColor;
    slice.lineWidth = 1.0;
    
    CGFloat angle = DEG2RAD(angleStart);
    CGPoint center = CGPointMake(circle.frame.size.width/2, circle.frame.size.height/2);
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



@end
