//
//  ALRefreshTableDelegate.h
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-12.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define  REFRESH_REGION_HEIGHT 65.0f
#define  REFRESH_MAX_HEIGHT 400.0f

typedef enum{
	ALRefreshPulling = 0,
	ALRefreshNormal,
	ALRefreshLoading,
} ALRefreshState;

typedef enum{
	ALRefreshHeader = 0,
	ALRefreshFooter
} ALRefreshPos;

@protocol ALRefreshTableDelegate <NSObject>

- (void)ALRefreshTableDidTriggerRefresh:(ALRefreshPos)aRefreshPos;
- (BOOL)ALRefreshTableDataSourceIsLoading:(UIView*)view;
@optional
- (NSDate*)ALRefreshTableDataSourceLastUpdated:(UIView*)view;

@end
