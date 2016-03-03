//
//  XPurchasing.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/6/13.
//
//

#import "XPurchasing.h"
#import "XStoreObserver.h"

#define kMyFeatureIdentifierFree @"com.xio.35hints", @"com.xio.100hints", nil
#define kMyFeatureIdentifierPaid @"com.xio.25phints", @"com.xio.100phints", nil
@implementation XPurchasing

@synthesize delegate = mDelegate;
@synthesize arrayOfProducts=mArrayOfProducts;

- (void)dealloc {
    XSafeRelease(mArrayOfProducts);
    [super dealloc];
}

- (void)startPurchasing {
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData];
    } else {
        // Warn the user that purchases are disabled.
    }
}

#pragma mark Payment

- (void) requestProductData {
    DLog(@"---requestProductData");
    SKProductsRequest *request;
    if (IS_FREE_VERSION) {
        request = [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 [NSSet setWithObjects: kMyFeatureIdentifierFree]];
    }else{
        request = [[SKProductsRequest alloc] initWithProductIdentifiers:
                   [NSSet setWithObjects: kMyFeatureIdentifierPaid]];
    }

    request.delegate = self;
    [request start];
    
    [request release];
}


#pragma mark SKProductRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    DLog(@"---Response");
    NSArray *lMyProducts = response.products;
    NSArray *lInvalidProducts = response.invalidProductIdentifiers;
   
    XSafeRelease(mArrayOfProducts);
    if (lInvalidProducts.count > 0) {
        DLog(@"Invalid products: %@", lInvalidProducts);
        UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                              message:@"Invalid products"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [simpleAlert show];
        [simpleAlert release];
        
    } else if (lMyProducts.count > 0) {
        DLog(@"Valid products: %@", lMyProducts);
        mArrayOfProducts = [lMyProducts retain];
    } else {
        DLog(@"Unknown error while purchasing!");
    }
//    ///////////////////////////////////////////////////////////////////////////////////
//    if (mDelegate && [mDelegate respondsToSelector:@selector(becomeFree:)]) {       ///
//        [mDelegate performSelector:@selector(becomeFree:) withObject:self];         ///
//    }                                                                               ///
//    ///////////////////////////////////////////////////////////////////////////////////
}
- (void)callBecomeFreeMethod{
    DLog(@"---callBecomeFreeMethod");
    if (mDelegate && [mDelegate respondsToSelector:@selector(becomeFree:)]) {       ///
        [mDelegate performSelector:@selector(becomeFree:) withObject:self];         ///
    }
}
#pragma mark -After user chosen
- (void)productChosen:(NSInteger)pIndex{
    DLog(@"productChosen...%i",pIndex);
    if(pIndex<mArrayOfProducts.count){
        SKProduct *selectedProduct = [mArrayOfProducts objectAtIndex:pIndex];
        SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

#pragma mark -Singletone
static XPurchasing * sharedXPurchasing = NULL;
+(XPurchasing *)sharedXPurchasing{
    if (!sharedXPurchasing || sharedXPurchasing == NULL) {
		sharedXPurchasing = [XPurchasing new];
        XStoreObserver *lObserver = [XStoreObserver new];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:lObserver];
        
        
        
	}
	return sharedXPurchasing;
}

@end
