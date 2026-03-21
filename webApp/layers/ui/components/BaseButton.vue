<script setup lang="ts">
import { type ButtonVariants, buttonVariants } from "@ui/components/buttonVariants";
import { classMerge } from "@ui/utils/classMerge";
import type { RouteLocationRaw } from "vue-router";

interface BaseButtonProps {
  class?: string;
  href?: string;
  ariaLabel?: string;
  disabled?: boolean;
  to?: RouteLocationRaw;
  activeClass?: string;
  color?: ButtonVariants["color"];
  appearance?: ButtonVariants["appearance"];
  size?: ButtonVariants["size"];
  modifier?: ButtonVariants["modifier"];
  circle?: boolean;
  square?: boolean;
}

const buttonProps = defineProps<BaseButtonProps>();

const isLink = computed(() => buttonProps.to);
</script>

<template>
  <!-- NuxtLink -->
  <NuxtLink v-if="isLink" :to="to" custom v-slot="{ href, navigate, isActive }">
    <a
      :href="href"
      @click="navigate"
      :class="classMerge(
        buttonVariants(buttonProps),
        isActive && (activeClass || 'btn-active'),
        buttonProps.class
      )"
      :aria-label="ariaLabel"
    >
      <slot />
    </a>
  </NuxtLink>

  <!-- a -->
  <a
    v-else-if="href"
    :href="href"
    :class="classMerge(buttonVariants(buttonProps), buttonProps.class)"
    :aria-label="ariaLabel"
  >
    <slot />
  </a>

  <!-- button -->
  <button
    v-else
    :class="classMerge(buttonVariants(buttonProps), buttonProps.class)"
    :disabled="disabled"
    :aria-label="ariaLabel"
  >
    <slot />
  </button>
</template>
