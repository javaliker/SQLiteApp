//
//  NSTableColumn+Category.m
//  TableDataNavigationViewController
//
//  Created by MacDev on 9/29/15.
//  Copyright (c) 2015 http://www.macdev.io All rights reserved.
//

#import "NSTableColumn+Category.h"

@implementation NSTableColumn (Category)

+ (id)xx_tableColumnWithItem:(TableColumnItem*)item {
    NSTableColumn *column = [[NSTableColumn alloc]init];
    [column columnWithItem:item];
    return column;
}

- (void)columnWithItem:(TableColumnItem*)item {
    self.identifier = item.identifier;
    [self setWidth:item.width];
    [self setMinWidth:item.minWidth];
    [self setMaxWidth:item.maxWidth];
    [self setEditable:item.editable];
   
    [self updateHeaderCellWithItem:item];
}

- (void)updateHeaderCellWithItem:(TableColumnItem*)item{
    if(item.title){
        [[self headerCell] setStringValue:item.title];
    }
    [[self headerCell] setAlignment:item.headerAlignment];
    if([[self headerCell]  isKindOfClass:[NSCell class]]){
        [[self headerCell] setLineBreakMode: NSLineBreakByTruncatingMiddle];
    }
}
@end
