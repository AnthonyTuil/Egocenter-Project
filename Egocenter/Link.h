//
//  Link.h
//  Egocenter
//
//  Created by Anthony Tuil on 03/07/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Link : NSObject  {
    int fromRelation;
    int toRelation;
}

@property (nonatomic) int fromRelation;
@property (nonatomic) int toRelation;

@end
