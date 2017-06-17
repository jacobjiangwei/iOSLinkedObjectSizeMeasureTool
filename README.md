# A mac tool to visualize iOS linked object size change between different version


As time passing by, Production managers keep adding features, app become bigger and bigger, launch time increases. It become a major issue for big company with tons of feature they can't cut.

Improve launch time is a hot topic,  WWDC2016 covered this topic: https://developer.apple.com/videos/play/wwdc2016/406/ , but they didn't really give us constructive/easy to use tool to improve this.

Here is a (not well known) tip to print all statistics of launch time, everything before main()
### DYLD_PRINT_STATISTICS_DETAILS = 1

Here is a sample of cold launch data:

2017-06-17 11:23:40.810749+0800 Glip[2375:879292] [DYMTLInitPlatform] platform initialization successful
  total time: 11.8 seconds (100.0%)
  total images loaded:  368 (324 from dyld shared cache)
  total segments mapped: 131, into 88781 pages with 648 pages pre-fetched
  total images loading time: 9.1 seconds (76.7%)
  total load time in ObjC: 210.44 milliseconds (1.7%)
  total debugger pause time: 7.8 seconds (65.8%)
  total dtrace DOF registration time:   0.09 milliseconds (0.0%)
  total rebase fixups:  624,857
  total rebase fixups time: 392.24 milliseconds (3.2%)
  total binding fixups: 490,020
  total binding fixups time: 615.62 milliseconds (5.1%)
  total weak binding fixups time:  43.43 milliseconds (0.3%)
  total redo shared cached bindings time: 614.46 milliseconds (5.1%)
  total bindings lazily fixed up: 0 of 0
  total time in initializers and ObjC +load: 1.4 seconds (12.5%)
                         libSystem.B.dylib :   8.79 milliseconds (0.0%)
                      libglInterpose.dylib : 294.84 milliseconds (2.4%)
                     libMTLInterpose.dylib : 125.98 milliseconds (1.0%)
                          MediaLibraryCore :  85.85 milliseconds (0.7%)
                               HomeSharing :  17.96 milliseconds (0.1%)
                                   ModelIO : 132.82 milliseconds (1.1%)
                                  GlipCore : 680.82 milliseconds (5.7%)
                                      Glip : 109.50 milliseconds (0.9%)
total symbol trie searches:    1050694
total symbol table binary searches:    0
total images defining weak symbols:  42
total images using weak symbols:  83


You look at it, you endup saying "Wow, Xcode so Cool", but what you going to do about it?

Merge all A,B,C,D...Z framework into One framework is not practical, initializers global definition in one struct place, we already did that, how to deal with the biggest (total images loading time) time consumer?

Here is an idea, when they load the image, it's literally load translated version of object file. So if we look at the generated object file, we may have a clue.

To enable that, you need set YES for write link map file.


Lucky someone provide a tool to analyse linked object files map and list all by size. https://github.com/alicialy/LTAppThinningScript
### run "node linkmap_ext.js /Users/jacob/Library/Developer/Xcode/DerivedData/Glip-cpijjvpuwarqlyclgmpmpuwlfbsb/Build/Intermediates/Glip.build/Debug-iphoneos/Glip.build/Glip-LinkMap-normal-arm64.txt -u"

### With benefit of that tool, you have a clear idea who is cost most in your project, you may start having an idea how to improve it.

## Here I provide a visualized tool to measure your changes between different version of your app, so you clearly understand what your code activity impact was.

Step:

1. Compile old branch and get linkmap file, run "node linkmap_ext.js /Users/jacob/Library/Developer/Xcode/DerivedData/Glip-cpijjvpuwarqlyclgmpmpuwlfbsb/Build/Intermediates/Glip.build/Debug-iphoneos/Glip.build/Glip-LinkMap-normal-arm64.txt -u"
2. Compile new branch and get linkmap file, run "node linkmap_ext.js /Users/jacob/Library/Developer/Xcode/DerivedData/Glip-cpijjvpuwarqlyclgmpmpuwlfbsb/Build/Intermediates/Glip.build/Debug-iphoneos/Glip.build/Glip-LinkMap-normal-arm64.txt -u"
3. Using Xcode 9 build run this project
4. Select Old version link map file
5. Select New version link map file
6. Click start analyse, you will see comparison 
7. Optional, Click XLS chart to select a folder to save chart.cvs file. Use Excel or Numbers to import cvs, Selct "Tab" as delimiters to finish import, select data, generate 2 line chart, you will have a cool visualized chart showing you are improving or fall back.





