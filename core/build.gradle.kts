import love.forte.plugin.suspendtrans.configuration.SuspendTransformConfigurations.kotlinJsExportIgnoreClassInfo
import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JsModuleKind
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import java.util.Properties

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
    alias(libs.plugins.suspend.transform)
    alias(libs.plugins.kotlin.serialization)
    alias(libs.plugins.buildKonfig)
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
            commonWebpackConfig {
                sourceMaps = true
            }
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

fun loadEnv(envName: String): Properties {
    val props = Properties()
    val file = rootProject.file("core/.env.$envName")
    if (file.exists()) {
        file.inputStream().use { props.load(it) }
    }

    System.getenv().forEach { (k, v) -> if (k.startsWith("SUPABASE_")) props[k] = v }
    return props
}

val selectedEnv: String = (project.findProperty("env") as String?)
    ?: System.getenv("ENV")
    ?: "dev"

val envProps = loadEnv(selectedEnv)

buildkonfig {
    packageName = "pl.kurczaczkowe.bill.core.config"
    objectName = "BuildKonfig"
    exposeObjectWithName = "BuildKonfig"

    defaultConfigs {
        buildConfigField(
            com.codingfeline.buildkonfig.compiler.FieldSpec.Type.STRING,
            "SUPABASE_URL",
            envProps.getProperty("SUPABASE_URL") ?: error("Missing SUPABASE_URL for env=$selectedEnv")
        )
        buildConfigField(
            com.codingfeline.buildkonfig.compiler.FieldSpec.Type.STRING,
            "SUPABASE_KEY",
            envProps.getProperty("SUPABASE_KEY") ?: error("Missing SUPABASE_KEY for env=$selectedEnv")
        )
        buildConfigField(
            com.codingfeline.buildkonfig.compiler.FieldSpec.Type.STRING,
            "ENVIRONMENT",
            selectedEnv
        )
    }
}