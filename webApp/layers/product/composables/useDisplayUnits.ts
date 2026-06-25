import { DisplayUnit, type ProductClient } from "@bill/Bill-shoppingList";

import { useKtClientData } from "~/composables/useKtClientData";

import { useProductClient } from "./useProductClient";

type ListenerType = "displayUnits";

type Options = ClientOptionsWithAutoListener<DisplayUnit[], ProductClient, ListenerType[]>;

export const INITIAL_DISPLAY_UNITS = [new DisplayUnit("g", "gram", "g", 1)] as const;

export function useDisplayUnits(options?: Options) {
  const productClient = options?.client ?? useProductClient();

  const initialDisplayUnitsResult = ref<AsyncDataWithTimestamp<DisplayUnit[]>>({
    result: [...INITIAL_DISPLAY_UNITS],
    fetchedAt: Date.now(),
  });

  const displayUnitsResult = useKtClientData(
    "displayUnits",
    () => productClient.getDisplayUnitsAsync(),
    {
      default: () => initialDisplayUnitsResult as unknown as Ref<undefined>,
      ...options,
    },
  );

  const displayUnitsMap = computed(() =>
    displayUnitsResult.data.value?.reduce((unitMap, unit) => {
      if (!unitMap.has(unit.baseUnit)) {
        unitMap.set(unit.baseUnit, []);
      }
      // biome-ignore lint/style/noNonNullAssertion: see condition above
      unitMap.set(unit.baseUnit, [...unitMap.get(unit.baseUnit)!, unit]);

      return unitMap;
    }, new Map<DisplayUnit["baseUnit"], DisplayUnit[]>()),
  );

  function mapUnitToDisplayUnit(baseUnit: string, quantity: number) {
    const displayUnits = displayUnitsMap.value?.get(baseUnit) ?? [];
    const sortedDisplayUnit = displayUnits.toSorted((a, b) => b.multiplier - a.multiplier);

    let resultQuantity: number;
    for (const displayUnit of sortedDisplayUnit) {
      resultQuantity = quantity / displayUnit.multiplier;
      if (resultQuantity >= 1) {
        return { quantity: resultQuantity, baseUnit: displayUnit.shortName };
      }
    }

    return { quantity, baseUnit: baseUnit };
  }

  return {
    ...displayUnitsResult,

    //Utils
    displayUnitsMap,
    mapUnitToDisplayUnit,
  };
}
