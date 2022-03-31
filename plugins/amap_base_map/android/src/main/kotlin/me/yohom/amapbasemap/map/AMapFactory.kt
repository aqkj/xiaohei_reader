package me.yohom.amapbasemap.map

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.View
import com.amap.api.maps.AMapOptions
import com.amap.api.maps.TextureMapView
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import me.yohom.amapbasemap.*
import me.yohom.amapbasemap.AMapBaseMapPlugin.Companion.registrar
import me.yohom.amapbasemap.common.parseFieldJson
import me.yohom.amapbasemap.common.toFieldJson
import java.util.concurrent.atomic.AtomicInteger

const val mapChannelName = "me.yohom/map"
const val markerClickedChannelName = "me.yohom/marker_clicked"
const val mapClickedEventChannel = "me.yohom/map_clicked"
const val success = "调用成功"

class AMapFactory(private val activityState: AtomicInteger)
    : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, id: Int, params: Any?): PlatformView {
        val view = AMapView(
                context,
                id,
                activityState,
                (params as String).parseFieldJson<UnifiedAMapOptions>().toAMapOption()
        )
        view.setup()
        return view
    }
}

@SuppressLint("CheckResult")
class AMapView(context: Context,
               private val id: Int,
               private val activityState: AtomicInteger,
               amapOptions: AMapOptions) : PlatformView, Application.ActivityLifecycleCallbacks {

    private val mapView = TextureMapView(context, amapOptions)
    private var disposed = false
    private val registrarActivityHashCode: Int = AMapBaseMapPlugin.registrar.activity().hashCode()

    override fun getView(): View = mapView

    override fun dispose() {
        if (disposed) {
            return
        }
        disposed = true
        mapView.onDestroy()

        registrar.activity().application.unregisterActivityLifecycleCallbacks(this)
    }

    fun setup() {
        when (activityState.get()) {
            STOPPED -> {
                mapView.onCreate(null)
                mapView.onResume()
                mapView.onPause()
            }
            RESUMED -> {
                mapView.onCreate(null)
                mapView.onResume()
            }
            CREATED -> mapView.onCreate(null)
            DESTROYED -> {
            }
            else -> throw IllegalArgumentException("Cannot interpret " + activityState.get() + " as an activity activityState")
        }

        // 地图相关method channel
        val mapChannel = MethodChannel(registrar.messenger(), "$mapChannelName$id")
        mapChannel.setMethodCallHandler { call, result ->
            MAP_METHOD_HANDLER[call.method]
                    ?.with(mapView.map)
                    ?.onMethodCall(call, result) ?: result.notImplemented()
        }

        // click event channel
        var markerEventSink: EventChannel.EventSink? = null
        var mapEventSink: EventChannel.EventSink? = null
        // marker点击事件channel
        val markerClickedEventChannel = EventChannel(registrar.messenger(), "$markerClickedChannelName$id")
        // 地图点击事件channel
        val mapClickedEventChannel = EventChannel(registrar.messenger(), "$mapClickedEventChannel$id")

        markerClickedEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, sink: EventChannel.EventSink?) {
                markerEventSink = sink
            }

            override fun onCancel(p0: Any?) {
                Log.d("AMapView", "markerEventSink取消")
            }
        })
        mapClickedEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, sink: EventChannel.EventSink?) {
                mapEventSink = sink
            }

            override fun onCancel(p0: Any?) {
                Log.d("AMapView", "mapEventSink取消")
            }
        })
        mapView.map.setOnMarkerClickListener {
            it.showInfoWindow()
            markerEventSink?.success(UnifiedMarkerOptions(it).toFieldJson())
            true
        }
        mapView.map.setOnMapClickListener {
            mapEventSink?.success(it.toFieldJson())
        }

        // 注册生命周期
        registrar.activity().application.registerActivityLifecycleCallbacks(this)
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onCreate(savedInstanceState)
    }

    override fun onActivityStarted(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
    }

    override fun onActivityResumed(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onResume()
    }

    override fun onActivityPaused(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onPause()
    }

    override fun onActivityStopped(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle?) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onSaveInstanceState(outState)
    }

    override fun onActivityDestroyed(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onDestroy()
    }
}