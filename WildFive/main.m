

//  main.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/2/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAppDelegate.h"
#import "XApplication.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, NSStringFromClass([XApplication class]), NSStringFromClass([XAppDelegate class]));
    [pool release];
    return retVal;
}
