//
//  ViewController.m
//  WMYTextField
//
//  Created by Wmy on 16/3/9.
//  Copyright © 2016年 Wmy. All rights reserved.
//

#import "ViewController.h"
#import "WMYTextField.h"

@interface ViewController () <WMYTextFieldDelegate>
@property (nonatomic, weak) IBOutlet WMYTextField *textF;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_textF setRightBtnTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)textField:(WMYTextField *)textField clickedButton:(UIButton *)button {
    [self startTime];
}

- (void)startTime
{
    __block int timeout = 10; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_textF setRightBtnTitle:@"重新获取验证码" forState:UIControlStateNormal];
                [_textF setRightBtnEnabled:YES];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    [_textF setRightBtnTitle:[NSString stringWithFormat:@"%zd s",timeout]
                                    forState:UIControlStateNormal];
                [_textF setRightBtnEnabled:NO];
                }];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
