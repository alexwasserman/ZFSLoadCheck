#import "LogManager.h"

#include <asl.h>

@interface ASLLogManager : LogManager

@end

@implementation ASLLogManager {
    aslclient       _client;
    aslmsg          _messageTemplate;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self->_client = asl_open(NULL, "PreLoginAgents", 0);
        assert(self->_client != NULL);
        
        (void) asl_set_filter(self->_client, ASL_FILTER_MASK_UPTO(ASL_LEVEL_INFO));
        
        self->_messageTemplate = asl_new(ASL_TYPE_MSG);
        assert(self->_messageTemplate != NULL);
        
        // If you set state in the message template here then it'll be included in all 
        // messages logged.
    }
    return self;
}

- (void)dealloc
{
    if (self->_messageTemplate != NULL) {
        asl_free(self->_messageTemplate);
    }
    if (self->_client != NULL) {
        asl_close(self->_client);
    }
}

- (void)logWithFormat:(NSString *)format, ...
{
    va_list     ap;
    NSString *  str;
    
    va_start(ap, format);
    str = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);

    (void) asl_log(self->_client, self->_messageTemplate, ASL_LEVEL_INFO, "%s", [str UTF8String]);
}

@end

@interface NSLogManager : LogManager

- (void)logWithFormat:(NSString *)format, ...;

@end

@implementation NSLogManager

- (void)logWithFormat:(NSString *)format, ...;
{
    va_list     ap;
    
    va_start(ap, format);
    NSLogv(format, ap);
    va_end(ap);
}

@end

@implementation LogManager

+ (LogManager *)sharedManager
{
    static dispatch_once_t  sOnceToken;
    static LogManager *     sLogManager;
    
    dispatch_once(&sOnceToken, ^{
        // Change the following to log via ASL (the default) or NSLog.
        if (YES) {
            sLogManager = [[ASLLogManager alloc] init];
        } else {
            sLogManager = [[NSLogManager alloc] init];
        }
    });
    return sLogManager;
}

- (void)logWithFormat:(NSString *)format, ...
{
    #pragma unused(format)
    assert(NO);
}

@end
