//
//  Group.h
//  Egocenter
//
//  Created by Anthony Tuil on 25/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject{
    NSString *name_group;
    NSString *color;
    int id_relation;
}

@property (nonatomic, strong) NSString *name_group;
@property (nonatomic, strong) NSString *color;
@property (nonatomic) int id_relation;

@end
