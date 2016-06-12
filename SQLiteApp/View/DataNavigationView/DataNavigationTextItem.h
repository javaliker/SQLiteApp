//
//  DataNavigationTextItem.h
//  SQLiteApp
//
//  Created by MacDev on 6/2/16.
//  Copyright © 2016 macdev.io All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "DataNavigationItem.h"

@interface DataNavigationTextItem : DataNavigationItem
@property (nonatomic,assign)float width; //文本宽度
@property (nonatomic, strong) NSString *title;//用作label的标题
@property (nonatomic, strong) NSColor  *textColor;//文本颜色
@property (nonatomic, assign) NSInteger alignment;//文本的位置
@end
