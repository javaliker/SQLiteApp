//
//  DataStoreBO.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "DataStoreBO.h"
#import "MDatabase+Meta.h"
#import "DAO.h"
#import "Constant.h"

@interface DataStoreBO ()
@property(nonatomic,strong)NSMutableDictionary *dataBaseCache;
@property(nonatomic,readwrite)DatabaseInfo *databaseInfo;
@property(nonatomic,readwrite)DAO          *defaultDao;
@end

@implementation DataStoreBO
+ (DataStoreBO*)sharedInstance {
    static DataStoreBO *instace = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instace = [[self alloc] init];
        
    });
    return instace;
}

- (BOOL)openDefaultDB {
    
    return [[MDatabase sharedInstance]openDBWithName:kDefaultDatabaseName];
 
}
- (BOOL)openDBWithPath:(NSString*)path {
    [self clear];
    return [[MDatabase sharedInstance]openDBWithPath:path];
}

- (void)clear {
    _databaseInfo = nil;
    _dataBaseCache = nil;
    [[MDatabase sharedInstance]close];
}

- (void)refreshTables {
    _databaseInfo.tables = [[MDatabase sharedInstance] tables];
}

- (DatabaseInfo*)databaseInfo {
    if(!_databaseInfo){
        _databaseInfo = [[DatabaseInfo alloc]init];
        _databaseInfo.dbPath = [MDatabase sharedInstance].dbPath;
        _databaseInfo.dbName = [[MDatabase sharedInstance].dbPath lastPathComponent];
        _databaseInfo.tables = [[MDatabase sharedInstance] tables];
    }
    return _databaseInfo;
}

- (TableInfo*)tableInfoWithName:(NSString*)tableName {
    return [self.databaseInfo tableInfoWithName:tableName];
}

- (NSMutableDictionary*)dataBaseCache {

    if(!_dataBaseCache){
        _dataBaseCache = [[NSMutableDictionary alloc]init];
    }
    return _dataBaseCache;
}


- (DAO*)defaultDao {
    if(!_defaultDao){
        _defaultDao = [[DAO alloc]init];
    }
    return _defaultDao;
}

@end
