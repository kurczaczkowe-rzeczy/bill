<script lang="ts" setup>
import type { Category } from "@bill/Bill-shoppingList";

interface CategoryListItemProps {
  name: Category["name"];
  color: Category["color"];
}

const props = defineProps<CategoryListItemProps>();
const initials = computed(() => {
  if (!props.name) {
    return "";
  }

  const words = props.name.split(" ");
  if (words.length > 1) {
    return words
      .slice(0, 2)
      .map((w) => w[0])
      .join("")
      .toUpperCase();
  }

  return props.name.slice(0, 2).toUpperCase();
});
</script>
<template>
  <span class="inline-flex items-center gap-2 w-full">
    <span
      :style="{ backgroundColor: `#${color}` }"
      class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold aspect-square text-white shadow-sm"
    >
      {{ initials }}
    </span>
    <slot name="label">
      <span class="self-center">{{ name }}</span>
    </slot>
  </span>
</template>