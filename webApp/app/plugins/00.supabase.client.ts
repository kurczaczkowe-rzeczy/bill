import type { RemoteClient } from "@bill/Bill-shoppingList"

export default defineNuxtPlugin(async () => {
  const supabaseRemoteClient = (await import("@bill/Bill-shoppingList/kotlin/Bill-core")).supabaseRemoteClient;

  const supabaseClient = supabaseRemoteClient.get() as RemoteClient;

  return { provide: { supabaseClient } };
});
