//
//  MDatabase.m
//  MDatabase
//
//  Created by MacDev on 16/6/8.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "MDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface MDatabase ()
@property(nonatomic,readwrite)FMDatabaseQueue *queue;
@property(nonatomic,strong)NSString *dbName;
@property(nonatomic,readwrite) NSString *dbPath;
@end

@implementation MDatabase

- (void)dealloc {
    [self close];
}

+ (instancetype)sharedInstance {
    static MDatabase *instace = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instace = [[self alloc] init];
    });
    return instace;
}

- (BOOL)openDBWithName:(NSString*)dbName {
    self.dbName = dbName;
    NSString *dbPath = [[self docPath]stringByAppendingPathComponent:dbName];
    return [self openDBWithPath:dbPath];
}

- (BOOL)openDBWithPath:(NSString*)dbPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.dbName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            return NO;
        }
        else {
            NSLog(@"\n create database success");
        }
    }
    self.dbPath = dbPath;
    self.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if(!self.queue){
        NSLog(@"\n create queue failed!");
        return NO;
    }
    return YES;
}

- (void)close {
    if(self.queue){
        [self.queue close];
        self.queue = nil;
        self.dbPath = nil;
    }
}

- (NSString*)docPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
@end
