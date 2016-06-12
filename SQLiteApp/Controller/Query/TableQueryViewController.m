//
//  TableQueryViewController.m
//  SQLiteApp
//
//  Created by MacDev on 5/31/16.
//  Copyright © 2016 http://www.macdev.io All rights reserved.
//

#import "TableQueryViewController.h"
#import "NSString+Category.h"
#import "TableColumnItem.h"
#import "QueryDataDelegate.h"
#import "DataNavigationView.h"
#import "DataPageManager.h"
#import "TableDataNavigationViewController.h"
#import "DAO.h"
#import "NSTableView+Category.h"
#import <MGSFragaria/MGSFragaria.h>

@interface TableQueryViewController ()
@property (weak) IBOutlet DataNavigationView *queryNavigationXibView;
@property (weak) IBOutlet NSTableView *queryTableXibView;
@property(nonatomic,retain)MGSFragaria *sqlSyntxView;
@property(nonatomic,strong)QueryDataDelegate *dataDelegate;
@property (unsafe_unretained) IBOutlet NSTextView *queryTextView;
@property(nonatomic,strong)DAO      *dao;
@property(nonatomic,strong)NSString *sql;
@end

@implementation TableQueryViewController

- (id)init {
    self = [super initWithNibName:@"TableQueryViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableDelegateConfig];
    
    [self.sqlSyntxView embedInView:self.queryTextView];
    
 

}

- (void)tableDelegateConfig {
    self.tableView.delegate   = self.dataDelegate;
    self.tableView.dataSource = self.dataDelegate;
    self.dataDelegate.owner   = self.tableView;
}

- (void)setSQLStyle
{
   
}

#pragma mark- Button Action

- (IBAction)clearSQLAction:(id)sender {
    self.queryTextView.string = @"";
}

- (IBAction)runSQLAction:(id)sender {
    NSLog(@"self.queryTextView.string %@",self.sqlSyntxView.string);
    NSString *sql = [self.sqlSyntxView.string trim];
    if(sql.length<=0){
        return;
    }
    
    self.sql = sql;
    
    
    NSArray *datas =  [self.dao sqlQuery:self.sql pageIndex:0 pageSize:1];
    
    if([datas count]>0){
        NSDictionary *data = datas[0];
        NSArray *fieldNames = [data allKeys];
        [self tableViewUpdateColumnWithNames:fieldNames];
    }

    //计算分页数据
    [self.pageManager computePageNumbers];
    //导航到第一页
    [self.pageManager goFirstPage];
    //更新导航面板分页提示信息
    [self updatePageInfo];
    
    
}

- (void)tableViewUpdateColumnWithNames:(NSArray*)fieldNames {
    if(fieldNames.count<=0){
        return ;
    }
    NSMutableArray *tableViewColumns = [NSMutableArray arrayWithCapacity:fieldNames.count];
    for(NSString *name in fieldNames){
        TableColumnItem *col = [[TableColumnItem alloc]init];
        col.title      = name;
        col.identifier = name;
        col.width      = 120;
        col.minWidth   = 120;
        col.maxWidth   = 120;
        col.editable   = YES;
        col.headerAlignment = NSLeftTextAlignment;
        col.cellType = TableColumnCellTypeTextField;
        [tableViewColumns addObject:col];
    }
    [self.tableView xx_updateColumnsWithItems:tableViewColumns];
}


- (NSArray*)dataNavigationItemsConfig {
    
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
    
    return @[refreshItem,flexibleItem,firstItem,preItem,pageLable,nextItem,lastItem];
}

#pragma mark- Action

- (IBAction)toolButtonClicked:(id)sender {
    NSButton *button = sender;
    NSLog(@"button.tag %ld",button.tag);
    DataNavigationViewButtonActionType actionType = button.tag;
    switch (actionType) {
        
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


- (NSTableView*)tableXibView{
    return self.queryTableXibView;
}

- (DataNavigationView*)dataNavigationXibView{
    return self.queryNavigationXibView;
}


#pragma mark ***** PaginatorDelegate *****

- (void)paginator:(id)paginator requestDataWithPage:(NSInteger)page pageSize:(NSInteger)pageSize {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSArray *datas =  [self.dao sqlQuery:self.sql pageIndex:page pageSize:pageSize];
        [self.dataDelegate setData:datas];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
            [self updatePageInfo];
        });
    });
}

- (NSInteger)totalNumberOfData:(id)paginator {
    
    return  [self.dao numbersOfRecordWithSQL:self.sql];
}


#pragma mark -ivars

- (QueryDataDelegate*)dataDelegate {
    if(!_dataDelegate) {
        _dataDelegate = [[QueryDataDelegate alloc]init];
        _dataDelegate.owner = self.tableView;
    }
    return _dataDelegate;
}

- (DAO*)dao {
    if(!_dao){
        _dao = [[DAO alloc]init];
    }
    return _dao;
}

- (MGSFragaria*)sqlSyntxView {
    if(!_sqlSyntxView){
        _sqlSyntxView = [[MGSFragaria alloc] init];
        [_sqlSyntxView setShowsLineNumbers:NO];
        
        [_sqlSyntxView setObject:@"Sql" forKey:MGSFOSyntaxDefinitionName];
        NSTextView *textView = [_sqlSyntxView objectForKey:ro_MGSFOTextView];
        
        [textView setFont:[NSFont fontWithName:@"Menlo" size:14.0]];
    }
    return _sqlSyntxView;
}
@end
