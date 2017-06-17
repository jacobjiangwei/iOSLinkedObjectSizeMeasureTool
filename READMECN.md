＃一个可视化比较不同版本之间的iOS链接对象大小变化的mac工具


随着时间的推移，PM不断增加功能，应用越来越大，启动时间越来越长，这成为一个大公司无法回避的问题。

改进启动时间是一个热门话题，WWDC2016涵盖了这个主题：https://developer.apple.com/videos/play/wwdc2016/406/，但他们并没有真正给我们建设性/易于使用的工具来改善。

这是一个（不太知名的）参数，可以打印main函数前启动时间的所有统计信息，
### DYLD_PRINT_STATISTICS_DETAILS = 1
！[]（https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/enablePrint.png?raw=true）

以下是冷启动数据的示例：
！[]（https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/printstatics.png?raw=true）

你看到说“哇，Xcode这么酷”，但接下来该做点什么？

将所有A，B，C，D ... Z框架合并成一个框架是不实际的，初始化器全局定义在一个结构位置，我们已经做到了，如何解决最大的问题（total images loading time）？

当他们加载时，它其实是加载翻译版本的对象文件。如果我们可以看link object file，我们可能会有头绪。

为了实现这一点，你需要为写链接映射文件设置YES。
！[]（https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/enableLinked.png?raw=true）

幸运的是有腾讯的小伙伴们提供了一个工具来分析链接的对象文件，并按大小列出所有的对象文件。 https://github.com/alicialy/LTAppThinningScript
run "node linkmap_ext.js /Users/jacob/Library/Developer/Xcode/DerivedData/Glip-cpijjvpuwarqlyclgmpmpuwlfbsb/Build/Intermediates/Glip.build/Debug-iphoneos/Glip.build/Glip-LinkMap-normal-arm64.txt -u"

利用该工具，您可以有一个清晰的认知，谁消耗了最大的体积和启动时间，您可能会开始考虑如何改进它。

##在这里，我提供了一个可视化工具来衡量您的应用程序的不同版本之间的变化，以便您清楚地了解您的代码活动的影响。

步骤：

1.编译旧分支并获取linkmap文件，运行“node linkmap_ext.js /Users/jacob/Library/Developer/Xcode/DerivedData/Glip-cpijjvpuwarqlyclgmpmpuwlfbsb/Build/Intermediates/Glip.build/Debug-iphoneos/Glip.build/Glip -LinkMap-normal-arm64.txt -u“
2.编译新分支并获取linkmap文件，运行“node linkmap_ext.js /Users/jacob/Library/Developer/Xcode/DerivedData/Glip-cpijjvpuwarqlyclgmpmpuwlfbsb/Build/Intermediates/Glip.build/Debug-iphoneos/Glip.build/Glip -LinkMap-normal-arm64.txt -u“
3.使用Xcode 9构建运行此项目
4.选择旧版本的链接映射文件
5.选择新版本的链接映射文件
6.点击开始分析，你会看到比较
！[]（https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/compareData.png?raw=true）
7.这是可选的，单击XLS图表选择一个文件夹来保存chart.cvs文件。使用Excel或数字导入cvs，Selct“Tab”作为分隔符完成导入，选择数据，生成2线图，您将有一个很酷的可视化图表，显示您正在改进或回退。
！[]（https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/chart.png?raw=true）