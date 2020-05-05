import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/generated/l10n.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoViewSimpleScreen extends StatelessWidget {
  const PhotoViewSimpleScreen({
    this.imageData, //图片url
    this.imageProvider, //图片
    this.loadingChild, //加载时的widget
    this.backgroundDecoration, //背景修饰
    this.minScale, //最大缩放倍数
    this.maxScale, //最小缩放倍数
    this.heroTag, //hero动画tagid
  });

  final Uint8List imageData;
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: ExtendedImageSlidePage(
              child: Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    child: ExtendedImage(
                        mode: ExtendedImageMode.gesture,
                        enableSlideOutPage: true,
                        image: imageProvider),
                    onLongPress: () async {
                      showCupertinoModalPopup<int>(
                          context: context,
                          builder: (cxt) {
                            var dialog = CupertinoActionSheet(
                              cancelButton: CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(cxt, 1);
                                  },
                                  child: Text(S.of(context).cancel)),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                    onPressed: () async {
                                      Navigator.pop(cxt, 2);
                                      bool result =
                                          await saveNetworkImageToPhoto(
                                              imageData);
                                      if (result) {
                                        EasyLoading.showToast(
                                            S.of(context).savedSuccess);
                                      }
                                    },
                                    child: Text(S.of(context).savePicture))
                              ],
                            );
                            return dialog;
                          });
                    },
                  ),
                ),
                Positioned(
                  //右上角关闭按钮
                  right: 10,
                  top: MediaQuery.of(context).padding.top,
                  child: IconButton(
                    icon: Icon(Icons.close, size: 30, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Positioned(
                  //右下角保存按钮
                  right: 10,
                  bottom: MediaQuery.of(context).padding.bottom,
                  child: IconButton(
                    icon: Icon(Icons.file_download,
                        size: 30, color: Colors.white),
                    onPressed: () async {
                      bool result = await saveNetworkImageToPhoto(imageData);
                      if (result) {
                        EasyLoading.showToast(S.of(context).savedSuccess);
                      }
                    },
                  ),
                )
              ],
            ),
          ))),
    );
  }

  // 保存图片到本地
  Future saveNetworkImageToPhoto(Uint8List imageData) async {
    if (Platform.isAndroid) {
      // 检查并请求权限
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (PermissionStatus.granted != status) {
        PermissionHandler().requestPermissions(<PermissionGroup>[
          PermissionGroup.storage,
        ]);
      }
      if (status == PermissionStatus.granted) {
        return saveImageOnAndroidAndiOS(imageData);
      }
    } else if (Platform.isIOS) {
      return saveImageOnAndroidAndiOS(imageData);
    } else if (Platform.isMacOS) {
      // todo 待完成MacOS的图片保存功能
      EasyLoading.showToast("暂不支持该平台保存图片");
    }
    return false;
  }

  // 在Android和iOS上保存图片
  saveImageOnAndroidAndiOS(Uint8List imageData) async {
    EasyLoading.show();
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(imageData));
    EasyLoading.dismiss();
    return result != '' || result != null;
  }
}
