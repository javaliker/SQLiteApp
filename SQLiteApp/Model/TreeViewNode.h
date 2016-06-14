//
//  TreeViewNode.h
//  TreeViewController
//
//  Created by MacDev on 16/6/9.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeViewNode : NSObject
@property(nonatomic,strong)NSString *name;//名称
@property(nonatomic,strong)NSString *type;//节点是数据库还是表的类型
@property(nonatomic,strong)NSArray  *children;//子节点
@end
