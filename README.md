# flutter_ios_xcconfig_readme
纯flutter 或 主native+flutter关于多渠道配置的正确方式

[备注1：直接在Xcode中编译时，如果iPhone设备已存在包缓存，可能不会执行Post-action脚本，所以如果发现类型的情况，可以先删除包重新安装即可。]

[备注2：flutter工程下的build文件夹中的ios文件夹中存在了flutter的编译缓存，如果发现编译时不及时，可以将build -> ios这个文件夹的内容删除掉，让flutter的编译器重新确认编译环境并重新编译。]

### 1、iOS工程中，在默认的Runner这个target的基础上，copy多个渠道的target。



### 2、创建多个渠道的.xcconfig文件，作为target渠道绑定标志的scheme对象，每个渠道均有：-debug、 -release、 -profile三个编译环境的配置。注意，这里的.xcconfig文件的本地绝对路径必须和自动生成的【Generated.xcconfig】文件保持同样的路径。


### 3、对增加的每个.xcconfig文件进行依赖引用，所引用的pods文件路径和【Pods】文件保持一致。


### 4、对Pods的Podfile文件的ruby脚本进行补充，将新增的.xcconfig文件依次添加并制定对应的编译环境。


### 5、更新PROJECT-Runner中关于新增的.xcconfig文件的引用说明，并且保证是一一对应的。


### 6、在Build Setting中新增一项User-Defined，声明一个名为【BUNDLE_NAME】的项目，并在【Info.plist】文件中引用【$(BUNDLE_NAME)】变量。


### 7、在Edit Scheme中，对每个.xcconfig进行编辑和状态管理，保证对应的文件引用都是正确的。注意，这里【Build】、【Run】、【Test】、【Profile】、【Analyze】、【Archive】都需要根据实际清楚增加，正常来说，【Build】和【Analyze】不用处理。


### 8、在工程的根目录下，执行pod install/pod update指令，更新整个工程的配置状态。


### 9、同样在Edit Scheme中对每个.xcconfig文件进行脚本引用，注意，这里要添加的是【Post-actions】脚本，也就是编译后脚本，只有编译后脚本，才可以获取到【"$DART_DEFINES”】参数的值。并且，和步骤【7】一样，需要对【Build】、【Run】、【Test】、【Profile】、【Analyze】、【Archive】等所有的项均增加【Post-actions】脚本。


### 10、对【Run Script】脚本进行编辑，选中【Provide build setting from】为【Runner】，并执行.sh脚本的build内容。注意，这里的【/bin/sh ….. build】为固定写法，表示允许.sh获取执行权限，如果直接调用，可能存在权限错误。


### 11、.sh执行脚本过程，是在编译后获取【"$DART_DEFINES”】参数，并对flutter2.x版本以上的【base64】进行解码，后注入到一个名为【DartDefines.xcconfig】的动态文件中，在步骤【3】中，表明了需要对每个渠道的.xcconfig文件进行引用，这个引用也包括这个【DartDefines.xcconfig】动态文件。


