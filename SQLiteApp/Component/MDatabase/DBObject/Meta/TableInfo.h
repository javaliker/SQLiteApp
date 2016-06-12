//
//  TableInfo.h
//  MDatabase
//
//  Created by MacDev on 16/6/9.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableInfo : NSObject

/** Table name */
@property(nonatomic,strong)NSString *name;

/** Table Columns */
@property(nonatomic,strong)NSArray  *fields;

/** Table Primary Keys */
@property(nonatomic,strong)NSArray  *keys;
@end
