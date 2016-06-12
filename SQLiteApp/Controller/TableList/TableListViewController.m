//
//  TableListViewController.m
//  SQLiteApp
//
//  Created by MacDev on 5/27/16.
//  Copyright © 2016 http://www.macdev.io All rights reserved.
//

#import "TableListViewController.h"
#import "TableListViewDelegate.h"
#import "DataNavigationView.h"
#import "NSColor+CGColor.h"
#import "TreeViewNode.h"
#import "MDatabase+Meta.h"
#import "TableInfo.h"
#import "FieldInfo.h"
#import "DatabaseInfo.h"
#import "MDatabase.h"
#import "TableListSelectionManager.h"
#import "TableListSelectionState.h"
#import "DataStoreBO.h"
#import "TableListView.h"
#import "Constant.h"
#import "DAO.h"

NSString* const kOpenDBNotification = @"OpenDBNotification";
NSString* const kCloseDBNotification = @"CloseDBNotification";

@interface TableListViewController ()
@property (weak) IBOutlet TableListView *treeView;
@property(nonatomic,strong)TableListViewDelegate *treeViewDelegate;
@property (weak) IBOutlet DataNavigationView *dataNavigationView;
@property (strong) IBOutlet NSMenu *tableNodeMenu;

@property (strong) IBOutlet NSMenu *dataBaseNodeMenu;
@end

@implementation TableListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    if(![[DataStoreBO sharedInstance]openDefaultDB]){
        NSLog(@"Open Default Database Failed!");
        return;
    }
    
    [self treeViewDelegateConfig];
    
    [self treeViewStyleConfig];
    
    [self fetchData];

    //关联导航面板按钮事件
    [self.dataNavigationView setTarget:self withSelector:@selector(toolButtonClicked:)];
    //配置导航面板的按钮
    [self.dataNavigationView setUpDefaultNavigationView];
    
    [self registerDBNotification];
    
    [self treeeViewMenuConfig];
}

- (IBAction)toolButtonClicked:(id)sender {
    NSButton *button = sender;
    NSLog(@"button.tag %ld",button.tag);
    //DataNavigationViewButtonActionType actionType = button.tag;
}

- (void)fetchData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
        DatabaseInfo *dbInfo = [[DataStoreBO sharedInstance] databaseInfo];
        
        if(!dbInfo.dbName){
            
            [self.treeViewDelegate clearAll];
            
            dispatch_async(dispatch_get_main_queue(),^
                           {
                             [self.treeView reloadData];
                               
                           });
            
            
            return ;
        }
        
        TreeViewNode *node = [[TreeViewNode alloc]init];
        node.name = dbInfo.dbName;
        node.type = kDatabaseNode;
        
        NSArray *tables = [dbInfo tables];
        
        NSMutableArray *tableNodes = [NSMutableArray array];
        for(TableInfo *table in tables){
            TreeViewNode *childNode = [[TreeViewNode alloc]init];
            childNode.name = table.name;
            childNode.type = kTableNode;
            [tableNodes addObject:childNode];
        }
        node.children = tableNodes;
        [self.treeViewDelegate setData:node];
        dispatch_async(dispatch_get_main_queue(),^
                       {
                           [self.treeView reloadData];
                           [self.treeView expandItem:nil expandChildren:YES];
                           [self selectFirstTableNode];
                           
                       });
    });
    
}

- (void)selectFirstTableNode {
    
    id firstTableNode = [self.treeView itemAtRow:1];
    if(!firstTableNode){
        return;
    }
    NSMutableIndexSet *selectRowIndexes = [NSMutableIndexSet indexSetWithIndex:1];
    [self.treeView selectRowIndexes:selectRowIndexes byExtendingSelection:NO];
    
    NSString *tableName = [firstTableNode valueForKey:@"name"];
    
    [[TableListSelectionManager sharedInstance].treeListState selectedTableChanged:tableName];
}

- (void)treeViewDelegateConfig {
    self.treeView.delegate   = self.treeViewDelegate;
    self.treeView.dataSource = self.treeViewDelegate;
    self.treeViewDelegate.owner = self.treeView;
    
    self.treeViewDelegate.selectionChangedCallback = ^(id item,id parentItem) {
        //NSLog(@"item %@ parentItem %@",item,parentItem);
        NSString *tableName = [item valueForKey:@"name"];
        [[TableListSelectionManager sharedInstance].treeListState selectedTableChanged:tableName];
    };
    
}

- (void)treeViewStyleConfig {
    self.treeView.allowsMultipleSelection=YES;
    NSColor *color = [NSColor colorWithHexColorString:@"d7dde5"];
    [self.treeView setBackgroundColor:color];
}

- (void)treeeViewMenuConfig{
    
    self.treeView.tableNodeMenu = self.tableNodeMenu;
    self.treeView.dataBaseNodeMenu = self.dataBaseNodeMenu;
}


- (void)registerDBNotification {
    __weak __typeof(&*self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kOpenDBNotification   object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* note){
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        NSString *path = note.object;
        if(![[DataStoreBO sharedInstance]openDBWithPath:path]){
            NSLog(@"Open Db %@ Failed!",path);
            return;
        }
        [strongSelf fetchData];
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCloseDBNotification   object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* note){
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        [strongSelf closeDatabase];
        
    }];
}


- (void)closeDatabase {
    
    [[DataStoreBO sharedInstance]clear];
    [self fetchData];
    [[TableListSelectionManager sharedInstance].treeListState closeDatabase];
}

#pragma mark - Menu Action

- (IBAction)dataBaseOpenInFinderMenuItemClicked:(id)sender {
    DatabaseInfo *dbInfo = [[DataStoreBO sharedInstance]databaseInfo];
    NSURL *fileURL = [NSURL fileURLWithPath: dbInfo.dbPath];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[ fileURL ]];
}

- (IBAction)dataBaseCloseMenuItemClicked:(id)sender {
    [self closeDatabase];
}

- (IBAction)duplicateTableMenuItemClicked:(id)sender {
    
   

    
}

- (IBAction)renameTableMenuItemClicked:(id)sender {
    
    
}

- (IBAction)dropTableMenuItemClicked:(id)sender {
    
    NSInteger selectedRow = self.treeView.selectedRow;
    if(selectedRow<0){
        return;
    }
    id node = [self.treeView itemAtRow:selectedRow];
    NSString *type     = [node valueForKey:@"type"];
    NSString *name     = [node valueForKey:@"name"];
    if([type isEqualToString:kDatabaseNode]){
        return;
    }
    
    NSString *dropSQL = [NSString stringWithFormat:@"Drop Table %@",name];
    
    DAO *dao = [DataStoreBO sharedInstance].defaultDao;
    
    if([dao sqlUpdate:dropSQL]){
        [[DataStoreBO sharedInstance] refreshTables];
        [self fetchData];
    }
    else{
        NSLog(@"Drop Table Failed!");
    }
    
    
    
}

- (IBAction)emptyTableMenuItemClicked:(id)sender {
    
    NSInteger selectedRow = self.treeView.selectedRow;
    if(selectedRow<0){
        return;
    }
    id node = [self.treeView itemAtRow:selectedRow];
    NSString *type     = [node valueForKey:@"type"];
    NSString *name     = [node valueForKey:@"name"];
    if([type isEqualToString:kDatabaseNode]){
        return;
    }
    
    NSString *emeptySQL = [NSString stringWithFormat:@"DELETE FROM  %@",name];
    
    DAO *dao = [DataStoreBO sharedInstance].defaultDao;
    
    if([dao sqlUpdate:emeptySQL]){
        [[DataStoreBO sharedInstance] refreshTables];
        [self fetchData];
    }
    else{
        NSLog(@"DELETE Table Failed!");
    }
}


#pragma mark - ivars

- (TableListViewDelegate*)treeViewDelegate {
    if(!_treeViewDelegate){
        _treeViewDelegate = [[TableListViewDelegate alloc]init];
    }
    return _treeViewDelegate;
}




@end
