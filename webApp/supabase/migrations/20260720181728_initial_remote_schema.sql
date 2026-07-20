

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE TYPE "public"."menu_item_input" AS (
	"p_id" "uuid",
	"p_original_meal_id" "uuid",
	"p_user_meal_id" "uuid",
	"p_meal_time" timestamp without time zone,
	"p_type" "text"
);


ALTER TYPE "public"."menu_item_input" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."add_product_to_shopping_list"("p_shopping_list_id" "uuid", "p_product_base_unit" "text", "p_product_quantity" numeric, "p_product_name" "text", "p_category_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
v_found_product_id uuid;
    v_existing_quantity numeric;
    v_resulted_id uuid;
BEGIN
    -- check if product exists in product table
SELECT id INTO v_found_product_id
FROM product
WHERE name = p_product_name AND base_unit = p_product_base_unit;

IF v_found_product_id IS NULL THEN
        INSERT INTO product(name, base_unit)
        VALUES(p_product_name, p_product_base_unit)
        RETURNING id INTO v_found_product_id;
END IF;

    -- check if product already exists in this shopping list
SELECT product_in_shopping_list.quantity INTO v_existing_quantity
FROM product_in_shopping_list
WHERE product_in_shopping_list.product_id = v_found_product_id
  AND product_in_shopping_list.shopping_list_id = p_shopping_list_id
  AND product_in_shopping_list.category_id = p_category_id;

IF v_existing_quantity IS NOT NULL THEN
UPDATE product_in_shopping_list
SET quantity = quantity + p_product_quantity
WHERE product_in_shopping_list.product_id = v_found_product_id
  AND product_in_shopping_list.shopping_list_id = p_shopping_list_id
  AND product_in_shopping_list.category_id = p_category_id
    RETURNING product_in_shopping_list.id INTO v_resulted_id;
ELSE
        -- insert product into linked table
        INSERT INTO product_in_shopping_list(product_id, shopping_list_id, category_id, quantity)
        VALUES(v_found_product_id, p_shopping_list_id, p_category_id, p_product_quantity)
        RETURNING product_in_shopping_list.id INTO v_resulted_id;
END IF;

RETURN get_product_from_shopping_list(v_resulted_id);
END;
$$;


ALTER FUNCTION "public"."add_product_to_shopping_list"("p_shopping_list_id" "uuid", "p_product_base_unit" "text", "p_product_quantity" numeric, "p_product_name" "text", "p_category_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."add_user_meal_ingredient"("p_user_meal_id" "uuid", "p_product_id" "uuid", "p_quantity" numeric, "p_name" "text", "p_base_unit" "text") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_id uuid;
begin
  insert into public.user_meal_ingredient (
    user_meal_id, product_id, quantity,
    name, base_unit, overrider_uuid,
    created_at, updated_at
  )
  values (
    p_user_meal_id, p_product_id, p_quantity,
    p_name, p_base_unit, auth.uid(),
    now(), now()
  )
  returning id into v_id;

  return v_id;
end;
$$;


ALTER FUNCTION "public"."add_user_meal_ingredient"("p_user_meal_id" "uuid", "p_product_id" "uuid", "p_quantity" numeric, "p_name" "text", "p_base_unit" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_category"("p_name" "text", "p_color" character varying) RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
v_json_result json;
BEGIN
INSERT INTO category(name, color)
VALUES(p_name, p_color)
    RETURNING row_to_json(category.*) INTO v_json_result;

RETURN get_array_result(v_json_result);
END;
$$;


ALTER FUNCTION "public"."create_category"("p_name" "text", "p_color" character varying) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_meal_with_ingredients"("p_name" "text", "p_type" "text", "p_receipe_desc" "text", "p_receipe_link" "text", "p_servings" numeric, "p_servings_multiplier" numeric, "p_ingredients" "jsonb") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_meal_id uuid;
  v_user_meal_id uuid;
  v_ing jsonb;
  v_meal_ingredient_id uuid;
begin

  -- meal
  insert into public.meal (
    name, type, receipe_desc, receipe_link,
    author_uuid, servings, servings_multiplier,
    created_at, updated_at
  )
  values (
    p_name, p_type, p_receipe_desc, p_receipe_link,
    auth.uid(), p_servings, p_servings_multiplier,
    now(), now()
  )
  returning id into v_meal_id;

  -- user_meal
  insert into public.user_meal (
    meal_id, overrider_uuid,
    created_at, updated_at
  )
  values (
    v_meal_id, auth.uid(),
    now(), now()
  )
  returning id into v_user_meal_id;

  -- składniki
  for v_ing in select * from jsonb_array_elements(p_ingredients)
  loop
    insert into public.meal_ingredient (
      meal_id, product_id, quantity,
      author_uuid, created_at, updated_at
    )
    values (
      v_meal_id,
      (v_ing->>'product_id')::uuid,
      (v_ing->>'quantity')::numeric,
      auth.uid(), now(), now()
    )
    returning id into v_meal_ingredient_id;

    insert into public.user_meal_ingredient (
      user_meal_id,
      meal_ingredient_id,
      overrider_uuid,
      created_at, updated_at
    )
    values (
      v_user_meal_id,
      v_meal_ingredient_id,
      auth.uid(),
      now(), now()
    );
  end loop;

  return get_array_result(to_json(v_user_meal_id));
end;
$$;


ALTER FUNCTION "public"."create_meal_with_ingredients"("p_name" "text", "p_type" "text", "p_receipe_desc" "text", "p_receipe_link" "text", "p_servings" numeric, "p_servings_multiplier" numeric, "p_ingredients" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_shopping_list"("p_name" "text", "p_date" "date") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$DECLARE
v_json_result json;
BEGIN
    -- Create shopping list
INSERT INTO shopping_list(name, date)
VALUES(p_name, p_date)
    RETURNING row_to_json(shopping_list.*) INTO v_json_result;
INSERT INTO list_counter(user_id, next_shopping_list_number)
VALUES (COALESCE(auth.uid(), '68364db3-17df-4b7d-b8a4-5a6e56678404'), 2)
    ON CONFLICT (user_id)
    DO UPDATE set next_shopping_list_number = list_counter.next_shopping_list_number + 1;

RETURN get_array_result(v_json_result);
END;$$;


ALTER FUNCTION "public"."create_shopping_list"("p_name" "text", "p_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_user_meal_from_meal"("p_meal_id" "uuid") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user_meal_id uuid;
begin
  insert into public.user_meal (
    meal_id, overrider_uuid,
    created_at, updated_at
  )
  values (
    p_meal_id, auth.uid(),
    now(), now()
  )
  returning id into v_user_meal_id;

  insert into public.user_meal_ingredient (
    user_meal_id,
    meal_ingredient_id,
    overrider_uuid,
    created_at, updated_at
  )
  select
    v_user_meal_id,
    mi.id,
    auth.uid(),
    now(), now()
  from public.meal_ingredient mi
  where mi.meal_id = p_meal_id
    and mi.deleted_at is null;

  return v_user_meal_id;
end;
$$;


ALTER FUNCTION "public"."create_user_meal_from_meal"("p_meal_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."delete_menu_item"("p_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  update public.menu_item
  set
    deleted_at = now(),
    updated_at = now()
  where id = p_id
    and owner_uuid = auth.uid()
    and deleted_at is null;
end;
$$;


ALTER FUNCTION "public"."delete_menu_item"("p_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."delete_user_meal_ingredient"("p_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  update public.user_meal_ingredient
  set
    deleted_at = now(),
    updated_at = now()
  where id = p_id
    and overrider_uuid = auth.uid()
    and deleted_at is null;
end;
$$;


ALTER FUNCTION "public"."delete_user_meal_ingredient"("p_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."edit_category"("p_id" "uuid", "p_name" "text" DEFAULT NULL::"text", "p_color" character varying DEFAULT NULL::character varying) RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
v_json_result json;
BEGIN
    IF p_name IS NULL AND p_color IS NULL THEN
     RAISE EXCEPTION 'You should pass at least one parameters except id';
END IF;
UPDATE category
SET name = COALESCE(p_name, category.name), color = COALESCE(p_color, category.color)
WHERE category.id = p_id AND (
    p_name IS NOT NULL AND p_name IS DISTINCT FROM category.name OR
        p_color IS NOT NULL AND p_color IS DISTINCT FROM category.color
    )
    RETURNING row_to_json(category.*) INTO v_json_result;

RETURN get_array_result(v_json_result);
END;
$$;


ALTER FUNCTION "public"."edit_category"("p_id" "uuid", "p_name" "text", "p_color" character varying) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."edit_product_in_shopping_list"("p_id" "uuid", "p_shopping_list_id" "uuid", "p_name" "text" DEFAULT NULL::"text", "p_quantity" numeric DEFAULT NULL::numeric, "p_base_unit" "text" DEFAULT NULL::"text", "p_category_id" "uuid" DEFAULT NULL::"uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$DECLARE
v_new_product_id uuid;
    v_shopping_list_product_id uuid;
BEGIN
    IF p_name IS NULL
        AND p_quantity IS NULL
        AND p_base_unit IS NULL
        AND p_category_id IS NULL
    THEN
        RAISE EXCEPTION 'You should pass at least one parameters except p_id and p_shopping_list_id';
END IF;

SELECT product_in_shopping_list.id INTO v_shopping_list_product_id
FROM product_in_shopping_list
WHERE product_in_shopping_list.id = p_id
  AND product_in_shopping_list.shopping_list_id = p_shopping_list_id;

IF v_shopping_list_product_id IS NULL THEN
        RAISE EXCEPTION 'Provided product id is not associated with provided shopping list';
END IF;

UPDATE product_in_shopping_list
SET
    quantity = COALESCE(p_quantity, product_in_shopping_list.quantity),
    category_id = COALESCE(p_category_id, product_in_shopping_list.category_id)
WHERE product_in_shopping_list.id = p_id AND product_in_shopping_list.shopping_list_id = p_shopping_list_id
    RETURNING product_in_shopping_list.id INTO v_shopping_list_product_id;

RETURN get_product_from_shopping_list(v_shopping_list_product_id);
END;$$;


ALTER FUNCTION "public"."edit_product_in_shopping_list"("p_id" "uuid", "p_shopping_list_id" "uuid", "p_name" "text", "p_quantity" numeric, "p_base_unit" "text", "p_category_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."edit_shopping_list"("p_id" "uuid", "p_name" "text" DEFAULT NULL::"text", "p_date" "date" DEFAULT NULL::"date") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
    if p_name is null and p_date is null then
     raise exception 'You should pass at least one parameters except id';
end if;
update shopping_list
set shopping_list.name = coalesce(p_name, shopping_list.name), shopping_list.date = coalesce(p_date, shopping_list.date)
where shopping_list.id = p_id and (
    p_name IS NOT NULL AND p_name IS DISTINCT FROM shopping_list.name OR
        p_date IS NOT NULL AND p_date IS DISTINCT FROM shopping_list.date
    );
end;
$$;


ALTER FUNCTION "public"."edit_shopping_list"("p_id" "uuid", "p_name" "text", "p_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_array_result"("p_json" "json" DEFAULT NULL::"json") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
begin
  if p_json is null then
    return json_build_object('result', json_build_array());
end if;

return json_build_object('result', p_json);
end;
$$;


ALTER FUNCTION "public"."get_array_result"("p_json" "json") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_categories"() RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
v_json_result json;
BEGIN
SELECT jsonb_agg(obj) result
INTO v_json_result
FROM (
         SELECT row_to_json(category.*) obj
         FROM category
     ) AS f;

RETURN get_array_result(v_json_result);
END;
$$;


ALTER FUNCTION "public"."get_categories"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_display_units"() RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_json_result json;
begin
  select jsonb_agg(obj) result
  into v_json_result
  from (
    select json_build_object('base_unit', base_unit,'name', name, 'short_name', short_name, 'multiplier', multiplier) obj
    from display_units
  ) as f;

  return get_array_result(v_json_result);
end;
$$;


ALTER FUNCTION "public"."get_display_units"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_menu"("p_start_date" "date", "p_end_date" "date") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
  DECLARE
    json_result json;
  BEGIN

  select jsonb_build_object(
    'start_date', p_start_date,
    'end_date', p_end_date,
    'menu_items', coalesce(
      json_agg(
        json_build_object(
          'id', mi.id,
          'date', mi.meal_time,
          'type', mi.type,
          'user_meal_id', mi.user_meal_id,
          'created_at', mi.created_at,
          'updated_at', mi.updated_at,
          'meal', json_build_object(
            'id', um.id,
            'original_meal_id', um.meal_id,
            'name', coalesce(um.name, m.name),
            'type', coalesce(um.type, m.type),
            'created_at', um.created_at,
            'updated_at', um.updated_at,
            'deleted_at', um.deleted_at
          )
        )
        order by mi.meal_time
      ),
      '[]'::json
    )
  )
  into json_result
  from public.menu_item mi
  join public.user_meal um
    on um.id = mi.user_meal_id
   and um.deleted_at is null
  left join public.meal m
    on m.id = um.meal_id
   and m.deleted_at is null
  where mi.meal_time >= p_start_date and mi.meal_time <= p_end_date
    and mi.owner_uuid = auth.uid()
    and mi.deleted_at is null
    and um.overrider_uuid = auth.uid();

  return get_array_result(json_result);
  END;
$$;


ALTER FUNCTION "public"."get_menu"("p_start_date" "date", "p_end_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_product_from_shopping_list"("p_product_in_shopping_list_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
v_json_result json;
BEGIN
SELECT product_obj result INTO v_json_result
FROM (
         SELECT jsonb_build_object(
                        'id', ps.id,
                        'created_at', p.created_at,
                        'quantity', ps.quantity,
                        'base_unit', p.base_unit,
                        'name', p.name,
                        'in_cart', ps.in_cart,
                        'category', jsonb_build_object(
                                'id', c.id,
                                'name', c.name,
                                'color', c.color,
                                'created_at', c.created_at
                                    )
                ) product_obj
         FROM product p
                  FULL OUTER JOIN product_in_shopping_list ps
                                  ON p.id = ps.product_id
                  INNER JOIN category c
                             ON c.id = ps.category_id
         WHERE ps.id = p_product_in_shopping_list_id
         GROUP BY ps.id, p.id, ps.in_cart, c.id, ps.quantity
         ORDER BY ps.id
     ) AS s;

RETURN get_array_result(v_json_result);
END;
$$;


ALTER FUNCTION "public"."get_product_from_shopping_list"("p_product_in_shopping_list_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_product_suggestion"("p_name" "text", "p_base_unit" "text" DEFAULT NULL::"text") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$DECLARE
v_json_result json;
BEGIN
SELECT jsonb_agg(obj) result INTO v_json_result
FROM (
         SELECT json_build_object(
                        'id', id,
                        'created_at', created_at,
                        'name', name,
                        'base_unit', base_unit
                ) obj
         FROM product
         WHERE unaccent(lower(name)) ILIKE unaccent(lower(concat('%', p_name, '%')))
          AND (p_base_unit IS NULL OR base_unit = p_base_unit)
     ) AS q_get_product_suggestion;

return get_array_result(v_json_result);
END;$$;


ALTER FUNCTION "public"."get_product_suggestion"("p_name" "text", "p_base_unit" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_shopping_list"("p_shopping_list_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
v_json_result json;
BEGIN
SELECT jsonb_agg(product_obj) result
INTO v_json_result
FROM (
         SELECT jsonb_build_object(
                        'id', ps.id,
                        'created_at', p.created_at,
                        'quantity', ps.quantity,
                        'base_unit', p.base_unit,
                        'name', p.name,
                        'in_cart', ps.in_cart,
                        'category', jsonb_build_object(
                                'id', c.id,
                                'name', c.name,
                                'color', c.color,
                                'created_at', c.created_at
                                    )
                ) product_obj
         FROM product p
                  FULL OUTER JOIN product_in_shopping_list ps
                                  ON p.id = ps.product_id
                  INNER JOIN category c
                             ON c.id = ps.category_id
         WHERE ps.shopping_list_id = p_shopping_list_id
         GROUP BY ps.id, p.id, ps.in_cart, c.id, ps.quantity
         ORDER BY ps.id
     ) AS s;

RETURN get_array_result(v_json_result);
END;
$$;


ALTER FUNCTION "public"."get_shopping_list"("p_shopping_list_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_shopping_list_desc"("p_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
declare
v_json_result json;
begin
select json_build_object(
               'id', shopping_list.id,
               'created_at', shopping_list.created_at,
               'name', shopping_list.name,
               'date', shopping_list.date
       )
into v_json_result
from shopping_list
where id = p_id;

return get_array_result(v_json_result);
end;
$$;


ALTER FUNCTION "public"."get_shopping_list_desc"("p_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_shopping_lists"() RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
declare
  json_result json;
begin
  select jsonb_agg(shopping_list_obj) result
  into json_result
  from (
    select jsonb_build_object(
      'id', s.id,
      'created_at', s.created_at,
      'date', s.date,
      'name', s.name,
      'product_amount', count(p.in_cart)
    ) shopping_list_obj
    from shopping_list s
    full outer join product_in_shopping_list p
    on s.id = p.shopping_list_id
    group by s.id
  ) as f;

  return get_array_result(json_result);
end;
$$;


ALTER FUNCTION "public"."get_shopping_lists"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_meal"("p_user_meal_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
declare
  json_result json;
begin

  select jsonb_build_object(
    'id', um.id,
    'original_meal_id', um.meal_id,
    'name', coalesce(um.name, m.name),
    'type', coalesce(um.type, m.type),
    'receipe_desc', coalesce(um.receipe_desc, m.receipe_desc),
    'receipe_link', coalesce(um.receipe_link, m.receipe_link),
    'servings', coalesce(um.servings, m.servings),
    'servings_multiplier', coalesce(um.servings_multiplier, m.servings_multiplier),
    'created_at', coalesce(um.created_at, m.created_at),
    'updated_at', coalesce(um.updated_at, m.updated_at),

    'ingredients', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'id', umin.id,
            'meal_ingredient_id', umin.meal_ingredient_id,
            'product_id', coalesce(umin.product_id, mi.product_id),
            'name', coalesce(umin.name, pr.name),
            'quantity', coalesce(umin.quantity, mi.quantity),
            'base_unit', coalesce(umin.base_unit, pr.base_unit)
          )
        ),
        '[]'::jsonb
      )
      from public.user_meal_ingredient umin
      left join public.meal_ingredient mi
        on mi.id = umin.meal_ingredient_id
        and mi.deleted_at is null
      left join public.product pr
        on pr.id = umin.product_id
        or pr.id = mi.product_id
      where umin.user_meal_id = um.id
        and umin.deleted_at is null
        and umin.overrider_uuid = auth.uid()
    )
  )
  into json_result
  from public.meal m
  left join public.user_meal um
    on um.meal_id = m.id
   and um.overrider_uuid = auth.uid()
   and um.deleted_at is null
  where m.deleted_at is null
    and m.id = p_user_meal_id;

  return get_array_result(json_result);
end;
$$;


ALTER FUNCTION "public"."get_user_meal"("p_user_meal_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_meal_ingredients"("p_user_meal_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
declare
  json_result json;
begin

  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', umin.id,
        'meal_ingredient_id', umin.meal_ingredient_id,
        'product_id', coalesce(umin.product_id, mi.product_id),
        'name', coalesce(umin.name, pr.name),
        'quantity', coalesce(umin.quantity, mi.quantity),
        'base_unit', coalesce(umin.base_unit, pr.base_unit)
      )
    ),
    '[]'::jsonb
  )
  into json_result
  from public.user_meal_ingredient umin
  left join public.meal_ingredient mi
    on mi.id = umin.meal_ingredient_id
    and mi.deleted_at is null
  left join public.product pr
    on pr.id = umin.product_id
    or pr.id = mi.product_id
  where umin.user_meal_id = p_user_meal_id
    and umin.deleted_at is null
    and umin.overrider_uuid = auth.uid();

  return get_array_result(json_result);
end;
$$;


ALTER FUNCTION "public"."get_user_meal_ingredients"("p_user_meal_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_meals"() RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
declare
  json_result json;
begin

  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', coalesce(um.id, m.id),
        'original_meal_id', coalesce(um.meal_id, m.id),
        'name', coalesce(um.name, m.name),
        'type', coalesce(um.type, m.type),
        'created_at', coalesce(um.created_at, m.created_at),
        'updated_at', coalesce(um.updated_at, m.updated_at)
      )
    ),
    '[]'::jsonb
  )
  into json_result
  from public.meal m
  left join public.user_meal um
    on um.meal_id = m.id
   and um.overrider_uuid = auth.uid()
   and um.deleted_at is null
  where m.deleted_at is null;

  return get_array_result(json_result);
end;
$$;


ALTER FUNCTION "public"."get_user_meals"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."remove_category"("p_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
  DECLARE
v_removed_id uuid;
BEGIN
DELETE FROM category WHERE category.id = p_id
    RETURNING category.id INTO v_removed_id;

RETURN get_array_result(json_build_object('id', v_removed_id));
END;
$$;


ALTER FUNCTION "public"."remove_category"("p_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."remove_product_from_shopping_list"("p_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
v_removed_id uuid;
BEGIN
    -- Delete the matching row and capture its primary key
DELETE FROM product_in_shopping_list
WHERE product_in_shopping_list.id = p_id
    RETURNING product_in_shopping_list.id INTO v_removed_id;

IF v_removed_id IS NULL THEN
        RETURN json_build_object('error', 'Row not found', 'id', p_id);
END IF;

    -- Return the id of the removed row as JSON
RETURN get_array_result(json_build_object('id', v_removed_id));
END;
$$;


ALTER FUNCTION "public"."remove_product_from_shopping_list"("p_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."remove_shopping_list"("p_shopping_list_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
v_removed_id uuid;
BEGIN
delete from product_in_shopping_list where product_in_shopping_list.shopping_list_id = p_shopping_list_id;
delete from shopping_list where id = p_shopping_list_id
    RETURNING shopping_list.id INTO v_removed_id;

RETURN get_array_result(json_build_object('id', v_removed_id));
END;
$$;


ALTER FUNCTION "public"."remove_shopping_list"("p_shopping_list_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."toggle_product_in_cart"("p_product_in_shopping_list_id" "uuid") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
  DECLARE
v_json_result json;
BEGIN
UPDATE product_in_shopping_list
SET in_cart = not in_cart
WHERE id = p_product_in_shopping_list_id;

RETURN get_product_from_shopping_list(p_product_in_shopping_list_id);
END;
$$;


ALTER FUNCTION "public"."toggle_product_in_cart"("p_product_in_shopping_list_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_user_meal"("p_user_meal_id" "uuid", "p_name" "text" DEFAULT NULL::"text", "p_type" "text" DEFAULT NULL::"text", "p_receipe_desc" "text" DEFAULT NULL::"text", "p_receipe_link" "text" DEFAULT NULL::"text", "p_servings" numeric DEFAULT NULL::numeric, "p_servings_multiplier" numeric DEFAULT NULL::numeric) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  update public.user_meal
  set
    name = coalesce(p_name, name),
    type = coalesce(p_type, type),
    receipe_desc = coalesce(p_receipe_desc, receipe_desc),
    receipe_link = coalesce(p_receipe_link, receipe_link),
    servings = coalesce(p_servings, servings),
    servings_multiplier = coalesce(p_servings_multiplier, servings_multiplier),
    updated_at = now()
  where id = p_user_meal_id
    and overrider_uuid = auth.uid()
    and deleted_at is null;
end;
$$;


ALTER FUNCTION "public"."update_user_meal"("p_user_meal_id" "uuid", "p_name" "text", "p_type" "text", "p_receipe_desc" "text", "p_receipe_link" "text", "p_servings" numeric, "p_servings_multiplier" numeric) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_user_meal_ingredient"("p_id" "uuid", "p_quantity" numeric DEFAULT NULL::numeric, "p_name" "text" DEFAULT NULL::"text", "p_base_unit" "text" DEFAULT NULL::"text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  update public.user_meal_ingredient
  set
    quantity = p_quantity,
    name = p_name,
    base_unit = p_base_unit,
    updated_at = now()
  where id = p_id
    and overrider_uuid = auth.uid()
    and deleted_at is null;
end;
$$;


ALTER FUNCTION "public"."update_user_meal_ingredient"("p_id" "uuid", "p_quantity" numeric, "p_name" "text", "p_base_unit" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."upsert_menu_item"("p_user_meal_id" "uuid", "p_original_meal_id" "uuid", "p_meal_time" timestamp without time zone, "p_id" "uuid" DEFAULT NULL::"uuid", "p_type" "text" DEFAULT NULL::"text") RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_id uuid;
  v_user_meal public.user_meal%ROWTYPE;
  v_user_meal_id uuid;
begin

  -- jeśli user_meal należy do innego overridera, skopiuj go dla bieżącego użytkownika
  if p_user_meal_id = p_original_meal_id then
    v_user_meal_id :=
      public.create_user_meal_from_meal(p_original_meal_id);
  else
    v_user_meal_id := p_user_meal_id;
  end if;

  -- CREATE
  if p_id is null then
    insert into public.menu_item (
      user_meal_id,
      owner_uuid,
      meal_time,
      type,
      created_at,
      updated_at
    )
    values (
      v_user_meal_id,
      auth.uid(),
      p_meal_time,
      p_type,
      now(),
      now()
    )
    returning id into v_id;

  -- UPDATE / MOVE
  else
    update public.menu_item
    set
      user_meal_id = v_user_meal_id,
      meal_time = p_meal_time,
      type = coalesce(p_type, type),
      updated_at = now()
    where id = p_id
      and owner_uuid = auth.uid()
      and deleted_at is null
    returning id into v_id;

    if v_id is null then
      raise exception 'menu_item not found or access denied';
    end if;
  end if;

  return get_array_result(to_json(v_id));
end;
$$;


ALTER FUNCTION "public"."upsert_menu_item"("p_user_meal_id" "uuid", "p_original_meal_id" "uuid", "p_meal_time" timestamp without time zone, "p_id" "uuid", "p_type" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."upsert_menu_items"("p_items" "jsonb") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_item_json jsonb;
  v_item public.menu_item_input;
begin
  for v_item_json in select * from jsonb_array_elements(p_items)
  loop

    select *
    into v_item
    from jsonb_populate_record(null::public.menu_item_input, v_item_json);
    -- raise exception 'user_meal=%', v_item;

    perform public.upsert_menu_item(
      v_item.p_user_meal_id,
      v_item.p_original_meal_id,
      v_item.p_meal_time,
      v_item.p_id,
      v_item.p_type
    );
  end loop;
end;
$$;


ALTER FUNCTION "public"."upsert_menu_items"("p_items" "jsonb") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."base_units" (
    "unit" "text" NOT NULL
);


ALTER TABLE "public"."base_units" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."category" (
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "name" "text" NOT NULL,
    "color" character(6) NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    CONSTRAINT "should_be_equal_to_6" CHECK (("char_length"("color") = 6))
);


ALTER TABLE "public"."category" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."display_units" (
    "name" "text" NOT NULL,
    "short_name" "text" NOT NULL,
    "base_unit" "text" NOT NULL,
    "multiplier" numeric(20,10) DEFAULT 1 NOT NULL
);


ALTER TABLE "public"."display_units" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."list_counter" (
    "user_id" "uuid" NOT NULL,
    "next_shopping_list_number" bigint DEFAULT '0'::bigint NOT NULL
);


ALTER TABLE "public"."list_counter" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."meal" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "type" "text" NOT NULL,
    "receipe_desc" "text",
    "receipe_link" "text",
    "author_uuid" "uuid" NOT NULL,
    "servings" numeric DEFAULT 1 NOT NULL,
    "servings_multiplier" numeric DEFAULT 1 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deleted_at" timestamp with time zone
);


ALTER TABLE "public"."meal" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."meal_ingredient" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "author_uuid" "uuid" NOT NULL,
    "quantity" numeric NOT NULL,
    "meal_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deleted_at" timestamp with time zone
);


ALTER TABLE "public"."meal_ingredient" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."menu_item" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_meal_id" "uuid" NOT NULL,
    "owner_uuid" "uuid" NOT NULL,
    "meal_time" timestamp without time zone NOT NULL,
    "type" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deleted_at" timestamp with time zone
);


ALTER TABLE "public"."menu_item" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."product" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "base_unit" "text" NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."product" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."product_in_shopping_list" (
    "in_cart" boolean DEFAULT false NOT NULL,
    "quantity" numeric NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "shopping_list_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "category_id" "uuid" NOT NULL
);


ALTER TABLE "public"."product_in_shopping_list" OWNER TO "postgres";


COMMENT ON TABLE "public"."product_in_shopping_list" IS 'Produkt listy zakupów';



CREATE TABLE IF NOT EXISTS "public"."shopping_list" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "date" "date" NOT NULL,
    "name" "text" NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."shopping_list" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_meal" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "meal_id" "uuid" NOT NULL,
    "name" "text",
    "type" "text",
    "receipe_desc" "text",
    "receipe_link" "text",
    "overrider_uuid" "uuid" NOT NULL,
    "servings" numeric,
    "servings_multiplier" numeric,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deleted_at" timestamp with time zone
);


ALTER TABLE "public"."user_meal" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_meal_ingredient" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "meal_ingredient_id" "uuid",
    "user_meal_id" "uuid" NOT NULL,
    "product_id" "uuid",
    "overrider_uuid" "uuid" NOT NULL,
    "quantity" numeric,
    "base_unit" "text",
    "name" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deleted_at" timestamp with time zone
);


ALTER TABLE "public"."user_meal_ingredient" OWNER TO "postgres";


ALTER TABLE ONLY "public"."category"
    ADD CONSTRAINT "category_id_uniq" UNIQUE ("id");



ALTER TABLE ONLY "public"."category"
    ADD CONSTRAINT "category_id_uuid_uniq" UNIQUE ("id");



ALTER TABLE ONLY "public"."category"
    ADD CONSTRAINT "category_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."display_units"
    ADD CONSTRAINT "display_units_pkey" PRIMARY KEY ("name");



ALTER TABLE ONLY "public"."list_counter"
    ADD CONSTRAINT "list_counter_pkey" PRIMARY KEY ("user_id");



ALTER TABLE ONLY "public"."meal_ingredient"
    ADD CONSTRAINT "meal_ingredient_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."meal"
    ADD CONSTRAINT "meal_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."menu_item"
    ADD CONSTRAINT "menu_item_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product"
    ADD CONSTRAINT "product__id_uuid_uniq" UNIQUE ("id");



ALTER TABLE ONLY "public"."product"
    ADD CONSTRAINT "product_id_uniq" UNIQUE ("id");



ALTER TABLE ONLY "public"."product_in_shopping_list"
    ADD CONSTRAINT "product_in_shopping_list_id_uniq" UNIQUE ("id");



ALTER TABLE ONLY "public"."product_in_shopping_list"
    ADD CONSTRAINT "product_in_shopping_list_id_uuid_uniq" UNIQUE ("id");



ALTER TABLE ONLY "public"."product_in_shopping_list"
    ADD CONSTRAINT "product_in_shopping_list_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product"
    ADD CONSTRAINT "product_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."shopping_list"
    ADD CONSTRAINT "shopping_list_id_uniq" UNIQUE ("id");



ALTER TABLE ONLY "public"."shopping_list"
    ADD CONSTRAINT "shopping_list_id_uuid_uniq" UNIQUE ("id");



ALTER TABLE ONLY "public"."shopping_list"
    ADD CONSTRAINT "shopping_list_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."base_units"
    ADD CONSTRAINT "units_pkey" PRIMARY KEY ("unit");



ALTER TABLE ONLY "public"."user_meal_ingredient"
    ADD CONSTRAINT "user_meal_ingredient_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_meal"
    ADD CONSTRAINT "user_meal_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."display_units"
    ADD CONSTRAINT "display_units_base_unit_fkey" FOREIGN KEY ("base_unit") REFERENCES "public"."base_units"("unit");



ALTER TABLE ONLY "public"."meal"
    ADD CONSTRAINT "meal_author_uuid_fkey" FOREIGN KEY ("author_uuid") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."meal_ingredient"
    ADD CONSTRAINT "meal_ingredient_author_uuid_fkey" FOREIGN KEY ("author_uuid") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."meal_ingredient"
    ADD CONSTRAINT "meal_ingredient_meal_id_fkey" FOREIGN KEY ("meal_id") REFERENCES "public"."meal"("id");



ALTER TABLE ONLY "public"."meal_ingredient"
    ADD CONSTRAINT "meal_ingredient_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."product"("id");



ALTER TABLE ONLY "public"."menu_item"
    ADD CONSTRAINT "menu_item_owner_uuid_fkey" FOREIGN KEY ("owner_uuid") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."menu_item"
    ADD CONSTRAINT "menu_item_user_meal_id_fkey" FOREIGN KEY ("user_meal_id") REFERENCES "public"."user_meal"("id");



ALTER TABLE ONLY "public"."product_in_shopping_list"
    ADD CONSTRAINT "product_in_shopping_list_category_id_uuid_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."category"("id");



ALTER TABLE ONLY "public"."product_in_shopping_list"
    ADD CONSTRAINT "product_in_shopping_list_product_id_uuid_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."product"("id");



ALTER TABLE ONLY "public"."product_in_shopping_list"
    ADD CONSTRAINT "product_in_shopping_list_shopping_list_id_uuid_fkey" FOREIGN KEY ("shopping_list_id") REFERENCES "public"."shopping_list"("id");



ALTER TABLE ONLY "public"."product"
    ADD CONSTRAINT "product_unit_fkey" FOREIGN KEY ("base_unit") REFERENCES "public"."base_units"("unit");



ALTER TABLE ONLY "public"."user_meal_ingredient"
    ADD CONSTRAINT "user_meal_ingredient_base_unit_fkey" FOREIGN KEY ("base_unit") REFERENCES "public"."base_units"("unit");



ALTER TABLE ONLY "public"."user_meal_ingredient"
    ADD CONSTRAINT "user_meal_ingredient_meal_ingredient_id_fkey" FOREIGN KEY ("meal_ingredient_id") REFERENCES "public"."meal_ingredient"("id");



ALTER TABLE ONLY "public"."user_meal_ingredient"
    ADD CONSTRAINT "user_meal_ingredient_overrider_uuid_fkey" FOREIGN KEY ("overrider_uuid") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."user_meal_ingredient"
    ADD CONSTRAINT "user_meal_ingredient_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."product"("id");



ALTER TABLE ONLY "public"."user_meal_ingredient"
    ADD CONSTRAINT "user_meal_ingredient_user_meal_id_fkey" FOREIGN KEY ("user_meal_id") REFERENCES "public"."user_meal"("id");



ALTER TABLE ONLY "public"."user_meal"
    ADD CONSTRAINT "user_meal_meal_id_fkey" FOREIGN KEY ("meal_id") REFERENCES "public"."meal"("id");



ALTER TABLE ONLY "public"."user_meal"
    ADD CONSTRAINT "user_meal_overrider_uuid_fkey" FOREIGN KEY ("overrider_uuid") REFERENCES "auth"."users"("id");



CREATE POLICY "Enable CRUD for authenticated users" ON "public"."meal" TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Enable CRUD for authenticated users" ON "public"."meal_ingredient" TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Enable CRUD for users based on overrider_uuid" ON "public"."user_meal" TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "overrider_uuid")) WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "overrider_uuid"));



CREATE POLICY "Enable CRUD for users based on overrider_uuid" ON "public"."user_meal_ingredient" TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "overrider_uuid")) WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "overrider_uuid"));



CREATE POLICY "Enable CRUD for users based on owner_uuid" ON "public"."menu_item" TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "owner_uuid")) WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "owner_uuid"));



CREATE POLICY "Enable insert for users based on user_id" ON "public"."list_counter" TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id")) WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Enable read access for all users" ON "public"."base_units" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."display_units" FOR SELECT USING (true);



ALTER TABLE "public"."base_units" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."display_units" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."list_counter" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."meal" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."meal_ingredient" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."menu_item" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_meal" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_meal_ingredient" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."add_product_to_shopping_list"("p_shopping_list_id" "uuid", "p_product_base_unit" "text", "p_product_quantity" numeric, "p_product_name" "text", "p_category_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."add_product_to_shopping_list"("p_shopping_list_id" "uuid", "p_product_base_unit" "text", "p_product_quantity" numeric, "p_product_name" "text", "p_category_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_product_to_shopping_list"("p_shopping_list_id" "uuid", "p_product_base_unit" "text", "p_product_quantity" numeric, "p_product_name" "text", "p_category_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."add_user_meal_ingredient"("p_user_meal_id" "uuid", "p_product_id" "uuid", "p_quantity" numeric, "p_name" "text", "p_base_unit" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."add_user_meal_ingredient"("p_user_meal_id" "uuid", "p_product_id" "uuid", "p_quantity" numeric, "p_name" "text", "p_base_unit" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_user_meal_ingredient"("p_user_meal_id" "uuid", "p_product_id" "uuid", "p_quantity" numeric, "p_name" "text", "p_base_unit" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_category"("p_name" "text", "p_color" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."create_category"("p_name" "text", "p_color" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_category"("p_name" "text", "p_color" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."create_meal_with_ingredients"("p_name" "text", "p_type" "text", "p_receipe_desc" "text", "p_receipe_link" "text", "p_servings" numeric, "p_servings_multiplier" numeric, "p_ingredients" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."create_meal_with_ingredients"("p_name" "text", "p_type" "text", "p_receipe_desc" "text", "p_receipe_link" "text", "p_servings" numeric, "p_servings_multiplier" numeric, "p_ingredients" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_meal_with_ingredients"("p_name" "text", "p_type" "text", "p_receipe_desc" "text", "p_receipe_link" "text", "p_servings" numeric, "p_servings_multiplier" numeric, "p_ingredients" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_shopping_list"("p_name" "text", "p_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."create_shopping_list"("p_name" "text", "p_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_shopping_list"("p_name" "text", "p_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_user_meal_from_meal"("p_meal_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."create_user_meal_from_meal"("p_meal_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_user_meal_from_meal"("p_meal_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."delete_menu_item"("p_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."delete_menu_item"("p_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."delete_menu_item"("p_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."delete_user_meal_ingredient"("p_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."delete_user_meal_ingredient"("p_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."delete_user_meal_ingredient"("p_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."edit_category"("p_id" "uuid", "p_name" "text", "p_color" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."edit_category"("p_id" "uuid", "p_name" "text", "p_color" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."edit_category"("p_id" "uuid", "p_name" "text", "p_color" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."edit_product_in_shopping_list"("p_id" "uuid", "p_shopping_list_id" "uuid", "p_name" "text", "p_quantity" numeric, "p_base_unit" "text", "p_category_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."edit_product_in_shopping_list"("p_id" "uuid", "p_shopping_list_id" "uuid", "p_name" "text", "p_quantity" numeric, "p_base_unit" "text", "p_category_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."edit_product_in_shopping_list"("p_id" "uuid", "p_shopping_list_id" "uuid", "p_name" "text", "p_quantity" numeric, "p_base_unit" "text", "p_category_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."edit_shopping_list"("p_id" "uuid", "p_name" "text", "p_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."edit_shopping_list"("p_id" "uuid", "p_name" "text", "p_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."edit_shopping_list"("p_id" "uuid", "p_name" "text", "p_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_array_result"("p_json" "json") TO "anon";
GRANT ALL ON FUNCTION "public"."get_array_result"("p_json" "json") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_array_result"("p_json" "json") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_categories"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_categories"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_categories"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_display_units"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_display_units"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_display_units"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_menu"("p_start_date" "date", "p_end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."get_menu"("p_start_date" "date", "p_end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_menu"("p_start_date" "date", "p_end_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_product_from_shopping_list"("p_product_in_shopping_list_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_product_from_shopping_list"("p_product_in_shopping_list_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_product_from_shopping_list"("p_product_in_shopping_list_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_product_suggestion"("p_name" "text", "p_base_unit" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_product_suggestion"("p_name" "text", "p_base_unit" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_product_suggestion"("p_name" "text", "p_base_unit" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_shopping_list"("p_shopping_list_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_shopping_list"("p_shopping_list_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_shopping_list"("p_shopping_list_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_shopping_list_desc"("p_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_shopping_list_desc"("p_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_shopping_list_desc"("p_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_shopping_lists"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_shopping_lists"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_shopping_lists"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_meal"("p_user_meal_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_meal"("p_user_meal_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_meal"("p_user_meal_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_meal_ingredients"("p_user_meal_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_meal_ingredients"("p_user_meal_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_meal_ingredients"("p_user_meal_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_meals"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_meals"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_meals"() TO "service_role";



GRANT ALL ON FUNCTION "public"."remove_category"("p_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."remove_category"("p_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."remove_category"("p_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."remove_product_from_shopping_list"("p_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."remove_product_from_shopping_list"("p_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."remove_product_from_shopping_list"("p_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."remove_shopping_list"("p_shopping_list_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."remove_shopping_list"("p_shopping_list_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."remove_shopping_list"("p_shopping_list_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."toggle_product_in_cart"("p_product_in_shopping_list_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."toggle_product_in_cart"("p_product_in_shopping_list_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."toggle_product_in_cart"("p_product_in_shopping_list_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_user_meal"("p_user_meal_id" "uuid", "p_name" "text", "p_type" "text", "p_receipe_desc" "text", "p_receipe_link" "text", "p_servings" numeric, "p_servings_multiplier" numeric) TO "anon";
GRANT ALL ON FUNCTION "public"."update_user_meal"("p_user_meal_id" "uuid", "p_name" "text", "p_type" "text", "p_receipe_desc" "text", "p_receipe_link" "text", "p_servings" numeric, "p_servings_multiplier" numeric) TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_user_meal"("p_user_meal_id" "uuid", "p_name" "text", "p_type" "text", "p_receipe_desc" "text", "p_receipe_link" "text", "p_servings" numeric, "p_servings_multiplier" numeric) TO "service_role";



GRANT ALL ON FUNCTION "public"."update_user_meal_ingredient"("p_id" "uuid", "p_quantity" numeric, "p_name" "text", "p_base_unit" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."update_user_meal_ingredient"("p_id" "uuid", "p_quantity" numeric, "p_name" "text", "p_base_unit" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_user_meal_ingredient"("p_id" "uuid", "p_quantity" numeric, "p_name" "text", "p_base_unit" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."upsert_menu_item"("p_user_meal_id" "uuid", "p_original_meal_id" "uuid", "p_meal_time" timestamp without time zone, "p_id" "uuid", "p_type" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."upsert_menu_item"("p_user_meal_id" "uuid", "p_original_meal_id" "uuid", "p_meal_time" timestamp without time zone, "p_id" "uuid", "p_type" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."upsert_menu_item"("p_user_meal_id" "uuid", "p_original_meal_id" "uuid", "p_meal_time" timestamp without time zone, "p_id" "uuid", "p_type" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."upsert_menu_items"("p_items" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."upsert_menu_items"("p_items" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."upsert_menu_items"("p_items" "jsonb") TO "service_role";



GRANT ALL ON TABLE "public"."base_units" TO "anon";
GRANT ALL ON TABLE "public"."base_units" TO "authenticated";
GRANT ALL ON TABLE "public"."base_units" TO "service_role";



GRANT ALL ON TABLE "public"."category" TO "anon";
GRANT ALL ON TABLE "public"."category" TO "authenticated";
GRANT ALL ON TABLE "public"."category" TO "service_role";



GRANT ALL ON TABLE "public"."display_units" TO "anon";
GRANT ALL ON TABLE "public"."display_units" TO "authenticated";
GRANT ALL ON TABLE "public"."display_units" TO "service_role";



GRANT ALL ON TABLE "public"."list_counter" TO "anon";
GRANT ALL ON TABLE "public"."list_counter" TO "authenticated";
GRANT ALL ON TABLE "public"."list_counter" TO "service_role";



GRANT ALL ON TABLE "public"."meal" TO "anon";
GRANT ALL ON TABLE "public"."meal" TO "authenticated";
GRANT ALL ON TABLE "public"."meal" TO "service_role";



GRANT ALL ON TABLE "public"."meal_ingredient" TO "anon";
GRANT ALL ON TABLE "public"."meal_ingredient" TO "authenticated";
GRANT ALL ON TABLE "public"."meal_ingredient" TO "service_role";



GRANT ALL ON TABLE "public"."menu_item" TO "anon";
GRANT ALL ON TABLE "public"."menu_item" TO "authenticated";
GRANT ALL ON TABLE "public"."menu_item" TO "service_role";



GRANT ALL ON TABLE "public"."product" TO "anon";
GRANT ALL ON TABLE "public"."product" TO "authenticated";
GRANT ALL ON TABLE "public"."product" TO "service_role";



GRANT ALL ON TABLE "public"."product_in_shopping_list" TO "anon";
GRANT ALL ON TABLE "public"."product_in_shopping_list" TO "authenticated";
GRANT ALL ON TABLE "public"."product_in_shopping_list" TO "service_role";



GRANT ALL ON TABLE "public"."shopping_list" TO "anon";
GRANT ALL ON TABLE "public"."shopping_list" TO "authenticated";
GRANT ALL ON TABLE "public"."shopping_list" TO "service_role";



GRANT ALL ON TABLE "public"."user_meal" TO "anon";
GRANT ALL ON TABLE "public"."user_meal" TO "authenticated";
GRANT ALL ON TABLE "public"."user_meal" TO "service_role";



GRANT ALL ON TABLE "public"."user_meal_ingredient" TO "anon";
GRANT ALL ON TABLE "public"."user_meal_ingredient" TO "authenticated";
GRANT ALL ON TABLE "public"."user_meal_ingredient" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






