//
//  TypeKit.m
//  MDatabase
//
//  Created by MacDev on 16/6/9.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "TypeKit.h"


static NSString *objcType(NSString *sqliteType) {
    static dispatch_once_t onceToken;
    static NSDictionary *maps;
    dispatch_once(&onceToken, ^{
        maps = @{
                 @"INTEGER" : @"NSInteger",
                 @"INT"     : @"int",
                 @"BOOL"    : @"BOOL",
                 @"DOUBLE"  : @"double",
                 @"FLOAT"   : @"float",
                 @"TEXT"    : @"NSString",
                 @"VARCHAR" : @"NSString",
                 @"DATETIME": @"NSString",
                 @"NUMERIC" : @"NSNumber",
                 @"BLOB"    : @"NSData",
                 };
    });
    return maps[sqliteType];
}

static BOOL itIsObjcSimpleType(NSString *objcType) {
    static dispatch_once_t onceToken;
    static NSDictionary *simpleMaps;
    dispatch_once(&onceToken, ^{
        simpleMaps = @{
                       @"BOOL"        : @"",
                       @"INTEGER"     : @"",
                       @"NSINTEGER"   : @"",
                       @"NSUINTEGER"  : @"",
                       @"LONG"        : @"",
                       @"INT"         : @"",
                       @"DOUBLE"      : @"",
                       @"NUMERIC"     : @"",
                       
                       };
    });
    if(simpleMaps[objcType]){
        return YES;
    }
    return NO;
}

@implementation TypeKit

+ (BOOL)isSimpleType:(NSString *)type {
    return itIsObjcSimpleType(type);
}
+ (BOOL)isObjectType:(NSString *)type {
    
    return !itIsObjcSimpleType(type);
}

+ (NSString*)objectType:(NSString *)type
{
    NSString *objcTypeStr = objcType(type);
    if(!objcTypeStr) {
        objcTypeStr = @"NSString";
    }
    return objcTypeStr;
}

+ (NSArray*)objcTypes {
    
    return @[
             @"INTEGER" ,
             @"BOOL"    ,
             @"DOUBLE"  ,
             @"FLOAT"   ,
             @"TEXT"    ,
             @"VARCHAR" ,
             @"DATETIME",
             @"NUMERIC" ,
             @"BLOB"
             ];
}

@end
