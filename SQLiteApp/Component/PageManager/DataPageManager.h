//
//  DataPageManager.h
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PaginatorDelegate
@required

- (void)paginator:(id)paginator requestDataWithPage:(NSInteger)page pageSize:(NSInteger)pageSize;

- (NSInteger)totalNumberOfData:(id)paginator;

@end


@interface DataPageManager : NSObject

@property (weak) id <PaginatorDelegate>delegate;

@property(nonatomic,readonly)NSInteger  page;//current page index

@property(nonatomic,assign)NSInteger  pageSize;//row numbers of each page

@property(nonatomic,readonly)NSInteger  pages;//total pages

@property(nonatomic,readonly)NSInteger  total;//total data rows

- (id)initWithPageSize:(NSInteger)pageSize delegate:(id<PaginatorDelegate>)paginatorDelegate;

- (BOOL)isFirstPage;

- (BOOL)isLastPage;

- (BOOL)goPage:(NSInteger)index;

- (void)refreshCurrentPage;

- (BOOL)goNextPage;

- (BOOL)goPrePage;

- (BOOL)goFirstPage;

- (BOOL)goLastPage;

- (void)reset;

- (void)computePageNumbers;

@end
