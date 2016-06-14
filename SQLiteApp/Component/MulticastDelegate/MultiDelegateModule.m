//
//  MultiDelegateModule.m
//  SQLiteApp
//
//  Created by MacDev on 16/6/10.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "MultiDelegateModule.h"
#import "GCDMulticastDelegate.h"

@implementation MultiDelegateModule

- (id)init {
    
    return [self initWithDispatchQueue:NULL];
}

/**
 * Designated initializer.
 **/
- (id)initWithDispatchQueue:(dispatch_queue_t)queue {
    if ((self = [super init]))
    {
        if (queue)
        {
            moduleQueue = queue;
#if !OS_OBJECT_USE_OBJC
            dispatch_retain(moduleQueue);
#endif
        }
        else
        {
            const char *moduleQueueName = [[self moduleName] UTF8String];
            moduleQueue = dispatch_queue_create(moduleQueueName, NULL);
        }
        
        moduleQueueTag = &moduleQueueTag;
        dispatch_queue_set_specific(moduleQueue, moduleQueueTag, moduleQueueTag, NULL);
        
        multicastDelegate = [[GCDMulticastDelegate alloc] init];
    }
    return self;
}


/**
 * It is recommended that subclasses override this method (instead of deactivate:)
 * to perform tasks after the module has been deactivated.
 *
 * This method is only invoked if the module is transitioning from activated to deactivated.
 * This method is always invoked on the moduleQueue.
 **/
- (void)willDeactivate {
    
    // Override me to do custom work after the module is deactivated
}

- (dispatch_queue_t)moduleQueue {
    
    return moduleQueue;
}

- (void *)moduleQueueTag {
    
    return moduleQueueTag;
}



- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue {
    
    // Asynchronous operation (if outside xmppQueue)
    
    dispatch_block_t block = ^{
        [multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue synchronously:(BOOL)synchronously {
    
    dispatch_block_t block = ^{
        [multicastDelegate removeDelegate:delegate delegateQueue:delegateQueue];
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else if (synchronously)
        dispatch_sync(moduleQueue, block);
    else
        dispatch_async(moduleQueue, block);
    
}
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue {
    
    // Synchronous operation (common-case default)
    
    [self removeDelegate:delegate delegateQueue:delegateQueue synchronously:YES];
}

- (void)removeDelegate:(id)delegate {
    
    // Synchronous operation (common-case default)
    
    [self removeDelegate:delegate delegateQueue:NULL synchronously:YES];
}

- (NSString *)moduleName {
    
    // Override me (if needed) to provide a customized module name.
    // This name is used as the name of the dispatch_queue which could aid in debugging.
    
    return NSStringFromClass([self class]);
}

@end

