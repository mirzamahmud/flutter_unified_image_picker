package com.mirza.flutter_unified_image_picker

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.provider.MediaStore
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import androidx.annotation.NonNull

class FlutterUnifiedImagePickerPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private lateinit var context: android.content.Context
    private var pendingResult: Result? = null
    private val REQUEST_PERMISSION = 1001

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app.gallery/images")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when(call.method) {
            "getImages" -> {
                val act = activity
                if (act == null) {
                    result.error("NO_ACTIVITY", "Plugin requires an Activity.", null)
                    return
                }

                if (hasPermission(act)) {
                    result.success(getGalleryImages(act))
                } else {
                    pendingResult = result
                    requestPermission(act)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun hasPermission(act: Activity): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(act, Manifest.permission.READ_MEDIA_IMAGES) == PackageManager.PERMISSION_GRANTED
        } else {
            ContextCompat.checkSelfPermission(act, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
        }
    }

    private fun requestPermission(act: Activity) {
        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            arrayOf(Manifest.permission.READ_MEDIA_IMAGES)
        } else {
            arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE)
        }
        ActivityCompat.requestPermissions(act, permissions, REQUEST_PERMISSION)
    }

    fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == REQUEST_PERMISSION) {
            val result = pendingResult ?: return
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                result.success(getGalleryImages(activity!!))
            } else {
                result.error("PERMISSION_DENIED", "Storage permission denied", null)
            }
            pendingResult = null
        }
    }

    private fun getGalleryImages(act: Activity): List<String> {
        val images = mutableListOf<String>()
        val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf(MediaStore.Images.Media.DATA)
        val cursor = act.contentResolver.query(uri, projection, null, null, "${MediaStore.Images.Media.DATE_ADDED} DESC")
        cursor?.use {
            val columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            while (cursor.moveToNext()) {
                images.add(cursor.getString(columnIndex))
            }
        }
        return images
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ActivityAware methods
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener { requestCode, permissions, grantResults ->
            onRequestPermissionsResult(requestCode, permissions, grantResults)
            true
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener { requestCode, permissions, grantResults ->
            onRequestPermissionsResult(requestCode, permissions, grantResults)
            true
        }
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
