#import "AppDelegate.h"
#import "LogManager.h"

@interface AppDelegate () <NSApplicationDelegate>

@property (nonatomic, assign, readwrite) IBOutlet NSPanel *     panel;
@property (retain) IBOutlet NSTextField *zfsStatus;

@end

@implementation AppDelegate
@synthesize zfsStatus;

- (void)awakeFromNib
{
    NSLog(@"Checking ZFS");
    zfsStatus.stringValue = @"Checking ZFS";
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
}

- (void)updateStatus:(NSTimer *)timer
{
    NSString *pathToFile = @"/Users/.zfsloadcheck";
    BOOL isDir = NO;
    BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:pathToFile isDirectory:&isDir];
    
    if(isFile)
    {
        NSLog(@"ZFS Mounted");
        zfsStatus.stringValue = @"ZFS Mounted";
    }
    else
    {
        NSLog(@"ZFS NOT Mounted");
        zfsStatus.stringValue = @"ZFS Not Mounted!";
    }
}


- (void)applicationDidFinishLaunching:(NSNotification *)note
{
    #pragma unused(note)
    
    [[LogManager sharedManager] logWithFormat:@"Did finish launching begin"];

    assert(self.panel != nil);

    // We have to call -[NSWindow setCanBecomeVisibleWithoutLogin:] to let the 
    // system know that we're not accidentally trying to display a window 
    // pre-login.
    
    [self.panel setCanBecomeVisibleWithoutLogin:YES];
    
    // Our application is a UI element which never activates, so we want our 
    // panel to show regardless.
    
    [self.panel setHidesOnDeactivate:NO];

    // Due to a problem with the relationship between the UI frameworks and the 
    // window server <rdar://problem/5136400>, -[NSWindow orderFront:] is not 
    // sufficient to show the window.  We have to use -[NSWindow orderFrontRegardless].

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ForceOrderFront"]) {
        [[LogManager sharedManager] logWithFormat:@"Showing window with extreme prejudice"];
        [self.panel orderFrontRegardless];
    } else {
        [[LogManager sharedManager] logWithFormat:@"Showing window normally"];
        [self.panel orderFront:self];
    }

    [[LogManager sharedManager] logWithFormat:@"Did finish launching end"];
}

- (void)applicationWillTerminate:(NSNotification *)note
{
    #pragma unused(note)
    [[LogManager sharedManager] logWithFormat:@"Will terminate"];
}

@end
