//
//  ALRefreshTableHeaderView.h
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-12.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ALRefreshTableDelegate.h"

@interface ALRefreshTableHeaderView : UIView

@property (nonatomic, weak) id<ALRefreshTableDelegate> delegate;

- (id)initWithFrame:(CGRect)frame inScrollView:(UIScrollView*)scrollView;

@end
