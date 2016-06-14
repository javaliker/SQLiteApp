//
//  AppMainWindowController.m
//  SQLiteApp
//
//  Created by MacDev on 5/27/16.
//  Copyright © 2016 http://www.macdev.io All rights reserved.
//

#import "AppMainWindowController.h"
#import "AppMainSplitViewController.h"

extern NSString* const kOpenDBNotification;
extern NSString* const kCloseDBNotification;

@interface AppMainWindowController ()

@property(nonatomic,strong)AppMainSplitViewController *splitViewController;

@end

@implementation AppMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self configWindowFrameSize];
    self.contentViewController = self.splitViewController;
    [self setWindowIcon];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)configWindowFrameSize {
    NSRect frame = [[NSScreen mainScreen] visibleFrame];
    frame.size.height = 500;
    frame.size.width  = 1000;
    [self.window setFrame:frame display:YES];
}

- (void)setWindowIcon {
    [self.window setRepresentedURL:[NSURL URLWithString:@"WindowTitle"]];
    [self.window setTitle:@"SQLiteApp"];
    NSImage *image = [NSImage imageNamed:@"windowIcon"];
    [[self.window standardWindowButton:NSWindowDocumentIconButton] setImage:image];
}

- (NSString*)windowNibName {
    return @"AppMainWindowController";
}

#pragma mark- Toolbar Action

- (IBAction)openToolBarClicked:(id)sender {
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    openDlg.canChooseFiles = YES ;
    openDlg.canChooseDirectories = YES;
    openDlg.allowsMultipleSelection = YES;
    openDlg.allowedFileTypes = @[@"sqlite"];
    [openDlg beginWithCompletionHandler: ^(NSInteger result){
        if(result==NSFileHandlingPanelOKButton){
            NSArray *fileURLs = [openDlg URLs];
            for(NSURL *url in fileURLs) {
            
                NSString* path = [url path];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:kOpenDBNotification object:path];
                
                return ;
            }
        }
    }];

}

- (IBAction)closeToolBarClicked:(id)sender {
 
        NSAlert *alert = [[NSAlert alloc] init];
        //增加一个按钮
        [alert addButtonWithTitle:@"Ok"];
        //增加一个按钮
        [alert addButtonWithTitle:@"Cancel"];
        //提示的标题
        [alert setMessageText:@"Confirm"];
        //提示的详细内容
        [alert setInformativeText:@"Close Database?"];
        //设置告警风格
        [alert setAlertStyle:NSCriticalAlertStyle];
        //开始显示告警
        [alert beginSheetModalForWindow:self.window
                      completionHandler:^(NSModalResponse returnCode){
                          
                          NSLog(@"returnCode %ld",returnCode);
                          
                          if(returnCode==NSAlertFirstButtonReturn){
                              
                              
                                [[NSNotificationCenter defaultCenter]postNotificationName:kCloseDBNotification object:nil];
                          }
                          //用户点击告警上面的按钮后的回调
                      }
         ];
        return;
}


- (IBAction)homeToolBarClicked:(id)sender {
    
    NSString *appStoreURL = @"http://www.macdev.io";
    NSURL *url =[NSURL URLWithString: appStoreURL];
    if( ![[NSWorkspace sharedWorkspace] openURL:url] ){
        NSLog(@"Failed to open url: %@",[url description]);
    }
}

#pragma mark -- ivars

- (AppMainSplitViewController *)splitViewController {
    if(!_splitViewController){
        _splitViewController = [[AppMainSplitViewController alloc]init];
    }
    return _splitViewController;
}

@end
