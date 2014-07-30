//
//  ALRefreshTableFooterView.m
//  ALRefreshTable
//
//  Created by Abby lin on 14-2-18.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "ALRefreshTableFooterView.h"

@interface ALRefreshTableFooterView (){
    
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    
    ALRefreshState _state;
}

@property (nonatomic, assign) UIScrollView *scrollView;

@end

@implementation ALRefreshTableFooterView

- (id)initInScrollView:(UIScrollView*)scrollView{
    self = [super initWithFrame:CGRectMake(0, MAX(scrollView.frame.size.height, scrollView.contentSize.height), scrollView.frame.size.width, REFRESH_MAX_HEIGHT)];
    if (self) {
        self.scrollView = scrollView;
        self.originalInset = scrollView.contentInset;
        
        [scrollView addSubview:self];
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [self initTableFooterView];
    }
    return self;
}

- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    self.scrollView = nil;
}

- (void)willMoveToSuperview:(UIView *)superview
{
    [super willMoveToSuperview:superview];
    
    if (!superview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.scrollView = nil;
    }
}

- (void)initTableFooterView{
    
    self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = TEXT_COLOR;
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    _lastUpdatedLabel=label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.textColor = TEXT_COLOR;
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    _statusLabel=label;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(25.0f, 20.0f, 30.0f, 55.0f);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents = (id)[UIImage imageNamed:@"grayArrow.png"].CGImage;

    [[self layer] addSublayer:layer];
    _arrowImage=layer;
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.frame = CGRectMake(25.0f, 20.0f, 20.0f, 20.0f);
    [self addSubview:view];
    _activityView = view;
    
    [self setState:ALRefreshNormal];
    
}

- (void)layoutSubviews{
    
}


#pragma mark -
#pragma mark - update state and update refresh time

- (void)refreshLastUpdatedDate {
    
    return;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(ALRefreshTableDataSourceLastUpdated:)]) {
		
		NSDate *date = [self.delegate ALRefreshTableDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = @"";
		
	}
    
}

- (void)setState:(ALRefreshState)aState{
	
	switch (aState) {
		case ALRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"Release to load more...", @"Release to load more");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            //_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            _arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case ALRefreshNormal:
			
			if (_state == ALRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"Pull up to load more...", @"Pull up to load more");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case ALRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark - KVO and scrollEvent handling
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[UIScrollView class]] && [keyPath isEqualToString:@"contentOffset"]) {
        CGPoint newOffset = [[change objectForKey:@"new"] CGPointValue];
        if (newOffset.y < self.originalOffset.y) {
            // this means the header is being dragged, return
            return;
        }
        NSLog(@"footer new offset is %@", NSStringFromCGPoint(self.scrollView.contentOffset));
        NSLog(@"content size is %@", NSStringFromCGSize(self.scrollView.contentSize));
        UIScrollView *scrollView = (UIScrollView*)[self superview];
        if ((scrollView.contentOffset.y + self.originalOffset.y + scrollView.frame.size.height) < scrollView.contentSize.height+REFRESH_REGION_HEIGHT && scrollView.contentOffset.y > self.originalOffset.y) {
            if (self.scrollView.isDragging && _state == ALRefreshPulling) {
                // 开始拖动时，在这个区段恢复normal
                [self setState:ALRefreshNormal];
            }
        }else if (scrollView.contentOffset.y + self.originalOffset.y + scrollView.frame.size.height > scrollView.contentSize.height+REFRESH_REGION_HEIGHT) {
            if (_state == ALRefreshNormal && self.scrollView.isDragging) {
                // 从普通状态进入下拉状态
                [self setState:ALRefreshPulling];
            }else if (!self.scrollView.isDragging){
                // scrollView不再是拖拽状态，说明松手了，可以刷新了
                BOOL loading = NO;
                if (self.delegate && [self.delegate respondsToSelector:@selector(ALRefreshTableDataSourceIsLoading:)]) {
                    loading = [self.delegate ALRefreshTableDataSourceIsLoading:self];
                }
                
                if (!loading) {
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(ALRefreshTableDidTriggerRefresh:)]) {
                        [self.delegate ALRefreshTableDidTriggerRefresh:ALRefreshFooter];
                    }
                    
                    [UIView animateWithDuration:0.1
                                     animations:^{
                                         scrollView.contentInset = UIEdgeInsetsMake(self.originalInset.top, self.originalInset.left, self.originalInset.bottom+REFRESH_REGION_HEIGHT, self.originalInset.right);
                                     } completion:^(BOOL finished) {
                                         [self setState:ALRefreshLoading];
                                     }];
                    
                }
                
            }
        }
    }
}

#pragma mark -
#pragma mark - public method
- (void)ALRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView andComplete:(void (^)(void))completeBlock{
    
    if (_state != ALRefreshNormal) {
        if (scrollView) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [scrollView setContentInset:self.originalInset];
                             } completion:^(BOOL finished) {
                                 [self setState:ALRefreshNormal];
                                 if (completeBlock) {
                                     completeBlock();
                                 }
                             }];
        }
    }
}

@end
