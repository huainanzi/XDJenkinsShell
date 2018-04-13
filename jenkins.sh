#!/bin/sh

echo "$1-----$2-----$3"

# ==========================================选择配置=========================================
# scheme
ENG_SCHEME_NAME=$1;
# build configuration
ENG_BUILD_CONFIGURATION=$2
# 是否是workspace
ENG_IS_WORKSPACE=true
# 出包方式
echo "$3"
ENG_ExportOptionsPlistPath=""
if [[ "$3" == "AdHoc" ]]; then
ENG_ExportOptionsPlistPath="/Users/dong/Desktop/Shell/AdHocExportOptionsPlist.plist"
elif [[ "$3" == "AppStore" ]];then
ENG_ExportOptionsPlistPath="/Users/dong/Desktop/Shell/Plist/AppStoreExportOptions.plist"
elif [[ "$3" == "Enterprise" ]];then
ENG_ExportOptionsPlistPath="/Users/dong/Desktop/Shell/Plist/EnterpriseExportOptionsPlist.plist"
elif [[ "$3" == "Development" ]];then
ENG_ExportOptionsPlistPath="/Users/dong/Desktop/Shell/Plist/DevelopmentExportOptionsPlist.plist"
else
 echo "😯😯😯😯😯😯😯😯😯小伙子你的打包方式有问题😯😯😯😯😯😯😯😯😯"
exit 1
fi
# 是否上传内侧网站
ENG_IS_UPLOAD=""



# =============================================工程路径配置=================================
#⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️不同项目需要定制⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️
cd ~/.jenkins/workspace/QYCloud
# 工程路径
ENG_PROGECT_PATH=`pwd`
# 查找工程名
ENG_ROJECT_NAME=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
# 对应的infolist
#⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️不同项目需要定制⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️
ENG_CURRENT_INFO_PLIST_NAME="Info.plist"
# infoplist路径
ENG_CURRENT_INFO_PLIST_PATH="${ENG_SCHEME_NAME}/${ENG_CURRENT_INFO_PLIST_NAME}"
# 包的版本号
ENG_BUNDLE_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${ENG_CURRENT_INFO_PLIST_PATH}`
# 包编译的版本号
ENG_BUNDLE_BUILD_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${ENG_CURRENT_INFO_PLIST_PATH}`
# 导出包的路径
ENG_EXPORT_PATH="/Users/dong/Desktop/Shell/AutoIpa"
if test -d "${ENG_EXPORT_PATH}" ; then
rm -rf ${ENG_EXPORT_PATH}
else
mkdir -pv ${ENG_EXPORT_PATH}
fi

# 导出xcarchive的路径
ENG_EXPORT_ARCHIVE_PATH="${ENG_EXPORT_PATH}/${ENG_SCHEME_NAME}.xcarchive"
# 导出IPA的路径
ENG_EXPORT_IPA_PATH=${ENG_EXPORT_PATH}
# 获取当前时间
ENG_CURRENT_DATE="$(date +%Y%m%d_%H%M%S)"
# IPA名
ENG_IPA_NAME="${ENG_SCHEME_NAME}_V${ENG_BUNDLE_BUILD_VERSION}_${ENG_CURRENT_DATE}"

echo "😄😄😄😄😄😄😄😄😄你的出包为${ENG_SCHEME_NAME}--${ENG_BUILD_CONFIGURATION}--${ENG_ExportOptionsPlistPath},下面开始打包了😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄"

# ===============================================打包生成xcarchive=============================

# clean
xcodebuild clean  -workspace ${ENG_ROJECT_NAME}.xcworkspace \
-scheme ${ENG_SCHEME_NAME} \
-configuration ${ENG_BUILD_CONFIGURATION}
# Archive
xcodebuild archive  -workspace ${ENG_ROJECT_NAME}.xcworkspace \
-scheme ${ENG_SCHEME_NAME} \
-configuration ${ENG_BUILD_CONFIGURATION} \
-archivePath ${ENG_EXPORT_ARCHIVE_PATH} \
CFBundleVersion=${ENG_BUNDLE_BUILD_VERSION} \
-destination generic/platform=ios

# ================================================导出IPA包==============================
xcodebuild -exportArchive -archivePath ${ENG_EXPORT_ARCHIVE_PATH} \
-exportPath ${ENG_EXPORT_IPA_PATH} \
-destination generic/platform=ios \
-exportOptionsPlist ${ENG_ExportOptionsPlistPath} \
-allowProvisioningUpdates


cd ~/Desktop/Shell/AutoIpa
mv ${ENG_SCHEME_NAME}.ipa ${ENG_IPA_NAME}.ipa

if test -f "${ENG_IPA_NAME}.ipa" ; then
echo "导出 ${ENG_IPA_NAME}.ipa 包成功 🎉 🎉 🎉 "
open .
else
echo "导出 ${ENG_IPA_NAME}.ipa 包失败/(ㄒoㄒ)//(ㄒoㄒ)//(ㄒoㄒ)/~~ "
exit 1
fi


