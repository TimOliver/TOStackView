//
//  TOStackView.h
//
//  Copyright 2021 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "TOStackView.h"

@interface TOStackView () {
    NSMutableArray *_arrangedSubviews;
}

@end

@implementation TOStackView

- (instancetype)initWithLayoutAxis:(UILayoutConstraintAxis)axis
{
    if (self = [super initWithFrame:CGRectZero]) {
        _axis = axis;
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithArrangedSubviews:(NSArray<__kindof UIView *> *)subviews
{
    if (self = [super initWithFrame:CGRectZero]) {
        _arrangedSubviews = [NSMutableArray arrayWithArray:subviews];

        // Add the arranged subviews to our hierarchy
        for (UIView *subview in subviews) {
            [self addSubview:subview];
        }

        [self commonInit];
        [self sizeToFit];
    }

    return self;
}

- (void)commonInit
{
    _minimumSpacing = 20;
}

- (void)addArrangedSubview:(UIView *)subview
{
    // We might get strange behaviour if we store the same view twice
    if ([_arrangedSubviews containsObject:subview]) { return; }

    // Add to the hierarchy
    [_arrangedSubviews addObject:subview];
    [self addSubview:subview];

    // Set a new layout pass
    [self setNeedsLayout];
}

- (void)removeArrangedSubview:(UIView *)subview
{
    // Make sure it's a view currently in the stack view
    if (![_arrangedSubviews containsObject:subview]) { return; }

    // Remove the subview from all retaining references
    [subview removeFromSuperview];
    [_arrangedSubviews removeObject:subview];

    // Trigger a new layout
    [self setNeedsLayout];
}

- (void)insertArrangedSubview:(UIView *)subview atIndex:(NSInteger)index
{
    // Make sure it's a view currently in the stack view
    if (![_arrangedSubviews containsObject:subview]) { return; }

    // Insert the view at the desired index
    [self addSubview:subview];
    [_arrangedSubviews insertObject:subview atIndex:index];

    // Trigger a new layout pass
    [self setNeedsLayout];
}

#pragma mark - View Layout -

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Save the size we have to work with
    CGSize size = self.frame.size;

    // Capture whether we are laying out vertically or horizontal
    BOOL isHorizontal = (self.axis == UILayoutConstraintAxisHorizontal);

    // Manually lay out the first and last views
    UIView *firstView = _arrangedSubviews.firstObject;
    [self layoutSubview:firstView offset:0.0f];

    // Align the last view manually since relying on floating point offsets
    // can sometimes result with it either over or under shooting it
    UIView *lastView = _arrangedSubviews.lastObject;
    [self layoutSubview:lastView offset:0.0f];

    // If we have an odd number of views, align the middle one in the center
    UIView *midView = nil;
    NSInteger midIndex = floorf((CGFloat)_arrangedSubviews.count / 2.0f);
    if (_arrangedSubviews.count % 2 != 0) {
        midView = _arrangedSubviews[midIndex];
        CGSize viewSize = midView.frame.size;
        CGFloat offset = isHorizontal ? (size.width - viewSize.width) * 0.5f :
                                        (size.height - viewSize.height) * 0.5f;
        [self layoutSubview:midView offset:offset];
    }

    // Work out the spacing of the remaining views between the first, last and optionally mid
    if (midView != nil) {
        [self layoutSubviewsBetween:firstView lastView:midView];
        [self layoutSubviewsBetween:midView lastView:lastView];
    } else {
        [self layoutSubviewsBetween:firstView lastView:lastView];
    }
}

- (void)layoutSubviewsBetween:(UIView *)firstView lastView:(UIView *)lastView
{
    BOOL isHorizontal = (self.axis == UILayoutConstraintAxisHorizontal);

    NSInteger firstIndex = [_arrangedSubviews indexOfObject:firstView];
    NSInteger lastIndex = [_arrangedSubviews indexOfObject:lastView];

    // Work out the number of remaining in-between views on either side
    NSInteger inBetweenCount = (lastIndex - firstIndex) - 1;

    // Work out usable space for left hand views
    CGFloat spacing = [self spacingBetween:firstView lastView:lastView];

    // Divide that by the number of in between
    CGFloat segmentWidth = spacing / (CGFloat)inBetweenCount;

    // Work out segment starting point
    CGRect frame = firstView.frame;
    CGFloat offset = isHorizontal ? CGRectGetMaxX(frame) : CGRectGetMaxY(frame);

    for (NSInteger i = firstIndex + 1; i < lastIndex; i++) {
        UIView *subview = _arrangedSubviews[i];
        CGSize viewSize = subview.frame.size;
        CGFloat viewOffset = offset + (segmentWidth * 0.5f);
        viewOffset -= (isHorizontal ? viewSize.width : viewSize.height) * 0.5f;
        [self layoutSubview:subview offset:viewOffset];
        offset += segmentWidth;
    }
}

- (CGFloat)spacingBetween:(UIView *)firstView lastView:(UIView *)lastView
{
    CGRect firstFrame = firstView.frame;
    CGRect lastFrame = lastView.frame;

    BOOL isHorizontal = (self.axis == UILayoutConstraintAxisHorizontal);
    if (isHorizontal) {
        return CGRectGetMinX(lastFrame) - CGRectGetMaxX(firstFrame);
    }

    return CGRectGetMinY(lastFrame) - CGRectGetMaxY(firstFrame);
}

- (void)layoutSubview:(UIView *)subview offset:(CGFloat)offset
{
    BOOL isHorizontal = (self.axis == UILayoutConstraintAxisHorizontal);

    // Manually override for first and last frames
    if (subview == _arrangedSubviews.firstObject) {
        offset = 0.0f;
    } else if (subview == _arrangedSubviews.lastObject) {
        CGSize frameSize = self.frame.size;
        CGSize size = subview.frame.size;
        offset = isHorizontal ? frameSize.width - size.width :
                                frameSize.height - size.height;
    }

    CGRect frame = subview.frame;
    CGFloat alignment = [self alignmentOffsetForView:subview];
    frame.origin.x = floorf(isHorizontal ? offset : alignment);
    frame.origin.y = floorf(isHorizontal ? alignment : offset);
    subview.frame = frame;
}

- (CGFloat)alignmentOffsetForView:(UIView *)view
{
    // Work out what the perpendicular value of this view should be
    BOOL isHorizontal = (self.axis == UILayoutConstraintAxisHorizontal);

    CGSize frameSize = self.frame.size;
    CGSize size = view.frame.size;

    // Capture any intrinsic sizing for the view we'll need to adapt
    UIEdgeInsets insets = [[view viewForFirstBaselineLayout] alignmentRectInsets];

    // When horizontal, we're returning the Y value
    if (isHorizontal) {
        switch (self.alignment) {
            case TOStackViewAlignmentTop:
                return 0.0f;
            case TOStackViewAlignmentBottom:
                return frameSize.height - size.height;
            default: // Default is center vertical alignment (With baseline adjustments)
                return MAX(0.0f, ceilf((frameSize.height - size.height) * 0.5f)
                           + (insets.bottom - insets.top));
        }
    } else { // When vertical return the X alignment
        switch (self.alignment) {
            // Doesn't conform to right-to-left languages yet. Must fix later.
            case TOStackViewAlignmentLeading:
                return 0.0f;
            case TOStackViewAlignmentTrailing:
                return frameSize.width - size.width;
            default: // Default is center alignment
                return ceilf((frameSize.width - size.width) * 0.5f);
        }
    }
}

#pragma mark - View Sizing -

- (void)sizeToFit
{
    CGRect frame = self.frame;
    frame.size = CGSizeZero;

    BOOL isHorizontal = (self.axis == UILayoutConstraintAxisHorizontal);

    // Loop through each subview to aggregate the size
    for (UIView *subview in _arrangedSubviews) {
        if (isHorizontal) {
            frame.size.height = MAX(frame.size.height, subview.frame.size.height);
            frame.size.width += subview.frame.size.width;
        } else {
            frame.size.width = MAX(frame.size.width, subview.frame.size.width);
            frame.size.height += subview.frame.size.height;
        }
    }

    // Add additional spacing to match minimum allowed amount
    CGFloat spacing = (_arrangedSubviews.count - 1) * _minimumSpacing;
    if (isHorizontal) { frame.size.width += spacing; }
    else { frame.size.height += spacing; }

    self.frame = frame;
}

#pragma mark - Accessors -

- (NSArray<UIView *> *)arrangedSubviews
{
    return [NSArray arrayWithArray:_arrangedSubviews];
}

@end
