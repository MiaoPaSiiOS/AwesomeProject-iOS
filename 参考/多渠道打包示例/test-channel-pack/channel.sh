#!/bin/bash

channel=$1
echo "currentChannel:"$channel
channelPath=$PROJECT_DIR/test-channel-pack/Channels/$channel

echo "channelPath:"$channelPath

#code
codePath=$(find $channelPath -type d -name Code)
code=$PROJECT_DIR/test-channel-pack/ChannelConfig/Config
if [ "${codePath}" != "" ]; then

    for file in $(ls $codePath); do
        if [ -d $codePath"/"$file ]; then
            echo "do something"
        else
            filename=$(echo ${file##*/})
            fileheader=$(echo $filename | awk -F . '{print $1}')
            #配置文件
            configFileName="ChannelConfig"
            if [ $fileheader = $configFileName ]; then
                cp -f $codePath"/"$file $code"/ChannelConfig.h"
                echo "copy config file:"$filename
            else
                echo ""
            fi

            #颜色配置
            configColorFileName="ChannelColor"
            if [ $fileheader = $configColorFileName ]; then
                cp -f $codePath"/"$file $code"/ChannelColor.h"
                echo "copy config file:"$filename
            else
                echo ""

            fi
        fi
    done
fi

#assets
assetsPath=$(find $channelPath -type d -name Assets)
assets=$PROJECT_DIR/test-channel-pack/Assets.xcassets
echo "assetsPath:"$assetsPath
echo "assets:"$assets
if [ "${assetsPath}" != "" ]; then
    for file in $(ls $assetsPath); do
        fullPath=$assetsPath"/"$file
        if [ -d $fullPath ]; then
            echo "$file is a directory."
            cp -r -f $assetsPath"/"$file"/" $assets"/"$file"/"
            echo "copy dir:"$file
        else
            echo "$file is a file."
            filename=$(echo ${file##*/})
            fileheader=$(echo $filename | awk -F @ '{print $1}')
            cp -f $assetsPath"/"$file $assets"/"$fileheader".imageset/"$file
            echo "copy file:"$fileheader
        fi
    done
else
    echo ""
fi


#工程配置
channelPlist=$channelPath"/Info.plist"
infoPlistFile=$PROJECT_DIR/test-channel-pack/Info.plist

echo "channelPath:"$channelPath
echo "channelPlist:"$channelPlist
echo "infoPlistFile:"$infoPlistFile

if [ "${channelPlist}" != "" ]; then
    displayName=$(/usr/libexec/PlistBuddy -c "Print CFBundleDisplayName" $channelPlist)
    echo "displayName: "$displayName
    if [ "${displayName}" != "" ]; then
        /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $displayName" $infoPlistFile
    fi
fi
