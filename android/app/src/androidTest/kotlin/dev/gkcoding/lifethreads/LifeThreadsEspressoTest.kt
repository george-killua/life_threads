package dev.gkcoding.lifethreads

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.test.core.app.ApplicationProvider
import androidx.test.espresso.Espresso.onView
import androidx.test.espresso.assertion.ViewAssertions.matches
import androidx.test.espresso.matcher.ViewMatchers.isDisplayed
import androidx.test.espresso.matcher.ViewMatchers.isRoot
import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class LifeThreadsEspressoTest {
    @get:Rule
    val activityRule = ActivityScenarioRule(MainActivity::class.java)

    @Test
    fun appLaunchesMainActivity() {
        onView(isRoot()).check(matches(isDisplayed()))

        activityRule.scenario.onActivity { activity ->
            assertEquals("dev.gkcoding.lifethreads", activity.packageName)
            assertFalse(activity.isFinishing)
        }
    }

    @Test
    fun requiredAndroidPermissionsAreDeclared() {
        val context = ApplicationProvider.getApplicationContext<Context>()
        val permissions = context.packageManager
            .getPackageInfo(context.packageName, PackageManager.GET_PERMISSIONS)
            .requestedPermissions
            ?.toSet()
            .orEmpty()

        assertTrue(permissions.contains(Manifest.permission.INTERNET))
        assertTrue(permissions.contains(Manifest.permission.CAMERA))
        assertTrue(permissions.contains(Manifest.permission.READ_CONTACTS))
        assertTrue(permissions.contains(Manifest.permission.READ_MEDIA_IMAGES))
        assertTrue(permissions.contains(Manifest.permission.ACCESS_MEDIA_LOCATION))
        assertTrue(permissions.contains("android.permission.READ_MEDIA_VISUAL_USER_SELECTED"))
    }

    @Test
    fun lifeThreadsShareLinksResolveToTheApp() {
        val context = ApplicationProvider.getApplicationContext<Context>()
        assertShareLinkRegistered(context, "https://gkcoding.dev/lifethreads/share/test-share")
        assertShareLinkRegistered(context, "https://lifethreads.gkcoding.dev/share/test-share")
    }

    private fun assertShareLinkRegistered(context: Context, url: String) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            .addCategory(Intent.CATEGORY_BROWSABLE)
            .addCategory(Intent.CATEGORY_DEFAULT)
            .setPackage(context.packageName)
        val handlers = context.packageManager.queryIntentActivities(
            intent,
            PackageManager.MATCH_DEFAULT_ONLY,
        )
        val packages = handlers.map { it.activityInfo.packageName }.toSet()

        assertTrue(packages.contains(context.packageName))
    }
}
