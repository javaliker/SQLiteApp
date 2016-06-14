//
//  TreeViewDataDelegate.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "TreeViewDataDelegate.h"
#import <Cocoa/Cocoa.h>

@implementation TreeViewDataDelegate

#pragma init
- (id)init{
    self=[super init];
    if(self){
        _treeNodes = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return  self;
}

#pragma data
- (void)setData:(id)data {
    [self clearAll];
    [self.treeNodes addObject:data];
}

- (void)addData:(id)data {
    
    assert(data);
    [self.treeNodes addObject:data];
    
}

- (void)deleteData:(id)data {
    if([data isKindOfClass:[NSIndexSet class]]){
        [self.treeNodes removeObjectsAtIndexes:data];
    }
    else if([data isKindOfClass:[NSArray class]]){
        NSArray *array = data;
        for(id obj in array){
            [self.treeNodes removeObject:obj];
        }
    }
    else{
        [self.treeNodes removeObject:data];
    }
    
}
- (void)clearAll {
    [self.treeNodes removeAllObjects];
}

- (NSUInteger)indexOfItem:(id)item {
    return [self.treeNodes indexOfObject:item];
}


- (id)itemOfRow:(NSInteger)row {
    if(self.treeNodes.count==0){
        return nil;
    }
    if(row<=(self.treeNodes.count-1)){
        return self.treeNodes[row];
    }
    return nil;
}
- (NSArray*)itemsAtIndexSet:(NSIndexSet*)indexSet {
    NSMutableArray *items = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        id item = self.treeNodes[idx];
        [items addObject:item];
    }
     ];
    return items;
}


#pragma DataSource

- (NSInteger)outlineView:(NSOutlineView *__unused)outlineView numberOfChildrenOfItem:(id)item {
    id children;
    if (!item) {
        children = self.treeNodes;
    } else {
        children = [item valueForKey:@"children"];
        
    }
    return [children count];
}

- (BOOL)outlineView:(NSOutlineView *__unused)outlineView isItemExpandable:(id)item {
    id children;
    if (!item) {
        children = self.treeNodes ;
    } else {
        children = [item valueForKey:@"children"];
    }
    return ([children count] >0 ? YES : NO );
}
- (BOOL)isLeafItem:(id)item {
    id children = [item valueForKey:@"children"];
    if(!children){
        return YES;
    }
    return NO;
}
- (id)outlineView:(NSOutlineView *__unused)outlineView child:(NSInteger)index ofItem:(id)item {
    id children;
    if (!item) {
        children =  self.treeNodes;
    } else {
        children = [item valueForKey:@"children"];
    }
    if(index>=[children count]){
        NSLog(@"index(%ld invalid!",index);
        return nil;
    }
    return [children objectAtIndex:index];
}

#pragma mark- Delegate

- (void)outlineViewSelectionIsChanging:(NSNotification *)notification{
    NSOutlineView *ov = (NSOutlineView*)[notification object];
    NSInteger row = [ov selectedRow];
    NSMutableDictionary *item = (NSMutableDictionary*)[ov itemAtRow:row];
    NSMutableDictionary *pItem = [ov parentForItem:item];
    NSLog(@"outlineViewSelectionIsChanging item =%@ pItem =%@ \n",item,pItem);
    if(item){
        if(self.selectionChangedCallback){
            self.selectionChangedCallback(item,pItem);
        }
    }
}


#pragma ivar init
- (NSMutableArray*)treeNodes{
    if(!_treeNodes) {
        _treeNodes = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _treeNodes;
}

@end





