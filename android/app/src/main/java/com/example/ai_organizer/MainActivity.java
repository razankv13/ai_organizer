package com.example.ai_organizer;

import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "app.organizer.ai/share";
    private String sharedUrl = null;
    private String sharedText = null;
    private String sharedTitle = null;
    private String sharedType = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        handleSendIntent(getIntent());
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        handleSendIntent(intent);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "getInitialSharedUrl":
                                    result.success(sharedUrl);
                                    break;
                                case "getInitialSharedText":
                                    result.success(sharedText);
                                    break;
                                case "getInitialSharedData":
                                    if (sharedUrl != null || sharedText != null) {
                                        Map<String, String> data = new HashMap<>();
                                        data.put("type", sharedType);
                                        data.put("content", sharedUrl != null ? sharedUrl : sharedText);
                                        if (sharedTitle != null) {
                                            data.put("title", sharedTitle);
                                        }
                                        result.success(data);
                                    } else {
                                        result.success(null);
                                    }
                                    break;
                                case "clearSharedData":
                                    sharedUrl = null;
                                    sharedText = null;
                                    sharedTitle = null;
                                    sharedType = null;
                                    result.success(true);
                                    break;
                                default:
                                    result.notImplemented();
                            }
                        }
                );
    }

    private void handleSendIntent(Intent intent) {
        String action = intent.getAction();
        String type = intent.getType();

        if (Intent.ACTION_SEND.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                String sharedContent = intent.getStringExtra(Intent.EXTRA_TEXT);
                String sharedSubject = intent.getStringExtra(Intent.EXTRA_SUBJECT);

                if (sharedContent != null) {
                    // Check if it's a URL
                    if (sharedContent.startsWith("http://") || sharedContent.startsWith("https://")) {
                        sharedUrl = sharedContent;
                        sharedType = "url";
                        sharedTitle = sharedSubject;
                    } else {
                        sharedText = sharedContent;
                        sharedType = "text";
                        sharedTitle = sharedSubject;
                    }
                }
            }
        }
    }
}
