//
//  ALStockSeries.h
//  ALRefreshTable
//
//  Created by lin zhu on 14-1-13.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALStockSeries : NSObject

@property (nonatomic, strong)NSString *open;
@property (nonatomic, strong)NSString *close;
@property (nonatomic, strong)NSString *high;
@property (nonatomic, strong)NSString *low;
@property (nonatomic, assign)CGFloat volume;   // 已经处理成万手
@property (nonatomic, strong)NSString *date;

@end
