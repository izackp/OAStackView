//
//  OAStackView+Constraint.m
//  Pods
//
//  Created by Omar Abdelhafith on 14/06/2015.
//
//

#import "OAStackView+Constraint.h"

@implementation OAStackView (Constraint)

- (NSArray*)constraintsBetweenView:(UIView*)firstView andView:(UIView*)otherView
                            inAxis:(UILayoutConstraintAxis)axis includeReversed:(BOOL)includeReversed {
  NSMutableArray *arr = [@[] mutableCopy];
  
  for (NSLayoutConstraint *constraint in self.constraints) {
    BOOL viewMatches = (firstView == constraint.firstItem && otherView == constraint.secondItem);
    
    if (includeReversed) {
      viewMatches = viewMatches || (firstView == constraint.secondItem && otherView == constraint.firstItem);
    }
    
    BOOL isCorrectAxis = [self isConstraintAttribute:constraint.firstAttribute affectingAxis:axis] ||
    [self isConstraintAttribute:constraint.secondAttribute affectingAxis:axis];
    
    if (viewMatches && isCorrectAxis) {
      [arr addObject:constraint];
    }
  }
  
  return arr;
}

- (NSArray*)constraintsBetweenView:(UIView*)firstView andView:(UIView*)otherView inAxis:(UILayoutConstraintAxis)axis {
  return [self constraintsBetweenView:firstView andView:otherView inAxis:axis includeReversed:YES];
}

- (NSArray*)constraintsBetweenView:(UIView*)firstView andView:(UIView*)otherView {
  NSMutableArray *arr = [@[] mutableCopy];
  
  [arr addObjectsFromArray:[self constraintsBetweenView:firstView andView:otherView inAxis:UILayoutConstraintAxisVertical]];
  [arr addObjectsFromArray:[self constraintsBetweenView:firstView andView:otherView inAxis:UILayoutConstraintAxisHorizontal]];
  
  return arr;
}

- (NSArray*)constraintsAffectingView:(UIView*)view {
  NSMutableArray *arr = [@[] mutableCopy];
  [arr addObjectsFromArray:[self constraintsAffectingView:view inAxis:UILayoutConstraintAxisVertical]];
  [arr addObjectsFromArray:[self constraintsAffectingView:view inAxis:UILayoutConstraintAxisHorizontal]];
  return arr;
}

- (NSArray*)constraintsAffectingView:(UIView*)view inAxis:(UILayoutConstraintAxis)axis {
  NSMutableArray *arr = [@[] mutableCopy];
  
  for (NSLayoutConstraint *constraint in self.constraints) {
    BOOL viewMatches = (view == constraint.firstItem || view == constraint.secondItem);
    BOOL constraintAffectingAxis = [self isConstraint:constraint affectingAxis:axis];
    
    if (viewMatches && constraintAffectingAxis) {
      [arr addObject:constraint];
    }
  }
  
  return arr;
}

- (void)removeDecendentConstraints {
  for (NSInteger i = self.constraints.count - 1; i >= 0 ; i--) {
    NSLayoutConstraint *constraint = self.constraints[i];
    if ([self.subviews containsObject:constraint.firstItem] ||
        [self.subviews containsObject:constraint.secondItem]) {
      [self removeConstraint:constraint];
    }
  }
}

- (BOOL)isConstraint:(NSLayoutConstraint*)constraint affectingAxis:(UILayoutConstraintAxis)axis {
  return [self isConstraintAttribute:constraint.firstAttribute affectingAxis:axis] ||
  [self isConstraintAttribute:constraint.secondAttribute affectingAxis:axis];
}

- (BOOL)isConstraintAttribute:(NSLayoutAttribute)attribute affectingAxis:(UILayoutConstraintAxis)axis {
  switch (axis) {
    case UILayoutConstraintAxisHorizontal:
      return attribute == NSLayoutAttributeLeft || attribute == NSLayoutAttributeRight ||
      attribute == NSLayoutAttributeLeading || attribute == NSLayoutAttributeTrailing ||
      attribute == NSLayoutAttributeCenterX || attribute == NSLayoutAttributeWidth;
      break;
      
    case UILayoutConstraintAxisVertical:
      return attribute == NSLayoutAttributeTop || attribute == NSLayoutAttributeBottom ||
      attribute == NSLayoutAttributeCenterY || attribute == NSLayoutAttributeHeight;
      break;
      
    default:
      break;
  }
}

@end
