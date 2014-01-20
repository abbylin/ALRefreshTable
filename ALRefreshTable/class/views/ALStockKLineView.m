//
//  ALStockKLineView.m
//  ALRefreshTable
//
//  Created by lin zhu on 14-1-13.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "RegexKitLite.h"
#import "ALStockKLineView.h"
#import "ALStockSeries.h"

#define kMaxCandles 100
#define kUpColor [UIColor redColor]
#define kDownColor [UIColor greenColor];
#define kVolumeUnit 1000000

#define kRegexFirstDayInMonth @"[0-9]{4}-[0-9]{2}"

@interface ALStockKLineView ()

@property (nonatomic, strong)NSMutableArray *drawDataArray;
@property (nonatomic, assign)CGFloat maxValue;
@property (nonatomic, assign)CGFloat minValue;
@property (nonatomic, assign)CGFloat maxVolume;
@property (nonatomic, assign)CGFloat baseValue;
@property (nonatomic, assign)CGFloat candleInterval;
@property (nonatomic, assign)CGRect candleViewRect;
@property (nonatomic, assign)CGRect volumeViewRect;
@property (nonatomic, strong)NSString *monthCursor;
@property (nonatomic, strong)UIImage *tmpDrawImage;

@end

@implementation ALStockKLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.monthCursor = nil;
        self.drawDataArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        
        // 计算两部分的rect
        self.candleViewRect = CGRectMake(20.0, 5.0, frame.size.width - 20.0, frame.size.height*3/4);
        
        _candleInterval = self.candleViewRect.size.width/kMaxCandles;
        
        self.volumeViewRect = CGRectMake(self.candleViewRect.origin.x, CGRectGetMaxY(self.candleViewRect) + 18.0, self.candleViewRect.size.width, frame.size.height-CGRectGetMaxY(self.candleViewRect)-20.0);
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    self.tmpDrawImage = nil;
    [self.tmpDrawImage drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    UIGraphicsBeginImageContext(rect.size);
    [self.tmpDrawImage drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
    UIGraphicsPopContext();
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
    
    // candleView边框, 成交量边框
    CGMutablePathRef borderPath = CGPathCreateMutable();
    CGPathAddRect(borderPath, NULL, self.candleViewRect);
    CGPathAddRect(borderPath, NULL, self.volumeViewRect);
    [[UIColor darkGrayColor] setStroke];
    CGContextSetLineWidth(context, 0.5);
    CGContextAddPath(context, borderPath);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(borderPath);
    
    // 开始绘制candle
    [self drawCandleViewWithContextRef:context];
    
    self.tmpDrawImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawCandleViewWithContextRef:(CGContextRef)context{
    CGFloat beginX = self.candleViewRect.origin.x + (kMaxCandles-1) * _candleInterval;
    for (int i = 0; i < 100; i++) {
        [self drawCandleWithContext:context forEntity:(ALStockSeries*)[self.drawDataArray objectAtIndex:i] inUnitRect:CGRectMake(beginX, self.candleViewRect.origin.y, _candleInterval, CGRectGetMaxY(self.volumeViewRect)- self.candleViewRect.origin.y)];
        
        beginX -= _candleInterval;
    }
}

- (void)drawCandleWithContext:(CGContextRef)context forEntity:(ALStockSeries*)stockSeries inUnitRect:(CGRect)rect{
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 根据涨跌选择柱状图颜色
    BOOL isUp = stockSeries.close.floatValue >= stockSeries.open.floatValue ? YES : NO;
    UIColor *selectedColor = isUp ? kUpColor : kDownColor;
    
    // 添加最高价-最低价之间的线
    CGPoint points[2] = {CGPointMake(rect.origin.x + rect.size.width/2, [self currentYAxisForCandle:stockSeries.high.floatValue]),
                         CGPointMake(rect.origin.x + rect.size.width/2, [self currentYAxisForCandle:stockSeries.low.floatValue])};
    CGPathAddLines(path, NULL, points, sizeof(points)/sizeof(CGPoint));
    
    // 添加candle方框
    CGRect candleRect = CGRectMake(rect.origin.x + 1.0,
                                   isUp ? [self currentYAxisForCandle:stockSeries.close.floatValue] : [self currentYAxisForCandle:stockSeries.open.floatValue],
                                   rect.size.width - 2.0,
                                   [self heightInYAxisForCandle:(stockSeries.close.floatValue - stockSeries.open.floatValue)]);
    CGPathAddRect(path, NULL, candleRect);
    
    // 添加成交量方框
    CGRect volumeRect = CGRectMake(rect.origin.x + 1.0,
                                   [self currentYAxisForVolume:stockSeries.volume],
                                   rect.size.width - 2.0,
                                   [self heightInYAxisForVolume:stockSeries.volume]);
    CGPathAddRect(path, NULL, volumeRect);
    
    
    CGContextAddPath(context, path);
    
    [selectedColor setFill];
    [selectedColor setStroke];
    
    CGContextSetLineWidth(context, 1.0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPathRelease(path);
    
    // 如果是新的月份，需要绘制月份间隔线
    if ([self isNewMonth:stockSeries]) {
        CGContextMoveToPoint(context, rect.origin.x + rect.size.width/2, CGRectGetMaxY(rect));
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width/2, self.volumeViewRect.origin.y);
        CGContextMoveToPoint(context, rect.origin.x + rect.size.width/2, CGRectGetMaxY(self.candleViewRect));
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width/2, self.candleViewRect.origin.y);
        
        [[UIColor lightGrayColor] set];
        CGContextSetLineWidth(context, 0.5);
        CGContextStrokePath(context);
        
        // 写字
        UIFont *font = [UIFont systemFontOfSize:12.0];
        NSString *text = [stockSeries.date stringByMatching:kRegexFirstDayInMonth];
        CGSize tmpSize = [text sizeWithFont:font];
        CGRect textRect = CGRectMake(rect.origin.x + rect.size.width/2 - tmpSize.width/2,
                                     CGRectGetMaxY(self.candleViewRect)+2.0,
                                     tmpSize.width+2.0,
                                     tmpSize.height+1.0);
        [text drawInRect:textRect withFont:font];
    }
}

- (void)setDrawStockSeriesData:(NSArray *)originalArray withBegin:(NSInteger)beginIndex andEnd:(NSInteger)endIndex{
    if (beginIndex == -1) {
        beginIndex = 0;
    }
    
    if (endIndex >= originalArray.count) {
        endIndex = originalArray.count - 1;
    }
    
    [self.drawDataArray removeAllObjects];
    _maxValue = -1;
    _minValue = -1;
    _maxVolume = -1;
    
    for (NSInteger i = beginIndex; i <= endIndex; i++) {
        NSLog(@"%@", [(ALStockSeries*)[originalArray objectAtIndex:i] date]);
        CGFloat tmpMax = [(ALStockSeries*)[originalArray objectAtIndex:i] high].floatValue;
        _maxValue = (_maxValue == -1) ? tmpMax : MAX(_maxValue, tmpMax);
        
        CGFloat tmpMin = [(ALStockSeries*)[originalArray objectAtIndex:i] low].floatValue;
        _minValue = (_minValue == -1) ? tmpMin : MIN(_minValue, tmpMin);
        
        CGFloat tmpVolume = [(ALStockSeries*)[originalArray objectAtIndex:i] volume];
        _maxVolume = (_maxVolume == -1) ? tmpVolume : MAX(_maxVolume, tmpVolume);
        
        [self.drawDataArray addObject:(ALStockSeries*)[originalArray objectAtIndex:i]];
    }
}


#pragma mark -
#pragma mark - utility methods
- (CGFloat)currentYAxisForCandle:(CGFloat)currentValue{
    return self.candleViewRect.origin.y + self.candleViewRect.size.height * (_maxValue-currentValue)/(_maxValue - _minValue);
}

- (CGFloat)heightInYAxisForCandle:(CGFloat)value{
    return fabs(value)*self.candleViewRect.size.height/(_maxValue - _minValue);
}

- (CGFloat)currentYAxisForVolume:(CGFloat)currentVolume{
    return CGRectGetMaxY(self.volumeViewRect) - [self heightInYAxisForVolume:currentVolume];
}

- (CGFloat)heightInYAxisForVolume:(CGFloat)currentVolume{
    return currentVolume * self.volumeViewRect.size.height * 0.9 / _maxVolume;
}

- (BOOL)isNewMonth:(ALStockSeries*)stockSeries{
    if (stockSeries.date && stockSeries.date.length > 0) {
        NSArray *tmpArray = [stockSeries.date componentsSeparatedByString:@"-"];
        if (tmpArray.count > 2) {
            if (self.monthCursor == nil) {
                self.monthCursor = [tmpArray objectAtIndex:1];
            }else{
                if ([self.monthCursor isEqualToString:[tmpArray objectAtIndex:1]]) {
                    return NO;
                }else {
                    self.monthCursor = [tmpArray objectAtIndex:1];
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (CGFloat)getCandleWidth{
    return _candleInterval;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
