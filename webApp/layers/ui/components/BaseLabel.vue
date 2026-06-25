<script setup lang="ts">
import type { FieldProps } from "../types/typesField.ts";
import { labelVariants } from "./labelVarinats";

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
