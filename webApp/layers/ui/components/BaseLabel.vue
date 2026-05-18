<script setup lang="ts">
import { labelVariants } from "./labelVarinats";
import type { FieldProps } from "./typesField.ts";

export interface LabelProps extends FieldProps {
  floating?: boolean;
  class?: string;
}

const labelProps = defineProps<LabelProps>();

const labelAppConfig = useAppConfig().ui?.label ?? {};

const labelConfig = computed(() => ({
  floating: labelProps.floating ?? labelAppConfig.floating,
}));
</script>

<template>
  <label
    :for="name"
    :class="classMerge(labelVariants(labelConfig), labelProps.class)"
  >
    <slot></slot>
    <span
      v-if="required"
      class="text-error"
    >
      *
    </span>
  </label>
</template>

<style scoped></style>
