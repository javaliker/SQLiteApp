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
@property(nonatomic,strong)NSString *type;//名称
@property(nonatomic,assign)NSInteger count;//子节点个数
@property(nonatomic,assign)BOOL isLeaf;//是否叶子节点
@property(nonatomic,strong)NSArray *children;//子节点
@end
