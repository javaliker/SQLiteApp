//
//  DatabaseInfo.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "DatabaseInfo.h"

@implementation DatabaseInfo
- (TableInfo *)tableInfoWithName:(NSString*)tableName {
    
    for(TableInfo *table in self.tables) {
        if([table.name isEqualToString:tableName]){
            return table;
        }
    }
    return nil;
}
@end
