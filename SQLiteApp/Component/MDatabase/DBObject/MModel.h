//
//  MModel.h
//  MDatabase
//
//  Created by MacDev on 16/6/8.
//  Copyright © 2016年 http://www.macdev.io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MModel : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

/*save new model object*/
- (BOOL)save;

/*save updated model object*/
- (BOOL)update;

/*delete current model object*/
- (BOOL)delete;

@end
