/*
 * Copyright (c) 2012 Eloy Durán <eloy.de.enige@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "XcodeProjectConstants.h"

NSString * const PBXFileTypeStaticLibraryArchive = @"archive.ar";
NSString * const PBXFileTypeCompiledApplication = @"wrapper.application";
NSString * const PBXFileTypeCompiledDynamicLibrary = @"compiled.mach-o.dylib";
NSString * const PBXFileTypeCompiledFramework = @"wrapper.framework";
NSString * const PBXFileTypeLoadableBundle = @"wrapper.plug-in";
NSString * const PBXFileTypeCFamilyHeader = @"sourcecode.c.h";
NSString * const PBXFileTypeObjectiveCSource = @"sourcecode.c.objc";
NSString * const PBXFileTypeXcodeConfiguration = @"text.xcconfig";
NSString * const PBXFileTypeCoreDataModel = @"wrapper.xcdatamodel";
NSString * const PBXFileTypeXIB = @"file.xib";
NSString * const PBXFileTypeShellScript = @"text.script.sh";
NSString * const PBXFileTypeXMLPropertyList = @"text.plist.xml";
NSString * const PBXFileTypePlainText = @"text";
NSString * const PBXFileTypeAssetCatalog = @"folder.assetcatalog";
NSString * const PBXAnyBuildConfiguration = @"$(ANY)";
NSString * const PBXDebugBuildConfiguration = @"Debug";
NSString * const PBXReleaseBuildConfiguration = @"Release";

NSString * PBXGetProductTypeUTI(PBXProductType type) {
    if (type == PBXProductTypeApplication) return @"com.apple.product-type.application";
    else if (type == PBXProductTypeFramework) return @"com.apple.product-type.framework";
    else if (type == PBXProductTypeDynamicLibrary) return @"com.apple.product-type.library.dynamic";
    else if (type == PBXProductTypeStaticLibrary) return @"com.apple.product-type.library.static";
    else if (type == PBXProductTypeBundle) return @"com.apple.product-type.bundle";
    
    [NSException raise:NSInvalidArgumentException format:@"Invalid PBXProductType %ld", type];
    return nil;
}

NSString * PBXGetProductTypePathExtension(PBXProductType type) {
    if (type == PBXProductTypeApplication) return @"app";
    else if (type == PBXProductTypeFramework) return @"framework";
    else if (type == PBXProductTypeDynamicLibrary) return @"dylib";
    else if (type == PBXProductTypeStaticLibrary) return @"a";
    else if (type == PBXProductTypeBundle) return @"bundle";
    
    [NSException raise:NSInvalidArgumentException format:@"Invalid PBXProductType %ld", type];
    return nil;
}

NSInteger PBXGetCopyFileDestinationNumericValue(PBXCopyFileDestination dest) {
    if (dest == PBXCopyFileDestinationAbsolutePath) return 0;
    else if (dest == PBXCopyFileDestinationProductsDirectory) return 16;
    else if (dest == PBXCopyFileDestinationWrapper) return 1;
    else if (dest == PBXCopyFileDestinationBundleResourcesDirectory) return 7;
    else if (dest == PBXCopyFileDestinationBundleExecutablesDirectory) return 6;
    else if (dest == PBXCopyFileDestinationBundleJavaResourcesDirectory) return 15;
    else if (dest == PBXCopyFileDestinationBundleFrameworksDirectory) return 10;
    else if (dest == PBXCopyFileDestinationBundleSharedFrameworksDirectory) return 11;
    else if (dest == PBXCopyFileDestinationBundleSharedSupportDirectory) return 12;
    else if (dest == PBXCopyFileDestinationBundlePlugInsDirectory) return 13;
    
    [NSException raise:NSInvalidArgumentException format:@"Unrecognized PBXCopyFileDestination %ld", dest];
    return -1;
}

NSString * PBXFileTypeForPathExtension(NSString *extension) {
    NSString *fixedExtension = extension;
    if ([fixedExtension hasPrefix:@"."]) fixedExtension = [fixedExtension substringFromIndex:1];
    
    if ([fixedExtension isEqualToString:@"a"]) return PBXFileTypeStaticLibraryArchive;
    else if ([fixedExtension isEqualToString:@"app"]) return PBXFileTypeCompiledApplication;
    else if ([fixedExtension isEqualToString:@"framework"]) return PBXFileTypeCompiledFramework;
    else if ([fixedExtension isEqualToString:@"dylib"]) return PBXFileTypeCompiledDynamicLibrary;
    else if ([fixedExtension isEqualToString:@"bundle"]) return PBXFileTypeLoadableBundle;
    else if ([fixedExtension isEqualToString:@"h"] || [fixedExtension isEqualToString:@"pch"]) return PBXFileTypeCFamilyHeader;
    else if ([fixedExtension isEqualToString:@"m"]) return PBXFileTypeObjectiveCSource;
    else if ([fixedExtension isEqualToString:@"xcconfig"]) return PBXFileTypeXcodeConfiguration;
    else if ([fixedExtension isEqualToString:@"xcdatamodel"]) return PBXFileTypeCoreDataModel;
    else if ([fixedExtension isEqualToString:@"xib"]) return PBXFileTypeXIB;
    else if ([fixedExtension isEqualToString:@"sh"]) return PBXFileTypeShellScript;
    else if ([fixedExtension isEqualToString:@"plist"]) return PBXFileTypeXMLPropertyList;
    else if ([fixedExtension isEqualToString:@"md"] || [fixedExtension isEqualToString:@"markdown"]) return PBXFileTypePlainText;
    else if ([fixedExtension isEqualToString:@"xcassets"]) return PBXFileTypeAssetCatalog;
    
#if DEBUG
    NSLog(@"Could not map path extension .%@ to an Xcode file type", fixedExtension);
#endif
    
    return nil;
}

NSDictionary * PBXGetCommonBuildSettings(NSString *buildConfiguration, PBXPlatform platform) {
    NSDictionary * const globalBuildSettings = @{ @"GCC_VERSION": @"com.apple.compilers.llvm.clang.1_0", @"GCC_PRECOMPILE_PREFIX_HEADER": @"YES",
                                                  @"PRODUCT_NAME": @"$(TARGET_NAME)", @"SKIP_INSTALL": @"YES", @"DSTROOT": @"/tmp/$(TARGET_NAME).dst",
                                                  @"ALWAYS_SEARCH_USER_PATHS": @"NO", @"GCC_C_LANGUAGE_STANDARD": @"gnu99", @"INSTALL_PATH": @"$(BUILT_PRODUCTS_DIR)",
                                                  @"OTHER_LDFLAGS": @"", @"COPY_PHASE_STRIP": @"YES" };
    
    NSDictionary * const debugCommonBuildSettings = @{ @"GCC_DYNAMIC_NO_PIC": @"YES", @"GCC_PREPROCESSOR_DEFINITIONS": @[ @"DEBUG=1", @"$(inherited)" ],
                                                      @"GCC_SYMBOLS_PRIVATE_EXTERN": @"NO", @"GCC_OPTIMIZATION_LEVEL": @"0", @"COPY_PHASE_STRIP": @"NO" };
    
    NSDictionary * const releaseCommonBuildSettings = @{ @"GCC_PREPROCESSOR_DEFINITIONS": @[ @"NS_BLOCK_ASSERTIONS=1" ], };
    NSDictionary * const iOSCommonBuildSettings = @{ @"IPHONEOS_DEPLOYMENT_TARGET": @"4.3", @"PUBLIC_HEADERS_FOLDER_PATH": @"$(TARGET_NAME)", @"SDKROOT": @"iphoneos" };
    NSDictionary * const macCommonBuildSettings = @{ @"GCC_ENABLE_OBJC_EXCEPTIONS": @"YES", @"GCC_VERSION": @"com.apple.compilers.llvm.clang.1_0", @"MACOSX_DEPLOYMENT_TARGET": @"10.7", @"SDKROOT": @"macosx", @"COMBINE_HIDPI_IMAGES": @"YES" };
    NSDictionary * const macDebugBuildSettings = @{ /* empty? */ };
    NSDictionary * const macReleaseBuildSettings = @{ @"DEBUG_INFORMATION_FORMAT": @"dwarf-with-dsym" };
    NSDictionary * const iOSDebugBuildSettings = @{ /* empty? */ };
    NSDictionary * const iOSReleaseBuildSettings = @{ @"VALIDATE_PRODUCT": @"YES" };
    
    NSMutableDictionary *effectiveSettings = [NSMutableDictionary dictionary];
    [effectiveSettings addEntriesFromDictionary:globalBuildSettings];
    
    if ([buildConfiguration isEqualToString:PBXDebugBuildConfiguration]) {
        [effectiveSettings addEntriesFromDictionary:debugCommonBuildSettings];
    } else if ([buildConfiguration isEqualToString:PBXReleaseBuildConfiguration]) {
        [effectiveSettings addEntriesFromDictionary:releaseCommonBuildSettings];
    }
    
    if (platform == PBXPlatformIOS) {
        [effectiveSettings addEntriesFromDictionary:iOSCommonBuildSettings];
        
        if ([buildConfiguration isEqualToString:PBXDebugBuildConfiguration]) [effectiveSettings addEntriesFromDictionary:iOSDebugBuildSettings];
        else if ([buildConfiguration isEqualToString:PBXReleaseBuildConfiguration]) [effectiveSettings addEntriesFromDictionary:iOSReleaseBuildSettings];
    } else if (platform == PBXPlatformMac) {
        [effectiveSettings addEntriesFromDictionary:macCommonBuildSettings];
        
        if ([buildConfiguration isEqualToString:PBXDebugBuildConfiguration]) [effectiveSettings addEntriesFromDictionary:macDebugBuildSettings];
        else if ([buildConfiguration isEqualToString:PBXReleaseBuildConfiguration]) [effectiveSettings addEntriesFromDictionary:macReleaseBuildSettings];
    }
    
    return effectiveSettings;
}

NSDictionary * PBXGetDefaultBuildSettingsForConfiguration(NSString *buildConfiguration) {
    if ([buildConfiguration isEqualToString:PBXAnyBuildConfiguration]) {
        return @{ @"ALWAYS_SEARCH_USER_PATHS": @"NO", @"CLANG_CXX_LANGUAGE_STANDARD": @"gnu++0x", @"CLANG_CXX_LIBRARY": @"libc++",
                  @"CLANG_ENABLE_OBJC_ARC": @"YES", @"CLANG_WARN_BOOL_CONVERSION": @"YES", @"CLANG_WARN_CONSTANT_CONVERSION": @"YES",
                  @"CLANG_WARN_DIRECT_OBJC_ISA_USAGE": @"YES", @"CLANG_WARN_EMPTY_BODY": @"YES", @"CLANG_WARN_ENUM_CONVERSION": @"YES",
                  @"CLANG_WARN_INT_CONVERSION": @"YES", @"CLANG_WARN_OBJC_ROOT_CLASS": @"YES", @"CLANG_ENABLE_MODULES": @"YES",
                  @"GCC_C_LANGUAGE_STANDARD": @"gnu99", @"GCC_WARN_64_TO_32_BIT_CONVERSION": @"YES", @"GCC_WARN_ABOUT_RETURN_TYPE": @"YES",
                  @"GCC_WARN_UNDECLARED_SELECTOR": @"YES", @"GCC_WARN_UNINITIALIZED_AUTOS": @"YES", @"GCC_WARN_UNUSED_FUNCTION": @"YES",
                  @"GCC_WARN_UNUSED_VARIABLE": @"YES" };
    } else if ([buildConfiguration isEqualToString:PBXDebugBuildConfiguration]) {
        return @{ @"ONLY_ACTIVE_ARCH": @"YES", @"COPY_PHASE_STRIP": @"YES", @"GCC_DYNAMIC_NO_PIC": @"NO", @"GCC_OPTIMIZATION_LEVEL": @"0",
                  @"GCC_PREPROCESSOR_DEFINITIONS": @[ @"DEBUG=1", @"$(inherited)" ], @"GCC_SYMBOLS_PRIVATE_EXTERN": @"YES" };
    } else if ([buildConfiguration isEqualToString:PBXReleaseBuildConfiguration]) {
        return @{ @"COPY_PHASE_STRIP": @"NO", @"ENABLE_NS_ASSERTIONS": @"NO", @"VALIDATE_PRODUCT": @"YES" };
    } else {
        return [NSDictionary dictionary];
    }
}
