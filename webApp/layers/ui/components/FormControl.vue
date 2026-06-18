<script setup lang="ts">
import { computed } from "vue";

import BaseCheckboxInput, { type BaseCheckboxInputProps } from "./BaseCheckboxInput.vue";
import type { LabelProps } from "./BaseLabel.vue";
import BaseLabel from "./BaseLabel.vue";
import BaseNumberInput, { type BaseNumberInputProps } from "./BaseNumberInput.vue";
import BaseRadioInput, { type BaseRadioInputProps } from "./BaseRadioInput.vue";
import BaseSelect, { type BaseSelectInputProps } from "./BaseSelect.vue";
import BaseTextarea, { type BaseTextareaProps } from "./BaseTextarea.vue";
import BaseTextInput, { type BaseTextInputProps } from "./BaseTextInput.vue";
import type { Options } from "./typesField.ts";

type SelectValue = string | number | (string | number)[];
type RadioValue = string | number;
type Value = string | number | boolean | SelectValue | RadioValue;

interface FormControlProps {
  label?: string;
  inputClass?: string;
  wide?: boolean;
}

type CheckboxInputProps = BaseCheckboxInputProps & {
  type: "checkbox";
  options?: never;
};

type NumberInputProps = BaseNumberInputProps & {
  type: "number";
  options?: never;
};
type SelectInputProps = BaseSelectInputProps & {
  type: "select";
};
type RadioInputProps = BaseRadioInputProps & {
  type: "radio";
};
type TextareaProps = BaseTextareaProps & {
  type: "textarea";
  options?: never;
};

type CombinedInputProps = FormControlProps &
  (
    | BaseTextInputProps
    | NumberInputProps
    | SelectInputProps
    | CheckboxInputProps
    | RadioInputProps
    | TextareaProps
  );

type InputProps = CombinedInputProps & {
  labelProps?: Omit<LabelProps, "name" | "required">;
};

defineOptions({
  inheritAttrs: false,
});

const props = withDefaults(defineProps<InputProps>(), {
  options: () => [] as Options,
  wide: true,
});

const model = defineModel<Value>();

const isTextLike = computed(() => ["text", "password", "email", "tel"].includes(props.type));
const isTextarea = computed(() => props.type === "textarea");
const isNumber = computed(() => props.type === "number");
const isSelect = computed(() => props.type === "select");
const isCheckbox = computed(() => props.type === "checkbox");
const isRadio = computed(() => props.type === "radio");
</script>

<template>
  <div
    class="grid gap-2"
    :class="classMerge(props.wide && 'w-full', props.class)"
  >
    <BaseLabel
      v-if="label"
      :name="name"
      :required="required"
      :floating="labelProps?.floating"
      v-bind="$attrs"
    >
      {{ label }}
    </BaseLabel>

    <BaseTextInput
      v-if="isTextLike"
      :required="required"
      :disabled="disabled"
      :name="name"
      :type="type as BaseTextInputProps['type']"
      :wide="(props as BaseTextInputProps).wide"
      :color="(props as BaseTextInputProps).color"
      :appearance="(props as BaseTextInputProps).appearance"
      :size="(props as BaseTextInputProps).size"
      :class="props.inputClass"
      v-model="model as string"
      v-bind="$attrs"
    />

    <BaseTextarea
      v-if="isTextarea"
      type="textarea"
      :required="required"
      :disabled="disabled"
      :name="name"
      :wide="(props as TextareaProps).wide"
      :color="(props as TextareaProps).color"
      :appearance="(props as TextareaProps).appearance"
      :size="(props as TextareaProps).size"
      :class="props.inputClass"
      v-model="model as string"
      v-bind="$attrs"
    />

    <BaseNumberInput
      v-if="isNumber"
      type="number"
      :required="required"
      :disabled="disabled"
      :name="name"
      :wide="(props as NumberInputProps).wide"
      :color="(props as NumberInputProps).color"
      :appearance="(props as NumberInputProps).appearance"
      :size="(props as NumberInputProps).size"
      :class="props.inputClass"
      v-model="model as number"
      v-bind="$attrs"
    />

    <BaseSelect
      v-if="isSelect"
      type="select"
      :required="required"
      :disabled="disabled"
      :name="name"
      :options="(props as SelectInputProps).options"
      :wide="(props as SelectInputProps).wide"
      :color="(props as SelectInputProps).color"
      :appearance="(props as SelectInputProps).appearance"
      :size="(props as SelectInputProps).size"
      :multiple="(props as SelectInputProps).multiple"
      :class="props.inputClass"
      v-model="model as SelectValue"
      v-bind="$attrs"
    />

    <BaseCheckboxInput
      v-if="isCheckbox"
      type="checkbox"
      :required="required"
      :disabled="disabled"
      :name="name"
      :color="(props as CheckboxInputProps).color"
      :size="(props as CheckboxInputProps).size"
      :class="props.inputClass"
      v-model="model as boolean"
      v-bind="$attrs"
    />

    <BaseRadioInput
      v-if="isRadio"
      type="radio"
      :required="required"
      :disabled="disabled"
      :name="name"
      :color="(props as RadioInputProps).color"
      :size="(props as RadioInputProps).size"
      :options="(props as RadioInputProps).options"
      :class="props.inputClass"
      v-model="model as RadioValue"
      v-bind="$attrs"
    />
  </div>
</template>

<style scoped></style>
