//
//  ViewController.m
//  TOStackViewExample
//
//  Created by Tim Oliver on 28/8/21.
//

#import "ViewController.h"
#import "TOStackView.h"

@interface ViewController ()

@property (nonatomic, strong) TOStackView *stackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create 5 buttons we can test with
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setImage:[UIImage systemImageNamed:@"chevron.backward"] forState:UIControlStateNormal];
    [backButton sizeToFit];

    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [forwardButton setImage:[UIImage systemImageNamed:@"chevron.forward"] forState:UIControlStateNormal];
    [forwardButton sizeToFit];

    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [shareButton setImage:[UIImage systemImageNamed:@"square.and.arrow.up"] forState:UIControlStateNormal];
    [shareButton sizeToFit];

    UIButton *bookmarksButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [bookmarksButton setImage:[UIImage systemImageNamed:@"book"] forState:UIControlStateNormal];
    [bookmarksButton sizeToFit];

    UIButton *tabsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [tabsButton setImage:[UIImage systemImageNamed:@"square.on.square"] forState:UIControlStateNormal];
    [tabsButton sizeToFit];

    self.stackView = [[TOStackView alloc] initWithArrangedSubviews:@[backButton, forwardButton,
                                                                     shareButton, bookmarksButton, tabsButton]];

    self.stackView.backgroundColor = [UIColor redColor];

    [self.view addSubview:self.stackView];
}

- (void)viewWillLayoutSubviews
{
    // Size the stack view around the content
    [self.stackView sizeToFit];

    // Stretch the stack view to the window's size
    UIEdgeInsets margins = self.view.layoutMargins;
    CGRect frame = self.view.bounds;
    frame.origin.x = margins.left;
    frame.size.width -= (margins.left + margins.right);
    frame.size.height = self.stackView.frame.size.height;
    self.stackView.frame = frame;

    self.stackView.center = self.view.center;
}

@end
