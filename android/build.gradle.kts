allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            
            // Force all subprojects to compile against SDK 36
            android.compileSdkVersion(36)

            if (android.namespace == null) {
                android.namespace = "com.example.adscreen_revenue.${project.name.replace('-', '_')}"
            }
            // Fix for isar_flutter_libs and other plugins that still have 'package' in Manifest
            android.sourceSets.getByName("main").manifest.srcFile("src/main/AndroidManifest.xml")
            
            project.tasks.configureEach {
                if (name.contains("processDebugManifest") || name.contains("processReleaseManifest")) {
                    doFirst {
                        val manifestFile = android.sourceSets.getByName("main").manifest.srcFile
                        if (manifestFile.exists()) {
                            val content = manifestFile.readText()
                            if (content.contains("package=")) {
                                val newContent = content.replace(Regex("package=\"[^\"]*\""), "")
                                manifestFile.writeText(newContent)
                            }
                        }
                    }
                }
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
