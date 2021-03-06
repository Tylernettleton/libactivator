#import "libactivator.h"

#import <SpringBoard/SpringBoard.h>
#import <AppSupport/AppSupport.h>

// libactivator.m

@interface LAActivator ()

- (void)_loadPreferences;
- (void)_savePreferences;
- (void)_reloadPreferences;
- (id)_getObjectForPreference:(NSString *)preference;

- (NSDictionary *)_handleRemoteListenerMessage:(NSString *)message withUserInfo:(NSDictionary *)userInfo;
- (NSDictionary *)_handleRemoteMessage:(NSString *)message withUserInfo:(NSDictionary *)userInfo;
- (id)_performRemoteMessage:(SEL)selector withObject:(id)withObject;
- (NSDictionary *)_cachedAndSortedListeners;
- (void)_eventModeChanged;

@end

__attribute__((visibility("hidden")))
@interface LARemoteListener : NSObject<LAListener> {
}

+ (LARemoteListener *)sharedInstance;

@end

// Events.m

__attribute__((visibility("hidden")))
@interface LASlideGestureWindow : UIWindow {
@private
	BOOL hasSentSlideEvent;
	NSString *_eventName;
}

+ (LASlideGestureWindow *)leftWindow;
+ (LASlideGestureWindow *)middleWindow;
+ (LASlideGestureWindow *)rightWindow;
+ (void)updateVisibility;

- (id)initWithFrame:(CGRect)frame eventName:(NSString *)eventName;

- (void)updateVisibility;

@end

__attribute__((visibility("hidden")))
@interface LAVolumeTapWindow : UIWindow {
}

@end

__attribute__((visibility("hidden")))
@interface LAQuickDoDelegate : NSObject {
@private
	BOOL hasSentSlideEvent;
}

+ (id)sharedInstance;

- (void)acceptEventsFromControl:(UIControl *)control;

@end

__attribute__((visibility("hidden")))
BOOL shouldAddNowPlayingButton;

__attribute__((visibility("hidden")))
@interface LAApplicationListener : NSObject<LAListener> {
}

+ (LAApplicationListener *)sharedInstance;
- (BOOL)activateApplication:(SBApplication *)application;

@end

@interface NSObject(LAListener)
- (void)activator:(LAActivator *)activator didChangeToEventMode:(NSString *)eventMode;

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName;
- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event forListenerName:(NSString *)listenerName;
- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event forListenerName:(NSString *)listenerName;
- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event forListenerName:(NSString *)listenerName;

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName;
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName;
- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName;
- (NSNumber *)activator:(LAActivator *)activator requiresRequiresAssignmentForListenerName:(NSString *)name;
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)name;
- (NSData *)activator:(LAActivator *)activator requiresIconDataForListenerName:(NSString *)listenerName;
- (NSData *)activator:(LAActivator *)activator requiresSmallIconDataForListenerName:(NSString *)listenerName;
- (NSNumber *)activator:(LAActivator *)activator requiresIsCompatibleWithEventName:(NSString *)eventName listenerName:(NSString *)listenerName;
- (id)activator:(LAActivator *)activator requiresInfoDictionaryValueOfKey:(NSString *)key forListenerWithName:(NSString *)listenerName;

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event;
- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event;
- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event;
- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event;
@end

__attribute__((visibility("hidden")))
NSMutableDictionary *listenerData;
__attribute__((visibility("hidden")))
NSBundle *activatorBundle;

#define Localize(bundle, key, value_) ({ \
	NSBundle *_bundle = (bundle); \
	NSString *_key = (key); \
	NSString *_value = (value_); \
	(_bundle) ? [_bundle localizedStringForKey:_key value:_value table:nil] : _value; \
})
