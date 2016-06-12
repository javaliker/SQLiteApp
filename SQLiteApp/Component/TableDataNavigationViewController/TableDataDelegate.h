//
//  TableDataDelegate.h
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface TableDataDelegate : NSObject<NSTableViewDataSource,NSTableViewDelegate>

//Row Selection Changed Callback.
typedef void(^SelectionChangedCallbackBlock)(NSInteger index,  id obj);

//Row Drag Callback.
typedef void(^TableViewRowDragCallbackBlock)(NSInteger sourceRow,NSInteger targetRow);

//Row Edit Object Changed Callback.
typedef void(^RowObjectValueChangedCallbackBlock)(id obj,id oldObj,NSInteger row,NSString *fieldName);

@property(nonatomic,weak)  NSTableView *owner;

@property(nonatomic,copy)SelectionChangedCallbackBlock selectionChangedCallback;

@property(nonatomic,copy)TableViewRowDragCallbackBlock rowDragCallback;

@property(nonatomic,copy)RowObjectValueChangedCallbackBlock rowObjectValueChangedCallback;

- (void)setData:(id)data;

- (void)updateData:(id)item row:(NSInteger)row;

- (void)addData:(id)data;

- (void)deleteData:(id)data;

- (void)deleteDataAtIndex:(NSUInteger)index;

- (void)deleteDataIndexes:(NSIndexSet*)indexSet;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

- (void)clearData;

- (NSInteger)itemCount;

- (id)itemOfRow:(NSInteger)row;

- (NSArray*)itemsOfIndexSet:(NSIndexSet*)indexSet;

@end
