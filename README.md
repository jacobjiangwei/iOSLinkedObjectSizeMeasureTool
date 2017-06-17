# A mac tool to visualize iOS linked object size change between different version

- [中文版](https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/READMECN.md)

As time passing by, Production managers keep adding features, app become bigger and bigger, launch time increases. It become a major issue for big company with tons of feature they can't cut.

Improve launch time is a hot topic,  WWDC2016 covered this topic: https://developer.apple.com/videos/play/wwdc2016/406/ , but they didn't really give us constructive/easy to use tool to improve this.

Here is a (not well known) tip to print all statistics of launch time, everything before main()
### DYLD_PRINT_STATISTICS_DETAILS = 1
![](https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/enablePrint.png?raw=true)

Here is a sample of cold launch data:
![](https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/printstatics.png?raw=true)

You look at it, you endup saying "Wow, Xcode so Cool", but what you going to do about it?

Merge all A,B,C,D...Z framework into One framework is not practical, initializers global definition in one struct place, we already did that, how to deal with the biggest (total images loading time) time consumer?

Here is an idea, when they load the image, it's literally load translated version of object file. So if we look at the generated object file, we may have a clue.

To enable that, you need set YES for write link map file.
![](https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/enableLinked.png?raw=true)

Lucky someone provide a tool to analyse linked object files map and list all by size. https://github.com/alicialy/LTAppThinningScript

run "node linkmap_ext.js /Users/jacob/Library/Developer/Xcode/DerivedData/Glip-cpijjvpuwarqlyclgmpmpuwlfbsb/Build/Intermediates/Glip.build/Debug-iphoneos/Glip.build/Glip-LinkMap-normal-arm64.txt -u"

With benefit of that tool, you have a clear idea who is cost most in your project, you may start having an idea how to improve it.

## Here I provide a visualized tool to measure your changes between different version of your app, so you clearly understand what your code activity impact was.

Step:

1. Compile old branch and get linkmap file, run "node linkmap_ext.js /Users/jacob/Library/Developer/Xcode/DerivedData/Glip-cpijjvpuwarqlyclgmpmpuwlfbsb/Build/Intermediates/Glip.build/Debug-iphoneos/Glip.build/Glip-LinkMap-normal-arm64.txt -u"
2. Compile new branch and get linkmap file, run "node linkmap_ext.js /Users/jacob/Library/Developer/Xcode/DerivedData/Glip-cpijjvpuwarqlyclgmpmpuwlfbsb/Build/Intermediates/Glip.build/Debug-iphoneos/Glip.build/Glip-LinkMap-normal-arm64.txt -u"
3. Using Xcode 9 build run this project
4. Select Old version link map file
5. Select New version link map file
6. Click start analyse, you will see comparison 
![](https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/compareData.png?raw=true)
7. This is optional, click XLS chart to select a folder to save chart.cvs file. Use Excel or Numbers to import cvs, Selct "Tab" as delimiters to finish import, select data, generate 2 line chart, you will have a cool visualized chart showing you are improving or fall back.
![](https://github.com/jacobjiangwei/iOSLinkedObjectSizeMeasureTool/blob/master/resources/chart.png?raw=true)


In above example, you can clearly see we are not optimized for new added features. Then we know what to do next.
