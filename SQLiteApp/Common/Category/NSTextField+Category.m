//
//  Category.m
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/5.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "NSTextField+Category.h"
#import "TableColumnItem.h"
@implementation NSTextField (Category)

- (instancetype)initTextFieldWithItem:(TableColumnItem*)item; {
    self = [super init];
    [self setBezeled:NO];
    [self setDrawsBackground:NO];
    [self setEditable:item.editable];
    [self setSelectable:item.editable];
    self.identifier = item.identifier;
    return self;
}
@end
