//
//  TableListView.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/11.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "TableListView.h"
#import "TableListSelectionManager.h"
#import "TableListSelectionState.h"
#import "Constant.h"
@implementation TableListView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(NSMenu *)menuForEvent:(NSEvent *)event {
    NSPoint pt = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:pt];
    if (row >= 0) {
        id item = [self itemAtRow: row];
        NSString *type =[item valueForKey:@"type"];
        NSLog(@"%@",item);
        if([type isEqualToString:kTableNode]){
            return self.tableNodeMenu;
        }
        if([type isEqualToString:kDatabaseNode]){
            return self.dataBaseNodeMenu;
        }
    }
    return [super menuForEvent:event];
}

- (void) keyDown:(NSEvent *)event {
    
    if ([event keyCode] == 125 ||  [event keyCode] == 126) {
        [super keyDown:event];
        NSInteger row = self.selectedRow;
        id item = [self itemAtRow:row];
        
        if(item){
            NSString *tableName = [item valueForKey:@"name"];
            NSString *type =[item valueForKey:@"type"];
            if(tableName){
                if([type isEqualToString:kTableNode]){
                     [[TableListSelectionManager sharedInstance].treeListState selectedTableChanged:tableName];
                }
               
            }
        }
        return;
    }
    [super keyDown:event];
}


@end
