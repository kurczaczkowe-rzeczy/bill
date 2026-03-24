<script setup lang="ts">
import {
  type ButtonVariants,
  buttonVariants,
  type UiLayerButtonConfig,
} from "@ui/components/buttonVariants";
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

const buttonAppConfig = useAppConfig().ui?.button ?? {};

const buttonConfig = computed(
  () =>
    ({
      color: buttonProps.color ?? buttonAppConfig.color,
      appearance: buttonProps.appearance ?? buttonAppConfig.appearance,
      size: buttonProps.size ?? buttonAppConfig.size,
      modifier: buttonProps.modifier ?? buttonAppConfig.modifier,
      circle: buttonProps.circle ?? buttonAppConfig.circle,
      square: buttonProps.square ?? buttonAppConfig.square,
      disabled: buttonProps.disabled,
    }) as UiLayerButtonConfig,
);

const isLink = computed(() => buttonProps.to);
</script>

<template>
  <!-- NuxtLink -->
  <NuxtLink v-if="isLink" :to="to" custom v-slot="{ href, navigate, isActive }">
    <a
      :href="href"
      @click="navigate"
      :class="classMerge(
        buttonVariants(buttonConfig),
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
    :class="classMerge(buttonVariants(buttonConfig), buttonProps.class)"
    :aria-label="ariaLabel"
  >
    <slot />
  </a>

  <!-- button -->
  <button
    v-else
    :class="classMerge(buttonVariants(buttonConfig), buttonProps.class)"
    :disabled="disabled"
    :aria-label="ariaLabel"
  >
    <slot />
  </button>
</template>
