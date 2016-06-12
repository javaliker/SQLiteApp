//
//  TableBrowseViewController.m
//  SQLiteApp
//
//  Created by MacDev on 5/31/16.
//  Copyright © 2016 http://www.macdev.io All rights reserved.
//

#import "TableBrowseViewController.h"
#import "Masonry.h"
#import "TableBrowseViewDelegate.h"
#import "DataPageManager.h"
#import "DataNavigationView.h"
#import "TableListSelectionManager.h"
#import "TableListSelectionState.h"
#import "TableColumnItem.h"
#import "TableInfo.h"
#import "FieldInfo.h"
#import "DataStoreBO.h"
#import "DAO.h"
#import "NSTableView+Category.h"
#import "JSONObjKit.h"
#import "NSPasteboard+Copy.h"

@interface TableBrowseViewController ()<NSMenuDelegate>
@property(nonatomic,strong)TableListSelectionState *state;
@property(nonatomic,strong)TableBrowseViewDelegate *dataDelegate;
@property(nonatomic,strong)NSString *tableName;
@property (nonatomic,strong)NSMenu *tabelCellMenu;
@end

@implementation TableBrowseViewController
- (void)dealloc {
    [self removeTableListSelectionObserver];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableListSelectionObserver];
    [self contextMenuActionConfig];
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
    [self tableViewUpdateColumns:fields];
    [self tableViewSortColumnsConfig];
    //计算分页数据
    [self.pageManager computePageNumbers];
    //导航到第一页
    [self.pageManager goFirstPage];
    //更新导航面板分页提示信息
    [self updatePageInfo];
}

- (void)closeDatabase:(TableListSelectionState *)sender {
     [self.tableView xx_removeAllColumns];
     [self.dataDelegate setData:@[]];
     [self.tableView reloadData];
}

- (void)tableViewUpdateColumns:(NSArray*)fields {
    if(fields.count<=0){
        return ;
    }
    NSMutableArray *tableViewColumns = [NSMutableArray arrayWithCapacity:fields.count];
    for(FieldInfo *field in fields){
        TableColumnItem *col = [[TableColumnItem alloc]init];
        col.title      = field.name;
        col.identifier = field.name;
        col.width      = 120;
        col.minWidth   = 120;
        col.maxWidth   = 120;
        col.editable   = YES;
        col.headerAlignment = NSLeftTextAlignment;
        col.cellType = TableColumnCellTypeTextField;
        [tableViewColumns addObject:col];
    }
    [self.tableView xx_updateColumnsWithItems:tableViewColumns];
}

- (void)tableDelegateConfig {
    self.tableView.delegate   = self.dataDelegate;
    self.tableView.dataSource = self.dataDelegate;
    self.dataDelegate.owner = self.tableView;
}

- (void)contextMenuActionConfig {
    
    NSArray * menus = self.tabelCellMenu.itemArray;
    NSInteger opIndex = 0;
    for(NSMenuItem *item in menus){
        [item setTarget: self];
        item.tag = opIndex;
        [item setAction: @selector(tabelCellMenuItemClick:)];
        opIndex++;
    }
}

#pragma mark- table menu




- (NSMenu*) tabelCellMenu {
    
    if(!_tabelCellMenu){
        
        _tabelCellMenu = [[NSMenu alloc]init];
        
        NSMenuItem *item = [[NSMenuItem alloc]init];
        item.title = @"Copy as JSON";
        
        [_tabelCellMenu addItem:item];
        
        item = [[NSMenuItem alloc]init];
        item.title = @"Copy as XML";
        
        [_tabelCellMenu addItem:item];
        
        _tabelCellMenu.delegate = self;
        
        self.tableView.menu = _tabelCellMenu;
        
       
    }
    
    return _tabelCellMenu;
}

- (IBAction)tabelCellMenuItemClick:(id)sender {
    
    NSMenuItem *item = sender;
    NSInteger index = item.tag;
    NSInteger selectedRow = self.tableView.selectedRow;
    if(selectedRow<0){
        return;
    }
    
    NSDictionary *data = [self.dataDelegate itemOfRow:selectedRow];
   
    if(index==0){
        NSString *json = [data xx_JSONString];
        [NSPasteboard copyString:json owner:self];
    }
    
    if(index==1){
        
        TableInfo *table = [[DataStoreBO sharedInstance]tableInfoWithName:self.tableName];
        
        NSArray *fields = table.fields;
        
        NSMutableString *strs =  [NSMutableString string];
        
        for(FieldInfo *field in fields){
            NSString *val = data[field.name];
            NSString *colStr  =[NSString stringWithFormat:@"<column name=\"%@\">%@</column>",field.name,val];
            [strs appendString:colStr];
            [strs appendString:@"\n"];
            
        }
        [NSPasteboard copyString:strs owner:self];
    }
    
}


- (void)menuNeedsUpdate:(NSMenu *)menu {
    NSInteger clickedrow = [self.tableView clickedRow];
    NSInteger clickedcol = [self.tableView clickedColumn];
    if (clickedrow > -1 && clickedcol > -1) {
        
    }
}


#pragma mark ***** PaginatorDelegate *****

- (void)paginator:(id)paginator requestDataWithPage:(NSInteger)page pageSize:(NSInteger)pageSize {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sql =[NSString stringWithFormat: @"select * from %@ ",self.tableName ];
        NSArray *datas =  [[DataStoreBO sharedInstance].defaultDao sqlQuery:sql pageIndex:page pageSize:pageSize];
        [self.dataDelegate setData:datas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self updatePageInfo];
        });
    });
}

- (NSInteger)totalNumberOfData:(id)paginator {
    NSString *sql =[NSString stringWithFormat: @"select * from %@ ",self.tableName ];
    return  [[DataStoreBO sharedInstance].defaultDao numbersOfRecordWithSQL:sql];
}

#pragma mark- ivars

- (TableBrowseViewDelegate*)dataDelegate {
    if(!_dataDelegate) {
        _dataDelegate = [[TableBrowseViewDelegate alloc]init];
        _dataDelegate.owner = self.tableView;
    }
    return _dataDelegate;
}

- (TableListSelectionState*)state {
    return [TableListSelectionManager sharedInstance].treeListState;
}

@end
