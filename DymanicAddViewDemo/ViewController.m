//
//  ViewController.m
//  DymanicAddViewDemo
//
//  Created by 郑辉 on 2019/5/6.
//  Copyright © 2019 郑辉. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize scrollView;
@synthesize stackView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, rect.size.width, rect.size.height - 50)];
    [self.view addSubview:scrollView];
    
    // add stack view
    self.stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 10;
    stackView.translatesAutoresizingMaskIntoConstraints = false;

    [scrollView addSubview:stackView];
    
    
//    [stackView.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor].active = true;
//    [stackView.topAnchor constraintGreaterThanOrEqualToAnchor:scrollView.topAnchor constant:30].active = true;
    
    [self logToView:stackView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.stackView.frame.size.width, self.stackView.frame.size.height);
}

- (void) logToView:(UIStackView *)stackView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 50; i ++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"dispatch to main with %d", i);
            dispatch_async(dispatch_get_main_queue(), ^ {
                NSString *toUI = [NSString stringWithFormat:@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -> %d", i];
                UILabel *label = [[UILabel alloc] init];
                CGSize maxLableSize = CGSizeMake(296, FLT_MAX);
                CGSize expectedSize = [toUI sizeWithFont:label.font constrainedToSize:maxLableSize lineBreakMode:label.lineBreakMode];
                CGRect newFrame = label.frame;
                newFrame.size.height = expectedSize.height;
                label.frame = newFrame;
                label.text = toUI;
                [stackView addArrangedSubview:label];
            });
        }
    });
}

@end
