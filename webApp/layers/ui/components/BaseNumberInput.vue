<script setup lang="ts">
import { type NumberInputVariants, numberInputVariants } from './numberInputVarinats'
import type { BaseInputProps } from './typesField'

export interface BaseNumberInputProps extends BaseInputProps<number> {
  color?: NumberInputVariants['color'];
  appearance?: NumberInputVariants['appearance'];
  size?: NumberInputVariants['size'];
  wide?: boolean;
}

const numberInputProps = withDefaults(defineProps<BaseNumberInputProps>(), {
});

const numberInputAppConfig = useAppConfig().ui?.numberInput ?? {};

const numberInputConfig = computed(() => ({
  color: numberInputProps.color ?? numberInputAppConfig.color,
  appearance: numberInputProps.appearance ?? numberInputAppConfig.appearance,
  size: numberInputProps.size ?? numberInputAppConfig.size,
  wide: numberInputProps.wide ?? numberInputAppConfig.wide,
}))

type BaseNumberInputEmit = (e: "update:modelValue", value: number) => void;

const emit = defineEmits<BaseNumberInputEmit>();

const handleInput = (event: Event): void => {
  const target = event.target as HTMLInputElement;
  emit("update:modelValue", target.value as unknown as number);
};
</script>

<template>
  <input
    type="number"
    :value="modelValue"
    :disabled="disabled"
    :required="required"
    :class="classMerge(numberInputVariants(numberInputConfig), numberInputProps.class)"
    @input="handleInput"
    v-bind="$attrs"
  />
</template>

<style scoped></style>
