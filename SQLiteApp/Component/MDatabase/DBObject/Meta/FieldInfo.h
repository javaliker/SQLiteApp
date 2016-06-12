//
//  FieldInfo.h
//  MDatabase
//
//  Created by MacDev on 16/6/9.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldInfo : NSObject
@property(nonatomic,strong)NSString  *name;//字段名称
@property(nonatomic,strong)NSString  *type;//字段数据库类型
@property(nonatomic,strong)NSString  *objcType;//字段数据库类型对应的objc类型
@property(nonatomic,strong)NSString  *defaultVal;//缺省值
@property(nonatomic,assign)BOOL      isNULL;//是否为空

@property(nonatomic,assign)BOOL      isKey;//是否为主键

@property(nonatomic,assign) BOOL     isSimpleType;//是否为基本的值类型数据(数字,BOOL)
@property(nonatomic,assign) BOOL     isBOOL;
@property(nonatomic,assign) BOOL     isINTEGER;
@property(nonatomic,assign) BOOL     isNSString;
@property(nonatomic,assign) BOOL     isINT;
@property(nonatomic,assign) BOOL     isLONG;
@property(nonatomic,assign) BOOL     isDOUBLE;
@property(nonatomic,assign) BOOL     isFLOAT;
@property(nonatomic,assign) BOOL     isTEXT;
@property(nonatomic,assign) BOOL     isVARCHAR;
@property(nonatomic,assign) BOOL     isDATETIME;
@property(nonatomic,assign) BOOL     isNUMERIC;
@end
