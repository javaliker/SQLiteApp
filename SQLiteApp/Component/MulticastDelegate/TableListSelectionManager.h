//
//  TableListSelectionManager.h
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableListSelectionState.h"
@interface TableListSelectionManager : NSObject
@property(nonatomic,readonly)TableListSelectionState *treeListState;
+ (TableListSelectionManager*)sharedInstance;
@end
