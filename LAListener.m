#import "libactivator-private.h"

#import <CoreFoundation/CoreFoundation.h>

@implementation NSObject(LAListener)
- (void)activator:(LAActivator *)activator didChangeToEventMode:(NSString *)eventMode
{
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName
{
	[self activator:activator receiveEvent:event];
}
- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event forListenerName:(NSString *)listenerName
{
	[self activator:activator abortEvent:event];
}
- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event forListenerName:(NSString *)listenerName
{
	[self activator:activator otherListenerDidHandleEvent:event];
}
- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event forListenerName:(NSString *)listenerName
{
	[self activator:activator receiveDeactivateEvent:event];
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName
{
	NSBundle *bundle = [listenerData objectForKey:listenerName];
	NSString *unlocalized = [bundle objectForInfoDictionaryKey:@"title"] ?: listenerName;
	return Localize(activatorBundle, [@"LISTENER_TITLE_" stringByAppendingString:listenerName], Localize(bundle, unlocalized, unlocalized) ?: listenerName);
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName
{
	NSBundle *bundle = [listenerData objectForKey:listenerName];
	NSString *unlocalized = [bundle objectForInfoDictionaryKey:@"description"];
	if (unlocalized)
		return Localize(activatorBundle, [@"LISTENER_DESCRIPTION_" stringByAppendingString:listenerName], Localize(bundle, unlocalized, unlocalized));
	NSString *key = [@"LISTENER_DESCRIPTION_" stringByAppendingString:listenerName];
	NSString *result = Localize(activatorBundle, key, nil);
	return [result isEqualToString:key] ? nil : result;
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName
{
	NSBundle *bundle = [listenerData objectForKey:listenerName];
	NSString *unlocalized = [bundle objectForInfoDictionaryKey:@"group"] ?: @"";
	if ([unlocalized length] == 0)
		return @"";
	return Localize(activatorBundle, [@"LISTENER_GROUP_TITLE_" stringByAppendingString:unlocalized], Localize(bundle, unlocalized, unlocalized));
}
- (NSNumber *)activator:(LAActivator *)activator requiresRequiresAssignmentForListenerName:(NSString *)name
{
	return [[listenerData objectForKey:name] objectForInfoDictionaryKey:@"requires-event"];
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)name
{
	return [[listenerData objectForKey:name] objectForInfoDictionaryKey:@"compatible-modes"];
}
- (NSData *)activator:(LAActivator *)activator requiresIconDataForListenerName:(NSString *)listenerName
{
	NSBundle *bundle = [listenerData objectForKey:listenerName];
	return [NSData dataWithContentsOfFile:[bundle pathForResource:@"icon" ofType:@"png"]]
		?: [NSData dataWithContentsOfFile:[bundle pathForResource:@"Icon" ofType:@"png"]];
}
- (NSData *)activator:(LAActivator *)activator requiresSmallIconDataForListenerName:(NSString *)listenerName
{
	NSBundle *bundle = [listenerData objectForKey:listenerName];
	return [NSData dataWithContentsOfFile:[bundle pathForResource:@"icon-small" ofType:@"png"]]
		?: [NSData dataWithContentsOfFile:[bundle pathForResource:@"Icon-small" ofType:@"png"]];
}
- (NSNumber *)activator:(LAActivator *)activator requiresIsCompatibleWithEventName:(NSString *)eventName listenerName:(NSString *)listenerName
{
	return [[[listenerData objectForKey:listenerName] objectForInfoDictionaryKey:@"incompatible-events"] containsObject:eventName]
		? (NSNumber *)kCFBooleanFalse
		: (NSNumber *)kCFBooleanTrue;
}
- (id)activator:(LAActivator *)activator requiresInfoDictionaryValueOfKey:(NSString *)key forListenerWithName:(NSString *)listenerName
{
	if ([key isEqualToString:@"title"])
		return [self activator:activator requiresLocalizedTitleForListenerName:listenerName];
	if ([key isEqualToString:@"description"])
		return [self activator:activator requiresLocalizedDescriptionForListenerName:listenerName];
	if ([key isEqualToString:@"group"])
		return [self activator:activator requiresLocalizedGroupForListenerName:listenerName];
	if ([key isEqualToString:@"requires-event"])
		return [self activator:activator requiresRequiresAssignmentForListenerName:listenerName];
	if ([key isEqualToString:@"compatible-modes"])
		return [self activator:activator requiresCompatibleEventModesForListenerWithName:listenerName];
	return [[listenerData objectForKey:listenerName] objectForInfoDictionaryKey:key];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
}
- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event
{
}
- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event
{
}
- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event
{
}
@end
