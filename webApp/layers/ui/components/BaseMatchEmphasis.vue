<script setup lang="ts">
import { computed } from "vue";

export type EmphasisVariant = "bold" | "italic" | "underline" | "mark" | "custom";

export interface BaseMatchEmphasisProps {
  text: string;
  query: string;
  variant?: EmphasisVariant;
  emphasisClass?: string;
  onlyFirstMatch?: boolean;
}

const props = withDefaults(defineProps<BaseMatchEmphasisProps>(), {
  variant: "bold",
  onlyFirstMatch: true,
});

const searchRegex = computed(() => {
  if (!props.query) return null;
  return new RegExp(
    `(${props.query.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")})`,
    props.onlyFirstMatch ? "i" : "gi",
  );
});

const parts = computed(() => {
  if (!searchRegex.value) return [{ text: props.text, match: false }];
  return props.text.split(searchRegex.value).map((part) => ({
    text: part,
    match: searchRegex.value.test(part),
  }));
});

const emphasisTag: Record<EmphasisVariant, string> = {
  bold: "b",
  italic: "i",
  underline: "u",
  mark: "mark",
  custom: "span",
};
</script>

<template>
    <template v-for="(part, i) in parts" :key="i">
      <component
        :is="emphasisTag[variant]"
        v-if="part.match"
        :class="emphasisClass"
      >{{ part.text }}</component>
      <template v-else>{{ part.text }}</template>
    </template>
</template>
