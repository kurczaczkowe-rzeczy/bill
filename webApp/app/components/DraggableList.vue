<script setup lang="ts" generic="TItem extends Item">
import type { MoveEvent } from "sortablejs";
import type { LiHTMLAttributes } from "vue";
import { type SortableEvent, type UseDraggableOptions, VueDraggable } from "vue-draggable-plus";

import type { Item } from "~/types/item";

interface Props {
  items: TItem[] | readonly TItem[];
  draggableOptions?: UseDraggableOptions<TItem>;
  itemProps?: (item: TItem) => LiHTMLAttributes;
}

const props = defineProps<Props>();
const slots = defineSlots();

const propsDraggableOptions = computed(() => {
  const {
    onUpdate,
    onStart,
    onAdd,
    onRemove,
    onChoose,
    onUnchoose,
    onEnd,
    onSort,
    onFilter,
    onClone,
    onMove,
    onChange,
    ...options
  } = props.draggableOptions ?? {};
  return options;
});

const emit = defineEmits<{
  update: [event: SortableEvent];
  start: [event: SortableEvent];
  add: [event: SortableEvent];
  remove: [event: SortableEvent];
  choose: [event: SortableEvent];
  unchoose: [event: SortableEvent];
  end: [event: SortableEvent];
  sort: [event: SortableEvent];
  filter: [event: SortableEvent];
  clone: [event: SortableEvent];
  move: [event: MoveEvent, originalEvent: Event];
  change: [event: SortableEvent];
}>();

function onUpdate(e: SortableEvent) {
  emit("update", e);
}
function onStart(e: SortableEvent) {
  emit("start", e);
}
function onAdd(e: SortableEvent) {
  emit("add", e);
}
function onRemove(e: SortableEvent) {
  emit("remove", e);
}
function onChoose(e: SortableEvent) {
  emit("choose", e);
}
function onUnchoose(e: SortableEvent) {
  emit("unchoose", e);
}
function onEnd(e: SortableEvent) {
  emit("end", e);
}
function onSort(e: SortableEvent) {
  emit("sort", e);
}
function onFilter(e: SortableEvent) {
  emit("filter", e);
}
function onClone(e: SortableEvent) {
  emit("clone", e);
}
function onMove(evt: MoveEvent, originalEvent: Event): boolean | void | 1 | -1 {
  emit("move", evt, originalEvent);
}
function onChange(e: SortableEvent) {
  emit("change", e);
}
</script>

<template>
  <VueDraggable
    v-model="props.items"
    v-bind="propsDraggableOptions"
    @update="onUpdate"
    @start="onStart"
    @add="onAdd"
    @remove="onRemove"
    @choose="onChoose"
    @unchoose="onUnchoose"
    @end="onEnd"
    @sort="onSort"
    @filter="onFilter"
    @clone="onClone"
    @move="onMove"
    @change="onChange"
    class="list"
    tag="ul"
  >
    <li
      class="list-row"
      v-for="item in props.items"
      v-bind="props.itemProps?.(item)"
      :key="item.id"
      v-if="props.items?.length"
    >
      <slot name="item" :item="item"></slot>
    </li>
    <li class="list-row" v-if="!props.items?.length && slots.empty">
      <slot name="empty"></slot>
    </li>
  </VueDraggable>
</template>

<style scoped>

</style>