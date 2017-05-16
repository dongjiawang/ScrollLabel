//
//  JWScrollLabel.m
//  JWScrollLabel
//
//  Created by djw on 2017/5/16.
//  Copyright © 2017年 ubiquitous. All rights reserved.
//

#import "JWScrollLabel.h"

@interface JWScrollLabel ()

/**
 用来滚动的 scrollView
 */
@property (nonatomic,strong) UIScrollView *scrollView;

/**
  用来显示的主 label
 */
@property (nonatomic,strong) UILabel *mainLabel;

/**
  存储 label 数据（类似缓存）
 */
@property (nonatomic,strong) NSMutableArray *labelArray;


@end

@implementation JWScrollLabel

#define WIDTH self.frame.size.width

#define HEIGHT self.frame.size.height

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.scrollView.frame.size.width != self.bounds.size.width) {
        self.scrollView.frame = self.bounds;
        [self refreshLabelFrame];
    }
}

- (void)initData {
    _textColor = [UIColor blackColor];
    _labelFont = [UIFont systemFontOfSize:14.0];
    
    self.userInteractionEnabled = NO;
    
    _scrollSpeed = 10;
    _intervalTime = 1.5;
    _isScrolling = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reStartScroll) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setLabelText:(NSString *)labelText {
    // 相同的文字 就不用再次赋值并计算 frame
    if ([labelText isEqualToString:_labelText]) return;
    _labelText = labelText;
    [self refreshLabelFrame];
}

- (void)refreshLabelFrame {
    if (_labelText.length == 0) return;
    // 获取文字的 size
    CGSize labelSize = [_labelText boundingRectWithSize:CGSizeMake(MAXFLOAT, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _labelFont} context:nil].size;
    
    CGFloat labelX = 0;
    // 获取单个 label 的 width
    CGFloat labelW = (labelSize.width + 10) > WIDTH ? (labelSize.width + 20) : WIDTH;
    // 设置 label 的 frame 和文字
    for (UILabel *label in self.labelArray) {
        label.frame = CGRectMake(labelX, 0, labelW, HEIGHT);
        label.text = _labelText;
        labelX += labelW;
        label.hidden = NO;
    }
    // 移除 UIView 动画
    [self.scrollView.layer removeAllAnimations];
    
    //  对比 label 的宽度，大于self  就加上滚动动画, 小于就隐藏第二个占位 Label
    if (labelSize.width + 10 > WIDTH) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.mainLabel.frame) + WIDTH, HEIGHT);
        [self scrollLabelIfNeed];
    }
    else {
        // 防止基类控制器调用 reStartScroll
        _isScrolling = YES;
        UILabel *label = self.labelArray[1];
        label.hidden = YES;
        self.scrollView.contentSize = self.bounds.size;
    }
}

- (void)scrollLabelIfNeed {
    _isScrolling = YES;
    NSTimeInterval duration = (CGRectGetWidth(self.mainLabel.frame) - WIDTH) / _scrollSpeed;
    
    // 重置 sontentoffset
    self.scrollView.contentOffset = CGPointZero;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:duration delay:_intervalTime options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.mainLabel.frame), 0);
    } completion:^(BOOL finished) {
        //  只有动画能正确的执行完才会循环调用，否则就是说明控制器有其他的操作（比如重新赋值，或者 viewdisapper）
        if (finished) {
            [weakSelf scrollLabelIfNeed];
        }
        else {
            _isScrolling = NO;
        }
    }];
}

- (void)reStartScroll {
    if (_isScrolling) return;
    [self scrollLabelIfNeed];
}


#pragma mark -- getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = _labelFont;
            label.textColor = _textColor;
            [self.scrollView addSubview:label];
            [self.labelArray addObject:label];
        }
    }
    return _labelArray;
}

- (UILabel *)mainLabel {
    return self.labelArray[0];
}

@end
