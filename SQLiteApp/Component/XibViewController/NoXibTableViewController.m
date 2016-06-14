//
//  NoXibTableViewController.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/3.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "NoXibTableViewController.h"

@interface NoXibTableViewController ()

@end

@implementation NoXibTableViewController

- (void)dealloc {
    NSLog(@"NoXibTableViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //关联表视图到滚动条视图
    [self.tableViewScrollView setDocumentView:self.tableView];
    //将滚动条视图添加到父视图
    [self.view addSubview:self.tableViewScrollView];
    
    // Do view setup here.
}

- (void)loadView {
    CGRect frame = CGRectMake(0, 0, 500, 300);
    NSView *view = [[NSView alloc]initWithFrame:frame];
    self.view = view;
}


- (NSScrollView*)tableViewScrollView{
    if(!_tableViewScrollView){
        _tableViewScrollView = [[NSScrollView alloc] init];
        [_tableViewScrollView setHasVerticalScroller:NO];
        [_tableViewScrollView setHasHorizontalScroller:NO];
        [_tableViewScrollView setFocusRingType:NSFocusRingTypeNone];
        [_tableViewScrollView setAutohidesScrollers:YES];
        [_tableViewScrollView setBorderType:NSNoBorder];
        [_tableViewScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _tableViewScrollView;
    
}

- (NSTableView*)tableView{
    
    if(!_tableView){
        _tableView = [[NSTableView alloc] init];
        [_tableView setAutoresizesSubviews:YES];
        [_tableView setFocusRingType:NSFocusRingTypeNone];
    }
    return _tableView;
}

@end
