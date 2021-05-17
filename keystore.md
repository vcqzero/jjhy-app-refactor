# Keystore

## 文件 `android/app/jjhy.keystore`

| 项目                 | 内容                        |
| -------------------- | --------------------------- |
| app名称              | `京9`                       |
| 包名                 | `cn.jjhycom.www`            |
| 签名文件（keystore） | `android/app/jjhy.keystore` |
| keystore密码         | `kunpeng462400`             |
| keystore-别名        | `jjhy.keystore`             |
| keystore-别名密码    | `kunpeng462400`             |

## 说明
程序使用keystore的好处
### 有利于程序升级

当新版程序和旧版程序的数字证书相同时，Android系统才会认为这两个程序是同一个程序的不同版本。如果新版程序和旧版程序的数字证书不相同，则Android系统认为他们是不同的程序，并产生冲突，会要求新程序更改包名。

### 有利于程序的模块化设计和开发。

Android系统允许拥有同一个数字签名的程序运行在一个进程中，Android程序会将他们视为同一个程序。所以开发者可以将自己的程序分模块开发，而用户只需要在需要的时候下载适当的模块。

### 可以通过权限(permission)的方式在多个程序间共享数据和代码。

Android提供了基于数字证书的权限赋予机制，应用程序可以和其他的程序共享概功能或者数据给那那些与自己拥有相同数字证书的程序。如果某个权限(permission)的protectionLevel是signature，则这个权限就只能授予那些跟该权限所在的包拥有同一个数字证书的程序。

### keystore的两种模式
调试模式(debug mode)和发布模式(release mode)

(1)调试模式(debug mode)：在调试模式下， Android Studio会自动的使用debug密钥为应用程序签名，因此我们可以直接运行程序。

(2)发布模式(release mode)：当要发布程序时，开发者就需要使用自己的数字证书给apk包签名。
