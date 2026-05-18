<script setup lang="ts">
const route = useRoute()
const type = route.query.type

if (type === 'recovery') {
  await navigateTo('/reset-password')
} else {
  await navigateTo('/')
}
</script>

<template>Redirecting...</template>