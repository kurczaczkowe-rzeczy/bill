<script setup lang="ts">
interface BaseFieldsetProps {
  title?: string;
}

defineProps<BaseFieldsetProps>();
</script>

<template>
<fieldset class="fieldset border border-primary/25 rounded-lg px-4 pb-4">
  <legend class="fieldset-legend" v-if="title">{{ title }}</legend>
  <slot />
</fieldset>
</template>

<style scoped>

</style>