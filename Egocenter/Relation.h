//
//  Relation.h
//  Egocenter
//
//  Created by Anthony Tuil on 06/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Relation : NSObject{
    int relationID;
    NSString *name;
    float x;
    float y;
    NSMutableArray *colors;
    NSMutableArray *links;

}

@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *links;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int relationID;
@property (nonatomic) float x;
@property (nonatomic) float y;

@end
