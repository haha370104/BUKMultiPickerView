//
//  BUKMultiPickerView.h
//  Baixing
//
//  Created by 李翔 on 1/5/16.
//  Copyright © 2016 Baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BUKMultiPickerView;

@protocol BUKMultiPickerViewDataSourceAndDelegate <NSObject>

- (NSInteger)numberOfTableViewsInMultiPickerView:(BUKMultiPickerView *)multiPickerView;

- (NSInteger)numberOfSectionsInTableViewOfIndex:(NSInteger)tableViewIndex multiPickerView:(BUKMultiPickerView *)multiPickerView;

- (NSInteger)numberOfRowsInSection:(NSInteger)section tableViewofIndex:(NSInteger)tableViewIndex multiPickerView:(BUKMultiPickerView *)multiPickerView;

- (void)registerCellForTableView:(UITableView *)tableView index:(NSInteger)tableViewIndex multiPickerView:(BUKMultiPickerView *)multiPickerView;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView index:(NSInteger)tableViewIndex multiPickerView:(BUKMultiPickerView *)multiPickerView;

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView index:(NSInteger)tableViewIndex multiPickerView:(BUKMultiPickerView *)multiPickerView;

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView index:(NSInteger)tableViewIndex multiPickerView:(BUKMultiPickerView *)multiPickerView;

- (NSIndexPath *)selectedCellIndexPathOfTableViewAtIndex:(NSInteger)tableViewIndex multiPickerView:(BUKMultiPickerView *)multiPickerView;

@end


@interface BUKMultiPickerView : UIView

@property (nonatomic, assign) BOOL needTitleView;
@property (nonatomic, strong) UIView *titleView;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<BUKMultiPickerViewDataSourceAndDelegate>)delegate;

- (void)selectRowAtTableViewIndex:(NSInteger)tableViewIndex animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)reloadDataOfTableViewAtIndex:(NSInteger)tableViewIndex;
- (void)reloadData;

@end
