//
//  TableListSelectionManager.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "TableListSelectionManager.h"

@interface TableListSelectionManager ()
@property(nonatomic,readwrite)TableListSelectionState *treeListState;
@end

@implementation TableListSelectionManager

+ (TableListSelectionManager*)sharedInstance
{
    static TableListSelectionManager *instace = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instace = [[self alloc] init];
        
    });
    return instace;
}

- (TableListSelectionState*)treeListState{
    if(!_treeListState) {
        _treeListState = [[TableListSelectionState alloc]init];
    }
    return _treeListState;
}

@end
