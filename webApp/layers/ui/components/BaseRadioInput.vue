<script setup lang="ts">
import type { BaseInputProps, Options } from "../types/typesField.ts";
import { type RadioVariants, radioVariants } from "./radioVariants";

type Value = string | number;

export interface BaseRadioInputProps extends BaseInputProps<Value> {
  type: "radio";
  options: Options;
  color?: RadioVariants["color"];
  size?: RadioVariants["size"];
}

type BaseRadioInputEmit = (e: "update:modelValue", value: Value) => void;

const props = withDefaults(defineProps<BaseRadioInputProps>(), { options: () => [] as Options });
const emit = defineEmits<BaseRadioInputEmit>();

const radioAppConfig = useAppConfig().ui?.radio ?? {};

const radioConfig = computed(() => ({
  color: props.color ?? radioAppConfig.color,
  size: props.size ?? radioAppConfig.size,
}));

const handleChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  emit("update:modelValue", target.value);
};
</script>

<template>
  <div class="flex flex-wrap gap-2">
    <label
      v-for="option in options"
      :key="`${name}-${option.value}`"
      class="flex items-center gap-2 cursor-pointer"
    >
      <input
        type="radio"
        :name="name"
        :value="option.value"
        :checked="modelValue === option.value"
        :disabled="disabled"
        :required="required"
        :class="classMerge(radioVariants(radioConfig), props.class)"
        @change="handleChange"
      />
      {{ option.label }}
    </label>
  </div>
</template>

<style scoped></style>
