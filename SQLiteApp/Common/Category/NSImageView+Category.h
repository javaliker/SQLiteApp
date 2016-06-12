//
//  NSImageView+Category.h
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/7.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TableColumnItem;
@interface NSImageView (Category)
- (instancetype)initImageViewWithItem:(TableColumnItem*)item;
@end
