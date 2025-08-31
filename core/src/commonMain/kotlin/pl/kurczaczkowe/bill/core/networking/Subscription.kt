package pl.kurczaczkowe.bill.core.networking

import io.github.jan.supabase.realtime.RealtimeChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlin.js.JsExport

@JsExport
class Subscription internal constructor(
    private val job: Job,
    private val channel: RealtimeChannel,
    private val channelName: String,
    private val scope: CoroutineScope,
    private val onUnsubscribe: () -> Unit
) {
    fun unsubscribe() {
        onUnsubscribe()
    }

    fun isActive(): Boolean = job.isActive

    fun getChannelName(): String = channelName

    internal fun cleanup() {
        job.cancel()

        scope.launch {
            try {
                job.join()

                channel.unsubscribe()
            } catch (e: Exception) {
                println("Error during cleanup of channel $channelName: ${e.message}")
            }
        }
    }
}