//
//  NSButton+Category.m
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/5.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "NSButton+Category.h"
#import "TableColumnItem.h"
@implementation NSButton (Category)

- (instancetype)initCheckBoxWithItem:(TableColumnItem*)item {
    
    self = [super init];
    [self setButtonType:NSSwitchButton];
    [self setBezelStyle:NSRegularSquareBezelStyle];
    [self setTitle:@""];
    [[self cell] setBordered:NO];
    self.identifier = item.identifier;
    return self;
}

@end
