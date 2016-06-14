//
//  DAO.h
//  MDatabase
//
//  Created by MacDev on 16/6/8.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue;
@interface DAO : NSObject
@property(nonatomic,copy)    NSString  *tableName;/*table name*/
@property(nonatomic,strong)  NSArray   *fldList;/*all coulumn list*/
@property(nonatomic,strong)  NSArray   *keyList;/*primary key coulumn list*/
@property(nonatomic,strong)  NSArray   *fldExcludeKeyList;/*coulumn list */

@property(nonatomic,weak)FMDatabaseQueue *queue;

/* return page number according to page size */

- (NSInteger)numbersOfRecord;

- (NSInteger)pageNumberWithSize:(NSInteger)pageSize;

- (NSInteger)numbersOfRecordWithSQL:(NSString*)sql;

- (NSInteger)pageNumberWithSQL:(NSString*)sql pageSize:(NSInteger)pageSize;

/*insert a record*/
- (BOOL)insert:(id)model;

/*update a record*/
- (BOOL)update:(id)model;

/*delete a record*/
- (BOOL)delete:(id)model;

/*delete all record*/
- (BOOL)removeAll;

/*execute  sql update in table*/
- (BOOL)sqlUpdate:(NSString*)sql;

/*execute  sql update in table*/
- (BOOL)sqlUpdate:(NSString*)sql withArgumentsInArray:(NSArray*)args;

/*execute  sql update in table*/
- (BOOL)sqlUpdate:(NSString*)sql withParameterDictionary:(NSDictionary*)dics;

/*execute  sql query in table*/
- (NSArray*)sqlQuery:(NSString*)sql;

/*execute  sql query in table accoding to pageIndex & pageSize */
- (NSArray*)sqlQuery:(NSString*)sql pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

/*execute  sql query in table*/
- (NSArray*)sqlQuery:(NSString*)sql  withArgumentsInArray:(NSArray*)args;

/*execute  sql query in table*/
- (NSArray*)sqlQuery:(NSString*)sql  withParameterDictionary:(NSDictionary*)dics;

/*fetch all record*/
- (NSArray*)findAll;

/*fetch record By Primary Key Field*/
- (id)findByKey:(NSDictionary*)kv;

/*fetch MAX(column) By Primary Key Field*/
- (id)findMaxKey;

/*fetch records for given attributes*/
- (NSArray*)findByAttributes:(NSDictionary*)Attributes;

/*fetch records based on the index of pages*/
- (NSArray*)findByPage:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;


@end

