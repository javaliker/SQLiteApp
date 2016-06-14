//
//  DataStoreBO.h
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseInfo.h"
#import "TableInfo.h"
@class DAO;
@interface DataStoreBO : NSObject
+ (DataStoreBO*)sharedInstance;
@property(nonatomic,readonly)DatabaseInfo *databaseInfo;
@property(nonatomic,readonly)DAO          *defaultDao;

- (BOOL)openDefaultDB;
- (BOOL)openDBWithPath:(NSString*)path;
- (void)clear;
- (void)refreshTables;

- (DatabaseInfo*)databaseInfo;
- (TableInfo*)tableInfoWithName:(NSString*)tableName;
@end
