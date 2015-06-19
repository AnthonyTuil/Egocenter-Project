//
//  DBManager.h
//  Egocenter
//
//  Created by Anthony Tuil on 12/06/2015.
//  Copyright (c) 2015 Anthony Tuil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManager : NSObject{
    
}

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;


-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;


@end
