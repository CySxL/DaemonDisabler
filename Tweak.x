#import <Foundation/Foundation.h>
#import "NSTask.h"
#import <roothide.h>

NSDictionary *prefs;

%hook SpringBoard
-(void)applicationDidFinishLaunching:(bool)arg1{
	%orig();
	for(NSString *daemon in [prefs allKeys]){
		if([[prefs objectForKey:daemon] boolValue] == FALSE){
			NSDictionary *daemonPlist = [NSDictionary dictionaryWithContentsOfFile:daemon];
			NSString *service = [daemonPlist objectForKey:@"Label"];
			if(!service){
				NSArray *components = [[daemon lastPathComponent] componentsSeparatedByString:@"."];
				service = components[[components count]-2];
			}
			NSTask *task = [NSTask new];
			[task setLaunchPath:[NSString stringWithUTF8String:jbroot("/usr/libexec/launchctl_wrapper")]];
			[task setArguments:@[@"disable", service]];
			[task launch];
		}
	}
}
%end

%ctor{
	prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:jbroot("/var/mobile/Library/Preferences/com.level3tjg.daemondisabler.plist")]];
}
