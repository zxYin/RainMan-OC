# 西交Link-iOS

------

## 编译环境
Xcode 8

## 运行项目
1. 安装CocoaPods (关于CocoaPods的安装和使用，可参考[这个教程](http://code4app.com/article/cocoapods-install-usage))

2. 在终端下打开项目所在的目录，执行```pod install``` (若是首次使用CocoaPods，需先执行```pod setup```)

3. ```pod install```命令执行成功后，通过新生成的xcworkspace文件打开工程运行项目

   ​

## 目录简介
```
---------------------------------------------------------
LKBaseModule			基础模块：用户模块、分享模块、网络模块、基础UI、通用工具、浏览器
LKResourceModule		资源模块：各类文件资源
---------------------------------------------------------
LKMediator				中介者
---------------------------------------------------------
LKActivityModule		活动模块：讲座、活动、打卡
LKCardModule			校园卡模块：一卡通余额、账单、圈存
LKCourseModule			课程模块：课表、评教、成绩、考试安排
LKClassroomModule		空闲教室模块
LKDiscoverModule		发现模块：头条、社团、表白墙
LKRecruitmentModule		招聘模块
LKFlowModule			流量模块
LKLibraryModule			图书馆模块
LKLoginModule			登录模块
LKNewsModule			新闻模块
LKSettingModule			设置模块
---------------------------------------------------------
XJTULink-iOS  			壳工程
---------------------------------------------------------

各工程通用目录
	|- Public			对外接口
	|- Category			扩展文件  
	|- Vendors			第三方库 
	|- Model			Model层 
	|- View				View/Controller层 
	|- ViewModel		ViewModel层 
	|- Networking		网络层
```


