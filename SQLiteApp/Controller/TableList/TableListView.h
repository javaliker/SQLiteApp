//
//  TableListView.h
//  SQLiteApp
//
//  Created by MacDev on 16/6/11.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TableListView : NSOutlineView
@property(nonatomic,weak)NSMenu *tableNodeMenu;
@property(nonatomic,weak)NSMenu *dataBaseNodeMenu;
@end
