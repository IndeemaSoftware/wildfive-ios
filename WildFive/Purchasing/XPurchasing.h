//
//  XPurchasing.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/6/13.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class XPurchasing;

@protocol XPurchasingDelegate <NSObject>

- (void)becomeFree:(XPurchasing*)object;

@end

@interface XPurchasing : NSObject <SKProductsRequestDelegate> {
    NSArray *mArrayOfProducts;

    id <XPurchasingDelegate> mDelegate;
}
@property (nonatomic, assign) id <XPurchasingDelegate> delegate;
@property (nonatomic, readonly) NSArray *arrayOfProducts;
- (void)callBecomeFreeMethod;
- (void)startPurchasing;
- (void)productChosen:(NSInteger) pIndex;

+(XPurchasing *)sharedXPurchasing;
@end
