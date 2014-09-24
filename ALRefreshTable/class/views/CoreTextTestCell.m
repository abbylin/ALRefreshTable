//
//  CoreTextTestCell.m
//  ALRefreshTable
//
//  Created by linzhu on 14-8-28.
//  Copyright (c) 2014年 lin zhu. All rights reserved.
//

#import "CoreTextTestCell.h"
#import <CoreText/CoreText.h>
#import <CoreText/CTRunDelegate.h>

#pragma mark -
#pragma mark - ALMixTextLabel
@implementation ALMixTextLabel

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self textAndImageAttributed];
}

void RunDelegateDeallocCallBack(void *refCon){
    
}

CGFloat RunDelegateGetAscentCallback(void* refCon){
    return 18;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    return 18;
}

- (void)textAndImageAttributed{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    
    NSString *name = @"hellokitty";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"hellokitty送X2"];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(248, 25, 151) range:NSMakeRange(0, name.length)];
    NSInteger pos = [attributeStr.string rangeOfString:@"X"].location;
    [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(248, 25, 151) range:NSMakeRange(pos, attributeStr.string.length - pos)];
    
    NSString *imgName = @"bobo_chat_flower.png";
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallBack;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(imgName));
    NSMutableAttributedString *imgAttributeString = [[NSMutableAttributedString alloc] initWithString:@" "];
    [imgAttributeString addAttribute:(NSString*)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    
    [imgAttributeString addAttribute:@"imageName" value:imgName range:NSMakeRange(0, 1)];
    [attributeStr insertAttributedString:imgAttributeString atIndex:name.length+1];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(10.0, 2.0, self.bounds.size.width - 20.0, self.bounds.size.height - 4.0));
    
    CTFramesetterRef ctFrameSetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributeStr);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame, context);
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    NSLog(@"line count = %ld",CFArrayGetCount(lines));
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        NSLog(@"ascent = %f,descent = %f,leading = %f",lineAscent,lineDescent,lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        NSLog(@"run count = %ld",CFArrayGetCount(runs));
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            NSLog(@"width = %f",runRect.size.width);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(18, 18);
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x + imageDrawRect.size.width/2;
                    imageDrawRect.origin.y = lineOrigin.y;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    CFRelease(ctFrame);
    CGPathRelease(path);
    CFRelease(ctFrameSetter);
}

@end


#pragma mark -
#pragma mark - cell

@interface CoreTextTestCell (){
    UILabel *_titleLabel;
    UILabel *_textLabel;
    UILabel *_timeLabel;
    ALMixTextLabel *_mixTextLabel;
}

@end

@implementation CoreTextTestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        // Initialization code
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_titleLabel];
//        
//        _textLabel = [[UILabel alloc] init];
//        _textLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_textLabel];
//        
//        _timeLabel = [[UILabel alloc] init];
//        _timeLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_timeLabel];
        
        _mixTextLabel = [[ALMixTextLabel alloc] init];
        _mixTextLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_mixTextLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    //_titleLabel.frame = CGRectMake(10, 10, rect.size.width - 20.0, 20.0);
    _mixTextLabel.frame = rect;
}

- (void)setInfo:(NSDictionary *)dict{
    NSString *nickName = @"CIGALYAMEI";
    NSString *wholeText = [NSString stringWithFormat:@"欢迎%@进入直播间", nickName];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:wholeText];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[wholeText rangeOfString:nickName]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
