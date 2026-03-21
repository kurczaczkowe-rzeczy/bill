<script lang="ts" setup>
import BaseButton from "@ui/components/BaseButton.vue";

interface Props {
  open?: boolean;
  defaultOpen?: boolean;
  toggleable?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  toggleable: true,
});
const isOpen = defineModel<boolean>("open");

if (isOpen.value === undefined) {
  isOpen.value = props.defaultOpen ?? false;
}

watchEffect(() => {
  if (props.open !== undefined) {
    isOpen.value = props.open;
  }
});
</script>

<template>
  <div class="overflow-y-hidden">
    <BaseButton
      v-if="toggleable"
      :aria-expanded="isOpen"
      class="collapse-title cursor-pointer"
      @click="isOpen = !isOpen"
    >
      <slot name="summary"></slot>
    </BaseButton>
    <div
      v-else
    >
      <slot name="summary"></slot>
    </div>
    <div
      :class="isOpen ? 'grid-rows-[1fr]' : 'grid-rows-[0fr]'"
      class="grid transition-[grid-template-rows] duration-300"
    >
      <div class="overflow-y-hidden"><slot name="content"></slot></div>
    </div>
  </div>
</template>
