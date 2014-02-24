//
//  NTESIMMainBaseViewController.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-19.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "NTESIMMainBaseViewController.h"

@interface NTESIMMainBaseViewController (){
    UIImageView *_customNaviBarShadow;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    UIView *_rightButton;
    UIView *_subRightButton; // secondary right navi button, the button which is not at the typical location
    UIView *_leftButton;
    
    CGFloat _statusBarHeight;
    
    BOOL _haveNaviBar;
}

@end

@implementation NTESIMMainBaseViewController

- (id)init {
    self = [super init];
    if (self) {
        _haveNaviBar = YES;
    }
    return self;
}

- (id)initWithCustomNaviBar:(BOOL)haveNaviBar{
    self = [super init];
    if (self) {
        _haveNaviBar = haveNaviBar;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.userInteractionEnabled = YES;

    if (_haveNaviBar) {
        _statusBarHeight = (SYSTEM_VERSION >= 7.0) ? 20.0 : 0.0;
        
        self.view.backgroundColor = RGBCOLOR(198, 212, 234);
        self.customNaviBar = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44.0+_statusBarHeight)];
        self.customNaviBar.image = nil;
        [self.view addSubview:self.customNaviBar];
        self.customNaviBar.backgroundColor = RGBCOLOR(1, 23, 63);
        
        
        // title label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, _statusBarHeight, self.view.bounds.size.width - 140.0, self.customNaviBar.bounds.size.height - _statusBarHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.customNaviBar addSubview:_titleLabel];
        
        // left navi arrow
        UIImageView *backButton = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, _statusBarHeight, 45.0, 44.0)];
        backButton.userInteractionEnabled = YES;
        backButton.image = [UIImage imageNamed:@"top_navigation_back.png"];
        backButton.backgroundColor = [UIColor clearColor];
        [self.view addSubview:backButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
        [backButton addGestureRecognizer:tap];
        _leftButton = backButton;
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}

- (void)setTitle:(NSString *)title{
    if (title && _titleLabel) {
        _titleLabel.text =  title;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(UIGestureRecognizer*)gesture{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark - public methods
- (void)addRightButtonWithImage:(UIImage *)image target:(id)target action:(SEL)selector{
    UIImageView *naviItem = [[UIImageView alloc] initWithImage:image];
    naviItem.userInteractionEnabled = YES;
    naviItem.frame = CGRectMake(self.customNaviBar.frame.size.width - 10.0 - naviItem.image.size.width, (self.customNaviBar.bounds.size.height - _statusBarHeight - naviItem.image.size.height)/2, naviItem.image.size.width, naviItem.image.size.height);
    naviItem.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [naviItem addGestureRecognizer:tap];
    
    if (_rightButton && [_rightButton superview]) {
        [_rightButton removeFromSuperview];
    }
    
    _rightButton = naviItem;
    [self.view addSubview:_rightButton];
}

- (void)addRightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)selector{
    if (title && title.length > 0) {
        UILabel *naviItem = [[UILabel alloc] init];
        naviItem.userInteractionEnabled = YES;
        naviItem.text = title;
        naviItem.textColor = [UIColor whiteColor];
        naviItem.font = [UIFont systemFontOfSize:14.0];
        naviItem.backgroundColor = [UIColor clearColor];
        naviItem.frame = CGRectMake(self.customNaviBar.frame.size.width - 10.0 - naviItem.intrinsicContentSize.width,
                                    (self.customNaviBar.frame.size.height - _statusBarHeight - naviItem.intrinsicContentSize.height)/2,
                                    naviItem.intrinsicContentSize.width,
                                    naviItem.intrinsicContentSize.height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
        [naviItem addGestureRecognizer:tap];
        
        if (_rightButton && [_rightButton superview]) {
            [_rightButton removeFromSuperview];
        }
        
        _rightButton = naviItem;
        [self.view addSubview:_rightButton];
    }
}

- (void)addPrimaryButtonForTwoButtonsStyleWithImage:(UIImage*)image target:(id)target action:(SEL)selector{
    [self addRightButtonWithImage:image target:target action:selector];
}

- (void)addSecondaryButtonForTwoButtonsStyleWithImage:(UIImage*)image target:(id)target action:(SEL)selector{
    UIImageView *naviItem = [[UIImageView alloc] initWithImage:image];
    naviItem.userInteractionEnabled = YES;
    naviItem.frame = CGRectMake(self.customNaviBar.frame.size.width - 65.0 - naviItem.image.size.width,
                                (self.customNaviBar.bounds.size.height - _statusBarHeight - naviItem.image.size.height)/2,
                                naviItem.image.size.width,
                                naviItem.image.size.height);
    naviItem.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [naviItem addGestureRecognizer:tap];
    
    if (_subRightButton && [_subRightButton superview]) {
        [_subRightButton removeFromSuperview];
    }
    
    _subRightButton = naviItem;
    [self.view addSubview:_subRightButton];
}

- (void)addLeftButtonWithImage:(UIImage*)image target:(id)target action:(SEL)selector{
    UIImageView *naviItem = [[UIImageView alloc] initWithImage:image];
    naviItem.userInteractionEnabled = YES;
    naviItem.frame = CGRectMake(10.0,
                                (self.customNaviBar.bounds.size.height - _statusBarHeight - naviItem.image.size.height)/2,
                                naviItem.image.size.width,
                                naviItem.image.size.height);
    naviItem.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [naviItem addGestureRecognizer:tap];
    
    if (_leftButton && [_leftButton superview]) {
        [_leftButton removeFromSuperview];
    }
    
    _leftButton = naviItem;
    [self.view addSubview:_leftButton];
}

- (void)setTwoLineNaviTitleWithMain:(NSString *)mainTitle andSubTitle:(NSString *)subTitle{
    if (mainTitle && mainTitle.length > 0) {
        _titleLabel.text = mainTitle;
    }
    
    if (subTitle && subTitle.length > 0) {
        if (_subTitleLabel == nil) {
            _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 0.0, self.view.bounds.size.width - 140.0, 14.0)];
            _subTitleLabel.backgroundColor = [UIColor clearColor];
            _subTitleLabel.font = [UIFont systemFontOfSize:12.0];
            _subTitleLabel.textColor = [UIColor whiteColor];
            _subTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self.customNaviBar addSubview:_subTitleLabel];
        }
    }
    _subTitleLabel.text = subTitle;
    
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, _titleLabel.frame.size.width, 20.0);
    _subTitleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame) + 6.0, _titleLabel.frame.size.width, 14.0);
}

- (void)setNoNaviBar{
    if (self.customNaviBar && [self.customNaviBar superview]) {
        [self.customNaviBar removeFromSuperview];
        self.customNaviBar = nil;
    }
}

@end
