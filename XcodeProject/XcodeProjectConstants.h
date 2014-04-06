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

#import <Foundation/Foundation.h>

#define PBXLatestIOSSDKVersion @"7.1"
#define PBXLatestOSXSDKVersion @"10.9"
#define PBXLatestXcodeUpgradeCheckVersionString @"0510"
#define PBXLatestArchiveVersion @1
#define PBXLatestObjectVersion @46

#pragma mark -
#pragma mark Product Types

typedef NS_ENUM(NSInteger, PBXProductType) {
    PBXProductTypeApplication,
    PBXProductTypeFramework,
    PBXProductTypeDynamicLibrary,
    PBXProductTypeStaticLibrary,
    PBXProductTypeBundle
};

extern NSString * PBXGetProductTypeUTI(PBXProductType type);
extern NSString * PBXGetProductTypePathExtension(PBXProductType type);

#pragma mark File Types

extern NSString * const PBXFileTypeStaticLibraryArchive;
extern NSString * const PBXFileTypeCompiledApplication;
extern NSString * const PBXFileTypeCompiledDynamicLibrary;
extern NSString * const PBXFileTypeCompiledFramework;
extern NSString * const PBXFileTypeLoadableBundle;
extern NSString * const PBXFileTypeCFamilyHeader;
extern NSString * const PBXFileTypeObjectiveCSource;
extern NSString * const PBXFileTypeXcodeConfiguration;
extern NSString * const PBXFileTypeCoreDataModel;
extern NSString * const PBXFileTypeXIB;
extern NSString * const PBXFileTypeShellScript;
extern NSString * const PBXFileTypeXMLPropertyList;
extern NSString * const PBXFileTypePlainText;
extern NSString * const PBXFileTypeAssetCatalog;

extern NSString * PBXFileTypeForPathExtension(NSString *extension);

#pragma mark Copy Files Destinations

typedef NS_ENUM(NSInteger, PBXCopyFileDestination) {
    PBXCopyFileDestinationAbsolutePath,
    PBXCopyFileDestinationProductsDirectory,
    PBXCopyFileDestinationWrapper,
    PBXCopyFileDestinationBundleResourcesDirectory,
    PBXCopyFileDestinationBundleExecutablesDirectory,
    PBXCopyFileDestinationBundleJavaResourcesDirectory,
    PBXCopyFileDestinationBundleFrameworksDirectory,
    PBXCopyFileDestinationBundleSharedFrameworksDirectory,
    PBXCopyFileDestinationBundleSharedSupportDirectory,
    PBXCopyFileDestinationBundlePlugInsDirectory
};

extern NSInteger PBXGetCopyFileDestinationNumericValue(PBXCopyFileDestination dest);

#pragma mark Build Settings

/// This special build configuration is used to specify that the settings returned be applied to all build configurations in the project.
extern NSString * const PBXAnyBuildConfiguration;
/// The \c Debug build configuration.
extern NSString * const PBXDebugBuildConfiguration;
/// The \c Release build configuration.
extern NSString * const PBXReleaseBuildConfiguration;

typedef NS_ENUM(NSInteger, PBXPlatform) {
    PBXPlatformAny = 0,
    PBXPlatformMac = 1,
    PBXPlatformIOS = 2
};

extern NSDictionary * PBXGetCommonBuildSettings(NSString *buildConfiguration, PBXPlatform platform);
extern NSDictionary * PBXGetDefaultBuildSettingsForConfiguration(NSString *buildConfiguration);
