<script setup lang="ts">
import { AuthError, AuthLoading } from "@bill/Bill-shoppingList/kotlin/Bill-core";

const auth = useAuth();
</script>

<template>
  <div>
    <NuxtPwaManifest />
    <NuxtRouteAnnouncer />
    <div v-if="auth.state.value === undefined || auth.state.value === AuthLoading.getInstance()">Ładowanie...</div>
    <div v-else-if="toRaw(auth.state.value) instanceof AuthError">Error...</div>
    <NuxtLayout v-else>
      <NuxtPage />
    </NuxtLayout>
    <ClientOnly>
      <PWAUpdate />
    </ClientOnly>
  </div>
</template>

<style>
</style>