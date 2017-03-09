//
//  BXMultiPickerViewDefaultCell.m
//  Baixing
//
//  Created by 李翔 on 1/5/16.
//  Copyright © 2016 Baixing. All rights reserved.
//

#import "BXMultiPickerViewDefaultCell.h"
#import <Masonry/Masonry.h>
#import "NSObject+BXTypeCheck.h"


@interface BXMultiPickerViewDefaultCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorLine;

@end


@implementation BXMultiPickerViewDefaultCell

#pragma mark - life cycle -
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _normalStateBgColor = [self bx_colorFromHexRGB:0xeff0e9];
        _selectedStateBgColor = [self bx_colorFromHexRGB:0xf6f6f6];
        _normalStateTextColor = [UIColor bx_blackColor];
        _selectedStateTextColor = [UIColor bx_radicalRedColor];

        [self addSubview:self.titleLabel];
        [self addSubview:self.separatorLine];

        [self setUpConstraints];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self updateBackgroundColor];
    }

    return self;
}

- (void)setUpConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - public method -
- (void)setTitleLabelText:(NSString *)titleLabelText
{
    self.titleLabel.text = [self bx_safeString:titleLabelText];
}

#pragma mark - getters & setters -
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLabel;
}

- (UIView *)separatorLine
{
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor bx_separatorGray];
    }
    return _separatorLine;
}

#pragma mark - colors
- (void)setNormalStateBgColor:(UIColor *)normalStateBgColor
{
    _normalStateBgColor = normalStateBgColor;
    [self updateBackgroundColor];
}

- (void)setSelectedStateBgColor:(UIColor *)selectedStateBgColor
{
    _selectedStateBgColor = selectedStateBgColor;
    [self updateBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    [self updateBackgroundColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];

    [self updateBackgroundColor];
}

- (void)updateBackgroundColor
{
    if (self.isSelected || self.isHighlighted) {
        self.backgroundColor = self.selectedStateBgColor;
        self.titleLabel.textColor = self.selectedStateTextColor;
    } else {
        self.backgroundColor = _normalStateBgColor;
        self.titleLabel.textColor = _normalStateTextColor;
    }
}

- (UIColor *)bx_colorFromHexRGB:(NSInteger)rgbValue
{
    return [self bx_colorFromHexRGB:rgbValue alpha:1.0];
}

- (UIColor *)bx_colorFromHexRGB:(NSInteger)rgbValue alpha:(CGFloat)alpha
{
    NSInteger mask = 0x000000FF;
    CGFloat red = ((rgbValue >> 16) & mask) / 255.0;
    CGFloat green = ((rgbValue >> 8) & mask) / 255.0;
    CGFloat blue = (rgbValue & mask) / 255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
