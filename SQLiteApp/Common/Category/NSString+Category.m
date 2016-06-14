//
//  NSString+Category.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/11.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString(Category)

- (NSString *)trim {
    NSString *trimStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimStr;
}

@end
