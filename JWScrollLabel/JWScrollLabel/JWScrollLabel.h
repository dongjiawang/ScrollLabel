//
//  JWScrollLabel.h
//  JWScrollLabel
//
//  Created by djw on 2017/5/16.
//  Copyright © 2017年 ubiquitous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWScrollLabel : UIView

/**
 滚动的文字
 */
@property (nonatomic,copy) NSString *labelText;
/**
  文字颜色
 */
@property (nonatomic,strong) UIColor *textColor;
/**
  字体
 */
@property (nonatomic,strong) UIFont *labelFont;
/**
  滚动速度 默认是 10
 */
@property (nonatomic,assign) CGFloat scrollSpeed;
/**
 滚动间隔时间 默认 1.5 秒
 */
@property (nonatomic,assign) NSTimeInterval intervalTime;

/**
  是否正在滚动
 */
@property (nonatomic,assign) BOOL isScrolling;

/**
  重新开始滚动
 */
- (void)reStartScroll;

@end
