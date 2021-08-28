//
//  TOStackView.h
//  TOStackViewExample
//
//  Created by Tim Oliver on 28/8/21.
//

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
