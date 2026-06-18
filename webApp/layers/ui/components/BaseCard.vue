<script setup lang="ts">
import { classMerge } from "@ui/utils/classMerge";

import { type CardVariants, cardVariants } from "./cardVarinats";

export interface BaseCardProps {
  appearance?: CardVariants["appearance"];
  size?: CardVariants["size"];
  class?: string;
}

const cardProps = withDefaults(defineProps<BaseCardProps>(), {});

const cardAppConfig = useAppConfig().ui?.card ?? {};

const cardConfig = computed(() => ({
  appearance: cardProps.appearance ?? cardAppConfig.appearance,
  size: cardProps.size ?? cardAppConfig.size,
}));
</script>

<template>
  <div :class="classMerge(cardVariants(cardConfig), cardProps.class)">
    <div class="card-body bg-base-100 rounded-box shadow-md w-full">
      <div v-if="$slots.title" class="card-title">
        <slot name="title" />
      </div>
      <slot />
    </div>
  </div>
</template>

<style scoped>

</style>