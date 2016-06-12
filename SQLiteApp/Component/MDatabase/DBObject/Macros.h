//
//  Basic.h
//  Database
//
//  Created by MacDev on 15/9/9.
//  Copyright (c) 2015年 http://www.macdev.io All rights reserved.
//

#ifndef Database_Basic_h
#define Database_Basic_h


#define XXXAssert(expression, ...) \
do { if(!(expression)) { \
DLog(@"%@", [NSString stringWithFormat: @"XXXAssertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); }} while(0)


#define XXXDEBUG
#ifdef XXXDEBUG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define DLog(...)
#endif

#endif
