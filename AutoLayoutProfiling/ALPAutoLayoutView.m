//
// Created by Florian on 18.04.13.
//


#import "ALPAutoLayoutView.h"
#import "UIView+Helpers.h"


@implementation ALPAutoLayoutView {
    ALPLayoutType type;
    NSUInteger viewCount;
	NSMutableArray *centerXConstraints;
	id previousView;
}

- (id)initWithFrame:(CGRect)frame type:(ALPLayoutType)aType viewCount:(NSUInteger)aViewCount {
    self = [super initWithFrame:frame];
    if (self) {
        type = aType;
        viewCount = aViewCount;
		centerXConstraints = [NSMutableArray array];
        [self setup];
    }
    return self;
}

- (void)setup {
    if (type == ALPLayoutTypeIndependent) {
        [self setupIndependentLayout];
    } else if (type == ALPLayoutTypeChained) {
        [self setupChainedLayout];
    } else if (type == ALPLayoutTypeNested) {
        [self setupNestedLayout];
    }
}

- (void)setupNestedLayout {
    previousView = self;
    for (NSUInteger i = 0; i < viewCount; i++) {
        UIView* view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [previousView addSubview:view];
		NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [centerXConstraints addObject:xConstraint];
		[previousView addConstraint:xConstraint];
        [previousView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [previousView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [previousView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeHeight multiplier:1 constant:-1]];
        view.backgroundColor = [self randomColor];
        previousView = view;
    }
	[self layoutIfNeeded];
}

- (void)setupChainedLayout {
    previousView = self;
    for (NSUInteger i = 0; i < viewCount; i++) {
        UIView* view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
		NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [centerXConstraints addObject:xConstraint];
		[self addConstraint:xConstraint];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeTop multiplier:1 constant:1]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
        view.backgroundColor = [self randomColor];
        previousView = view;
    }
	[self layoutIfNeeded];
}

- (void)setupIndependentLayout {
    for (NSUInteger i = 0; i < viewCount; i++) {
        UIView* view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        CGFloat x = [self randomNumber] * 2;
        CGFloat y = [self randomNumber] * 2;
		NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:x constant:0];
        [centerXConstraints addObject:xConstraint];
		[self addConstraint:xConstraint];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:y constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
        view.backgroundColor = [self randomColor];
    }
	[self layoutIfNeeded];
}

- (void)moveViews {
	for (NSLayoutConstraint *constraint in centerXConstraints) {
		[constraint setConstant:(constraint.constant + 10)];
	}
	[self layoutIfNeeded];
}

- (void)add10Views {
	if (type == ALPLayoutTypeIndependent) {
        [self addIndependentViews];
    } else if (type == ALPLayoutTypeNested) {
        [self addNestedViews];
    }
}

- (void)addIndependentViews {
	for (NSUInteger i = 0; i < 10; i++) {
        UIView* view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        CGFloat x = [self randomNumber] * 2;
        CGFloat y = [self randomNumber] * 2;
		NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:x constant:0];
        [centerXConstraints addObject:xConstraint];
		[self addConstraint:xConstraint];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:y constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
        view.backgroundColor = [self randomColor];
    }
	[self layoutIfNeeded];
}

- (void)addNestedViews {
    for (NSUInteger i = 0; i < 10; i++) {
        UIView* view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [previousView addSubview:view];
		NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [centerXConstraints addObject:xConstraint];
		[previousView addConstraint:xConstraint];
        [previousView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [previousView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [previousView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeHeight multiplier:1 constant:-1]];
        view.backgroundColor = [self randomColor];
        previousView = view;
    }
	[self layoutIfNeeded];
}

@end