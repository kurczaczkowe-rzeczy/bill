<script setup lang="ts" generic="TItem extends Item">
import type { Item } from "~/types/item";

interface Props {
  items: TItem[] | readonly TItem[];
}

const props = defineProps<Props>();
const slots = useSlots();
</script>

<template>
  <ul class="list">
    <slot name="static"></slot>
    <li
      class="list-row"
      v-for="item in props.items"
      :key="item.id"
      v-if="props.items?.length"
    >
      <slot name="item" :item="item"></slot>
    </li>
    <li class="list-row" v-if="!props.items?.length && slots.empty">
      <slot name="empty"></slot>
    </li>
  </ul>
</template>

<style scoped>

</style>