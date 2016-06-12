//
//  TableColumnItem.h
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


typedef NS_ENUM(NSInteger, TableColumnCellType) {
    TableColumnCellTypeLabel = 0,
    TableColumnCellTypeTextField = 1,
    TableColumnCellTypeComboBox = 2,
    TableColumnCellTypeCheckBox = 3,
    TableColumnCellTypeImageView = 4
} ;

@interface TableColumnItem : NSObject

@property(nonatomic,strong)NSString       *title;//列标题
@property(nonatomic,strong)NSString       *identifier;//表列Identifier
@property(nonatomic,assign)NSTextAlignment headerAlignment;//列标题的alignment
@property(nonatomic,assign)CGFloat width;//列宽度
@property(nonatomic,assign)CGFloat minWidth;//列最小宽度
@property(nonatomic,assign)CGFloat maxWidth;//列最大宽度
@property(nonatomic,assign)TableColumnCellType     cellType;//表格单元视图的类型
@property(nonatomic,strong)NSColor        *textColor;//文本的Color
@property(nonatomic,assign)BOOL    editable;//文本是否允许编辑
@property(nonatomic,strong)NSArray *items;//Combox类型的items数据
@end
