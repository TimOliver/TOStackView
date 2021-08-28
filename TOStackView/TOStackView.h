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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// The alignment of each subview within the stack view
typedef NS_ENUM(NSInteger, TOStackViewAlignment) {
    TOStackViewAlignmentCenter,   // Elements are aligned in the middle of the stack view
    TOStackViewAlignmentLeading,  // Elements are aligned from the leading edge
    TOStackViewAlignmentTrailing, // Elements are aligned from the trailing edge
    TOStackViewAlignmentTop,      // Elements are aligned along the top
    TOStackViewAlignmentBottom    // Elements are aligned along the bottom
};

/// A basic container view that handles laying out
/// a collection of subviews in a vertical or horizontal alignment.
/// Unlike `UIStackView`, it usese manual frame layout, and is designed
/// for really simplistic use cases where leveraging the full power
/// of Auto Layout, and the performance overhead isn't required.
NS_SWIFT_NAME(StackView)
@interface TOStackView : UIView

/// Create a new stack view instance with the provided direction
/// @param axis The layout direction, horizontal or vertical
- (instancetype)initWithLayoutAxis:(UILayoutConstraintAxis)axis;

/// Create a new stack view with the provided subviews
/// @param subviews The subviews to provide
- (instancetype)initWithArrangedSubviews:(NSArray<__kindof UIView *> *)subviews;

/// All of the arranged subviews currently in the stack view
@property (nonatomic, readonly) NSArray<__kindof UIView *> *arrangedSubviews;

/// The directional axis that subviews are arranged
@property (nonatomic, assign) UILayoutConstraintAxis axis;

/// The layout alignment of the arranged subviews
@property (nonatomic, assign) TOStackViewAlignment alignment;

/// The minimum allowed spacing between each element
@property (nonatomic, assign) CGFloat minimumSpacing;

/// Add another arranged subview to the stack view
- (void)addArrangedSubview:(UIView *)subview;

/// Remove a specific subview from the stack view
- (void)removeArrangedSubview:(UIView *)subview;

/// Insert a new subview at a specific index
- (void)insertArrangedSubview:(UIView *)subview atIndex:(NSInteger)index;

/// Resizes the view to fit around all of the subviews
- (void)sizeToFit;

@end

NS_ASSUME_NONNULL_END
