import { DisplayUnit, type Product, type ProductClient } from "@bill/Bill-shoppingList";

import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";

import { useKtClientData } from "./useKtClientData";

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

  function mapUnitToDisplayUnit(unit: string, quantity: number) {
    const displayUnits = displayUnitsMap.value?.get(unit) ?? [];
    const sortedDisplayUnit = displayUnits.toSorted((a, b) => b.multiplier - a.multiplier);

    let resultQuantity: number;
    for (const displayUnit of sortedDisplayUnit) {
      resultQuantity = quantity / displayUnit.multiplier;
      if (resultQuantity >= 1) {
        return { quantity: resultQuantity, unit: displayUnit.shortName };
      }
    }

    return { quantity, unit };
  }

  return {
    ...displayUnitsResult,

    //Utils
    displayUnitsMap,
    mapUnitToDisplayUnit,
  };
}
