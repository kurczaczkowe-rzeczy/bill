<script setup lang="ts">
import { type TextareaVariants, textareaVariants } from "./textareaVariants";
import type { BaseInputProps } from "./typesField";

export interface BaseTextareaProps extends BaseInputProps<string> {
  color?: TextareaVariants["color"];
  appearance?: TextareaVariants["appearance"];
  size?: TextareaVariants["size"];
  wide?: boolean;
}

type BaseTextareaEmit = (e: "update:modelValue", value: string) => void;

const props = withDefaults(defineProps<BaseTextareaProps>(), {
  wide: true,
});
const emit = defineEmits<BaseTextareaEmit>();

const textareaAppConfig = useAppConfig().ui?.textarea ?? {};

const textareaConfig = computed(() => ({
  color: props.color ?? textareaAppConfig.color,
  appearance: props.appearance ?? textareaAppConfig.appearance,
  size: props.size ?? textareaAppConfig.size,
  wide: props.wide ?? textareaAppConfig.wide,
}));

const handleInput = (event: Event) => {
  const target = event.target as HTMLTextAreaElement;
  emit("update:modelValue", target.value);
};
</script>

<template>
  <textarea
    :value="modelValue"
    :disabled="disabled"
    :required="required"
    :class="classMerge(textareaVariants(textareaConfig), props.class)"
    @input="handleInput"
    v-bind="$attrs"
  />
</template>

<style scoped></style>
