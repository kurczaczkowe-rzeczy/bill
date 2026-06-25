<script setup lang="ts">
import type { BaseInputProps, Options } from "../types/typesField.ts";
import { type SelectVariants, selectVariants } from "./selectVariants";

type Value = string | number | (string | number)[];

export interface BaseSelectInputProps extends BaseInputProps<Value> {
  options: Options;
  multiple?: boolean;
  color?: SelectVariants["color"];
  appearance?: SelectVariants["appearance"];
  size?: SelectVariants["size"];
  wide?: boolean;
}

type BaseSelectEmit = (e: "update:modelValue", value: Value) => void;

const props = withDefaults(defineProps<BaseSelectInputProps>(), {
  options: () => [] as Options,
  wide: true,
});
const emit = defineEmits<BaseSelectEmit>();

const selectAppConfig = useAppConfig().ui?.select ?? {};

const selectConfig = computed(() => ({
  color: props.color ?? selectAppConfig.color,
  appearance: props.appearance ?? selectAppConfig.appearance,
  size: props.size ?? selectAppConfig.size,
  wide: props.wide ?? selectAppConfig.wide,
}));

const handleChange = (event: Event) => {
  const target = event.target as HTMLSelectElement;
  if (props.multiple) {
    emit(
      "update:modelValue",
      Array.from(target.selectedOptions).map((o) => o.value),
    );
  } else {
    emit("update:modelValue", target.value);
  }
};
</script>

<template>
  <select
    :value="modelValue"
    :disabled="disabled"
    :required="required"
    :multiple="multiple"
    :class="classMerge(selectVariants(selectConfig), props.class)"
    @change="handleChange"
    v-bind="$attrs"
  >
<!--    <option-->
<!--      v-if="placeholder"-->
<!--      value=""-->
<!--      disabled-->
<!--      selected-->
<!--    >-->
<!--      {{ placeholder }}-->
<!--    </option>-->
    <option
      v-for="option in options"
      :key="`${name}-${option.value}`"
      :value="option.value"
    >
      {{ option.label }}
    </option>
  </select>
</template>

<style scoped></style>
