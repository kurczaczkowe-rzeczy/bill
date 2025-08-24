package pl.kurczaczkowe.bill.core.networking

import io.github.jan.supabase.auth.Auth
import io.github.jan.supabase.createSupabaseClient
import io.github.jan.supabase.postgrest.Postgrest
import io.github.jan.supabase.realtime.Realtime

val supabaseClient by lazy {
    createSupabaseClient(
        supabaseUrl = "https://xselopsaykimcplkdros.supabase.co",
        supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhzZWxvcHNheWtpbWNwbGtkcm9zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4NTE3MDEsImV4cCI6MjA1ODQyNzcwMX0.C9ZGtBhxiCM8xNujqd9NT-6G5fpEZ0t5CkjMBZzg6Ok"
    ) {
        install(Auth)
        install(Realtime)
        install(Postgrest)
    }
}