//
//  DataNavigationView.h
//  SQLiteApp
//
//  Created by MacDev on 6/2/16.
//  Copyright © 2016 macdev.io All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "DataNavigationItem.h"
#import "DataNavigationFlexibleItem.h"
#import "DataNavigationTextItem.h"
#import "DataNavigationButtonItem.h"

typedef NS_ENUM(NSInteger, DataNavigationViewButtonActionType) {
    DataNavigationViewAddActionType       = 1,
    DataNavigationViewRemoveActionType    = 2,
    DataNavigationViewRefreshActionType   = 3,
    DataNavigationViewFirstPageActionType = 4,
    DataNavigationViewPrePageActionType   = 5,
    DataNavigationViewNextPageActionType  = 6,
    DataNavigationViewLastPageActionType  = 7,
    DataNavigationViewExpandActionType    = 8,
} ;


#define kToolbarPreImageName      @"pre"
#define kToolbarFirstImageName    @"first"
#define kToolbarNextImageName     @"next"
#define kToolbarLastImageName     @"last"


@interface DataNavigationView : NSView

//配置默认的按钮组视图
- (void)setUpDefaultNavigationView;

//按items配置不同的按钮组
- (void)setUpNavigationViewWithItems:(NSArray*)items;

//对按钮组进行布局
- (void)layoutNavigationView;

//设置按钮响应事件
- (void)setTarget:(id)target withSelector:(SEL)selector;

//根据唯一标识获取按钮
- (id)buttonWithIdentifier:(NSString*)identifier;

//根据唯一标识更新label的标题
- (void)updateLabelWithIdentifier:(NSString*)identifier title:(NSString*)title;

@end
