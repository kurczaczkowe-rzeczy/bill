<script setup lang="ts">
</script>

<template>
  <div>
    <NuxtPwaManifest />
    <NuxtRouteAnnouncer />
    <NuxtPage />
    <ClientOnly>
      <PWAUpdate />
    </ClientOnly>
  </div>
</template>

<style>
</style>