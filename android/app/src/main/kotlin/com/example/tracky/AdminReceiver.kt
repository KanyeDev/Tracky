package com.example.tracky

import android.annotation.TargetApi
import android.app.admin.DeviceAdminReceiver
import android.os.Build

@TargetApi(Build.VERSION_CODES.FROYO)
class AdminReceiver : DeviceAdminReceiver() {
}
