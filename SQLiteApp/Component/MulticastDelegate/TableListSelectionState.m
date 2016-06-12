//
//  TableListSelectionState.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "TableListSelectionState.h"

@interface TableListSelectionState ()
@property(nonatomic,readwrite)NSString* currentTableName;
@end

@implementation TableListSelectionState

- (void)selectedTableChanged:(NSString*)tableName {
    [multicastDelegate selectedTableChanged:self tableName:tableName];
    self.currentTableName = tableName;
}


- (void)closeDatabase {
    [multicastDelegate closeDatabase:self ];
}
@end
