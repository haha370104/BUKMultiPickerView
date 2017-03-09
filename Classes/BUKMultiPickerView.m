//
//  BUKMultiPickerView.m
//  Baixing
//
//  Created by 李翔 on 1/5/16.
//  Copyright © 2016 Baixing. All rights reserved.
//

#import "BUKMultiPickerView.h"
#import "BUKMultiPickerTitleView.h"


@interface BUKMultiPickerView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *tableViewsHolder;

@property (nonatomic, weak) id<BUKMultiPickerViewDataSourceAndDelegate> buk_delegate;
@property (nonatomic, strong) NSArray *tableViews;

@property (nonatomic, strong) NSLayoutConstraint *tableViewsHolderTopConstraint;

@end


@implementation BUKMultiPickerView

@synthesize titleView = _titleView;

#pragma mark - life cycle -
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<BUKMultiPickerViewDataSourceAndDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buk_delegate = delegate;

        [self addSubview:self.tableViewsHolder];
        [self initTableViews];
        [self setUpConstraints];
    }
    return self;
}

#pragma mark - public method -
- (void)reloadData
{
    for (UIView *subView in self.tableViewsHolder.subviews) {
        [subView removeFromSuperview];
    }

    [self initTableViews];
}

- (void)reloadDataOfTableViewAtIndex:(NSInteger)tableViewIndex
{
    UITableView *someTableView = [self.tableViews objectAtIndex:tableViewIndex];
    [someTableView reloadData];
    NSIndexPath *selectedIndexPath = [self selectedCellIndexPathOfTableViewAtIndex:tableViewIndex];
    [someTableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

- (void)selectRowAtTableViewIndex:(NSInteger)tableViewIndex animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    UITableView *someTableView = [self.tableViews objectAtIndex:tableViewIndex];
    NSIndexPath *selectedIndexPath = [self selectedCellIndexPathOfTableViewAtIndex:tableViewIndex];
    [someTableView selectRowAtIndexPath:selectedIndexPath animated:animated scrollPosition:scrollPosition];
    // scrolling effect of selectRowAtIndexPath:animated:scrollPosition: isn't good enough
    // scroll the table views manually
    NSUInteger numberOfRowsToBeScrolled = selectedIndexPath.row - 2 > 0 ? selectedIndexPath.row - 2 : 0;
    CGFloat yOffset = [self heightForRowAtIndexPath:selectedIndexPath tableView:someTableView index:tableViewIndex] * numberOfRowsToBeScrolled;
    [someTableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

#pragma mark - private method -
- (void)initTableViews
{
    NSInteger numberOfTableViews = [self numberOfTableViews];
    CGFloat multiplier = 1.0f / numberOfTableViews;
    UITableView *previousTableView = nil;
    NSMutableArray *tableViews = [NSMutableArray array];
    for (int i = 0; i < numberOfTableViews; i++) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self registerCellForTableView:tableView index:i];
        [self.tableViewsHolder addSubview:tableView];
        // constraints
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.tableViewsHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
        [self.tableViewsHolder addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.tableViewsHolder attribute:NSLayoutAttributeWidth multiplier:multiplier constant:0]];
        if (!previousTableView) {
            [self.tableViewsHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
        } else {
            [self.tableViewsHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousTableView][tableView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView, previousTableView)]];
        }

        previousTableView = tableView;
        [tableViews addObject:tableView];
    }
    self.tableViews = tableViews;

    for (int i = 0; i < self.tableViews.count; i++) {
        [self selectRowAtTableViewIndex:i animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
}

- (void)setUpConstraints
{
    self.tableViewsHolder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableViewsHolder]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableViewsHolder)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableViewsHolder]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableViewsHolder)]];
    self.tableViewsHolderTopConstraint = [NSLayoutConstraint constraintWithItem:self.tableViewsHolder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:self.tableViewsHolderTopConstraint];
}

- (void)updateNeedTitleViewConstraints
{
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleView(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleView)]];

    [self removeConstraint:self.tableViewsHolderTopConstraint];
    if (self.needTitleView) {
        self.tableViewsHolderTopConstraint = [NSLayoutConstraint constraintWithItem:self.titleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.tableViewsHolder attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    } else {
        self.tableViewsHolderTopConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.tableViewsHolder attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    }

    [self addConstraint:self.tableViewsHolderTopConstraint];
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger tableViewIndex = [self.tableViews indexOfObject:tableView];
    if (tableViewIndex == NSNotFound) {
        return 0;
    }

    return [self numberOfSectionsInTableViewOfIndex:tableViewIndex];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tableViewIndex = [self.tableViews indexOfObject:tableView];
    if (tableViewIndex == NSNotFound) {
        return 0;
    }

    return [self numberOfRowsInSection:section tableViewOfIndex:tableViewIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tableViewIndex = [self.tableViews indexOfObject:tableView];
    if (tableViewIndex == NSNotFound) {
        return 0;
    }

    return [self heightForRowAtIndexPath:indexPath tableView:tableView index:tableViewIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tableViewIndex = [self.tableViews indexOfObject:tableView];
    if (tableViewIndex == NSNotFound) {
        return [[UITableViewCell alloc] init];
    }

    return [self cellForRowAtIndexPath:indexPath tableView:tableView index:tableViewIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tableViewIndex = [self.tableViews indexOfObject:tableView];
    if (tableViewIndex == NSNotFound) {
        return;
    }

    return [self didSelectRowAtIndexPath:indexPath tableView:tableView index:tableViewIndex];
}

#pragma mark - delegate wrapper -
- (NSInteger)numberOfTableViews
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(numberOfTableViewsInMultiPickerView:)]) {
        return [self.buk_delegate numberOfTableViewsInMultiPickerView:self];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableViewOfIndex:(NSInteger)tableViewIndex
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(numberOfSectionsInTableViewOfIndex:multiPickerView:)]) {
        return [self.buk_delegate numberOfSectionsInTableViewOfIndex:tableViewIndex multiPickerView:self];
    }
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section tableViewOfIndex:(NSInteger)tableViewIndex
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(numberOfRowsInSection:tableViewofIndex:multiPickerView:)]) {
        return [self.buk_delegate numberOfRowsInSection:section tableViewofIndex:tableViewIndex multiPickerView:self];
    }
    return 0;
}

- (void)registerCellForTableView:(UITableView *)tableView index:(NSInteger)tableViewIndex
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(registerCellForTableView:index:multiPickerView:)]) {
        [self.buk_delegate registerCellForTableView:tableView index:tableViewIndex multiPickerView:self];
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView index:(NSInteger)tableViewIndex
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(heightForRowAtIndexPath:tableView:index:multiPickerView:)]) {
        return [self.buk_delegate heightForRowAtIndexPath:indexPath tableView:tableView index:tableViewIndex multiPickerView:self];
    }
    return 0;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView index:(NSInteger)tableViewIndex
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(cellForRowAtIndexPath:tableView:index:multiPickerView:)]) {
        return [self.buk_delegate cellForRowAtIndexPath:indexPath tableView:tableView index:tableViewIndex multiPickerView:self];
    }
    return [[UITableViewCell alloc] init];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView index:(NSInteger)tableViewIndex
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(didSelectRowAtIndexPath:tableView:index:multiPickerView:)]) {
        [self.buk_delegate didSelectRowAtIndexPath:indexPath tableView:tableView index:tableViewIndex multiPickerView:self];
    }
}

- (NSIndexPath *)selectedCellIndexPathOfTableViewAtIndex:(NSInteger)tableViewIndex
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(selectedCellIndexPathOfTableViewAtIndex:multiPickerView:)]) {
        return [self.buk_delegate selectedCellIndexPathOfTableViewAtIndex:tableViewIndex multiPickerView:self];
    }
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

#pragma mark - getters & setters -
- (UIView *)tableViewsHolder
{
    if (!_tableViewsHolder) {
        _tableViewsHolder = [[UIView alloc] init];
    }
    return _tableViewsHolder;
}

- (void)setNeedTitleView:(BOOL)needTitleView
{
    _needTitleView = needTitleView;
    [self.titleView removeFromSuperview]; // title view may change
    [self addSubview:self.titleView];
    [self updateNeedTitleViewConstraints];
}

- (UIView *)titleView
{
    if (!_titleView) {
        BUKMultiPickerTitleView *titleView = [[BUKMultiPickerTitleView alloc] init];
        _titleView = titleView;
    }
    return _titleView;
}

- (void)setTitleView:(UIView *)titleView
{
    _titleView = titleView;
    [self.titleView removeFromSuperview];
    [self addSubview:_titleView];
    [self updateNeedTitleViewConstraints];
}

@end
