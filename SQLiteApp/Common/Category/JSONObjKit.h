//
//  JSONObjKit.h
//  SQLiteApp
//
//  Created by MacDev on 15/9/6.
//  Copyright (c) 2015年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSONKit)
- (id)xx_objectFromJSONString;
- (id)xx_mutableObjectFromJSONString;
@end


@interface NSData (JSONKit)
- (id)xx_objectFromJSONData;
- (id)xx_mutableObjectFromJSONData;
@end


@interface NSArray (JSONKit)
- (NSString*)xx_JSONString;
- (NSData*)xx_JSONData;
@end


@interface NSDictionary (JSONKit)
- (NSString*)xx_JSONString;
- (NSData*)xx_JSONData;
@end