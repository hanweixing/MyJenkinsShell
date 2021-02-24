
#/bin/bash

##############

# 这个脚本的作用是导出ipa，然后上传到Fir.im上.

##############
SCHEME_NAME=ScrollHero
ARCHIVE_PATH=../../jobs/${JOB_NAME}/builds/${BUILD_NUMBER}

# 设置Beta环境、正式环境还是测试环境
if [ "${archiveBetaVersion}" = true ]
then
    ENVIRONMENT_BUILD=Release
    EXPORT_PLIST=/Users/mini/Desktop/likelyBuild/Release/export_adhoc.plist
elif [ "${archiveDebugVersion}" = true ]
then
    ENVIRONMENT_BUILD=Development
    EXPORT_PLIST=/Users/mini/Desktop/likelyBuild/Release/export_development.plist
else
    ENVIRONMENT_BUILD=Release
    EXPORT_PLIST=/Users/mini/Desktop/likelyBuild/Release/export_adhoc.plist
fi


echo "--- 导出ipa包，用以上传到蒲公英 ---"
xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH}/${SCHEME_NAME}.xcarchive -exportPath ${ARCHIVE_PATH}/${SCHEME_NAME} -exportOptionsPlist ${EXPORT_PLIST}

echo "---进入到ipa的文件夹"
cd ${ARCHIVE_PATH}/${SCHEME_NAME}

IPA_PATH=Slow.ipa
API_KEY=2e67290647134c308756e093c7529f32

echo "push 上传到 蒲公英"
curl -F "file=@${IPA_PATH}" -F "_api_key=${API_KEY}" https://www.pgyer.com/apiv2/app/upload

echo "上传成功"
