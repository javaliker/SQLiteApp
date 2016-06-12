//
//  NSPasteboard+Utils.h
//  SQLiteApp
//
//  Created by MacDev on 15/2/13.
//  Copyright (c) 2015年 http://www.iosxtools.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSPasteboard (Copy)
+ (void)copyString:(NSString*)str owner:(id)owner;
@end
