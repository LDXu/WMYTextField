//
//  WMYTextField.h
//  Workspace
//
//  Created by Wmy on 16/3/9.
//  Copyright © 2016年 Wmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WMYTextFieldDelegate;

IB_DESIGNABLE
@interface WMYTextField : UITextField

@property (nullable, nonatomic, weak) IBOutlet id<WMYTextFieldDelegate> tfDelegate;

@property (nullable, nonatomic, strong) IBInspectable UIImage *leftImage;
@property (nonatomic, assign) IBInspectable BOOL showRightView;

@property (nonatomic) IBInspectable CGFloat leftViewWidth;  // default is 40.0.
@property (nonatomic) IBInspectable CGFloat rightViewWidth; // default is 80.0.

@property (nonatomic, assign) BOOL rightBtnEnabled;
@property (nonatomic, assign) BOOL rightBtnSelected;

- (void)setRightBtnTitle:(nullable NSString *)title forState:(UIControlState)state;
- (void)setRightBtnTitleColor:(nullable UIColor *)color forState:(UIControlState)state;

@end


@protocol WMYTextFieldDelegate <NSObject>
@optional
- (void)textField:(WMYTextField *)textField clickedButton:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
