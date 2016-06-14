//
//  TableListSelectionState.h
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MultiDelegateModule.h"
@interface TableListSelectionState : MultiDelegateModule
@property(nonatomic,readonly)NSString* currentTableName;

- (void)selectedTableChanged:(NSString*)tableName;
- (void)closeDatabase;
@end

@protocol TableListSelectionStateDelegate
@optional
- (void)selectedTableChanged:(TableListSelectionState *)sender tableName:(NSString*)tableName;
- (void)closeDatabase:(TableListSelectionState *)sender;
@end