//
//  DataNavigationView.m
//  SQLiteApp
//
//  Created by MacDev on 6/2/16.
//  Copyright © 2016 macdev.io All rights reserved.
//

#import "DataNavigationView.h"
#import "DataNavigationItem.h"
#import "DataNavigationTextItem.h"
#import "DataNavigationButtonItem.h"
#import "Masonry.h"

@interface DataNavigationView()
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)NSMutableArray *leftViews;//左边按钮视图集
@property(nonatomic,strong)NSView *flexibleView;//中间Center区域
@property(nonatomic,strong)NSMutableArray *rightViews;//右边按钮视图集
@property (strong, nonatomic) id target;
@property (nonatomic) SEL action;
@property(nonatomic,strong)NSBox *line;
@end

@implementation DataNavigationView


- (void)setUpDefaultNavigationView {
    self.items = [self defaultItemsConfig];
    [self setUpNavigationViewWithItems:self.items];
}

- (void)setUpNavigationViewWithItems:(NSArray*)items {
    self.items = items;
    [self addNavigationItemsToView];
}

- (NSArray*)defaultItemsConfig {
    
    DataNavigationButtonItem *insertItem  = [[DataNavigationButtonItem alloc]init];
    insertItem.tooltips = @"add new row data";
    insertItem.image = NSImageNameAddTemplate;
    insertItem.tag = DataNavigationViewAddActionType;
    
    DataNavigationButtonItem *deleteItem  = [[DataNavigationButtonItem alloc]init];
    deleteItem.tooltips = @"delete seleted data";
    deleteItem.image = NSImageNameRemoveTemplate;
    deleteItem.tag = DataNavigationViewRemoveActionType;
    
    
    DataNavigationButtonItem *refreshItem  = [[DataNavigationButtonItem alloc]init];
    refreshItem.image = NSImageNameRefreshTemplate;
    refreshItem.tooltips = @"reload  data";
    refreshItem.tag = DataNavigationViewRefreshActionType;
    
    return @[insertItem,deleteItem,refreshItem];
}


/*
 
 -------------------------------------------------
 ［B B B］ ［---------------------------][B B - B B］
 -------------------------------------------------
 
 中间区域是一个空白区域,可以做为信息面板,显示提示说明信息。
 
 */

- (void)addNavigationItemsToView {
    for(NSView *view in self.subviews) {
        [view removeFromSuperview];
    }
    //存储靠近左边部分的按钮
    self.leftViews  = [NSMutableArray arrayWithCapacity:4];
    //存储靠近右边部分的按钮,包括中间的空白区
    self.rightViews = [NSMutableArray arrayWithCapacity:4];
    
    [self addSubview:self.line];
    
    BOOL hasFlexibleView = NO;
    NSView *view = nil;
    for(DataNavigationItem *item in self.items){
        view = nil;
        if([item isKindOfClass:[DataNavigationButtonItem class]]){
            view = [self buttonWithItem:(DataNavigationButtonItem *)item];
        }
        else if([item isKindOfClass:[DataNavigationTextItem class]]){
            view = [self textLabelWithItem:(DataNavigationTextItem *)item];
        }
        else if([item isKindOfClass:[DataNavigationFlexibleItem class]]){
           
           //中间区域,使用一个Text Lable占位
           self.flexibleView = [self infoLabel];
           [self addSubview:self.flexibleView];
           hasFlexibleView = YES;
        }
        
        if(view){
            [self addSubview:view];
            if(!hasFlexibleView){
                [self.leftViews addObject:view];
            }
            else{
              
                [self.rightViews addObject:view];
            }
        }
    }
    [self layoutNavigationView];
}


//对按钮组进行布局
- (void)layoutNavigationView {
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];

    NSView *leftLastView ;
    for(NSView *view in self.leftViews) {
        if(!leftLastView){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(4);
                make.centerY.equalTo(self.mas_centerY).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(24, 24));
            }];
        }
        else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLastView.mas_right).with.offset(4);
                make.centerY.equalTo(self.mas_centerY).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(24, 24));
            }];
        }
        leftLastView = view;
    }
    
    if([self.rightViews count] <= 0){
        return;
    }
    
    NSView *rightLastView;
    for(NSView *view in [self.rightViews reverseObjectEnumerator]){
        if(!rightLastView){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).with.offset(-4);
                make.centerY.equalTo(self.mas_centerY).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(24, 24));
            }];
        }
        else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(rightLastView.mas_left).with.offset(-4);
                make.centerY.equalTo(self.mas_centerY).with.offset(0);
                if([view isKindOfClass:[NSButton class]]){
                     make.size.mas_equalTo(CGSizeMake(24, 24));
                }
                else{
                     //make.size.mas_equalTo(CGSizeMake(60, 32));
                    make.width.mas_equalTo(60);
                }
            }];
        }
        rightLastView = view;
    }
    
    //与Center区域右边相邻的第一个button
    NSButton *neighborButton = self.rightViews[0];
    //Center的约束,与左边，右边邻居各偏离4个像素
    [self.flexibleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLastView.mas_right).with.offset(4);
        make.right.equalTo(neighborButton.mas_left).with.offset(-4);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
}


- (NSButton*)buttonWithItem:(DataNavigationButtonItem*)item {
    NSButton *button = [[NSButton alloc]init];
    button.image = [NSImage imageNamed:item.image];
    [button setButtonType:NSMomentaryPushInButton];
    [button setBordered: NO];
    button.bezelStyle = NSTexturedRoundedBezelStyle;
    [button setEnabled:YES];
    [button setState:NSOnState];
    button.identifier = item.identifier;
    if(item.tooltips){
        button.toolTip = item.tooltips;
    }
    [button setAction:self.action];
    [button setTarget:self.target];
    if(item.tooltips){
        button.toolTip = item.tooltips;
    }
    if(item.tag>0){
        button.tag = item.tag;
    }
    return button;
    
}


- (NSTextField*)textLabelWithItem:(DataNavigationTextItem*)item {
    NSTextField *label = [[NSTextField alloc]init];
    [label setAlignment:item.alignment];
    [label setFont:[NSFont labelFontOfSize:12]];
    label.stringValue = item.title;
    label.identifier = item.identifier;
    
    [label setBezeled:NO];
    [label setDrawsBackground:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
   
    
    if(item.textColor){
        label.textColor = item.textColor;
    }
    
    if(item.tag>0){
        label.tag = item.tag;
    }
    
    return label;
    
}

- (NSTextField*)infoLabel {
    NSTextField *label = [[NSTextField alloc]init];
    [label setAlignment:NSTextAlignmentCenter];
    label.identifier = @"info";
    [label setFont:[NSFont labelFontOfSize:12]];
    label.stringValue = @"";

    [label setBezeled:NO];
    [label setDrawsBackground:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
    
    return label;
}

- (void)updateLabelWithIdentifier:(NSString*)identifier title:(NSString*)title {
    NSArray *subviews = [self subviews];
    for(NSView *view in subviews){
        if([view.identifier isEqualToString:identifier])
        {
            if([view isKindOfClass:[NSTextField class]]){
                NSTextField *label = (NSTextField*)view;
                label.stringValue = title;
                break;
            }
        }
    }
}

- (id)buttonWithIdentifier:(NSString*)identifier {
    NSArray *subviews = [self subviews];
    for(NSView *view in subviews){
        if([view.identifier isEqualToString:identifier])
        {
            return view;
        }
    }
    return nil;
}

#pragma mark- Target Action

- (void)setTarget:(id)target withSelector:(SEL)selector {
    _target = target;
    _action = selector;
}
- (void)setTarget:(id)target {
    _target = target;
}
- (void)setAction:(SEL)action {
    _action = action;
}

#pragma mark - 

- (NSBox*)line {
    if(!_line){
        _line =[[NSBox alloc]init];
        [_line setBoxType:NSBoxSeparator];
    }
    return _line;
}

@end
