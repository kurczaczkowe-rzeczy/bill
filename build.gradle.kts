import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

plugins {
    // this is necessary to avoid the plugins to be loaded multiple times
    // in each subproject's classloader
    alias(libs.plugins.androidApplication) apply false
    alias(libs.plugins.androidLibrary) apply false
    alias(libs.plugins.composeMultiplatform) apply false
    alias(libs.plugins.composeCompiler) apply false
    alias(libs.plugins.kotlinMultiplatform) apply false
    alias(libs.plugins.kotlin.serialization) apply false
    alias(libs.plugins.android.kotlin.multiplatform.library) apply false
    alias(libs.plugins.jetbrains.kotlin.jvm) apply false
    alias(libs.plugins.android.lint) apply false
}

val baseVersion = property("VERSION_NAME") as String
val groupId = property("GROUP") as String

val isDevBuild = gradle.startParameter.taskNames.any {
    it.contains("Development", ignoreCase = true)
}

val timestamp = LocalDateTime.now()
    .format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))

allprojects {
    group = groupId
    version = if (isDevBuild) {
        "$baseVersion-dev.$timestamp"
    } else {
        baseVersion
    }
}