//
//  TypeKit.h
//  MDatabase
//
//  Created by MacDev on 16/6/9.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "MDatabase.h"

@interface TypeKit : MDatabase
+ (BOOL)isSimpleType:(NSString *)type;
+ (BOOL)isObjectType:(NSString *)type;
+ (NSString*)objectType:(NSString *)type;
+ (NSArray*)objcTypes;
@end

