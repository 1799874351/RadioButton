//
//  BJHSectionHeaderView.h
//  BaiJiaHao
//
//  Created by Luo,Hefei on 2017/7/24.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BJHSectionHeaderView;
@protocol BJHSectionHeaderViewDelegate <NSObject>

- (void)sectionHeaderView:(BJHSectionHeaderView *)sectionHeaderView  didSelectIndex:(NSInteger) index;

@end

@interface BJHSectionHeaderView : UIView

/**
 标题数组，元素为NSString  建议在其他属性都设置完之后在设置此属性
 */
@property (nonatomic, strong) NSArray<NSString *> *titles;

/**
 当前选中的index   下标从0开始计算
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 选中事件代理
 */
@property (nonatomic, weak) id<BJHSectionHeaderViewDelegate> delegate;

/**
 title 字体       默认为system大小 15
 */
@property (nonatomic, strong) UIFont *titleFont;


/**
 是否有游标指示器       默认没有
 */
@property (nonatomic, assign) BOOL hasIndicator;

/**
 游标颜色       默认为蓝色
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 是否有边框
 */
@property (nonatomic, assign) BOOL hasBorderLine;


/**
 设置title 字体颜色 

 @param titleDefaultColor 未选中状态下的颜色 默认为黑色
 @param titleSelectedColor  选中状态下的颜色    默认为蓝色
 */
- (void)setTitleDefaultColor:(UIColor *)titleDefaultColor selectedColor:(UIColor *)titleSelectedColor;

/**
 设置title 字体颜色
 
 @param titleDefaultColor 未选中状态下的颜色 默认为黑色
 @param defaultBackgroundColor 未选中状态下的颜色
 @param selectedBackgroundColor 选中状态下的颜色
 @param titleSelectedColor  选中状态下的颜色    默认为蓝色
 */
- (void)setTitleDefaultColor:(UIColor *)titleDefaultColor defaultBackgroundColor:(UIColor *)defaultBackgroundColor selectedColor:(UIColor *)titleSelectedColor selectedBackgroundColor:(UIColor *)selectBackgroundColor;

/**
 设置边框

 @param lineColor 边框颜色
 @param lineWidth 边框线条大小
 @param cornerRadius 边框圆角
 */
- (void)setBorderLineColor:(UIColor *)lineColor borderLineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat) cornerRadius;

@end
