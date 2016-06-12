//
//  MultiDelegateModule.h
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiDelegateModule : NSObject
{
    
    dispatch_queue_t moduleQueue;
    
    void *moduleQueueTag;
    
    id multicastDelegate;
}

@property (readonly) dispatch_queue_t moduleQueue;
@property (readonly) void *moduleQueueTag;



- (id)init;
- (id)initWithDispatchQueue:(dispatch_queue_t)queue;

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

- (void)removeDelegate:(id)delegate;

- (NSString *)moduleName;



@end

