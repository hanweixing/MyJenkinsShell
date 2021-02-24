
#/bin/bash

##############

# 这个脚本的作用是打包, 并判断是否上传到App Store上.

#############
git checkout ${branch}
git pull

echo "---设置版本号---"
APP_VERSION=${app_version}
APP_BUILD=${app_build}

SCHEME_NAME=ScrollHero
ARCHIVE_PATH=../../jobs/${JOB_NAME}/builds/${BUILD_NUMBER}

agvtool new-marketing-version ${APP_VERSION}
agvtool new-version -all ${APP_BUILD}

# Beta的网络配置文件
BETA_PRODUCTION_CONFIG_FILE=/Users/mini/Desktop/likelyBuild/Release/Production.swift
BETA_PRODUCTION_CONFIG_REPLACE_FILE=../../workspace/iOS-Likely/ScrollHero/Config/Production.swift
BETA_PRODUCTION_CONFIG_MOVE_DIR=../../workspace/iOS-Likely/ScrollHero/Config

echo "Linux提权"
sudo spctl --master-disable # 已经设置过了etc/sudoers无需输入sudo密码

echo "设置编译路径"
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# 设置Beta环境、正式环境还是测试环境
if [ "${archiveBetaVersion}" = true ]
then
    ENVIRONMENT_BUILD=Release
    # 如果是beta环境，那么替换掉原Production.swift文件
    sudo rm -rf ${BETA_PRODUCTION_CONFIG_REPLACE_FILE}
    sudo cp ${BETA_PRODUCTION_CONFIG_FILE} ${BETA_PRODUCTION_CONFIG_MOVE_DIR}
elif [ "${archiveDebugVersion}" = true ]
then
    ENVIRONMENT_BUILD=Development
else
    ENVIRONMENT_BUILD=Release
fi

UPLOAD_PLIST=/Users/mini/Desktop/likelyBuild/Release/upload_appstore.plist

echo "---执行clean---"
xcodebuild clean -workspace ScrollHero.xcworkspace -scheme ${SCHEME_NAME}

echo "---clean完毕，编译---"
xcodebuild -workspace ScrollHero.xcworkspace -scheme ${SCHEME_NAME} -sdk iphoneos -configuration ${ENVIRONMENT_BUILD} -archivePath ${ARCHIVE_PATH}/${SCHEME_NAME}.xcarchive archive

if [ "${uploadToApple}" = true ]
then
    echo "---需要上传到Apple store---"
       echo "---编译成app完毕，进行打包上传App Store---"
       xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH}/${SCHEME_NAME}.xcarchive -exportPath ${ARCHIVE_PATH}/${SCHEME_NAME} -exportOptionsPlist ${UPLOAD_PLIST}
       echo "---上传到AppStore完毕---"
else
    echo "---不需要上传到Apple store---"
fi
