//
//  NSComboBox+Category.h
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/5.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TableColumnItem;
@interface NSComboBox (Category)
- (instancetype)initComboBoxWithItem:(TableColumnItem*)item;
@end