package pl.kurczaczkowe.bill.core.networking

import io.github.jan.supabase.auth.Auth
import io.github.jan.supabase.createSupabaseClient
import io.github.jan.supabase.postgrest.Postgrest
import io.github.jan.supabase.realtime.Realtime
import pl.kurczaczkowe.bill.core.config.BuildKonfig

val supabaseClient by lazy {
    createSupabaseClient(
        supabaseUrl = BuildKonfig.SUPABASE_URL,
        supabaseKey = BuildKonfig.SUPABASE_KEY,
    ) {
        install(Auth)
        install(Realtime)
        install(Postgrest)
    }
}