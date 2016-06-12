//
//  MModel.m
//  MDatabase
//
//  Created by MacDev on 16/6/8.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import "MModel.h"
#import "MDAO.h"

@interface MModel ()
@property(nonatomic,strong)MDAO *dao;
@end

@implementation MModel
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(!self){
        return nil;
    }
    return self;
}

- (MDAO*)dao {
    if(!_dao){
        NSString *selfName = NSStringFromClass([self class]);
        NSString *className = [NSString stringWithFormat:@"%@MDAO",selfName];
        Class class = NSClassFromString(className);
        return [[class alloc]init];
    }
    return _dao;
}

- (BOOL)save {
    return [self.dao insert:self];
}

- (BOOL)update {
    return [self.dao update:self];
}

- (BOOL)delete {
    return [self.dao delete:self];
}
@end
