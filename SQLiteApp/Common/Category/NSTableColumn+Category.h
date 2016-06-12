//
//  NSTableColumn+Category.h
//  TableDataNavigationViewController
//
//  Created by MacDev on 9/29/15.
//  Copyright (c) 2015 http://www.macdev.io All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TableColumnItem.h"
@interface NSTableColumn (Category)
+ (id)xx_tableColumnWithItem:(TableColumnItem*)item;
@end
