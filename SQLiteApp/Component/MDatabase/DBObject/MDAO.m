//
//  MDAO.m
//  MDatabase
//
//  Created by MacDev on 16/6/8.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "MDAO.h"
#import "Macros.h"
#import "MDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface MDAO ()

@end

@implementation MDAO

- (NSArray*)sqlQuery:(NSString*)sql {
    NSMutableArray *modles  = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id model = [[NSClassFromString(self.tableName) alloc] init];
            for(NSString  *mapkey in self.fldList){
                id obj=[rs objectForColumnName: mapkey];
                if([obj isEqual:[NSNull null]]){
                    continue;
                }
                [model setValue:obj forKey:mapkey];
            }
            [modles addObject:model];
        }
        [rs close];
    }];
    
    return modles;
}

- (NSArray*)sqlQuery:(NSString*)sql  withArgumentsInArray:(NSArray*)args{
    if(args.count==0){
        return [self sqlQuery:sql];
    }
    NSMutableArray *modles  = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs =  [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            id model = [[NSClassFromString(self.tableName) alloc] init];
            for(NSString  *mapkey in self.fldList){
                id obj=[rs objectForColumnName: mapkey];
                if([obj isEqual:[NSNull null]]){
                    continue;
                }
                [model setValue:obj forKey:mapkey];
            }
            [modles addObject:model];
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
            id model = [[NSClassFromString(self.tableName) alloc] init];
            for(NSString  *mapkey in self.fldList){
                id obj=[rs objectForColumnName: mapkey];
                if([obj isEqual:[NSNull null]]){
                    continue;
                }
                [model setValue:obj forKey:mapkey];
            }
            [modles addObject:model];
        }
        [rs close];
    }];
    return modles;
}

@end

