<script setup lang="ts">
const props = defineProps({
  showChangelog: {
    type: Boolean,
    default: false,
  },
  showOfflineToast: {
    type: Boolean,
    default: true,
  },
});

const emit = defineEmits(["update-available", "updated", "offline-ready"]);

const needRefresh = ref(false);
const offlineReady = ref(false);
const isUpdating = ref(false);
const updateSW = ref(null);

onMounted(async () => {
  try {
    const { useRegisterSW } = await import("virtual:pwa-register/vue");

    const {
      needRefresh: refresh,
      offlineReady: offline,
      updateServiceWorker,
    } = useRegisterSW({
      immediate: true,
    });

    updateSW.value = updateServiceWorker;

    watch(refresh, (newVal) => {
      needRefresh.value = newVal;
      if (newVal) {
        emit("update-available");
      }
    });

    watch(offline, (newVal) => {
      offlineReady.value = newVal;
      if (newVal) {
        emit("offline-ready");

        if (props.showOfflineToast) {
          setTimeout(() => {
            offlineReady.value = false;
          }, 3000);
        }
      }
    });
  } catch (error) {
    console.error("❌ Błąd ładowania PWA:", error);
  }
});

const updateServiceWorker = async () => {
  if (updateSW.value && !isUpdating.value) {
    isUpdating.value = true;

    try {
      await updateSW.value();
      emit("updated");
    } catch (error) {
      isUpdating.value = false;
    }
  }
};

const close = () => {
  if (!isUpdating.value) {
    needRefresh.value = false;
  }
};
</script>

<template>
  <ClientOnly>
    <div
        :class="[
        'modal',
        'modal-bottom sm:modal-middle',
        { 'modal-open': needRefresh }
      ]"
    >
      <div class="modal-box">
        <div class="flex items-center gap-3 mb-4">
          <div class="badge badge-primary badge-lg p-3">
            <Icon name="mdi:rocket-launch" size="20" />
          </div>
          <div>
            <h3 class="font-bold text-lg">Nowa wersja dostępna!</h3>
            <p class="text-sm opacity-70">Aplikacja została zaktualizowana</p>
          </div>
        </div>

        <div class="py-4">
          <div class="alert alert-info mb-4">
            <Icon name="mdi:information" />
            <span class="text-sm">
              Zaktualizuj aplikację, aby korzystać z najnowszych funkcji i poprawek.
            </span>
          </div>

          <div v-if="showChangelog" class="space-y-2 mb-4">
            <p class="text-sm font-semibold">Co nowego:</p>
            <ul class="text-sm space-y-1">
              <li class="flex items-start gap-2">
                <Icon name="mdi:check-circle" class="text-success mt-0.5" size="16" />
                <span>Poprawiona wydajność aplikacji</span>
              </li>
              <li class="flex items-start gap-2">
                <Icon name="mdi:check-circle" class="text-success mt-0.5" size="16" />
                <span>Nowe funkcje offline</span>
              </li>
              <li class="flex items-start gap-2">
                <Icon name="mdi:check-circle" class="text-success mt-0.5" size="16" />
                <span>Naprawione błędy</span>
              </li>
            </ul>
          </div>

          <div v-if="isUpdating" class="space-y-2">
            <p class="text-sm">Aktualizowanie...</p>
            <progress class="progress progress-primary w-full"></progress>
          </div>
        </div>

        <div class="modal-action">
          <button
              @click="close"
              class="btn btn-ghost"
              :disabled="isUpdating"
          >
            Później
          </button>
          <button
              @click="updateServiceWorker"
              class="btn btn-primary"
              :disabled="isUpdating"
          >
            <Icon v-if="isUpdating" name="mdi:loading" class="animate-spin" />
            <Icon v-else name="mdi:download" />
            {{ isUpdating ? 'Aktualizowanie...' : 'Aktualizuj teraz' }}
          </button>
        </div>
      </div>

      <div class="modal-backdrop" @click="close"></div>
    </div>

    <div v-if="offlineReady && showOfflineToast" class="toast toast-bottom toast-center z-50">
      <div class="alert alert-success">
        <Icon name="mdi:wifi-off" />
        <span>Aplikacja gotowa do pracy offline!</span>
      </div>
    </div>
  </ClientOnly>
</template>
