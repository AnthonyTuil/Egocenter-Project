//
//  GroupTableViewCell.m
//  Egocenter
//
//  Created by Anthony Tuil on 16/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import "GroupTableViewCell.h"

@implementation GroupTableViewCell
@synthesize primaryLabel,firstColor,secondColor,thirdColor;

- (void)awakeFromNib {
    // Initialization code
}

-(void)setColors:(UIColor*)color atIndex:(int)index{
    
    switch (index) {
        case 0:
            firstColor.backgroundColor = color;
            break;
        case 1:
            secondColor.backgroundColor = color;
            break;
        case 2:
            thirdColor.backgroundColor = color;
            break;
        default:
            break;
    }
   
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        primaryLabel = [[UILabel alloc]init];
        primaryLabel.frame = CGRectMake(20, 0, 100, 50);
        primaryLabel.textAlignment = NSTextAlignmentLeft;
        primaryLabel.font = [UIFont boldSystemFontOfSize:17];
        
        
        firstColor = [[UIView alloc] init];
        firstColor.frame = CGRectMake(256, 14, 20, 20);
        firstColor.backgroundColor = [UIColor grayColor];
        firstColor.layer.cornerRadius = 10;
        
        secondColor = [[UIView alloc] init];
        secondColor.frame = CGRectMake(227, 14, 20, 20);
        secondColor.backgroundColor = [UIColor grayColor];
        secondColor.layer.cornerRadius = 10;
        
        thirdColor = [[UIView alloc] init];
        thirdColor.frame = CGRectMake(198, 14, 20, 20);
        thirdColor.backgroundColor = [UIColor grayColor];
        thirdColor.layer.cornerRadius = 10;
        
        
        
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:firstColor];
        [self.contentView addSubview:secondColor];
        [self.contentView addSubview:thirdColor];
        
        
    }
    return self;
}



@end
