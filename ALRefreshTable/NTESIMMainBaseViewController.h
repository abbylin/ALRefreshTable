//
//  NTESIMMainBaseViewController.h
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-19.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

// base view controller

#import <UIKit/UIKit.h>

@interface NTESIMMainBaseViewController : UIViewController

@property (nonatomic, strong)UIImageView *customNaviBar;


- (void)addRightButtonWithImage:(UIImage*)image target:(id)target action:(SEL)selector;

- (void)addRightButtonWithTitle:(NSString*)title target:(id)target action:(SEL)selector;

// 在原有右导航按钮位置的是primary button
- (void)addPrimaryButtonForTwoButtonsStyleWithImage:(UIImage*)image target:(id)target action:(SEL)selector;

// 其它位置的是Secondary button
- (void)addSecondaryButtonForTwoButtonsStyleWithImage:(UIImage*)image target:(id)target action:(SEL)selector;

// default is back button
- (void)addLeftButtonWithImage:(UIImage*)image target:(id)target action:(SEL)selector;

- (void)setTwoLineNaviTitleWithMain:(NSString*)mainTitle andSubTitle:(NSString*)subTitle;

@end
