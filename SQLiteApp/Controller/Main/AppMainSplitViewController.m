//
//  AppMainSplitViewController.m
//  SQLiteApp
//
//  Created by MacDev on 5/27/16.
//  Copyright © 2016 http://www.macdev.io All rights reserved.
//

#import "AppMainSplitViewController.h"
#import "TableListViewController.h"
#import "AppMainTabViewController.h"
#import "Masonry.h"
@interface AppMainSplitViewController ()
@property(nonatomic,strong)TableListViewController *tableListViewController;
@property(nonatomic,strong)AppMainTabViewController *appMainTabViewController;
@end

@implementation AppMainSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setUpControllers];
    //配置左右部分的布局约束
    [self configLayout];
}



- (void)configLayout {
    //设置第一个视图的宽度最小100,最大200
    [self.tableListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@100);
        make.width.lessThanOrEqualTo(@300);
    }];
    //设置第二个视图的宽度最小100,最大800
    [self.appMainTabViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@300);
        make.width.lessThanOrEqualTo(@2000);
    }];
}

- (void)setUpControllers {
    [self addChildViewController:self.tableListViewController];
    [self addChildViewController:self.appMainTabViewController];
}
#pragma mark-- ivars

- (TableListViewController *)tableListViewController {
    
    if(!_tableListViewController) {
        _tableListViewController = [[TableListViewController alloc ]init];
    }
    return _tableListViewController;
}

- (AppMainTabViewController *)appMainTabViewController {
    
    if(!_appMainTabViewController) {
        _appMainTabViewController = [[AppMainTabViewController alloc ]init];
    }
    return _appMainTabViewController;
}

@end
