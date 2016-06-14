//
//  TableListViewDelegate.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "TableListViewDelegate.h"


@implementation TableListViewDelegate

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 28;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    NSDictionary *node = (NSDictionary *)item ;
    NSString *type     = [node valueForKey:@"type"];
    NSString *identifier = tableColumn.identifier;
    NSString *name     = [node valueForKey:identifier];
    NSView   *result   =  [outlineView makeViewWithIdentifier:type owner:self];
    
    NSTextField *cell = result.subviews[1];
    if(name){
        cell.stringValue = name;
    }
    return result;
}




@end
