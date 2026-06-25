<script setup lang="ts">
import type { BaseInputProps } from "../types/typesField";
import { type CheckboxVariants, checkboxVariants } from "./checkboxVarinats";

export interface BaseCheckboxInputProps extends BaseInputProps<boolean> {
  // ToDo: handle tristate
  // ToDo: should value be in separate from checked?
  color?: CheckboxVariants["color"];
  size?: CheckboxVariants["size"];
}

type BaseCheckboxInputEmit = (e: "update:modelValue", value: boolean) => void;

const checkboxProps = withDefaults(defineProps<BaseCheckboxInputProps>(), {});

const checkboxAppConfig = useAppConfig().ui?.checkbox ?? {};

const checkboxConfig = computed(() => ({
  color: checkboxProps.color ?? checkboxAppConfig.color,
  size: checkboxProps.size ?? checkboxAppConfig.size,
}));

const emit = defineEmits<BaseCheckboxInputEmit>();

const handleInput = (event: Event) => {
  const target = event.target as HTMLInputElement;
  emit("update:modelValue", target.checked);
};
</script>

<template>
  <input
    type="checkbox"
    :value="modelValue"
    :checked="modelValue"
    :disabled="disabled"
    :class="classMerge(checkboxVariants(checkboxConfig), checkboxProps.class)"
    @input="handleInput"
    v-bind="$attrs"
  />
</template>

<style scoped></style>
