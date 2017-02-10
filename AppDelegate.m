#import "AppDelegate.h"

@interface AppDelegate () <NSApplicationDelegate>
@property (nonatomic, assign, readwrite) IBOutlet NSPanel *     panel;
@end

@implementation AppDelegate
@synthesize zfsStatus;

- (void)awakeFromNib
{
    self.panel.level=2147483631;
    NSLog(@"Checking ZFS");
    zfsStatus.stringValue = @"Checking ZFS";
    [NSTimer scheduledTimerWithTimeInterval:5.0f
    target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
}

- (void)updateStatus:(NSTimer *)timer
{
    NSString *pathToFile = @"/Users/alex/.zfsTest";
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

- (IBAction)simpleButtonPressed:(id)sender {
    [NSApp terminate:self];
}


- (void)applicationDidFinishLaunching:(NSNotification *)note
{
#pragma unused(note)
    
    assert(self.panel != nil);
    
    [self.panel setCanBecomeVisibleWithoutLogin:YES];
    [self.panel setHidesOnDeactivate:NO];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ForceOrderFront"]) {
        [self.panel orderFrontRegardless];
    } else {
        [self.panel orderFront:self];
        [self.panel orderFrontRegardless];
    }
    
    self.panel.level=2147483631;
    
    }

- (void)applicationWillTerminate:(NSNotification *)note
{
#pragma unused(note)
    NSLog(@"Quitting");

}

@end
