//
//  NSTableView+Category.h
//  TableDataNavigationViewController
//
//  Created by MacDev on 9/29/15.
//  Copyright (c) 2015 http://www.macdev.io All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TableColumnItem;
@interface NSTableView (Category)

- (void)xx_removeAllColumns;

- (void)xx_updateColumnsWithItems:(NSArray*)items;

- (void)xx_setEditFoucusAtColumn:(NSInteger)columnIndex;

- (void)xx_setEditFoucusAtColumn:(NSInteger)columnIndex atRow:(NSInteger)rowIndex;

- (void)xx_setLostEditFoucus;

- (void)xx_setSelectionAtRow:(NSInteger)rowIndex;


- (TableColumnItem*)xx_columnItemAtIndex:(NSInteger)colIndex;

- (TableColumnItem*)xx_columnItemWithIdentifier:(NSString*)identifier;
@end
