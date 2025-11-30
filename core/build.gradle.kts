import love.forte.plugin.suspendtrans.configuration.SuspendTransformConfigurations.kotlinJsExportIgnoreClassInfo
import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JsModuleKind
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
    alias(libs.plugins.suspend.transform)
    alias(libs.plugins.kotlin.serialization)
}

kotlin {
    compilerOptions {
        freeCompilerArgs.add("-Xes-long-as-bigint")
    }

    androidTarget {
        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }

    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach { iosTarget ->
        iosTarget.binaries.framework {
            baseName = "core"
            isStatic = true
        }
    }

    js(IR) {
        useEsModules()
        browser {
            compilerOptions {
                target = "es2015"
                moduleKind.set(JsModuleKind.MODULE_ES)
            }
        }
        binaries.library()
        generateTypeScriptDefinitions()
        compilations.all {
            packageJson {
                customField("types", "kotlin/$name.d.mts")
                customField("type", "module")
            }
        }
    }

    sourceSets {
        androidMain {
            dependencies {

                api(libs.ktor.client.okhttp)
            }
        }
        commonMain {
            dependencies {

                implementation(libs.kotlin.stdlib)

                api(project.dependencies.platform(libs.supabase.bom))
                api(libs.supabase.postgres.kt)
                api(libs.supabase.auth.kt)
                api(libs.supabase.realtime.kt)

                api(libs.bundles.ktor)
            }
        }

        jsMain {
            dependencies {
                api(libs.ktor.client.js)
            }
        }

        nativeMain {
            dependencies {
                api(libs.ktor.client.darwin)
            }
        }

        iosMain {
            dependencies {
            }
        }

        all {
            languageSettings.apply {
                optIn("kotlin.js.ExperimentalJsExport")
                optIn("kotlin.js.ExperimentalJsFileName")
            }
        }
    }

}

android {
    namespace = "pl.kurczaczkowe.bill"
    compileSdk = 35

    buildTypes
}


suspendTransformPlugin {
    transformers {
        addJsPromise {
            addCopyAnnotationExclude {
                from(kotlinJsExportIgnoreClassInfo)
            }
        }
    }
}