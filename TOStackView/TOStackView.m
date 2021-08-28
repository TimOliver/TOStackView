//
//  TOStackView.m
//  TOStackViewExample
//
//  Created by Tim Oliver on 28/8/21.
//

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

}

- (void)removeArrangedSubview:(UIView *)subview
{

}

- (void)insertArrangedSubview:(UIView *)subview atIndex:(NSInteger)index
{

}

#pragma mark - View Layout -

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Save the size we have to work with
    CGSize size = self.frame.size;

    // Capture whether we are laying out vertically or horizontal
    BOOL isHorizontal = (self.axis == UILayoutConstraintAxisHorizontal);

    // Get overall size of elements along our target axis
    CGFloat totalSubviewSize = [self totalSubviewSizeForAxis:self.axis];

    // Get the entire space we can use
    CGFloat totalSize = isHorizontal ? size.width : size.height;

    // Work out remaining spacing
    CGFloat spacing = (totalSize - totalSubviewSize) / (_arrangedSubviews.count - 1);

    // Loop through every view and lay out
    CGFloat offset = 0.0f;
    for (UIView *subview in _arrangedSubviews) {
        CGSize size = subview.frame.size;

        // Lay out the subview
        [self layoutSubview:subview offset:offset];
        offset += spacing + (isHorizontal ? size.width : size.height);
    }
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
    frame.origin.x = isHorizontal ? offset : alignment;
    frame.origin.y = isHorizontal ? alignment : offset;
    subview.frame = frame;
}

- (CGFloat)alignmentOffsetForView:(UIView *)view
{
    // Work out what the perpendicular value of this view should be
    BOOL isHorizontal = (self.axis == UILayoutConstraintAxisHorizontal);

    CGSize frameSize = self.frame.size;
    CGSize size = view.frame.size;

    // When horizontal, we're returning the Y value
    if (isHorizontal) {
        switch (self.alignment) {
            default: // Default is center alignment
                return floorf((frameSize.height - size.height) * 0.5f);
        }
    } else { // When vertical return the X alignment
        switch (self.alignment) {
            default: // Default is center alignment
                return floorf((frameSize.width - size.width) * 0.5f);
        }
    }
}

- (CGFloat)totalSubviewSizeForAxis:(UILayoutConstraintAxis)axis
{
    CGFloat size = 0.0f;
    BOOL isHorizontal = (axis == UILayoutConstraintAxisHorizontal);
    for (UIView *subview in _arrangedSubviews) {
        CGSize frameSize = subview.frame.size;
        size += isHorizontal ? frameSize.width : frameSize.height;
    }

    return size;
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
