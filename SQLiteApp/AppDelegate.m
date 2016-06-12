//
//  AppDelegate.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/12.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "AppDelegate.h"
#import "AppMainWindowController.h"
@interface AppDelegate ()
@property(nonatomic,strong)AppMainWindowController *appMainWindowController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self.appMainWindowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (AppMainWindowController*)appMainWindowController {
    if(!_appMainWindowController){
        _appMainWindowController = [[AppMainWindowController alloc]init];
    }
    return _appMainWindowController;
}

@end
