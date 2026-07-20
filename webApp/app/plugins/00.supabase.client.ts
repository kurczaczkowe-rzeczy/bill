import type { RemoteClient } from "@bill/packages/Bill-shoppingList";

export default defineNuxtPlugin(async () => {
  const supabaseRemoteClient = (await import("@bill/packages/Bill-shoppingList/kotlin/Bill-core"))
    .supabaseRemoteClient;

  const supabaseClient = supabaseRemoteClient.get() as RemoteClient;

  return { provide: { supabaseClient } };
});
