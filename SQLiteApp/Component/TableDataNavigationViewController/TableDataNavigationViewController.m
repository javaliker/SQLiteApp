//
//  TableDataNavigationViewController.m
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "TableDataNavigationViewController.h"
#import "Masonry.h"
#import "DataPageManager.h"
#import "DataNavigationView.h"
#import "NSTableView+Category.h"
#import "TableColumnItem.h"
#import "TableDataDelegate.h"


extern NSString * const TableViewDragDataTypeName;

@interface TableDataNavigationViewController ()<PaginatorDelegate>
@end

@implementation TableDataNavigationViewController

- (void)dealloc {
    NSLog(@"TableDataNavigationViewController dealloc");
    [self.tableView unregisterDraggedTypes];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupAutolayout];
    // Do view setup here.
    [self tableViewStyleConfig];
    [self tableDelegateConfig];
    
    //关联导航面板按钮事件
    [self.dataNavigationView setTarget:self withSelector:@selector(toolButtonClicked:)];
    //配置导航面板的按钮
    [self.dataNavigationView setUpNavigationViewWithItems:[self dataNavigationItemsConfig]];
    //注册脱拖放
    [self registerRowDrag];

}

- (void)setupAutolayout {
    //如果界面使用xib方式的话,不进行自动布局的处理
    if([self tableXibView]){
        return;
    }
    
    //关联表视图到滚动条视图
    [self.tableViewScrollView setDocumentView:self.tableView];
    //将滚动条视图添加到父视图
    [self.view addSubview:self.tableViewScrollView];
    
    //将导航面板视图添加到父视图
    [self.view addSubview:self.dataNavigationView];
    
    //设置表视图约束
    [self.tableViewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-30);
    }];
    
    //设置导航数据面板约束
    [self.dataNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.tableViewScrollView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
}

- (void)registerRowDrag {
    
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:TableViewDragDataTypeName]];
    
}

- (void)tableDelegateConfig {
     // subclass override this in subclass
}

- (void)tableViewStyleConfig {
    self.tableView.gridStyleMask =  NSTableViewSolidHorizontalGridLineMask | NSTableViewSolidVerticalGridLineMask;
    self.tableView.usesAlternatingRowBackgroundColors = YES;
}


- (void)tableViewSortColumnsConfig {

    for (NSTableColumn *tableColumn in self.tableView.tableColumns ) {
//  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:tableColumn.identifier ascending:YES selector:@selector(compare:)];
        NSSortDescriptor *sortStates = [NSSortDescriptor sortDescriptorWithKey:tableColumn.identifier
                        ascending:NO
                        comparator:^(id obj1, id obj2) {
                                                                        
                                if (obj1 < obj2) {
                                    return  NSOrderedAscending;
                                                                            
                                }
                                if (obj1 > obj2) {
                                                                            
                                     return NSOrderedDescending;
                                                                            
                                }
                            
                                 return NSOrderedSame;
                            }];
        
        [tableColumn setSortDescriptorPrototype:sortStates];
    }
}


#pragma mark - Config


- (NSArray*)dataNavigationItemsConfig {
    
    DataNavigationButtonItem *insertItem  = [[DataNavigationButtonItem alloc]init];
    insertItem.tooltips = @"insert a row into current table";
    insertItem.image = NSImageNameAddTemplate;
    insertItem.tag = DataNavigationViewAddActionType;
    
    DataNavigationButtonItem *deleteItem  = [[DataNavigationButtonItem alloc]init];
    deleteItem.tooltips = @"delete seleted rows form current table";
    deleteItem.image = NSImageNameRemoveTemplate;
    deleteItem.tag = DataNavigationViewRemoveActionType;
    
    
    DataNavigationButtonItem *refreshItem  = [[DataNavigationButtonItem alloc]init];
    refreshItem.image = NSImageNameRefreshTemplate;
    refreshItem.tooltips = @"reload table data";
    refreshItem.tag = DataNavigationViewRefreshActionType;
    
    
    DataNavigationFlexibleItem *flexibleItem = [[DataNavigationFlexibleItem alloc]init];
    
    
    DataNavigationButtonItem *firstItem  = [[DataNavigationButtonItem alloc]init];
    firstItem.image = kToolbarFirstImageName;
    firstItem.tooltips = @"go first page";
    firstItem.tag = DataNavigationViewFirstPageActionType;
    
    DataNavigationButtonItem *preItem  = [[DataNavigationButtonItem alloc]init];
    preItem.image = kToolbarPreImageName;
    preItem.tooltips = @"go pre page";
    preItem.tag = DataNavigationViewPrePageActionType;
    
    DataNavigationTextItem *pageLable  = [[DataNavigationTextItem alloc]init];
    pageLable.width = 80;
    pageLable.identifier = @"pages";
    pageLable.title      = @"0/0";
    pageLable.alignment  = NSCenterTextAlignment;
    
    
    DataNavigationButtonItem *nextItem  = [[DataNavigationButtonItem alloc]init];
    nextItem.image = kToolbarNextImageName;
    nextItem.tooltips = @"go next page";
    nextItem.tag = DataNavigationViewNextPageActionType;
    
    DataNavigationButtonItem *lastItem  = [[DataNavigationButtonItem alloc]init];
    lastItem.image = kToolbarLastImageName;
    lastItem.tooltips = @"go last page";
    lastItem.tag = DataNavigationViewLastPageActionType;
    
    return @[insertItem,deleteItem,refreshItem,flexibleItem,firstItem,preItem,pageLable,nextItem,lastItem];
}

#pragma mark- Action

- (IBAction)toolButtonClicked:(id)sender {
    NSButton *button = sender;
    NSLog(@"button.tag %ld",button.tag);
    DataNavigationViewButtonActionType actionType = button.tag;
    switch (actionType) {
        case DataNavigationViewAddActionType:
        {
            [self addNewData];
        }
            break;
        case DataNavigationViewRemoveActionType:
        {
            [self reomoveSelectedData];
        }
            break;
        case DataNavigationViewRefreshActionType:
        {
            [self.pageManager refreshCurrentPage];
        }
            break;
        case DataNavigationViewFirstPageActionType:
        {
            [self.pageManager goFirstPage];
        }
            break;
        case DataNavigationViewPrePageActionType:
        {
            [self.pageManager goPrePage];
        }
            break;
        case DataNavigationViewNextPageActionType:
        {
            [self.pageManager goNextPage];
        }
            break;
        case DataNavigationViewLastPageActionType:
        {
            [self.pageManager goLastPage];
        }
            break;
        default:
            break;
    }
}

- (void)addNewData {
    
   
}

- (void)reomoveSelectedData {
    
    NSInteger selectedRow = self.tableView.selectedRow;
    //没有行选择,不执行删除操作
    if(selectedRow==NSNotFound){
        return;
    }
    //删除选中的行失去焦点
    [self.tableView xx_setLostEditFoucus];
    
    //开始删除
    [self.tableView beginUpdates];
    //以指定的动画风格执行删除
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:selectedRow];
    [self.tableView removeRowsAtIndexes:indexes withAnimation:NSTableViewAnimationSlideUp];
    //完成删除
    [self.tableView endUpdates];

    
    //id data = [self.dataDelegate itemOfRow:selectedRow];
    //[self.dataDelegate deleteDataAtIndex:selectedRow];
    
    //[self.datas removeObject:data];
    //更新页数据
    [self computePageNumbers];
    [self updatePageInfo];
}



#pragma mark ***** PaginatorDelegate *****

- (void)paginator:(id)paginator requestDataWithPage:(NSInteger)page pageSize:(NSInteger)pageSize {
    // override this in subclass
}

- (NSInteger)totalNumberOfData:(id)paginator {
    // override this in subclass
    return  0;
}

#pragma mark ***** Page *****

- (DataPageManager*)pageManager{
    if(!_pageManager){
        _pageManager = [[DataPageManager alloc]initWithPageSize:kPageSize delegate:self];
    }
    return _pageManager;
}

- (void)computePageNumbers {
    [self.pageManager computePageNumbers];
}

- (void)updatePageInfo {
    NSString *pageInfo;
    NSInteger currentPageIndex = self.pageManager.page;
    NSInteger pageNumbers = self.pageManager.pages;
    if(pageNumbers>0){
        pageInfo = [NSString stringWithFormat:@"%ld/%ld",currentPageIndex+1,pageNumbers];
    }
    else{
        pageInfo = [NSString stringWithFormat:@"%ld/%ld",currentPageIndex,pageNumbers];
    }
    [self.dataNavigationView updateLabelWithIdentifier:@"pages" title:pageInfo];
    NSString *info = [NSString stringWithFormat:@"%ld records",self.pageManager.total];
    [self.dataNavigationView updateLabelWithIdentifier:@"info" title:info];
}

- (NSScrollView*)tableViewXibScrollView{
    return nil;
}
- (NSTableView*)tableXibView{
    return nil;
}

- (DataNavigationView*)dataNavigationXibView{
    return nil;
}

#pragma mark - ivars


- (NSScrollView*)tableViewScrollView{
    if(!_tableViewScrollView){
        _tableViewScrollView = [self tableViewXibScrollView];
        if(_tableViewScrollView){
            return _tableViewScrollView;
        }
        _tableViewScrollView = [[NSScrollView alloc] init];
        [_tableViewScrollView setHasVerticalScroller:NO];
        [_tableViewScrollView setHasHorizontalScroller:NO];
        [_tableViewScrollView setFocusRingType:NSFocusRingTypeNone];
        [_tableViewScrollView setAutohidesScrollers:YES];
        [_tableViewScrollView setBorderType:NSNoBorder];
        [_tableViewScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _tableViewScrollView;
}

- (NSTableView*)tableView{
    if(!_tableView){
        _tableView = [self tableXibView];
        if(_tableView){
            return _tableView;
        }
        _tableView = [[NSTableView alloc] init];
        [_tableView setAutoresizesSubviews:YES];
        [_tableView setFocusRingType:NSFocusRingTypeNone];
    }
    return _tableView;
}

- (DataNavigationView *)dataNavigationView {
    if(!_dataNavigationView){
        _dataNavigationView = [self dataNavigationXibView];
        if(_dataNavigationView){
            return _dataNavigationView;
        }
        _dataNavigationView =  [[DataNavigationView alloc]init];
    }
    return _dataNavigationView;
}

@end
