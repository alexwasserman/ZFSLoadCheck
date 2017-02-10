#import <Foundation/Foundation.h>

@interface LogManager : NSObject

+ (LogManager *)sharedManager;

- (void)logWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

@end
