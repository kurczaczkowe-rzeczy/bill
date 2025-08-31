import { isNil } from "~/utils/isNil";

export const CHANNEL_ACTION = {
  UPDATE: "update",
  INSERT: "insert",
  DELETE: "delete",
} as const;

export type Enum<EnumLike> = EnumLike[keyof EnumLike];

export type ChannelAction = Enum<typeof CHANNEL_ACTION>;

export function getChannelActionFrom<Record, OldRecord>(
  payload: JsPostgresAction<Record, OldRecord>,
): ChannelAction {
  if (!isNil(payload.record) && isNil(payload.oldRecord)) {
    return CHANNEL_ACTION.INSERT;
  }
  if (!isNil(payload.record) && !isNil(payload.oldRecord)) {
    return CHANNEL_ACTION.UPDATE;
  }
  if (isNil(payload.record) && !isNil(payload.oldRecord)) {
    return CHANNEL_ACTION.DELETE;
  }
  throw new Error("Unknown channel action");
}
