<script lang="ts" setup>
import BaseButton from "@ui/components/BaseButton.vue";
import BaseFieldset from "@ui/components/BaseFieldset.vue";
import FormControl from "@ui/components/FormControl.vue";

const { resetPassword } = useAuth();

const email = ref("");

async function handleResetPassword() {
  try {
    await resetPassword(email.value);
  } catch (e) {
    console.error(e);
  }
}
</script>

<template>
  <div class="card w-full min-h-screen items-center justify-center">
    <div
      class="card-body bg-base-100 outline outline-primary/25 rounded-box shadow-md max-w-xl w-full flex-none overflow-y-auto">
      <div class="alert alert-warning alert-soft" role="alert">
        <Icon name="streamline-freehand:alerts-warning-triangle" />
        <span>Resetowanie hasła niedostępne</span>
      </div>
      <form class="flex flex-col gap-4" @submit.prevent="handleResetPassword">
        <BaseFieldset class="gap-4" title="Resetowanie hasła" disabled>
          <FormControl
            v-model="email"
            label="Email"
            name="email"
            placeholder="Email"
            type="text"
            wide
          />
        </BaseFieldset>
        <BaseButton appearance="outline" class="w-full" color="primary" type="submit">Zaloguj</BaseButton>
      </form>
    </div>
  </div>
</template>

<style scoped>

</style>