//
//  BXMultiPickerViewDefaultCell.h
//  Baixing
//
//  Created by 李翔 on 1/5/16.
//  Copyright © 2016 Baixing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BXMultiPickerViewDefaultCell : UITableViewCell

@property (nonatomic, strong) UIColor *normalStateBgColor;
@property (nonatomic, strong) UIColor *normalStateTextColor;
@property (nonatomic, strong) UIColor *selectedStateBgColor;
@property (nonatomic, strong) UIColor *selectedStateTextColor;

- (void)setTitleLabelText:(NSString *)titleLabelText;

@end
