//
//  NSTableView+Category.m
//  TableDataNavigationViewController
//
//  Created by MacDev on 9/29/15.
//  Copyright (c) 2015 http://www.macdev.io All rights reserved.
//

#import "NSTableView+Category.h"
#import "NSTableColumn+Category.h"
#import "TableColumnItem.h"
#import <objc/runtime.h>
static char kTableViewColumnDefObjectKey;

@implementation NSTableView (Category)

- (void)xx_removeAllColumns {
    while([[self tableColumns] count] > 0) {
        [self removeTableColumn:[[self tableColumns] lastObject]];
    }
}

- (void)xx_updateColumnsWithItems:(NSArray*)items {

    if(items.count<=0){
        return;
    }
    if([[self tableColumns] count]>0){
        [self xx_removeAllColumns];
    }
    objc_setAssociatedObject(self, &kTableViewColumnDefObjectKey, items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    for(TableColumnItem *item in items){
        NSTableColumn *column=[NSTableColumn xx_tableColumnWithItem:item];
        [self addTableColumn:column];
    }
}

- (TableColumnItem*)xx_columnItemWithIdentifier:(NSString*)identifier {
     NSArray *items =  (NSArray *)objc_getAssociatedObject(self, &kTableViewColumnDefObjectKey);
    for(TableColumnItem *item in items){
        if([item.identifier isEqualToString:identifier]) {
            return item;
        }
    }
    
    return nil;
    
}

- (TableColumnItem*)xx_columnItemAtIndex:(NSInteger)colIndex {
    NSArray *items =  (NSArray *)objc_getAssociatedObject(self, &kTableViewColumnDefObjectKey);
    
    if(!items){
        return nil;
    }
    if(colIndex >= items.count){
        return nil;
    }

    return items[colIndex];
}

- (void)xx_setEditFoucusAtColumn:(NSInteger)columnIndex {
    if(self.numberOfRows<=0){
        return;
    }
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:[self numberOfRows]-1] byExtendingSelection:NO];
    [self editColumn:columnIndex row:([self numberOfRows] - 1) withEvent:nil select:YES];
}

- (void)xx_setEditFoucusAtColumn:(NSInteger)columnIndex atRow:(NSInteger)rowIndex {

    if(self.numberOfRows<=0){
        return;
    }
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] byExtendingSelection:NO];
    [self editColumn:columnIndex row:rowIndex withEvent:nil select:YES];
}

- (void)xx_setSelectionAtRow:(NSInteger)rowIndex {

    if(self.numberOfRows<=0){
        return;
    }
    if(rowIndex>=self.numberOfRows){
        return;
    }
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] byExtendingSelection:NO];
}

- (void)xx_setLostEditFoucus {
    NSInteger row = [self selectedRow];
    if(row<0){
        return;
    }
    NSIndexSet *indexes = [self selectedRowIndexes];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self deselectRow:row];
    }
    ];
    NSInteger col = [self selectedColumn];
    [self deselectColumn:col];
}



@end