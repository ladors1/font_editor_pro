plugins {
    // نسخه‌ها حذف شده‌اند تا از نسخه پیش‌فرض محیط استفاده شود و تضاد حل شود
   id("dev.flutter.flutter-gradle-plugin") apply false
   id("com.android.application") version "8.7.3" apply false
   id("org.jetbrains.kotlin.android") version "1.8.0" apply false
}


tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
