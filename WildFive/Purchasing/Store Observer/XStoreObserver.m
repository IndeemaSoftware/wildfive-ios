//
//  XStoreObserver.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/6/13.
//
//

#import "XStoreObserver.h"
#import "XCounter.h"

@interface XStoreObserver()
- (void)recordTransaction:(SKPaymentTransaction*)transaction;
- (void)restoreTransaction:(SKPaymentTransaction*)transaction;
- (void)completeTransaction:(SKPaymentTransaction*)transaction;
- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
@end

@implementation XStoreObserver

- (void)recordTransaction:(SKPaymentTransaction*)transaction {
    
}

- (void)restoreTransaction:(SKPaymentTransaction*)transaction {
    [self recordTransaction: transaction];
//    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)completeTransaction:(SKPaymentTransaction*)transaction {
    // Your application should implement these two methods.
    [self recordTransaction:transaction];
//    [self provideContent:transaction.payment.productIdentifier];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction*)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                DLog(@"****updatedTransactions");
                [[XCounter instance] addHints];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

@end
