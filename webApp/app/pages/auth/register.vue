<script setup lang="ts">
definePageMeta({ layout: "auth" });

import BaseButton from "@ui/components/BaseButton.vue";
import BaseFieldset from '@ui/components/BaseFieldset.vue'
import FormControl from "@ui/components/FormControl.vue";

import type { RegisterParameters } from '~/composables/useAuth'

const { signUp } = useAuth();

const registerParams = reactive<RegisterParameters>({
  email: "",
  password: "",
});

async function handleRegister() {
  try {
    await signUp(registerParams);
  } catch (e) {
    console.error(e);
  }
}
</script>

<template>
    <div class="card w-full min-h-screen items-center justify-center">
      <div class="card-body bg-base-100 outline outline-primary/25 rounded-box shadow-md max-w-xl w-full flex-none overflow-y-auto">
        <form class="flex flex-col gap-4" @submit.prevent="handleRegister">
          <BaseFieldset title="Zarejestruj się" class="gap-4">
            <FormControl
              type="text"
              placeholder="Email"
              label="Email"
              name="email"
              v-model="registerParams.email"
              wide
            />
            <FormControl
              label="Hasło"
              type="password"
              placeholder="Hasło"
              name="password"
              wide
              v-model="registerParams.password"
            />
          </BaseFieldset>
          <BaseButton type="submit" class="w-full" appearance="outline" color="primary">Zaloguj</BaseButton>
        </form>
      </div>
    </div>

</template>

<style scoped>

</style>