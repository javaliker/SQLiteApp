//
//  NSImageView+Category.m
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/7.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "NSImageView+Category.h"
#import "TableColumnItem.h"
@implementation NSImageView(Category)

- (instancetype)initImageViewWithItem:(TableColumnItem*)item {
    self = [super init];
    if (self) {
        self.identifier = item.identifier;
    }
    return self;
}

@end
