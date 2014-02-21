//
//  NTESAPScrollTabView.h
//  Apper
//
//  Created by 林竹 on 13-8-12.
//  Copyright (c) 2013年 NetEase, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultFontHeight 16.0f

@protocol NTESIMTabBarViewDelegate <NSObject>

- (void)tabSelectedWithIndex:(NSInteger)index;

@end

@interface NTESIMTabBarView : UIView

@property(nonatomic, strong)UIImageView *backgroundView;
@property(nonatomic, unsafe_unretained)id<NTESIMTabBarViewDelegate> delegate;

- (void)setTabTitleImagesArray:(NSArray*)imgsArray andHighLightImagesArray:(NSArray*)imgsHLArray;
- (void)setTabTitlesArray:(NSArray*)titlesArray;

- (NSInteger)currentSelectedIndex;
- (void)setDefaultSelectedTab;

@end
