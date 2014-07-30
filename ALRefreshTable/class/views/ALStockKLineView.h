//
//  ALStockKLineView.h
//  ALRefreshTable
//
//  Created by lin zhu on 14-1-13.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALStockKLineView : UIView


- (void)setDrawStockSeriesData:(NSArray*)originalArray withBegin:(NSInteger)beginIndex andEnd:(NSInteger)endIndex;


- (CGFloat)getCandleWidth;
@end
