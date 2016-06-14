//
//  TreeViewDataDelegate.h
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef void (^TreeNodeSelectChangedCallback)(id item,id parentItem);

@interface TreeViewDataDelegate : NSObject <NSOutlineViewDataSource,NSOutlineViewDelegate>

@property(nonatomic,strong)NSMutableArray *treeNodes;
@property(nonatomic,weak)NSOutlineView *owner;

@property(nonatomic,copy)TreeNodeSelectChangedCallback selectionChangedCallback;

- (void)clearAll;
- (void)setData:(id)data;
- (void)addData:(id)data;
- (void)deleteData:(id)data;
- (NSUInteger)indexOfItem:(id)item;
- (id)itemOfRow:(NSInteger)row;
- (NSArray*)itemsAtIndexSet:(NSIndexSet*)indexSet;
- (BOOL)isLeafItem:(id)item;
@end

