//
//  DataPageManager.m
//  TableDataNavigationViewController
//
//  Created by MacDev on 16/6/4.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "DataPageManager.h"

@interface DataPageManager ()
@property(nonatomic,readwrite)NSInteger  page;//current page index

@property(nonatomic,readwrite)NSInteger  pageSize;//row numbers of each page

@property(nonatomic,readwrite)NSInteger  pages;//total pages

@property(nonatomic,readwrite)NSInteger  total;//total data rows

@end;

@implementation DataPageManager

- (id)initWithPageSize:(NSInteger)pageSize delegate:(id<PaginatorDelegate>)paginatorDelegate {
    self = [super init];
    if(self){
        _page = 0;
        _delegate = paginatorDelegate;
        _pageSize = pageSize;
    }
    return self;
}


- (BOOL)isFirstPage {
    
    return (self.page==0);
}

- (BOOL)isLastPage {
    
    return (self.pages==0 || self.page==self.pages-1);
}

- (BOOL)goPage:(NSInteger)index {
    
    if(self.pages >0 && index<=self.pages-1){
        self.page = index;
        if(self.delegate) {
            [self.delegate paginator:self requestDataWithPage:self.page pageSize:self.pageSize];
        }
        return YES;
    }
    return NO;
}

- (void)refreshCurrentPage {
    
    [self goPage:self.page];
    
}
- (BOOL)goFirstPage {
    return [self goPage:0];
}

- (BOOL)goLastPage {
    
    if(self.pages>1){
        return [self goPage:self.pages-1];
    }
    return NO;
}

- (BOOL)goNextPage {
    
    if(![self isLastPage]){
        return [self goPage:self.page+1];
    }
    return NO;
}

- (BOOL)goPrePage {
    
    if(![self isFirstPage]){
        return [self goPage:self.page-1];
        
    }
    return NO;
}

- (void)computePageNumbers {
    [self reset];
    self.total = [self.delegate totalNumberOfData:self];
    if(self.pageSize>0){
        self.pages = ceil((double)self.total/(double)self.pageSize);
    }
    else{
        self.pages = 0;
    }
}

- (void)reset {
    self.pages = 0;
    self.page = 0;

}

@end

