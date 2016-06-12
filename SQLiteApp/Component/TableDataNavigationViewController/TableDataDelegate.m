//
//  TableDataDelegate.m
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "TableDataDelegate.h"
#import "TableColumnItem.h"
#import "NSTableView+Category.h"
#import <Cocoa/Cocoa.h>
#import "NSTextField+Category.h"
#import "NSButton+Category.h"
#import "NSComboBox+Category.h"
#import "NSImageView+Category.h"
#import "Masonry.h"

NSString * const TableViewDragDataTypeName  = @"TableViewDragDataTypeName";

@interface TableDataDelegate ()<NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate,NSComboBoxDelegate>
@property(nonatomic,strong)NSMutableArray *items;
@end

@implementation TableDataDelegate

- (void)dealloc {
    NSLog(@"TableDataDelegate dealloc");
}

- (id)init {
    self = [super init];
    if(self){
        _items = [[NSMutableArray alloc]initWithCapacity:4];
    }
    return  self;
}

- (void)setData:(id)data {
    if(!data){
        [self clearData];
        return;
    }
    assert([data isKindOfClass:[NSArray class]]);
    self.items = [NSMutableArray arrayWithArray:data];
}

- (void)updateData:(id)item row:(NSInteger)row {
    if(row<=(_items.count-1)){
        self.items[row] = item;
    }
}

- (void)addData:(id)data {
    if(!data){
        return ;
    }
    if([data isKindOfClass:[NSArray class]]){
        [self.items addObjectsFromArray:data];
    }
    else{
        [self.items addObject:data];
    }
}
- (void)addData:(id)data atIndex:(NSInteger)index {
    if(!data){
        return ;
    }
    [self.items insertObject:data atIndex:index];
}

- (void)deleteData:(id)data {
    if([data isKindOfClass:[NSIndexSet class]]){
        [self.items removeObjectsAtIndexes:data];
    }
    else if([data isKindOfClass:[NSArray class]]){
        NSArray *array = data;
        for(id obj in array){
            [self.items removeObject:obj];
        }
    }
    else{
        [self.items removeObject:data];
    }
}

- (void)deleteDataAtIndex:(NSUInteger)index {
    assert(index<=(self.items.count-1));
    [self.items removeObjectAtIndex:index];
}

- (void)deleteDataIndexes:(NSIndexSet*)indexSet {
    [self deleteData:indexSet];
}

- (id)itemOfRow:(NSInteger)row {
    if(row<=(_items.count-1)){
        return _items[row];
    }
    return nil;
}

- (NSArray*)itemsOfIndexSet:(NSIndexSet*)indexSet {
    NSInteger count = indexSet.count;
    if(count<=0){
        return nil;
    }
    NSMutableArray *array =[[NSMutableArray alloc]initWithCapacity:count];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        id obj = [self itemOfRow:idx];
        [array addObject:obj];
    }
    ];
    return array;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    assert(index<=(self.items.count-1));
    [self addData:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    assert(index<=(self.items.count-1));
    [self deleteDataAtIndex:index];
}
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    assert(idx1<=(self.items.count-1));
    assert(idx2<=(self.items.count-1));
    [self.items exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)clearData {
    self.items =  [[NSMutableArray alloc]initWithCapacity:4];
}

- (NSInteger)itemCount{
    return [self.items count];
}

#pragma  mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.items count];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [notification.object selectedRow];
    if(row>=self.items.count){
        return;
    }
    id data = [self.items objectAtIndex:row];
    NSLog(@"select row notification.object=%@",data);
    if(self.selectionChangedCallback){
        self.selectionChangedCallback(row,data);
    }
}

- (void)tableView:(NSTableView *)aTableView sortDescriptorsDidChange:(NSArray *)oldDescriptors {
    NSArray *sortDescriptors = [aTableView sortDescriptors];
    self.items =[NSMutableArray arrayWithArray:[self.items sortedArrayUsingDescriptors:sortDescriptors]];
    [aTableView reloadData];
}


#pragma mark - NSTableViewDelegate

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //获取row数据
    id data = [self itemOfRow:row];
    //表格列的标识
    NSString *identifier = tableColumn.identifier;
    //单元格数据
    NSString *value = [data valueForKey:identifier];
    
    //根据表格列的标识,创建单元视图
    NSView *view = [tableView makeViewWithIdentifier:identifier owner:self];
    
    TableColumnItem *tableColumnItem = [tableView xx_columnItemWithIdentifier:identifier];
    
    switch (tableColumnItem.cellType) {
        case TableColumnCellTypeCheckBox:
        {
            NSButton *checkBoxField;
            if(!view){
                checkBoxField =  [[NSButton alloc]initCheckBoxWithItem:tableColumnItem];
                view = checkBoxField ;
            }
            else{
                checkBoxField = (NSButton*)view;
            }
            [checkBoxField setTarget:self];
            [checkBoxField setAction:@selector(checkBoxChick:)];
            if(value){
                checkBoxField.state = [value integerValue];
            }
            
        }
            break;
            
        case TableColumnCellTypeComboBox:
        {
            
            NSComboBox *comboBoxField;
            if(!view){
                view = [[NSTableCellView alloc]init];
                comboBoxField =  [[NSComboBox alloc]initComboBoxWithItem:tableColumnItem];
                comboBoxField.delegate = self;
                [view addSubview:comboBoxField];
                [comboBoxField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left).with.offset(2);
                    make.right.equalTo(view.mas_right).with.offset(-2);
                    make.centerY.equalTo(view.mas_centerY).with.offset(0);
                    
                }];
            }
            else{
                comboBoxField = (NSComboBox*)view.subviews[0];
            }
            
            NSArray *items = tableColumnItem.items;
            if(items){
                [comboBoxField addItemsWithObjectValues:items];
            }
            if(value) {
                comboBoxField.stringValue = value;
            }
        }
            break;
            
        case TableColumnCellTypeImageView:
        {
            
            NSImageView *imageField;
            //如果不存在,创建新的textField
            if(!view){
                imageField =  [[NSImageView alloc]initImageViewWithItem:tableColumnItem];
                
                view = imageField ;
            }
            else{
                imageField = (NSImageView*)view;
            }
            
            if(value){
                //更新单元格的image
                imageField.image = (NSImage*)value;
            }
        }
            break;
            
            
        default: //默认都是文本控件
        {
            NSTextField *textField;
            //如果不存在,创建新的textField
            if(!view){
                textField =  [[NSTextField alloc]initTextFieldWithItem:tableColumnItem];
                textField.delegate = self;
                view = textField ;
            }
            else{
                textField = (NSTextField*)view;
            }
            
            textField.stringValue  = @"";
            if(value){
                //更新单元格的文本
                textField.stringValue = value;
            }
        }
            break;
    }
    
    return view;
}

#pragma mark - Action

//文本输入框变化处理事件
- (void)controlTextDidChange:(NSNotification *)aNotification{
    NSTextField *field = aNotification.object;
    NSString *identifier = field.identifier;
    NSInteger row = [self.owner selectedRow];
    NSLog(@"field text = %@",field.stringValue);
    NSMutableDictionary *data = [self itemOfRow:row];
    NSMutableDictionary *oldData = [data mutableCopy];
    
    if(field.stringValue){
        data[identifier]    = field.stringValue;
    }
    
    if(self.rowObjectValueChangedCallback){
        self.rowObjectValueChangedCallback(data, oldData,row,identifier);
    }
}

//comboBox选择框处理事件
- (void)comboBoxSelectionDidChange:(NSNotification *)aNotification {
    NSComboBox *field = aNotification.object;
    NSString *identifier = field.identifier;
    NSInteger row = [self.owner selectedRow];
    NSLog(@"field text = %@",field.stringValue);
    NSMutableDictionary *data = [self itemOfRow:row];
    NSMutableDictionary *oldData = [data mutableCopy];
    if(field.stringValue){
        data[identifier]    = field.stringValue;
    }
    if(self.rowObjectValueChangedCallback){
        self.rowObjectValueChangedCallback(data, oldData,row,identifier);
    }
}

//Check Box 选择处理事件
- (IBAction)checkBoxChick:(id)sender {
    NSButton *button = (NSButton *)sender;
    NSLog(@"Form checkBoxChick=%ld",button.state);
    NSString *identifier = button.identifier;
    NSInteger row = [self.owner selectedRow];
    NSMutableDictionary *data = [self itemOfRow:row];
    NSMutableDictionary *oldData = [data mutableCopy];
    data[identifier]    = @(button.state);
    
    if(self.rowObjectValueChangedCallback){
        self.rowObjectValueChangedCallback(data, oldData,row,identifier);
    }
}



#pragma mark -- Drag/Drop

// drag operation stuff
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {
    // Copy the row numbers to the pasteboard.
    NSData *zNSIndexSetData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:TableViewDragDataTypeName] owner:self];
    [pboard setData:zNSIndexSetData forType:TableViewDragDataTypeName];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {

    return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info
              row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
    
    NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType:TableViewDragDataTypeName];
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    NSInteger dragRow = [rowIndexes firstIndex];
    
    NSInteger count = [self itemCount];
    if(count<=1){
        return YES;
    }
    NSLog(@"dragRow = %ld row=%ld count=%ld",dragRow,row,count);
    /*drag row inside table cell row*/
    if(row<=count-1){
        [self exchangeObjectAtIndex:dragRow withObjectAtIndex:row];
        [tableView noteNumberOfRowsChanged];
        [tableView reloadData];
        if(self.rowDragCallback){
            self.rowDragCallback(row,dragRow);
        }
        return YES;
    }
    else{
        /*drag row index out of row count*/
        id zData = [[self itemOfRow:dragRow]mutableCopy];
        [self insertObject:zData atIndex:row];
        count = [self itemCount];
        [self deleteDataAtIndex:dragRow];
        count = [self itemCount];
        [tableView noteNumberOfRowsChanged];
        [tableView reloadData];
        if(self.rowDragCallback){
            self.rowDragCallback(row,dragRow);
        }
        return YES;
    }
}

@end
