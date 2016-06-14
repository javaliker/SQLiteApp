//
//  FieldInfo.m
//  MDatabase
//
//  Created by MacDev on 16/6/9.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "FieldInfo.h"
#import "TypeKit.h"
@implementation FieldInfo

- (NSString*)objcType {
    if(!_objcType){
        _objcType = [TypeKit objectType:[self.type uppercaseString] ];
    }
    return _objcType;
}
- (BOOL)isSimpleType {

    return [TypeKit isSimpleType:[self.type uppercaseString] ];
}
- (BOOL)isObjectType {

    return [TypeKit isObjectType:[self.type uppercaseString] ];
}
- (BOOL)isBOOL {
    if([self.type isEqualToString:@"BOOL"]){
        return  YES;
    }
    return  NO;
}

- (BOOL)isINTEGER {
    NSString *uppType =[self.type uppercaseString];
    if([uppType isEqualToString:@"INT"]){
        return  YES;
    }
    
    if([uppType isEqualToString:@"INTEGER"]){
        return  YES;
    }
    
    return  NO;
}

- (BOOL)isAutoIncrement{
    if([self.type isEqualToString:@"INTEGER"] && self.isKey){
        return  YES;
    }
    return  NO;
}

- (BOOL)isINT{
    NSString *uppType =[self.type uppercaseString];
    if([uppType isEqualToString:@"INT"]){
        return  YES;
    }
    return  NO;
}

- (BOOL)isLONG{
    if([self.type isEqualToString:@"LONG"]){
        return  YES;
    }
    return  NO;
}

- (BOOL)isDOUBLE{
    if([self.type isEqualToString:@"DOUBLE"]){
        return  YES;
    }
    return  NO;
}

- (BOOL)isFLOAT{
    if([self.type isEqualToString:@"FLOAT"]){
        return  YES;
    }
    return  NO;
}

- (BOOL)isTEXT{
    if([self.type isEqualToString:@"TEXT"]){
        return  YES;
    }
    return  NO;
}

- (BOOL)isVARCHAR{
    
    if([self.type isEqualToString:@"VARCHAR"]){
        return  YES;
    }
    NSRange range;
    range = [self.type rangeOfString:@"VARCHAR"];
    if(range.location!=NSNotFound){
        return  YES;
    }
    range = [self.type rangeOfString:@"CHAR"];
    if(range.location!=NSNotFound){
        return  YES;
    }
    return  NO;
}

- (BOOL)isDATETIME{
    if([self.type isEqualToString:@"DATETIME"]){
        return  YES;
    }
    return  NO;
}

- (BOOL)isNUMERIC{
    if([self.type isEqualToString:@"NUMERIC"]){
        return  YES;
    }
    return  NO;
}

- (BOOL)isNSString{
    if([self.type isEqualToString:@"NSSTRING"]){
        return  YES;
    }
    return  NO;
}

- (BOOL)isBLOB{
    if([self.type isEqualToString:@"BLOB"]){
        return  YES;
    }
    return  NO;
}
@end
