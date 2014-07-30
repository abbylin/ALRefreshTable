//
//  ALRefreshTableFooterView.h
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-18.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALRefreshTableDelegate.h"

@interface ALRefreshTableFooterView : UIView

@property (nonatomic, weak) id<ALRefreshTableDelegate> delegate;
@property (nonatomic, assign) UIEdgeInsets originalInset;
@property (nonatomic, assign) CGPoint originalOffset;

- (id)initInScrollView:(UIScrollView*)scrollView;

- (void)ALRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView andComplete:(void(^)(void))completeBlock;

@end
