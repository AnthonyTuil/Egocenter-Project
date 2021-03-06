//
//  RelationView.h
//  Egocenter
//
//  Created by Anthony Tuil on 14/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Relation.h"

@interface RelationView : UIView{
    int relation_id;
    UILabel *name;
    UIView *circle;
    NSMutableArray *arrayColor;
    NSMutableArray *arrayLink;
    
}

-(UIView*)initRelationViewWithRelation:(Relation*)relation;

@property(nonatomic) int relation_id;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UIView *circle;
@property(nonatomic, strong) NSArray *arrayColor;
@property(nonatomic, strong) NSMutableArray *arrayLink;

@end
