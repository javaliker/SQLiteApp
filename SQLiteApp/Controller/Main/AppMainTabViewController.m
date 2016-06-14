//
//  AppMainTabViewController.m
//  SQLiteApp
//
//  Created by MacDev on 5/27/16.
//  Copyright © 2016 http://www.macdev.io All rights reserved.
//

#import "AppMainTabViewController.h"

#import "TableBrowseViewController.h"
#import "TableSchemaViewController.h"
#import "TableQueryViewController.h"
#import "TableListSelectionManager.h"
#import "TableListSelectionState.h"

@interface AppMainTabViewController ()

@end

@implementation AppMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewControllers];
    // Do view setup here.
}

- (void)addChildViewControllers {
    
    TableBrowseViewController *dataViewController = [[TableBrowseViewController alloc]init];
    dataViewController.title = @"Browse";
    
    
    TableSchemaViewController *schemaViewController = [[TableSchemaViewController alloc]init];
    schemaViewController.title = @"Schema";

    
    TableQueryViewController *queryViewController = [[TableQueryViewController alloc]init];
    queryViewController.title = @"Query";
    
    [self addChildViewController:dataViewController];
    [self addChildViewController:schemaViewController];
    [self addChildViewController:queryViewController];

}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem {
    [super tabView:tabView didSelectTabViewItem:tabViewItem];
    NSLog(@"didSelectTabViewItem %@",tabViewItem);
    
    TableListSelectionState *state = [TableListSelectionManager sharedInstance].treeListState;
    NSString *tableName = state.currentTableName;
    [state selectedTableChanged:tableName];
}

@end
