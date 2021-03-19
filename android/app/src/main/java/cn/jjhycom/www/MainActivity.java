package cn.jjhycom.www;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        // 注册自定义channel
        registerCustomChannel(flutterEngine);
    }

    private void registerCustomChannel(FlutterEngine flutterEngine){
        String channelName ="cn.jjhycom.www.flutter";
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), channelName); //此处名称应与Flutter端保持一致
        MethodChannel.MethodCallHandler handler = getMethodCallHandler();

        //设置接收调用时的handler
        channel.setMethodCallHandler(handler);
    }

    private MethodChannel.MethodCallHandler getMethodCallHandler(){
        return new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                switch (call.method){
                    case "toast":
                        String msg = call.argument("msg");
                        Toast.makeText(MainActivity.this, "测试channel", Toast.LENGTH_SHORT).show();
                        result.success("成功啦");
                        break;

                    case "haveInstallPermission" :
                        checkInstallPemission(result);
                        break;

                    case "requestInstallPermission" :
                        requestInstallPermission(result);
                        break;
                    default:
                        result.error("404", "未匹配到对应的方法"+call.method, null);
                }
            }
        };
    }

    private void checkInstallPemission(@NonNull MethodChannel.Result result){
        boolean haveInstallPermission =true;
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            haveInstallPermission = getPackageManager().canRequestPackageInstalls();
        }
        result.success(haveInstallPermission);
    }

    private void requestInstallPermission(@NonNull MethodChannel.Result result){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String appId = getApplication().getPackageName();
            Uri packageUri = Uri.parse("package:" + appId);
            Intent intent = new Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, packageUri);
            startActivityForResult(intent, 0);
        }
        result.success("启动设置页面");
    }
}
