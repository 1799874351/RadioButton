//
//  BJHSectionHeaderView.m
//  BaiJiaHao
//
//  Created by Luo,Hefei on 2017/7/24.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BJHSectionHeaderView.h"

@implementation BJHSectionHeaderView{
    NSMutableArray *_titleBts;
    CALayer *_indicatorLayer;
    
    UIColor *_titleDefaultColor;
    UIColor *_titleSelectedColor;
    
    UIColor *_borderLineColor;
    CGFloat _borderLineWidth;
    
    UIColor *_btDefaultBackgroundColor;
    UIColor *_btSelectedBackgroundColor;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configureUISet];
    }
    return self;
}

- (void)configureUISet{
    self.backgroundColor = [UIColor whiteColor];
    _borderLineColor = [UIColor whiteColor];
    _borderLineWidth = 0.5;
    _titleFont = [UIFont systemFontOfSize:15];
    _titleDefaultColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor blueColor];
    _indicatorColor = [UIColor blueColor];
    
    _titleBts = [NSMutableArray new];
    _indicatorLayer = [CALayer layer];
    _indicatorLayer.backgroundColor = _indicatorColor.CGColor;
    _indicatorLayer.anchorPoint  = CGPointMake(0, 0);
    _currentIndex = -1;
    _hasIndicator = NO;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = _titleBts.count;
    if (count == 0) {
        return;
    }
    CGFloat itemWidth = self.width / count;
    for (int i = 0; i < count; i++) {
        UIButton *button = _titleBts[i];
        CGRect frame = CGRectMake(itemWidth * i + 0.5, 0,itemWidth - 1, self.height);
        [button setFrame:frame];
    }
    [self resetIndicatorFrame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (_hasBorderLine && _titles.count > 1) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        NSInteger count = _titles.count;
        CGFloat itemWidth = rect.size.width /count;
        CGFloat itemHeight = rect.size.height;
        path.lineWidth = _borderLineWidth;
        for (int i = 1; i < count ; i++) {
            CGFloat xAxisPoint = itemWidth * i;
            [path moveToPoint:CGPointMake(xAxisPoint, 0)];
            [path addLineToPoint:CGPointMake(xAxisPoint, itemHeight)];
        }
        [_borderLineColor setStroke];
        [path stroke];
    }
}


- (void)setTitles:(NSArray<NSString *> *)titles{
    _titles = [titles copy];
    [self removeAllSubviews];
    [_titleBts removeAllObjects];
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        NSString *titleStr = [titles objectAtIndex:i];
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.font = _titleFont;
        [button setTitleColor:_titleDefaultColor forState:UIControlStateNormal];
        [button setTitleColor:_titleSelectedColor
                    forState:UIControlStateSelected];
        if (_btDefaultBackgroundColor) {
            [button setBackgroundImage:[UIImage imageWithColor:_btDefaultBackgroundColor] forState:UIControlStateNormal];
        }
        if (_btSelectedBackgroundColor) {
            [button setBackgroundImage:[UIImage imageWithColor:_btSelectedBackgroundColor] forState:UIControlStateSelected];
        }
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_titleBts addObject:button];
    }
    [_indicatorLayer removeFromSuperlayer]; //  前置indicatorlayer
    [self.layer insertSublayer:_indicatorLayer atIndex:(int)self.layer.sublayers.count];
    [self setCurrentIndex:0];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)resetIndicatorFrame{
    if (_hasIndicator && _titleBts.count > 0) {
        CGFloat width = self.width / _titleBts.count;
        CGFloat buttonTitleWidth = [self buttonTitleLabelSize:_titleBts[_currentIndex]].width;
        _indicatorLayer.frame = CGRectMake(width/2 - buttonTitleWidth/2 + width * _currentIndex, self.height - 1.5,buttonTitleWidth,1.5);
    }
}

- (CGSize)buttonTitleLabelSize:(UIButton *)button{
    CGSize buttonLabelSize = button.titleLabel.frame.size;
//    if (buttonLabelSize.width == 0) {
       buttonLabelSize.width = [button.currentTitle boundingRectWithSize:button.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleFont} context:nil].size.width;
//    }
    return buttonLabelSize;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
//    if (_currentIndex == currentIndex) {
//        return ;
//    }
    _currentIndex = currentIndex;
    [self updateButtonStatu];
    
    if (_hasIndicator) {
        [self indicatorLayerDoMoveAnimation];
    }
}


- (void)updateButtonStatu{
    for (UIButton *button in _titleBts) {
        button.selected = (button.tag == _currentIndex);
    }
}

- (void)indicatorLayerDoMoveAnimation{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self resetIndicatorFrame];
    [CATransaction commit];
}

#pragma mark - 点击事件
- (void)clickButton:(id)sender{
    NSInteger tag = [sender tag];
    self.currentIndex = tag;
    if (_delegate && [_delegate respondsToSelector:@selector(sectionHeaderView:didSelectIndex:)]) {
        [_delegate sectionHeaderView:self didSelectIndex:tag];
    }
}

#pragma mark - title 颜色、字体、指示器颜色设置
- (void)setTitleFont:(UIFont *)titleFont{
    if (titleFont) {
        _titleFont = titleFont;
        for (UIButton *item in _titleBts) {
            item.titleLabel.font = titleFont;
        }
    }
}

- (void)setTitleDefaultColor:(UIColor *)titleDefaultColor selectedColor:(UIColor *)titleSelectedColor{
    [self setTitleDefaultColor:titleDefaultColor defaultBackgroundColor:nil selectedColor:titleSelectedColor selectedBackgroundColor:nil];
}

- (void)setTitleDefaultColor:(UIColor *)titleDefaultColor defaultBackgroundColor:(UIColor *)defaultBackgroundColor selectedColor:(UIColor *)titleSelectedColor selectedBackgroundColor:(UIColor *)selectBackgroundColor{
    if (titleDefaultColor && titleSelectedColor) {
        _titleDefaultColor = titleDefaultColor;
        _titleSelectedColor = titleSelectedColor;
        _btDefaultBackgroundColor = defaultBackgroundColor;
        _btSelectedBackgroundColor = selectBackgroundColor;
        
        for (UIButton *button in _titleBts) {
            [button setTitleColor:_titleDefaultColor forState:UIControlStateNormal];
            [button setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
            
            if (defaultBackgroundColor) {
                [button setBackgroundImage:[UIImage imageWithColor:defaultBackgroundColor] forState:UIControlStateNormal];
            }
            if (selectBackgroundColor) {
                [button setBackgroundImage:[UIImage imageWithColor:selectBackgroundColor] forState:UIControlStateSelected];
            }
        }
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor{
    if (indicatorColor) {
        _indicatorColor = indicatorColor;
        [_indicatorLayer setBackgroundColor:indicatorColor.CGColor];
    }
}

- (void)setHasBorderLine:(BOOL)hasBorderLine{
    _hasBorderLine = hasBorderLine;
    [self setNeedsDisplay];
}

- (void)setBorderLineColor:(UIColor *)lineColor borderLineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius{
    if (!lineColor) {
        return;
    }
    _borderLineWidth = lineWidth;
    _borderLineColor = lineColor;
    self.layer.borderWidth = lineWidth;
    self.layer.borderColor = lineColor.CGColor;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

@end
