<script setup lang="ts">
import { type TextInputVariants, textInputVariants } from "./textInputVarinats";
import type { BaseInputProps } from "./typesField";

export interface BaseTextInputProps extends BaseInputProps<string> {
  type: "text" | "password" | "email" | "tel";
  color?: TextInputVariants["color"];
  appearance?: TextInputVariants["appearance"];
  size?: TextInputVariants["size"];
  wide?: boolean;
}

type BaseTextInputEmit = (e: "update:modelValue", value: string) => void;

const textInputProps = withDefaults(defineProps<BaseTextInputProps>(), {
  wide: true,
});

const textInputAppConfig = useAppConfig().ui?.textInput ?? {};

const textInputConfig = computed(() => ({
  color: textInputProps.color ?? textInputAppConfig.color,
  appearance: textInputProps.appearance ?? textInputAppConfig.appearance,
  size: textInputProps.size ?? textInputAppConfig.size,
  wide: textInputProps.wide ?? textInputAppConfig.wide,
}));

const emit = defineEmits<BaseTextInputEmit>();

function handleInput(event: Event): void {
  const target = event.target as HTMLInputElement;
  emit("update:modelValue", target.value);
}
</script>

<template>
  <input
    :type="type"
    :value="modelValue"
    :disabled="disabled"
    :required="required"
    :class="classMerge(textInputVariants(textInputConfig), textInputProps.class)"
    @input="handleInput"
    v-bind="$attrs"
  />
</template>

<style scoped></style>
