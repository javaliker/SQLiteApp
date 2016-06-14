//
//  TableSchemaViewController.m
//  SQLiteApp
//
//  Created by MacDev on 5/31/16.
//  Copyright © 2016 http://www.macdev.io All rights reserved.
//

#import "TableSchemaViewController.h"
#import "DataNavigationView.h"
#import "TableListSelectionManager.h"
#import "TableListSelectionState.h"
#import "TableSchemaDelegate.h"
#import "TableColumnItem.h"
#import "TableInfo.h"
#import "FieldInfo.h"
#import "DataStoreBO.h"
#import "DAO.h"
#import "TypeKit.h"
#import "NSTableView+Category.h"
@interface TableSchemaViewController ()
@property(nonatomic,strong)TableListSelectionState *state;
@property(nonatomic,strong)TableSchemaDelegate *dataDelegate;
@property(nonatomic,strong)NSString *tableName;
@end

@implementation TableSchemaViewController
- (void)dealloc {
    [self removeTableListSelectionObserver];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableListSelectionObserver];
    
    [self tableDelegateConfig];
    
    [self.tableView xx_updateColumnsWithItems:[self tableColumnItems]];
    // Do view setup here.
}
- (void)addTableListSelectionObserver{
    [[self state] addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (void)removeTableListSelectionObserver{
    [[self state] removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}


#pragma mark - TableListSelectionStateDelegate

- (void)selectedTableChanged:(TableListSelectionState *)sender tableName:(NSString*)tableName {
    
    NSLog(@"selectedTableChanged %@",tableName);
    TableInfo *table = [[DataStoreBO sharedInstance]tableInfoWithName:tableName];
    self.tableName  = tableName;
    NSArray *fields = [table fields];
    
    [self.dataDelegate setData:fields];
    
    [self.tableView reloadData];
}

- (void)closeDatabase:(TableListSelectionState *)sender {
    
    [self.tableView xx_removeAllColumns];
    
    [self.dataDelegate setData:@[]];
    
    [self.tableView reloadData];
    
}


- (void)tableDelegateConfig {
    self.tableView.delegate   = self.dataDelegate;
    self.tableView.dataSource = self.dataDelegate;
    self.dataDelegate.owner   = self.tableView;
}


- (NSArray*)tableColumnItems {


    
    TableColumnItem *col1 = [[TableColumnItem alloc]init];
    col1.title      = @"Name";
    col1.identifier = @"name";
    col1.width      = 120;
    col1.minWidth   = 120;
    col1.maxWidth   = 120;
    col1.editable   = 1;
    col1.textColor = [NSColor highlightColor];
    col1.headerAlignment = NSLeftTextAlignment;
    col1.cellType = TableColumnCellTypeTextField;
    
    TableColumnItem *col2 = [[TableColumnItem alloc]init];
    col2.title      = @"Type";
    col2.identifier = @"type";
    col2.width      = 100;
    col2.minWidth   = 100;
    col2.maxWidth   = 100;
    col2.editable   = 1;
    col2.textColor = [NSColor highlightColor];
    col2.headerAlignment = NSLeftTextAlignment;
    col2.cellType = TableColumnCellTypeComboBox;
    col2.items    = [TypeKit objcTypes];
    
    TableColumnItem *col3 = [[TableColumnItem alloc]init];
    col3.title      = @"NULL";
    col3.identifier = @"isNULL";
    col3.width      = 100;
    col3.minWidth   = 100;
    col3.maxWidth   = 100;
    col3.editable   = 1;
    col3.textColor = [NSColor highlightColor];
    col3.headerAlignment = NSLeftTextAlignment;
    col3.cellType = TableColumnCellTypeCheckBox;
    
    TableColumnItem *col4 = [[TableColumnItem alloc]init];
    col4.title      = @"Default Val";
    col4.identifier = @"defaultVal";
    col4.width      = 100;
    col4.minWidth   = 100;
    col4.maxWidth   = 100;
    col4.editable   = 1;
    col4.textColor = [NSColor highlightColor];
    col4.headerAlignment = NSLeftTextAlignment;
    col4.cellType = TableColumnCellTypeTextField;
    
    TableColumnItem *col5 = [[TableColumnItem alloc]init];
    col5.title      = @"Primary Key";
    col5.identifier = @"isKey";
    col5.width      = 100;
    col5.minWidth   = 100;
    col5.maxWidth   = 100;
    col5.editable   = 1;
    col5.textColor = [NSColor highlightColor];
    col5.headerAlignment = NSLeftTextAlignment;
    col5.cellType = TableColumnCellTypeCheckBox;
    
    
    

    
    
    
    return @[
             //col0,
             
             col1,
             
             col2,
             
             col3,
             
             col4,
             
             col5,
            
             ];
}


- (NSArray*)dataNavigationItemsConfig {
    
    DataNavigationButtonItem *insertItem  = [[DataNavigationButtonItem alloc]init];
    insertItem.tooltips = @"insert a row into current table";
    insertItem.image = NSImageNameAddTemplate;
    insertItem.tag = DataNavigationViewAddActionType;
    
    DataNavigationButtonItem *deleteItem  = [[DataNavigationButtonItem alloc]init];
    deleteItem.tooltips = @"delete seleted rows form current table";
    deleteItem.image = NSImageNameRemoveTemplate;
    deleteItem.tag = DataNavigationViewRemoveActionType;
    
    
    DataNavigationButtonItem *refreshItem  = [[DataNavigationButtonItem alloc]init];
    refreshItem.image = NSImageNameRefreshTemplate;
    refreshItem.tooltips = @"reload table data";
    refreshItem.tag = DataNavigationViewRefreshActionType;
    
    return @[insertItem,deleteItem,refreshItem];
}




#pragma mark- ivars

- (TableSchemaDelegate*)dataDelegate {
    if(!_dataDelegate) {
        _dataDelegate = [[TableSchemaDelegate alloc]init];
        _dataDelegate.owner = self.tableView;
    }
    return _dataDelegate;
}

- (TableListSelectionState*)state {
    return [TableListSelectionManager sharedInstance].treeListState;
}


@end
