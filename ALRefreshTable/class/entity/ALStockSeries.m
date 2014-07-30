//
//  ALStockSeries.m
//  ALRefreshTable
//
//  Created by lin zhu on 14-1-13.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "ALStockSeries.h"

@implementation ALStockSeries

- (id)init{
    self = [super init];
    if (self) {
        self.open = @"0";
        self.close = @"0";
        self.high = @"0";
        self.low = @"0";
        self.volume = 0;
        self.date = @"0000-00-00";
    }
    return self;
}

@end
