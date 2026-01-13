<script setup lang="ts" generic="TItem extends Item">
import type { MoveEvent } from "sortablejs";
import type { LiHTMLAttributes } from "vue";
import {
  type DraggableEvent,
  type SortableEvent,
  type UseDraggableOptions,
  VueDraggable,
} from "vue-draggable-plus";

import type { Item } from "~/types/item";

type SortableEventHandler = (e: SortableEvent) => void;
type DraggableOptions = Partial<
  Omit<
    UseDraggableOptions<TItem>,
    | "onUpdate"
    | "onStart"
    | "onAdd"
    | "onRemove"
    | "onChoose"
    | "onUnchoose"
    | "onEnd"
    | "onSort"
    | "onFilter"
    | "onClone"
    | "onMove"
    | "onChange"
  >
>;

interface Props extends /* @vue-ignore */ DraggableOptions {
  items: TItem[] | readonly TItem[];
  itemProps?: (item: TItem) => LiHTMLAttributes;
}

const props = defineProps<Props>();
const slots = defineSlots();

const localItems = ref<TItem[]>([...props.items]);

watch(
  () => props.items,
  (newItems) => {
    localItems.value = [...newItems];
  },
  { deep: true },
);

const propsDraggableOptions = computed(() => {
  const { items, itemProps, ...options } = props ?? {};
  return options;
});

const emit = defineEmits<{
  update: [event: DraggableEvent<TItem>];
  start: [event: DraggableEvent<TItem>];
  add: [event: DraggableEvent<TItem>];
  remove: [event: DraggableEvent<TItem>];
  choose: [event: DraggableEvent<TItem>];
  unchoose: [event: DraggableEvent<TItem>];
  end: [event: DraggableEvent<TItem>];
  sort: [event: DraggableEvent<TItem>];
  filter: [event: DraggableEvent<TItem>];
  clone: [event: DraggableEvent<TItem>];
  move: [event: MoveEvent, originalEvent: Event];
  change: [event: DraggableEvent<TItem>];
}>();

function onUpdate(e: DraggableEvent<TItem>) {
  emit("update", e);
}
function onStart(e: DraggableEvent<TItem>) {
  emit("start", e);
}
function onAdd(e: DraggableEvent<TItem>) {
  emit("add", e);
}
function onRemove(e: DraggableEvent<TItem>) {
  emit("remove", e);
}
function onChoose(e: DraggableEvent<TItem>) {
  emit("choose", e);
}
function onUnchoose(e: DraggableEvent<TItem>) {
  emit("unchoose", e);
}
function onEnd(e: DraggableEvent<TItem>) {
  emit("end", e);
}
function onSort(e: DraggableEvent<TItem>) {
  emit("sort", e);
}
function onFilter(e: DraggableEvent<TItem>) {
  emit("filter", e);
}
function onClone(e: DraggableEvent<TItem>) {
  emit("clone", e);
}
function onMove(evt: MoveEvent, originalEvent: Event) {
  emit("move", evt, originalEvent);
}
function onChange(e: DraggableEvent<TItem>) {
  emit("change", e);
}
</script>

<template>
  <VueDraggable
    v-model="localItems"
    v-bind="propsDraggableOptions"
    @update="onUpdate as SortableEventHandler"
    @start="onStart as SortableEventHandler"
    @add="onAdd as SortableEventHandler"
    @remove="onRemove as SortableEventHandler"
    @choose="onChoose as SortableEventHandler"
    @unchoose="onUnchoose as SortableEventHandler"
    @end="onEnd as SortableEventHandler"
    @sort="onSort as SortableEventHandler"
    @filter="onFilter as SortableEventHandler"
    @clone="onClone as SortableEventHandler"
    @move="onMove"
    @change="onChange as SortableEventHandler"
    target=".transition-group"
  >
    <TransitionGroup
      type="transition"
      tag="ul"
      name="fade"
      class="transition-group list"
    >
      <li
        class="list-row"
        v-for="item in localItems"
        v-bind="props.itemProps?.(item as TItem)"
        :key="item.id.toString()"
        v-if="localItems?.length"
      >
        <slot name="item" :item="item"></slot>
      </li>
      <li class="list-row" v-if="!localItems?.length && slots.empty">
        <slot name="empty"></slot>
      </li>
    </TransitionGroup>
  </VueDraggable>
</template>

<style scoped>
.fade-move,
.fade-enter-active,
.fade-leave-active {
  transition: all 200ms cubic-bezier(0.55, 0, 0.1, 1);
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: scaleY(0.01) translate(30px, 0);
}

.fade-leave-active {
  position: absolute;
}
</style>