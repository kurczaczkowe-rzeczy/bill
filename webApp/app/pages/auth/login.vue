<script setup lang="ts">
definePageMeta({ layout: "auth" });

import { AuthAuthenticated } from "@bill/Bill-shoppingList/kotlin/Bill-core";
import BaseButton from "@ui/components/BaseButton.vue";
import BaseFieldset from "@ui/components/BaseFieldset.vue";
import FormControl from "@ui/components/FormControl.vue";

import type { LogInParameters } from "~/composables/useAuth";

const { signIn, state } = useAuth();

const logInParams = reactive<LogInParameters>({
  email: "",
  password: "",
});

watchEffect(() => {
  if (toRaw(state.value) instanceof AuthAuthenticated) {
    navigateTo("/");
  }
});

async function handleLogIn() {
  try {
    await signIn(logInParams);
  } catch (e) {
    console.error(e);
  }
}
</script>

<template>
    <div class="card w-full min-h-screen items-center justify-center">
      <div class="card-body bg-base-100 outline outline-primary/25 rounded-box shadow-md max-w-xl w-full flex-none overflow-y-auto">
        <form class="flex flex-col gap-4" @submit.prevent="handleLogIn">
          <BaseFieldset title="Zaloguj się" class="gap-4">
            <FormControl
              type="text"
              placeholder="Email"
              label="Email"
              name="email"
              v-model="logInParams.email"
              wide
            />
            <FormControl
              label="Hasło"
              type="password"
              placeholder="Hasło"
              name="password"
              wide
              v-model="logInParams.password"
            />
          </BaseFieldset>
          <BaseButton type="submit" class="w-full" appearance="outline" color="primary">Zaloguj</BaseButton>
        </form>
      </div>
    </div>

</template>

<style scoped>

</style>