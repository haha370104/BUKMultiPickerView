//
//  BUKMultiPickerTitleView.h
//  Baixing
//
//  Created by 李翔 on 1/7/16.
//  Copyright © 2016 Baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BUKMultiPickerTitleView;

typedef void (^BUKMultiPickerTitleViewAction)(BUKMultiPickerTitleView *titleView);


@interface BUKMultiPickerTitleView : UIView

@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UIButton *rightButton;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *bottomLine;


@property (nonatomic, copy) BUKMultiPickerTitleViewAction leftButtonAction;
@property (nonatomic, copy) BUKMultiPickerTitleViewAction rightButtonAction;

// Custom UI

@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;

/**
 *  Color used for left and right button's normal state color.
 */
@property (nonatomic, strong) UIColor *tintColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *bottomLineColor UI_APPEARANCE_SELECTOR;

@end
