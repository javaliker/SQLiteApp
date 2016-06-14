//
//  TableDataNavigationViewController.h
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XibViewController.h"
#define  kPageSize   20
@class DataPageManager,DataNavigationView;
@interface TableDataNavigationViewController : XibViewController
@property(nonatomic,strong)NSTableView  *tableView;
@property(nonatomic,strong)NSScrollView *tableViewScrollView;
@property(nonatomic,strong)DataNavigationView *dataNavigationView;
@property(nonatomic,strong)DataPageManager *pageManager;
- (void)updatePageInfo;
- (void)tableViewSortColumnsConfig;
@end
