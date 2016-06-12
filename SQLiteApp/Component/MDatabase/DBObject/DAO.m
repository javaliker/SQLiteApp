//
//  DAO.m
//  MDatabase
//
//  Created by MacDev on 16/6/8.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "DAO.h"

#import "Macros.h"
#import "MDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface DAO ()
@property(nonatomic,assign)NSInteger numbersOfRecord;/*numbers of record in table*/
@end

@implementation DAO
- (id)init{
    self = [super init];
    if(self){
        _queue = [MDatabase sharedInstance].queue;
        if(!_queue){
            return  nil;
        }
    }
    return self;
}

#pragma mark - Page 

- (NSInteger)numbersOfRecord {
    if(!self.tableName){
        return 0;
    }
    NSString *sql =[NSString stringWithFormat:@"SELECT count(*) as count FROM %@", self.tableName];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        _numbersOfRecord = 0;
        if([rs next]) {
            _numbersOfRecord  = [rs intForColumnIndex:0];
        }
        [rs close];
    }];
    return _numbersOfRecord;
}

- (NSInteger)pageNumberWithSize:(NSInteger)pageSize {
    if(!self.tableName){
        return 0;
    }
    XXXAssert(pageSize>0);
    NSString *sql =[NSString stringWithFormat:@"SELECT count(*) as count FROM %@", self.tableName];
    
    __block NSInteger pageNumber = 0;
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        _numbersOfRecord = 0;
        if([rs next]) {
            _numbersOfRecord  = [rs intForColumnIndex:0];
        }
        [rs close];
        if(_numbersOfRecord>0){
            pageNumber =  ceil(_numbersOfRecord/pageSize);
        }
        
    }];
    return pageNumber;
}
- (NSInteger)numbersOfRecordWithSQL:(NSString*)sql {
    __block NSInteger count = 0;
    NSString *queryTemp = [sql lowercaseString];
    NSRange dividerRange = [queryTemp rangeOfString:@"from"];
    if(dividerRange.location==NSNotFound){
        return 0;
    }
    NSUInteger divide = NSMaxRange(dividerRange);
    
    //NSString *scheme = [self substringToIndex:divide];
    NSString *fromSQL = [sql substringFromIndex:divide];
    
    NSString *countSQL = [NSString stringWithFormat:@"SELECT COUNT(*) as count FROM %@",fromSQL];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:countSQL];
        _numbersOfRecord = 0;
        if([rs next]) {
            count  = [rs intForColumnIndex:0];
        }
        [rs close];
        
    }];
    return count;
}


- (NSInteger)pageNumberWithSQL:(NSString*)sql pageSize:(NSInteger)pageSize {
    XXXAssert(pageSize>0);
   
    __block NSInteger pageNumber = 0;
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        NSInteger count  = 0;
        if([rs next]) {
            count  = [rs intForColumnIndex:0];
        }
        [rs close];
        if(count>0){
            pageNumber =  ceil(count/pageSize);
        }
        
    }];
    return pageNumber;
}

#pragma mark - insert/update/delete

- (BOOL)insert:(id)model {
    if(!model){
        return NO;
    }
    NSInteger keyCount = [self.keyList count];
    if(keyCount==0){
        return NO;
    }
    
    if(keyCount>0){
        NSString *key = self.keyList[0];
        NSInteger keyID = [[model valueForKey:key]integerValue];
        if(keyID==0){
            keyID = [[self findMaxKey]integerValue]+1;
            [model setValue:@(keyID) forKey:key];
        }
        else {
            if([self findByKey:model]){
                DLog(@"info:add %@ exsist!\n",self.tableName);
                return [self update:model];
            }
        }
    }
   
    NSMutableString *vals = [[NSMutableString alloc]initWithCapacity:10];
    NSInteger fieldCount = [self.fldList count];
    for(NSInteger i =0 ;i < fieldCount;i++){
        if(i!=fieldCount-1){
            [vals appendString:@"?,"];
        }
        else{
            [vals appendString:@"?"];
        }
    }
    NSString *fieldString = [self.fldList componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ( %@ )",self.tableName,fieldString,vals];
    DLog(@"insert sql=%@",sql)
    NSMutableArray *args=[[NSMutableArray alloc]initWithCapacity:10];
    for(NSInteger i =0 ;i < fieldCount;i++){
        NSString *mapkey = [self.fldList objectAtIndex:i];
        id value = [model valueForKey:mapkey];
        if(!value){
            value = [NSNull null];
        }
        [args addObject:value];
    }
    
    __block BOOL  isOK  = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        isOK = [db executeUpdate:sql withArgumentsInArray:args];
        DLog("insert lastErrorMessage =%@",[db lastErrorMessage]);
    }];
    return isOK;
}

- (BOOL)update:(id)model {
    if(!model){
        return NO;
    }
    if(![self findByKey:model]){
        DLog(@"info:no exsist update Model!\n");
        return NO;
    }
    NSMutableString *wheres = [[NSMutableString alloc]initWithCapacity:10];
    NSInteger keyCount = [self.keyList count];
    NSMutableString *fieldVals = [[NSMutableString alloc]initWithCapacity:10];
    NSMutableArray *args=[NSMutableArray arrayWithCapacity:5];
    NSInteger fieldCount = [self.fldExcludeKeyList count];
    for(NSInteger i =0 ;i < fieldCount;i++){
        NSString *fName = [self.fldExcludeKeyList objectAtIndex:i];
        if(i!=fieldCount-1){
            [fieldVals appendFormat:@"%@ = ? , ",fName];
        }
        else{
            [fieldVals appendFormat:@"%@ = ? ",fName];
        }
        id value = [model valueForKey:fName];
        if(!value){
            value = [NSNull null];
        }
        [args addObject:value];
    }
    if(fieldCount<=0){
        for(NSInteger i =0 ;i < keyCount;i++){
            NSString *fName = [self.keyList objectAtIndex:i];
            if(i!=keyCount-1){
                [fieldVals appendFormat:@"%@ = ? , ",fName];
            }
            else{
                [fieldVals appendFormat:@"%@ = ? ",fName];
            }
            id value = [model valueForKey:fName];
            if(!value){
                value = [NSNull null];
            }
            [args addObject:value];
        }
    }
    
    for(NSInteger i =0 ;i < keyCount;i++){
        NSString *fName = [self.keyList objectAtIndex:i];
        if(i!=keyCount-1){
            [wheres appendFormat:@"%@ = ? AND ",fName];
        }
        else{
            [wheres appendFormat:@"%@ = ? ",fName];
        }
        id value = [model valueForKey:fName];
        if(!value){
            value = [NSNull null];
        }
        [args addObject:value];
    }
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ ",self.tableName,fieldVals,wheres];
    
    DLog(@"update sql=%@",sql);
    
    __block BOOL  isOK  = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        isOK = [db executeUpdate:sql withArgumentsInArray:args];
        DLog("update lastErrorMessage =%@",[db lastErrorMessage]);
    }];
    return isOK;
}

- (BOOL)delete:(id)model {
    if(!model){
        return NO;
    }
    if(![self findByKey:model]){
        DLog(@"info:no exsist delete model!\n");
        return NO;
    }
    NSMutableString *wheres = [[NSMutableString alloc]initWithCapacity:10];
    NSInteger keyCount = [self.keyList count];
    for(NSInteger i =0 ;i < keyCount;i++){
        NSString *fName = [self.keyList objectAtIndex:i];
        if(i!=keyCount-1){
            [wheres appendFormat:@"%@ = ? AND ",fName];
        }
        else{
            [wheres appendFormat:@"%@ = ? ",fName];
        }
    }
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@ WHERE %@ ",self.tableName,wheres];
    NSMutableArray *args=[[NSMutableArray alloc]initWithCapacity:10];
    for(NSInteger i =0 ;i < keyCount;i++){
        NSString *mapkey = [self.keyList objectAtIndex:i];
        id value = [model valueForKey:mapkey];
        [args addObject:value];
    }
    DLog(@"delete sql=%@",sql);
    
    __block BOOL  isOK  = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        isOK = [db executeUpdate:sql withArgumentsInArray:args];
        DLog("delete lastErrorMessage =%@",[db lastErrorMessage]);
    }];
    return isOK;
}

- (BOOL)removeAll {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@ ",self.tableName];
    DLog(@"clearAll sql=%@",sql);
    return [self sqlUpdate:sql];
}

#pragma mark- SQL Execute

- (BOOL)sqlUpdate:(NSString*)sql {
    __block BOOL  isOK  = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        isOK = [db executeUpdate:sql];
        DLog("sqlUpdate lastErrorMessage =%@",[db lastErrorMessage]);
    }];
    return isOK;
}

- (BOOL)sqlUpdate:(NSString*)sql withArgumentsInArray:(NSArray*)args {
    id paras = nil;
    if(args.count > 0){
        paras = args;
    }
    __block BOOL  isOK  = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        isOK = [db executeUpdate:sql withArgumentsInArray:paras];
    }];
    return isOK;
}

- (BOOL)sqlUpdate:(NSString*)sql withParameterDictionary:(NSDictionary*)dics {
    NSInteger count =dics.allKeys.count;
    if(!dics || count==0){
        return  [self sqlUpdate:sql];
    }
    __block BOOL  isOK  = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        isOK = [db executeUpdate:sql withParameterDictionary:dics];
    }];
    return isOK;
}


- (NSArray*)sqlQuery:(NSString*)sql {
    NSMutableArray *modles  = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *jsonData = [rs resultDictionary];
            [modles addObject:jsonData];
        }
        [rs close];
    }];
    return modles;
}

- (NSArray*)sqlQuery:(NSString*)sql pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    NSString *finalSQL = [NSString stringWithFormat:@" %@  LIMIT %ld OFFSET %ld ",sql,pageSize,pageSize*pageIndex];
    return [self sqlQuery:finalSQL];
}


- (NSArray*)sqlQuery:(NSString*)sql  withArgumentsInArray:(NSArray*)args{
    if(args.count==0){
        return [self sqlQuery:sql];
    }
    NSMutableArray *modles  = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs =  [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSDictionary *jsonData = [rs resultDictionary];
           [modles addObject:jsonData];
        }
        [rs close];
    }];
    return modles;
}

- (NSArray*)sqlQuery:(NSString*)sql  withParameterDictionary:(NSDictionary*)dics {
    NSInteger count =dics.allKeys.count;
    if(!dics || count==0){
        return  [self sqlQuery:sql];
    }
    NSMutableArray *modles  = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs =  [db executeQuery:sql withParameterDictionary:dics];
        while ([rs next]) {
            NSDictionary *jsonData = [rs resultDictionary];
            [modles addObject:jsonData];
        }
        [rs close];
    }];
    return modles;
}

- (NSArray*)findAll {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM  %@  ",self.tableName];
    DLog(@"findAll sql=%@",sql);
    return [self sqlQuery:sql];
}


- (id)findByKey:(NSDictionary*)kv {
    NSArray *datas = [self findByAttributes:kv];
    if([datas count]>0){
        return datas[0];
    }
    return nil;
}

- (NSArray*)findByAttributes:(NSDictionary*)Attributes {
    NSMutableString *wheres = [[NSMutableString alloc]initWithCapacity:10];
    NSInteger keyCount = [Attributes.allKeys count];
    if(keyCount<=0){
        DLog(@"findByAttributes :  attribute parameter is null  !");
        return nil;
    }
    for(NSInteger i =0 ;i < keyCount;i++){
        NSString *fName = [Attributes.allKeys objectAtIndex:i];
        if(i!=keyCount-1){
            [wheres appendFormat:@"%@ = :%@ AND ",fName,fName];
        }
        else{
            [wheres appendFormat:@"%@ = :%@ ",fName,fName];
        }
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM  %@  WHERE %@ ",self.tableName,wheres];
    DLog(@"findByAttributes sql=%@",sql);
    return [self sqlQuery:sql withParameterDictionary:Attributes];
}

- (NSArray*)findByPage:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM  %@  LIMIT %ld OFFSET %ld ",self.tableName,pageSize,pageSize*pageIndex];
    DLog(@"findByPage sql=%@ pageindex=%ld",sql,pageIndex);
    return [self sqlQuery:sql];
}

- (id)findMaxKey {
    NSInteger keyCount = [self.keyList count];
    if(keyCount<=0){
        DLog(@"table no primary key field!");
        return @(1);
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT max(%@) FROM  %@  ",self.keyList[0],self.tableName];
    DLog(@"findMaxKey sql=%@",sql);
    
    __block FMResultSet *rs;
    [self.queue inDatabase:^(FMDatabase *db) {
        rs = [db executeQuery:sql ];
    }];
    
    id maxValue = @(1);
    if ([rs next]) {
        maxValue = [rs objectForColumnIndex:0];
        if(maxValue && ![maxValue isEqual:[NSNull null]]){
            [rs close];
            return maxValue;
        }
    }
    [rs close];
    return @(1);
}


@end

