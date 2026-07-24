<script setup lang="ts" generic="TItem extends Item">
import type { Item } from '@ui/types/item'
import type { MoveEvent } from "sortablejs";
import type { HTMLAttributes, LiHTMLAttributes } from "vue";
import {
  type DraggableEvent,
  type SortableEvent,
  type UseDraggableOptions,
  VueDraggable,
} from "vue-draggable-plus";

import type { Item } from "~~/layers/ui/types/item";

// biome-ignore lint/correctness/noUnusedVariables: It is used but biome not recognize it
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
  itemProps?: (item: TItem) => LiHTMLAttributes;
  listProps?: HTMLAttributes
  wrapperClass?: string;
  itemClass?: string
  debug?: boolean | string
}

const props = withDefaults(defineProps<Props>(), {
  wrapperClass: "list",
  itemClass: "list-row",
});
const slots = defineSlots();

const items = defineModel<TItem[]>({ default: () => [] as TItem[] });

const propsDraggableOptions = computed(() => {
  const { itemProps, wrapperClass, itemClass, ...options } = props ?? {};
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

function clone(item: TItem) {
  if (props.clone) {
    return props.clone(item)
  }

  if (item === undefined || item === null) {
    return item;
  }

  const rawItem = toRaw(item);

  return structuredClone(rawItem);
}
</script>

<template>
  <VueDraggable
    v-model="items"
    v-bind="propsDraggableOptions"
    :clone="clone"
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
    class="overflow-y-auto"
  >
    <TransitionGroup
      type="transition"
      tag="ul"
      name="fade"
      class="transition-group"
      :class="wrapperClass"
      v-bind="props.listProps"
    >
      <li
        :class="itemClass"
        v-for="item in items"
        v-bind="props.itemProps?.(item as TItem)"
        :key="item.id?.toString()"
        v-if="items?.length"
      >
        <slot name="item" :item="item"></slot>
      </li>
      <li class="list-row" v-if="!items?.length && slots.empty">
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