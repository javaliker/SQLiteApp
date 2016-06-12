//
//  NSPasteboard+Utils.m
//  SQLiteApp
//
//  Created by MacDev on 15/2/13.
//  Copyright (c) 2015年 http://www.iosxtools.com. All rights reserved.
//

#import "NSPasteboard+Copy.h"

@implementation NSPasteboard (Copy)
+ (void)copyString:(NSString*)str owner:(id)owner {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
    [pb declareTypes:types owner:owner];
    if(str){
        [pb setString:str forType:NSStringPboardType];
    }
}
@end
