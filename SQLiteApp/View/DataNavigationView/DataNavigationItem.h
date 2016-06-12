//
//  DataNavigationItem.h
//  SQLiteApp
//
//  Created by MacDev on 6/2/16.
//  Copyright © 2016 macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataNavigationItem : NSObject
@property (nonatomic, strong) NSString *tooltips;//鼠标悬停的提示
@property (nonatomic, strong) NSString *identifier;//标识字符串
@property (nonatomic, assign) NSInteger tag;//按钮的tag
@end
