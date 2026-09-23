// Declared (without version) so this root script can reference Kotlin task
// types; the version comes from settings.gradle.kts and is unchanged.
plugins {
    id("org.jetbrains.kotlin.android") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
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

// flutter_facebook_auth's Java and Kotlin tasks must share one JVM target.
// Its Android build files pin Java while Kotlin compiles with the JDK 21
// toolchain, and Kotlin 2.x fails the build on that inconsistency.
// Align both sides to 21 after every project has been configured (the
// "preferably 21" convention: Kotlin already targets 21 here).
// Other modules keep their own, already-consistent targets.
gradle.projectsEvaluated {
    val facebookProject = rootProject.findProject(":flutter_facebook_auth")
        ?: return@projectsEvaluated
    facebookProject.tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_21.toString()
        targetCompatibility = JavaVersion.VERSION_21.toString()
    }
    facebookProject.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>()
        .configureEach {
            compilerOptions.jvmTarget
                .set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21)
        }
}
