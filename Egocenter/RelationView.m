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

-(void)setCircleWithColor{
    // split the circle into X color
}



-(RelationView*)initRelationViewWithRelation:(Relation*)relation{
    
    self = [super init];
   
    self.frame = CGRectMake(0, 0, d*3/20, d*3/20);
    
    
    circle = [[UIView alloc] init];
    circle.frame = CGRectMake(d/20, d/20, d/20, d/20);
    circle.layer.cornerRadius = circle.frame.size.width/2;
    circle.backgroundColor = [UIColor redColor];
    
    name = [[UILabel alloc] init];
    name.frame = CGRectMake(0, 0, self.frame.size.width, d/20);
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentCenter;
    name.adjustsFontSizeToFitWidth = YES;
    
    
    name.text = relation.name;
    self.center = CGPointMake(relation.x,relation.y);
    
   
    
    [self addSubview:name];
    [self addSubview:circle];

    
    return self;
    
}



@end
