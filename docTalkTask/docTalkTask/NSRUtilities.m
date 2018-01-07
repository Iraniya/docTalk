//
//  NSRUtilities.m
//  docTalkTask
//
//  Created by Iraniya Naynesh on 06/01/18.
//  Copyright © 2018 iraniya. All rights reserved.
//

#import "NSRUtilities.h"

@implementation NSRUtilities

+ (BOOL)isNilOREmptyString:(NSString*)string{
    if (![string isEqual:[NSNull null]] &&
        ![string isEqual:@"(null)"] &&
        ![string isEqual:@"<null>"] &&
        string != nil &&
        ![string isEqual:@""]) {
        return NO;
    }
    return YES;
}


@end
