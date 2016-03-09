//
//  WMYTextField.m
//  Workspace
//
//  Created by Wmy on 16/3/9.
//  Copyright © 2016年 Wmy. All rights reserved.
//

#import "WMYTextField.h"

CGFloat const kTextRectLeftMarge = 12.0f;
CGFloat const kTextRectRightMarge = 16.0f;
CGFloat const kLeftImgRectTopMarge = 6.0f;

CGFloat const kRightBtnTitleFont = 15.0f;

CGFloat const kLeftViewDefaultWidth = 40.0f;
CGFloat const kRightViewDefaultWidth = 80.0f;

@interface WMYTextField ()

@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIView *rightBtnView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *line;

@end


@implementation WMYTextField

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib {
    [self configure];
}


#pragma mark - configure

- (void)configure {
    
    [self addCorner];
    self.backgroundColor = [UIColor whiteColor];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (!_leftViewWidth) {
        self.leftViewWidth = kLeftViewDefaultWidth;
    }
    if (!_rightViewWidth) {
        self.rightViewWidth = kRightViewDefaultWidth;
    }

}

- (void)addCorner {
    [self.layer setCornerRadius:6.0];
    [self.layer setBorderWidth:0.5];
    [self.layer setBorderColor:[[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor]];
}


#pragma mark - event response

- (void)action_rightBtn:(id)sender {
    [self resignFirstResponder];
    
    if (_tfDelegate && [_tfDelegate respondsToSelector:@selector(textField:clickedButton:)])
        [_tfDelegate textField:self clickedButton:sender];
    else
        NSLog(@"you need add 'tfDelegate' and responds selector (textField:clickedButton:)");
}


#pragma mark - setter

- (void)setRightBtnEnabled:(BOOL)rightBtnEnabled {
    if (_rightButton) {
        _rightButton.userInteractionEnabled = rightBtnEnabled;
    }
}

- (void)setLeftImage:(UIImage *)leftImage {
    if (!leftImage) {
        [self removeConstraints:_leftImgView.constraints];
        self.leftViewMode = UITextFieldViewModeNever;
        _leftImgView = nil;
        self.leftView = nil;
        return;
    }
    
    _leftImage = leftImage;
    self.leftImgView.image = leftImage;
    self.leftView = _leftImgView;
    self.leftViewMode = UITextFieldViewModeAlways;
    [self setNeedsLayout];
}

- (void)setShowRightView:(BOOL)showRightView {
    _showRightView = showRightView;
    if (!showRightView) {
        self.rightViewMode = UITextFieldViewModeNever;
        self.rightView = nil;
        return;
    }
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = self.rightBtnView;
    [self addRightVFL];
}

- (void)setRightBtnTitle:(NSString *)title forState:(UIControlState)state {
    [self.rightButton setTitle:title forState:state];
}

- (void)setRightBtnTitleColor:(UIColor *)color forState:(UIControlState)state {
    [self.rightButton setTitleColor:color forState:state];
}

- (void)setLeftViewWidth:(CGFloat)leftViewWidth {
    _leftViewWidth = leftViewWidth;
    [self setNeedsLayout];
}

- (void)setRightViewWidth:(CGFloat)rightViewWidth {
    _rightViewWidth = rightViewWidth;
    [self setNeedsLayout];
}


#pragma mark - getter

- (UIImageView *)leftImgView {
    if (_leftImgView == nil) {
        _leftImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImgView;
}

- (UIView *)rightBtnView {
    if (_rightBtnView == nil) {
        _rightBtnView = [[UIView alloc] initWithFrame:CGRectZero];
        [_rightBtnView addSubview:self.rightButton];
        [_rightBtnView addSubview:self.line];
    }
    return _rightBtnView;
}

- (UIButton *)rightButton {
    if (_rightButton == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectZero];
        [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:kRightBtnTitleFont]];
        [btn setTitle:@"Title" forState:UIControlStateNormal];
        [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]
                  forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor]
                  forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor yellowColor]
                  forState:UIControlStateSelected];
        [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]
                  forState:UIControlStateHighlighted];
        [btn setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.01]];
        [btn addTarget:self action:@selector(action_rightBtn:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton = btn;
    }
    return _rightButton;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        _line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return _line;
}

#pragma mark - vfl

- (void)addRightVFL {
    
    [_rightBtnView removeConstraints:_rightButton.constraints];
    [_rightBtnView removeConstraints:_line.constraints];
    
    NSString *vfl1 = @"H:|[line(0.5)][rightButton]|";
    [_rightBtnView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:nil
                                                                            views:@{@"line" : _line,
                                                                                    @"rightButton" : _rightButton}]];
    NSString *vfl2 = @"V:|-[line]-|";
    [_rightBtnView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:nil
                                                                            views:@{@"line" : _line}]];

    NSString *vfl3 = @"V:|[rightButton]|";
    [_rightBtnView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:nil
                                                                            views:@{@"rightButton" : _rightButton}]];
}


#pragma mark - 控制显示位置

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x,
                              bounds.origin.y + kLeftImgRectTopMarge,
                              _leftViewWidth,
                              bounds.size.height - 2 * kLeftImgRectTopMarge);
    return inset;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.size.width - bounds.origin.x - _rightViewWidth,
                              bounds.origin.y,
                              _rightViewWidth,
                              bounds.size.height);
    return inset;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat leftWidth = self.leftView ? self.leftView.bounds.size.width + 2 : kTextRectLeftMarge;
    CGFloat rightWidth = self.rightView ? self.rightView.bounds.size.width + 2 : kTextRectRightMarge;
    
    CGRect inset = CGRectMake(bounds.origin.x + leftWidth,
                              bounds.origin.y,
                              bounds.size.width - leftWidth - rightWidth,
                              bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGFloat leftWidth = self.leftView ? self.leftView.bounds.size.width + 2 : kTextRectLeftMarge;
    CGFloat rightWidth = self.rightView ? self.rightView.bounds.size.width + 2 : kTextRectRightMarge;
    
    CGRect inset = CGRectMake(bounds.origin.x + leftWidth,
                              bounds.origin.y,
                              bounds.size.width - leftWidth - rightWidth,
                              bounds.size.height);
    return inset;
}

@end
