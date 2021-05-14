# 京9APP重构项目

## 应用包名 id等
| 平台      | ApplicationId    | package          | 说明                               |
| :-------- | :--------------- | :--------------- | :--------------------------------- |
| `Android` | `cn.jjhycom.www` | `cn.jjhycom.www` | 应用上线之后id不可更改，包名可更改 |
| `IOS`     |                  |                  |                                    |

# Null safety
```shell
# 检查未开启空安全的依赖
flutter pub outdated --mode=null-safety
# 升级版本为空安全 
flutter pub upgrade --null-safety
```

## 使用图片

+ 在`pubspec.yaml`的`assets`字段添加资源；
+ 通过`Image.asset(name)`使用图片
## 使用SVG

+ 在`pubspec.yaml`的`assets`字段添加资源；
```dart
// 使用
SvgPicture.asset(
  svgPath,
  semanticsLabel: 'svg',
  color: widget.svgColor,
  width: 32,
)
```
