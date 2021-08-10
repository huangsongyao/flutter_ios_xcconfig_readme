# flutter_ios_xcconfig_readme
纯flutter 或 主native+flutter关于多渠道配置的正确方式

flutter在iOS中的多渠道配置和DART_DEFINES参数解析配置说明 【备注1：直接在Xcode中编译时，如果iPhone设备已存在包缓存，可能不会执行Post-action脚本，所以如果发现类型的情况，可以先删除包重新安装即可。】
【备注2：flutter工程下的build文件夹中的ios文件夹中存在了flutter的编译缓存，如果发现编译时不及时，可以将build -> ios这个文件夹的内容删除掉，让flutter的编译器重新确认编译环境并重新编译。】

## 1、iOS工程中，在默认的Runner这个target的基础上，copy多个渠道的target。

