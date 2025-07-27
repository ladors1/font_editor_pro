plugins {
    // نسخه‌ها حذف شده‌اند تا از نسخه پیش‌فرض محیط استفاده شود و تضاد حل شود
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
