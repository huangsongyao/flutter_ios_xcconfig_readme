#!/usr/bin/env bash

# 备注：想从env中获取DART_DEFINES参数的内容，必须使用编译后脚本模式，官网所说的编译前脚本是无法获取的！！！！
#
# 编译流程
#
# 1、将--dart-define参数在build前通过编译器传递到xcode中进行存储；
# 2、--dart-define的参数默认在传递过程中，会使用base64做一次加密传输，多个参数使用’,‘逗号进行分隔；
# 3、对参数进行分割，装入一个临时数组中进行存储；
# 4、对这个临时数组进行遍历，将每个--dart-define参数做一次base64解码，并存储回这个临时数组中；
# 5、最后将整个临时数组的内容，写入到当前目录下的DartDefines.xcconfig文件中进行存储
#

echo '开始执行编译前脚本: DartDefines.sh ......\n'
IFS=',' read -r -a define_items <<< "$DART_DEFINES"
echo '--dart-defines原始参数define_items:'$define_items'\n'
len=${#define_items[*]}
if [[ len -eq 0 ]]; then
	#如果数组长度为0，则直接退出脚本
	echo '--dart-defines原始参数未获取成功！'
	exit
fi

dart_defines_pre="PRE_DART_DEFINES"

for index in "${!define_items[@]}"
do
	decode_base64=$(printf "%s" ${define_items[$index]}| base64 -d)
	echo 'base64解码index:'$index'----------base64解码结果:'$decode_base64
	if [[ $decode_base64 != *$dart_defines_pre* ]]; then
		#解码后，如果不含有"PRE_DART_DEFINES"的项不写入到文件中
		decode_base64=""
	fi
    	define_items[$index]=$decode_base64
done

printf "%s\n" "${define_items[@]}" > ${SRCROOT}/Flutter/DartDefines.xcconfig
echo '--dart-defines参数解码完毕!'

exit



