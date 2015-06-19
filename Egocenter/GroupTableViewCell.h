//
//  GroupTableViewCell.h
//  Egocenter
//
//  Created by Anthony Tuil on 16/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell{
    UILabel *primaryLabel;
    UIView *firstColor;
    UIView *secondColor;
    UIView *thirdColor;
}

@property(nonatomic,retain)UILabel *primaryLabel;
@property(nonatomic,retain)UIView *firstColor;
@property(nonatomic,retain)UIView *secondColor;
@property(nonatomic,retain)UIView *thirdColor;

@end
