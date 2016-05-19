# cordovaDialogsPlus
An Cordova project is an extension to cordova-plugin-dialogs. It provides the progress bar, loading layer, file selection dialog box, toast to Android and IOS platform. Android part of the code reference to the cordova-plugin-dialogs source code.

这是一个cordova的插件项目，是对cordova的官方插件cordova-plugin-dialogs的扩展，在ios和安卓平台上，提供了进度条、加载层、文件选择对话框、消息提示等功能。安卓平台的代码参考了cordova-plugin-dialogs的部分源码。

## Installation
This requires cordova 5.0+

    cordova plugin add https://github.com/laden666666/UnifiedExceptionHandlingDome
Does not support earlier versions

插件只支持cordova5.0及以上版本

    cordova plugin add https://github.com/laden666666/UnifiedExceptionHandlingDome

## Supported Platforms

支持的平台为

- Android
- iOS

## API Reference
  Display load layer
  
  显示加载层
  
    window.navigator.dialogsPlus.show.showLoading(title, loadingMassage);
  
  Dismiss load layer
  
  隐藏加载层
  
    window.navigator.dialogsPlus.hideLoading();

  Display progress dialog
  
  显示进度条对话框
  
    window.navigator.dialogsPlus.progressStart(title, loadingMassage, errorCallback, canCancel, cancelButtonName, cancelCallback);
  The function returns a JSON object.Use this object to hide the progress bar, or set the progress value.
  
  这个函数返回的是一个json对象，使用这个对象可以对此函数打开的进度条操作，例如设置进度或者隐藏进度条。
  
    var progress = window.navigator.dialogsPlus.progressStart("title","loading....");
    progress.setValue(100);
    progress.hide(successCallback, errorCallback);

  Open choose file dialog.On the Android platform, you can open the system file activity, it returns the absolute path of the selected file. On the IOS platform, you can only choose photo of the album by cordova-plugin-camera (because of IOS file sandbox).
  
  选择文件，安卓上你可以使用系统对话框选择文件，选择后将获得所选文件的绝对路径。但是在ios上，你只能通过此插件依赖的cordova-plugin-camera插件，去选择相册里的图片，这主要是因为ios的文件沙箱机制，我无法向安卓那样获取其他应用目录里的图片。
  
    window.navigator.dialogsPlus.chooseFile(title, successCallback, errorCallback);
    
  
  
