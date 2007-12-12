/*
 * NSString+CarbonUtilities.m category
 *
 * Created by Nathan Day on Sat Aug 03 2002.
 * Copyright (c) 2002 Nathan Day. All rights reserved.
 */

#import "NSString+CarbonUtilities.h"

@implementation NSString (CarbonUtilitiesPaths)

//+ (NSString *)stringWithFSRef:(const FSRef *)aFSRef
// {
//	UInt8			thePath[PATH_MAX + 1]; 		// plus 1 for \0 terminator
//
//	return (FSRefMakePath ( aFSRef, thePath, PATH_MAX ) == noErr) ? [NSString stringWithUTF8String:(const char *)thePath] : nil;
//}

- (BOOL)getFSRef:(FSRef *)aFSRef { return FSPathMakeRef( [self UTF8String] , aFSRef, NULL ) == noErr; }

- (BOOL)getFSSpec:(FSSpec *)aFSSpec {
	FSRef aFSRef;
	return [self getFSRef:&aFSRef] && (FSGetCatalogInfo( &aFSRef, kFSCatInfoNone, NULL, NULL, aFSSpec, NULL ) == noErr);
}

- (NSString *)fileSystemPathHFSStyle {
	return [(NSString *)CFURLCopyFileSystemPath((CFURLRef)[NSURL fileURLWithPath:self], kCFURLHFSPathStyle) autorelease];
}

- (NSString *)pathFromFileSystemPathHFSStyle {
	return [[(NSURL *)CFURLCreateWithFileSystemPath( kCFAllocatorDefault, (CFStringRef)self, kCFURLHFSPathStyle, [self hasSuffix:@":"] ) autorelease] path];
}

- (NSString *)resolveAliasFile {
	FSRef			theRef;
	Boolean		theIsTargetFolder,
					theWasAliased;
	NSString		* theResolvedAlias = nil; ;

	[self getFSRef:&theRef];

	if ( (FSResolveAliasFile ( &theRef, YES, &theIsTargetFolder, &theWasAliased ) == noErr) ) {
		theResolvedAlias = (theWasAliased) ? [NSString stringWithFSRef:&theRef] : self;
	}

	return theResolvedAlias ? theResolvedAlias : self;
}

+ (NSString *)stringWithPascalString:(ConstStr255Param )aPStr {
	return (NSString*)CFStringCreateWithPascalString( kCFAllocatorDefault, aPStr, kCFStringEncodingMacRomanLatin1 );
}

- (BOOL)pascalString:(StringPtr)aBuffer length:(short)aLength {
	return CFStringGetPascalString( (CFStringRef) self, aBuffer, aLength, kCFStringEncodingMacRomanLatin1) != 0;
}

//- (NSString *)trimWhitespace {
//	CFMutableStringRef 		theString;
//
//	theString = CFStringCreateMutableCopy( kCFAllocatorDefault, 0, (CFStringRef) self);
//	CFStringTrimWhitespace( theString );
//
//	return (NSMutableString *)theString;
//}

@end




