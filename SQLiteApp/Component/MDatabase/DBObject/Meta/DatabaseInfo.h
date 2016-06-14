//
//  DatabaseInfo.h
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableInfo.h"
@interface DatabaseInfo : NSObject
@property(nonatomic,copy)NSString *dbName;
@property(nonatomic,copy)NSString *dbPath;
@property(nonatomic,strong)NSArray *tables;

- (TableInfo *)tableInfoWithName:(NSString*)tableName;
@end
