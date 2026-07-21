--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8 (Debian 15.8-1.pgdg120+1)

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

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

INSERT INTO auth.users VALUES ('00000000-0000-0000-0000-000000000000', '68a905eb-9d6d-4fe4-b368-a43f731fbe7c', 'authenticated', 'authenticated', 'kurczaczkowerzeczy@gmail.com', '$2a$10$kjT/5kG6AbBNqRBWCPpJo.UPipJAfsVIdlkX6qGwGz9795bvSKNJi', '2026-05-09 13:21:37.670674+00', NULL, '', NULL, '', '2026-05-09 14:40:14.886747+00', '', '', NULL, '2026-07-18 20:16:45.947595+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-05-09 13:21:37.641576+00', '2026-07-18 20:16:46.011981+00', NULL, NULL, '', '', NULL, DEFAULT, '', 0, NULL, '', NULL, false, NULL, false);
INSERT INTO auth.users VALUES ('00000000-0000-0000-0000-000000000000', '2ae0f11f-1724-4802-a028-61e74c13c9c8', 'authenticated', 'authenticated', 'kurczaczkowerzeczy+test@gmail.com', '$2a$10$aWmPPFMqcJifOT3jPLMW0OqlrIxVsEJxH/cj7xkr6mQuZ2GAXEIoa', '2026-04-15 19:58:20.735131+00', NULL, '', NULL, '', '2026-05-09 15:43:35.155088+00', '', '', NULL, '2026-05-09 15:43:45.403777+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-04-15 19:58:20.652775+00', '2026-07-19 08:36:04.544053+00', NULL, NULL, '', '', NULL, DEFAULT, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

INSERT INTO auth.identities VALUES ('2ae0f11f-1724-4802-a028-61e74c13c9c8', '2ae0f11f-1724-4802-a028-61e74c13c9c8', '{"sub": "2ae0f11f-1724-4802-a028-61e74c13c9c8", "email": "kurczaczkowerzeczy+test@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2026-04-15 19:58:20.696627+00', '2026-04-15 19:58:20.696682+00', '2026-04-15 19:58:20.696682+00', DEFAULT, 'a86f2629-5c70-4b20-aa7c-c7f6358f4600');
INSERT INTO auth.identities VALUES ('68a905eb-9d6d-4fe4-b368-a43f731fbe7c', '68a905eb-9d6d-4fe4-b368-a43f731fbe7c', '{"sub": "68a905eb-9d6d-4fe4-b368-a43f731fbe7c", "email": "kurczaczkowerzeczy@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2026-05-09 13:21:37.661123+00', '2026-05-09 13:21:37.661768+00', '2026-05-09 13:21:37.661768+00', DEFAULT, '83362b57-be48-43ce-959d-5c9926a47d38');


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: base_units; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.base_units VALUES ('m');
INSERT INTO public.base_units VALUES ('ml');
INSERT INTO public.base_units VALUES ('q');
INSERT INTO public.base_units VALUES ('p');
INSERT INTO public.base_units VALUES ('g');


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.category VALUES ('2023-01-20 21:33:33.981346+00', 'Mięso', 'FF4F4F', '677c22cd-1609-4c68-9126-bd5b3a8e3d3a');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Pieczywo', 'FFB84F', 'b0b5dfe4-2868-4996-807c-9d04846aefd7');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Ryby i owoce morza', '4FCAFF', '3afa0e98-6f37-4e64-9768-469ec1d859ed');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Warzywa i owoce', '3DC753', '8f91769c-1b9f-4837-b9b7-254f1d609267');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Nabiał', 'C6C85A', '9c1b53cc-5bab-49b8-b596-6eed36eeed25');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Produkty sypkie', 'C9642C', '9ee69362-ca4a-45f8-8f40-161b4d10ed4f');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Przyprawy', 'FC65FF', '5b5184ae-b941-451d-a970-e2843e90c613');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Alkohole', 'C9482C', '1be0d760-6cb9-4a18-be10-18375f4ad2de');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Chemia', '874FFF', '3d6379ff-d887-43bf-b683-4762e5a67b3b');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Inne', '43D1B8', 'a7535a36-4bef-471f-85f8-9c79177b13cd');
INSERT INTO public.category VALUES ('2023-02-05 18:13:25.218485+00', 'Soki i napoje', '444444', '280b0052-41ce-4876-9de5-95fadfd1fe04');
INSERT INTO public.category VALUES ('2023-01-20 22:11:21.51905+00', 'Konserwowe i sosy', '979797', '960e8045-d3cf-4607-87a6-310324d6dca5');
INSERT INTO public.category VALUES ('2025-08-23 14:03:45.304501+00', 'Budowlane', 'c04000', '4a200aa5-07c6-4128-8266-b80b8f3065ad');
INSERT INTO public.category VALUES ('2026-07-20 20:11:41.371572+00', 'Dania gotowe', '693901', 'c446cd25-660f-4053-9fe1-16234fb0951e');

--
-- Data for Name: display_units; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.display_units VALUES ('centymetr', 'cm', 'm', 0.0100000000);
INSERT INTO public.display_units VALUES ('gram', 'g', 'g', 1.0000000000);
INSERT INTO public.display_units VALUES ('kilogram', 'kg', 'g', 1000.0000000000);
INSERT INTO public.display_units VALUES ('litr', 'l', 'ml', 1000.0000000000);
INSERT INTO public.display_units VALUES ('metr', 'm', 'm', 1.0000000000);
INSERT INTO public.display_units VALUES ('sztuka', 'szt.', 'q', 1.0000000000);
INSERT INTO public.display_units VALUES ('dekagram', 'dag', 'g', 10.0000000000);
INSERT INTO public.display_units VALUES ('mililitr', 'ml', 'ml', 1.0000000000);
INSERT INTO public.display_units VALUES ('opakowanie', 'opak.', 'p', 1.0000000000);


--
-- Data for Name: list_counter; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.list_counter VALUES ('68a905eb-9d6d-4fe4-b368-a43f731fbe7c', 196);


--
-- Data for Name: meal; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.meal VALUES ('b032d89a-749d-44b6-9cec-751bd5373164', 'Zupa cebulowa', 'Zupa', '', 'https://www.kwestiasmaku.com/kuchnia_francuska/zupa_cebulowa/przepis.html', '2ae0f11f-1724-4802-a028-61e74c13c9c8', 6, 1, '2026-05-07 19:52:18.775241+00', '2026-05-07 19:52:18.775241+00', NULL);
INSERT INTO public.meal VALUES ('a8869542-9b9e-4a30-af7a-eac9cb84dda9', 'Kurczak curry z ryżem', 'Drugie danie', 'Opis', 'https://example.com', '68a905eb-9d6d-4fe4-b368-a43f731fbe7c', 2, 1, '2026-05-19 19:33:05.189586+00', '2026-05-19 19:33:05.189586+00', NULL);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.product VALUES ('2026-05-07 18:56:44.091272+00', 'Białe wytrawne wino', 'ml', '396f5e7d-fa8d-4615-b120-835f54746bf7');
INSERT INTO public.product VALUES ('2026-05-07 18:58:10.474779+00', 'bulion', 'ml', '0fc93d43-2f1d-430a-b150-2cb39f055238');
INSERT INTO public.product VALUES ('2026-05-07 18:59:15.201005+00', 'koniak', 'ml', '05266f64-f452-4b03-8c2b-2d2215a53134');
INSERT INTO public.product VALUES ('2025-08-29 13:21:29.41725+00', 'Tawot', 'q', '58150579-5a4e-4662-956c-948659570cfd');
INSERT INTO public.product VALUES ('2025-08-21 19:26:21.319024+00', 'pomidory koktajlowe', 'm', '8a1de5f3-77c7-40a4-aa9e-22f27ec3f047');
INSERT INTO public.product VALUES ('2025-08-16 10:37:21.215226+00', 'mleko', 'ml', '49f60bd8-a2f4-4d89-b66a-68ae7c0f2c3f');
INSERT INTO public.product VALUES ('2025-12-30 12:45:42.318192+00', 'śmietanka 30%', 'ml', '7a9b5b04-c447-46a7-9f0e-6e51c2ec4c91');
INSERT INTO public.product VALUES ('2026-02-07 10:39:17.960416+00', 'spirytus', 'ml', 'a8aaad69-4a9d-41c3-bc91-53152ee23296');
INSERT INTO public.product VALUES ('2025-08-15 11:44:29.302819+00', 'żel pod prysznic', 'q', 'afc4ec99-dcc2-4948-8924-2de7f3b176c3');
INSERT INTO public.product VALUES ('2025-08-15 11:45:33.396438+00', 'awokado', 'q', '54f70cee-0e24-49f4-a1a7-6677247d0595');
INSERT INTO public.product VALUES ('2025-08-21 15:19:43.06543+00', 'Miarka pojemność szklanki', 'q', 'a2ce93a7-df84-4632-b72e-035732c2bd3c');
INSERT INTO public.product VALUES ('2025-08-21 15:20:11.279453+00', 'Miarka pojemność 0,5L', 'q', 'addf24bd-a3fe-4d77-81c5-064ca94a3a91');
INSERT INTO public.product VALUES ('2025-08-21 15:20:31.749732+00', 'Maszynki do golenia', 'q', '3f867e8b-56ef-4afd-b5d8-55bf39327f08');
INSERT INTO public.product VALUES ('2025-08-21 15:20:45.52457+00', 'Płyn do płukania', 'q', '0d9ac3cc-e7a5-4c00-83cc-760d53409d34');
INSERT INTO public.product VALUES ('2025-08-21 15:22:09.771119+00', 'Sok do herbaty', 'q', '3a1affcc-54f2-47c8-aa44-76989d77ab9c');
INSERT INTO public.product VALUES ('2025-08-21 15:22:17.399398+00', 'sok cytrynowy', 'q', '34ccddd3-30b5-409c-87fc-c093f829f113');
INSERT INTO public.product VALUES ('2025-08-21 15:22:40.335927+00', 'musztarda', 'q', 'd9a245fb-e3c9-43f8-8745-6437ebd7b6e5');
INSERT INTO public.product VALUES ('2025-08-21 15:23:16.329337+00', 'ketchup', 'q', '487b4431-cc83-4772-b956-db7ecb6c5438');
INSERT INTO public.product VALUES ('2025-08-23 13:54:16.692142+00', 'sos sojowy bezglutenowy', 'q', 'b8f1b189-2958-4ebc-8ef1-87da5bfde4bf');
INSERT INTO public.product VALUES ('2025-08-28 15:47:44.85215+00', 'alpro migdałowe', 'q', '21aab52b-bf13-42e2-838c-69a8a45f6a3a');
INSERT INTO public.product VALUES ('2025-08-28 15:54:03.714853+00', 'ogórek zielony długi', 'q', 'e5a01316-8f6a-42c5-a537-b66726c91d14');
INSERT INTO public.product VALUES ('2025-08-30 07:48:52.300186+00', 'olej sezamowy', 'q', 'bea50944-0f5f-4572-9966-de3757c0c519');
INSERT INTO public.product VALUES ('2025-09-01 16:25:34.709192+00', 'tyskie', 'q', '216bfe1d-a127-4cc5-91da-17f456dbef4a');
INSERT INTO public.product VALUES ('2025-09-03 06:26:31.40776+00', 'oregano', 'q', 'a6634644-b90d-4c36-8ffe-929d61c4c1e1');
INSERT INTO public.product VALUES ('2025-09-04 14:39:52.477045+00', 'zioła prowansalskie', 'q', '8418d386-7fda-4782-b069-64f9dfbe8d38');
INSERT INTO public.product VALUES ('2025-09-04 14:45:00.949438+00', 'cebula', 'q', 'ed910792-70cd-4ec7-869e-683471ca52b5');
INSERT INTO public.product VALUES ('2025-09-06 10:25:31.900929+00', 'chleb', 'q', '50d21f26-fdc5-45f6-842c-3590a7bbcb4c');
INSERT INTO public.product VALUES ('2025-09-06 13:17:43.66709+00', 'Olej', 'q', 'b783e7e5-387b-4bd1-8d2f-8986f844133d');
INSERT INTO public.product VALUES ('2025-09-09 14:52:42.079021+00', 'avocado', 'q', '1814c2ff-29ca-4f53-ae2a-9a2b55afec6d');
INSERT INTO public.product VALUES ('2025-09-09 14:59:47.074725+00', 'marchew', 'q', '89b5680a-623f-4f92-8dfc-4b2cc8041f01');
INSERT INTO public.product VALUES ('2025-09-09 15:05:14.773361+00', 'sałata', 'q', '5251ab3b-fd3d-4cfe-b770-b1e422579f1c');
INSERT INTO public.product VALUES ('2025-09-12 11:57:10.026961+00', 'oliwa z oliwek', 'q', '2566d755-3d8f-45bd-8e20-feb143deeeb6');
INSERT INTO public.product VALUES ('2025-09-12 11:57:29.974922+00', 'żel do mycia twarzy', 'q', 'cc8dd1e7-6a13-4d76-b60a-0bb6db633855');
INSERT INTO public.product VALUES ('2025-09-12 11:58:14.39171+00', 'papier toaletowy', 'q', '44b767fa-b01f-4342-8dd3-252dd2f8bb51');
INSERT INTO public.product VALUES ('2025-09-13 13:57:14.462555+00', 'sałata rzymska', 'q', 'e71e17f4-c56c-4843-a738-b8f128d5afa4');
INSERT INTO public.product VALUES ('2025-09-14 16:06:05.736173+00', 'Imbir', 'q', 'bae3ff18-fbac-4bb4-a60d-201babae89b1');
INSERT INTO public.product VALUES ('2025-09-20 07:06:30.749188+00', 'sok pomarańczowy', 'q', '2e1e7774-0324-428f-9c86-18ca6769d889');
INSERT INTO public.product VALUES ('2025-09-20 07:10:01.047663+00', 'szczypiorek', 'q', 'd8060309-1ea3-4a62-877b-8ceef67f33e1');
INSERT INTO public.product VALUES ('2025-10-02 15:01:31.406821+00', 'środek grzybobójczy do roślin', 'q', '1129a57e-6a66-4105-8f5f-282095257b62');
INSERT INTO public.product VALUES ('2025-10-02 15:08:10.195152+00', 'bazylia', 'q', '757dc592-c899-4a56-8066-30cac4c9588b');
INSERT INTO public.product VALUES ('2025-10-03 06:13:41.143327+00', 'Płyn do czyszczenia zmywarek', 'q', '7b8cfd60-47cb-4adf-9a2c-fb8767fc4925');
INSERT INTO public.product VALUES ('2025-10-11 06:08:45.953507+00', 'dynia', 'q', '3874c17a-7413-45a0-ab31-2e316d033d18');
INSERT INTO public.product VALUES ('2025-10-11 06:11:15.456931+00', 'pomidory koktajlowe', 'q', 'd8726dfc-1a6a-4a3c-8454-a7bbb218b1ad');
INSERT INTO public.product VALUES ('2025-10-11 06:40:49.029596+00', 'majtki', 'q', '0ccc3b4c-a660-46be-a6c5-2aefb798231a');
INSERT INTO public.product VALUES ('2025-10-11 07:06:32.69167+00', 'Groszek konserwowy', 'q', 'ff1dfdb2-74e6-433b-a593-e7b3a3a92652');
INSERT INTO public.product VALUES ('2025-10-11 07:06:46.530674+00', 'kukurydza konserwowa', 'q', '30510650-8fd5-4d44-af11-8860aa6f5957');
INSERT INTO public.product VALUES ('2025-10-11 07:07:47.273137+00', 'Kiełbasa laska', 'q', '526752ed-0250-4486-aa7e-cf36e73cf878');
INSERT INTO public.product VALUES ('2025-10-15 20:37:48.902366+00', 'Nożyce do gałęzi', 'q', 'dc5bbaab-3896-4717-9037-e635d19dfc4f');
INSERT INTO public.product VALUES ('2025-10-15 20:38:21.325923+00', 'Pasta do zębów', 'q', '1cd89b39-3ce7-443d-a165-1e1d76c32fda');
INSERT INTO public.product VALUES ('2025-10-15 20:39:41.898821+00', 'Worki 60L', 'q', 'ce57949d-3851-4040-be42-51123479d4a7');
INSERT INTO public.product VALUES ('2025-10-16 10:10:15.383864+00', 'nożyczki', 'q', '0cb15cfa-8c73-40d3-bd3e-fe28b76ca251');
INSERT INTO public.product VALUES ('2025-10-16 10:10:52.335192+00', 'makrela', 'q', '8aece1eb-2490-453a-9057-78a15dcfb52a');
INSERT INTO public.product VALUES ('2025-10-30 16:40:29.514751+00', 'kawa', 'q', '350cf3a6-38e0-4be7-a71f-531d39819e42');
INSERT INTO public.product VALUES ('2025-10-30 16:55:11.830834+00', 'masło klarowane', 'q', '8f5320c4-6e62-4ca4-9079-de8fc5bd211d');
INSERT INTO public.product VALUES ('2025-10-30 17:22:07.635793+00', 'pita', 'q', '801b9b22-a019-414c-b7f1-0d205f038e49');
INSERT INTO public.product VALUES ('2025-10-30 17:20:34.664125+00', 'bagietka', 'q', '95ab2b49-f158-4f6c-bcb5-609da2fd5ce8');
INSERT INTO public.product VALUES ('2025-11-22 09:54:18.37765+00', 'szampon do włosów', 'q', '9b5beb3c-02a7-4a93-826d-607c618083c1');
INSERT INTO public.product VALUES ('2025-11-22 09:54:41.012576+00', 'płyn do mycia łazienki', 'q', '79663d1e-b048-4110-a28b-1398b347d659');
INSERT INTO public.product VALUES ('2025-11-22 09:56:15.561825+00', 'fasola czerwona', 'q', '57103c71-78ad-41d2-8754-f2c88aeef13c');
INSERT INTO public.product VALUES ('2025-11-22 10:00:05.172026+00', 'pasztet', 'q', '5e7aa57d-9aa3-4ced-875d-b16b5bec801c');
INSERT INTO public.product VALUES ('2025-11-27 14:23:55.616651+00', 'pomidory z puszki', 'q', 'fe58c956-42bb-4d8d-8c7a-e53a4a5bbbd3');
INSERT INTO public.product VALUES ('2025-11-29 07:38:14.421723+00', 'przyprawa do gyrosa', 'q', '3b5983b3-94d1-411b-8e76-dd7f822bcd00');
INSERT INTO public.product VALUES ('2025-12-12 17:57:17.229113+00', 'Miód', 'q', '613ce1ce-af19-4356-ab5a-b6cecfb4e677');
INSERT INTO public.product VALUES ('2025-12-12 17:57:38.519913+00', 'Maślanka', 'q', 'ecbe15c1-10be-442d-a36f-9b4a0f51091d');
INSERT INTO public.product VALUES ('2025-12-13 08:47:20.700751+00', 'noodle', 'q', 'd424036d-3f2b-4dba-9c7f-1c0f536f99c5');
INSERT INTO public.product VALUES ('2025-12-13 08:48:13.870321+00', 'pietruszka', 'q', '8373d371-66de-46ed-8e97-26065fc15070');
INSERT INTO public.product VALUES ('2025-12-30 12:31:26.687879+00', 'papryka czerwona', 'q', '64aa0638-5170-48b1-8d19-b20aded143d7');
INSERT INTO public.product VALUES ('2025-12-30 12:32:42.433893+00', 'pierogi ruskie', 'q', '83d42c62-342c-4240-8dca-99d17e6a641c');
INSERT INTO public.product VALUES ('2025-12-30 12:32:59.027672+00', 'kiszka', 'q', '1b0f5fec-b9a8-41b8-83a6-50566570779b');
INSERT INTO public.product VALUES ('2025-12-30 12:33:11.522794+00', 'Kiełbasa', 'q', '0342a629-71a4-4b4f-a507-a6ac5c06e349');
INSERT INTO public.product VALUES ('2025-12-30 12:38:03.809644+00', 'ryba wędzona', 'q', '1ac8d97b-4771-455f-9f5e-a3c0bc04bed8');
INSERT INTO public.product VALUES ('2026-01-03 10:00:05.595289+00', 'bułka', 'q', 'f5ceda26-d5c4-4b34-bcb3-33b4757c717a');
INSERT INTO public.product VALUES ('2026-01-03 10:02:06.088087+00', 'koncentrat pomidorowy 30%', 'q', 'd4ad78df-eed0-4226-882f-9e0e285cf5ef');
INSERT INTO public.product VALUES ('2026-01-05 07:21:55.725592+00', 'Waciki', 'q', '7b156cbb-cd67-482a-9a0c-9270f850c73b');
INSERT INTO public.product VALUES ('2026-01-05 07:22:50.793314+00', 'Mydło', 'q', 'a0686fbf-919a-4495-bbe5-bd205974aa73');
INSERT INTO public.product VALUES ('2026-01-05 07:31:04.943678+00', 'Tonik', 'q', '3a1815df-741d-4e7d-ad3d-d9a8f01e9dbf');
INSERT INTO public.product VALUES ('2026-01-05 21:50:13.445183+00', 'Żel do golenia', 'q', '3405b211-be0b-42ab-99c3-7e1aaea1bba7');
INSERT INTO public.product VALUES ('2026-01-08 14:14:56.370249+00', 'cebula czerwona', 'q', '7a0000d7-a102-4ee7-bc60-411d262880ce');
INSERT INTO public.product VALUES ('2026-01-10 07:37:46.67622+00', 'natka pietruszki', 'q', '4866e43d-2245-47c1-82f0-3241bc745089');
INSERT INTO public.product VALUES ('2026-01-10 09:08:51.144231+00', 'Płyn do spryskiwaczy ', 'q', 'e3bf4afb-115c-4ca9-8640-b9c57b8ffea6');
INSERT INTO public.product VALUES ('2026-01-13 07:22:04.25211+00', 'Płyn do czyszczenia pralki', 'q', '4f10eb24-b703-4bed-a5f9-50b8d5bcdff4');
INSERT INTO public.product VALUES ('2026-01-15 21:15:57.542775+00', 'Sól himalajska', 'q', '15b8a32e-1c6b-4a40-95ec-b3141d4cef30');
INSERT INTO public.product VALUES ('2026-01-23 16:26:40.857612+00', 'indyk mielony', 'q', 'd2cd15d1-41e1-404e-b6b5-9441ed998421');
INSERT INTO public.product VALUES ('2026-01-23 16:36:56.307628+00', 'masło', 'q', 'c0dcea5c-609f-4880-a619-aa6cab12c0c9');
INSERT INTO public.product VALUES ('2026-01-23 16:54:21.67383+00', 'masło orzechowe', 'q', '500b7574-7a73-481d-9092-6c659301c1f5');
INSERT INTO public.product VALUES ('2026-01-23 17:02:51.370861+00', 'rumianek', 'q', 'e1ca5892-df70-44d6-b7a3-1197ba26f1cb');
INSERT INTO public.product VALUES ('2026-01-23 17:06:26.399458+00', 'wiertłom 9∅', 'q', '791ecaa7-fcb4-495c-a0f4-b13906889fa9');
INSERT INTO public.product VALUES ('2026-01-23 17:19:53.895759+00', 'barszcz czerwony', 'q', '9661e694-b515-44b9-895a-9a9d72f54154');
INSERT INTO public.product VALUES ('2026-01-29 07:05:04.1886+00', 'Lubczyk', 'q', '91de841e-b35b-4b50-9c97-c884c3f57a59');
INSERT INTO public.product VALUES ('2026-02-05 14:34:11.376559+00', 'cola zero', 'q', '4215d478-df26-430a-840f-cb9ed9fed64a');
INSERT INTO public.product VALUES ('2026-02-07 09:53:20.857834+00', 'płatki kukurydziane', 'q', '1366ec9c-7d1f-46e6-9ebf-9ec4a759df54');
INSERT INTO public.product VALUES ('2026-03-07 09:23:26.534262+00', 'serek', 'q', '5c5f0685-9446-4781-bd90-77e84cb0720d');
INSERT INTO public.product VALUES ('2026-02-07 09:59:27.577252+00', 'papryka konserwowa', 'q', 'ec5b0105-ba11-429f-a3d7-008363609f75');
INSERT INTO public.product VALUES ('2026-02-07 10:38:12.181931+00', 'chleb razowy', 'q', 'b6b8c7f5-29e1-4b78-9ab2-6f037f66524e');
INSERT INTO public.product VALUES ('2026-02-07 10:46:37.049011+00', 'Cukier puder', 'q', '488b7977-d8e3-4463-b5e3-7beb0df5a29b');
INSERT INTO public.product VALUES ('2026-02-10 10:32:22.891733+00', 'Płyn do mycia szyb', 'q', '0e9a2b12-aeca-4469-8b00-24b05cb3b886');
INSERT INTO public.product VALUES ('2026-02-10 10:32:36.796998+00', 'Płyn do mycia kuchni', 'q', 'caaa5004-610b-4838-8d99-2596b77fcca7');
INSERT INTO public.product VALUES ('2026-02-13 11:50:41.162099+00', 'Deska do krojenia ', 'q', 'dea70db4-a614-476d-9a52-a8497fefa6e1');
INSERT INTO public.product VALUES ('2026-02-13 11:51:01.753162+00', 'Herbata', 'q', 'fca9227d-7ad7-407b-9fe4-4b5b84d77fa0');
INSERT INTO public.product VALUES ('2026-02-14 07:25:13.803827+00', 'surówka', 'q', '868897ba-019c-4a17-b7a7-85fd3711f8f5');
INSERT INTO public.product VALUES ('2026-02-19 15:19:40.863268+00', 'twaróg półtłusty', 'q', '4741c80a-6820-40dd-a648-21cbdbeaa850');
INSERT INTO public.product VALUES ('2026-02-20 19:09:39.489138+00', 'Deska do prasowania ', 'q', 'e193e749-e5c0-46d6-8be9-1bc765f9b073');
INSERT INTO public.product VALUES ('2026-02-21 08:22:46.98596+00', 'Glimbax do płukania', 'q', '5ab4e540-41d1-42b1-b162-96c6eaa90d89');
INSERT INTO public.product VALUES ('2026-02-26 16:33:07.160367+00', 'twaróg chudy', 'q', 'de400d21-6df2-46ff-84b2-ed72fb64eff3');
INSERT INTO public.product VALUES ('2026-02-26 22:13:10.807239+00', 'Spinka do włosów', 'q', 'fe4eb535-bdd7-4721-9fe3-dbff8309eb12');
INSERT INTO public.product VALUES ('2026-02-28 15:24:39.438389+00', 'proszek do pieczenia', 'q', 'e46028c4-ad38-4080-b31e-57cef91f7472');
INSERT INTO public.product VALUES ('2026-03-04 16:59:57.786374+00', 'Nóż mały do dłubania w warzywach', 'q', 'b357116f-1c39-4a63-ac1b-6b456f0d168a');
INSERT INTO public.product VALUES ('2026-03-05 15:33:18.589887+00', 'czosnek granulowany', 'q', '92f83476-74b1-4181-ba56-56489d1f58ff');
INSERT INTO public.product VALUES ('2026-03-05 15:38:28.143649+00', 'serek śmietankowy', 'q', 'b5222c54-7d4d-459e-9189-3b7c5c63aaa1');
INSERT INTO public.product VALUES ('2026-03-05 16:00:12.817877+00', 'żel do miejsc intymnych', 'q', 'f4699cab-0d69-44d3-9f09-7711bec7ed12');
INSERT INTO public.product VALUES ('2026-03-23 11:06:00.418566+00', 'chleb żytni', 'q', '1fb524e5-a09a-4ab1-8084-90c7b6d875fd');
INSERT INTO public.product VALUES ('2026-04-11 06:44:24.498426+00', 'chleb żytni razowy', 'q', '8e6b530a-c743-4b51-a9cb-3f3947e59ac4');
INSERT INTO public.product VALUES ('2026-04-11 06:55:08.707008+00', 'Ryż do sushi', 'q', '5cc2f193-567c-4c5b-921a-87035c20eadb');
INSERT INTO public.product VALUES ('2026-04-11 06:55:25.428628+00', 'Tykwa', 'q', '66a9b68d-043d-4639-9bd7-ad90b5e5e9b2');
INSERT INTO public.product VALUES ('2026-04-11 06:56:14.038124+00', 'Nori', 'q', '0f513c95-1465-412c-a210-7e131aad0cab');
INSERT INTO public.product VALUES ('2026-04-12 07:18:39.098005+00', 'odżywka', 'q', '4373d0e7-4b8e-4139-8111-88a10a2cfe6a');
INSERT INTO public.product VALUES ('2026-04-18 07:00:07.078628+00', 'seler konserwowy', 'q', '629dd35d-ec02-46ce-8029-d809547bcb93');
INSERT INTO public.product VALUES ('2026-04-18 07:10:36.326928+00', 'Nabłyszczacz do zmywarki', 'q', '0749a482-21a6-480f-9ed3-5074980ae86a');
INSERT INTO public.product VALUES ('2025-08-23 13:54:08.948126+00', 'jajka', 'p', '5f22ec99-6021-4d9b-8451-0e80d081c68b');
INSERT INTO public.product VALUES ('2025-08-23 13:57:20.154816+00', 'koper', 'p', 'a3a1eb1c-bb99-4965-910c-12bbfa12c5bb');
INSERT INTO public.product VALUES ('2025-08-23 14:05:17.433356+00', 'zestaw kluczy', 'p', '6afb5441-3e70-4a20-b4eb-097069e229a9');
INSERT INTO public.product VALUES ('2025-08-27 11:08:37.748271+00', 'mleko', 'p', '986903b7-26f7-498b-91d9-5e6139a266e2');
INSERT INTO public.product VALUES ('2025-09-09 14:48:11.598057+00', 'cynamon', 'p', '415f2cbd-9aa0-463c-b6db-da6599a15a7f');
INSERT INTO public.product VALUES ('2025-09-09 14:59:28.360579+00', 'skrzydełka', 'p', '6dde53b2-0fb8-4f28-8521-9545ca4ac114');
INSERT INTO public.product VALUES ('2025-09-20 07:07:42.353588+00', 'nać pietruszki', 'p', 'f8720dea-e343-4d5c-8fe6-78a0bf53ac0c');
INSERT INTO public.product VALUES ('2025-09-25 15:25:14.087856+00', 'papryka konserwowa', 'p', 'd92ecd4a-b130-4609-98cb-66780bc5f30e');
INSERT INTO public.product VALUES ('2025-10-04 08:16:42.622543+00', 'pojemniki', 'p', '8ebba954-1678-434a-9669-095a2d9b11b5');
INSERT INTO public.product VALUES ('2025-10-11 06:06:52.72578+00', 'ogórek zielony', 'p', '6d8cdcf1-4bb8-4d0b-a4ce-3fcb83be4b49');
INSERT INTO public.product VALUES ('2025-10-16 10:18:06.005817+00', 'tortillla pełnoziarnista', 'p', '28d28fc9-09cb-4a32-b546-f75e2a639893');
INSERT INTO public.product VALUES ('2025-11-22 09:58:58.378642+00', 'bulion', 'p', '742b57b4-94e4-490c-b55c-bad8389753dc');
INSERT INTO public.product VALUES ('2025-11-22 10:03:23.668097+00', 'Kapsułki do prania', 'p', '30e9df56-0704-4a43-9939-7aaaf8a404f6');
INSERT INTO public.product VALUES ('2025-11-27 14:22:29.227148+00', 'rzodkiew', 'p', '195b21c7-8bcd-4425-b8b3-393156ca5ff7');
INSERT INTO public.product VALUES ('2026-01-08 14:28:42.796498+00', 'gumki sprężynowe do włosów', 'p', '4e84d638-4ad9-4871-8150-3b77c1948681');
INSERT INTO public.product VALUES ('2026-01-08 14:29:01.977101+00', 'agrafki', 'p', '11a3a3ed-71e2-4dbe-8aa4-7e814033c492');
INSERT INTO public.product VALUES ('2026-01-23 17:19:37.187272+00', 'uszka z mięsem', 'p', '42f9f6b1-0cee-42c7-90e5-2bdae573c4a6');
INSERT INTO public.product VALUES ('2026-01-23 17:20:35.214412+00', 'Kiełbasa', 'p', '5a3eb5fc-16ad-48b1-aa7a-c2a32dd2511b');
INSERT INTO public.product VALUES ('2026-02-10 10:31:42.631511+00', 'Kostki do zmywarki', 'p', '0bbbe100-81bc-405f-8490-82ffeae81318');
INSERT INTO public.product VALUES ('2026-03-12 16:02:58.740682+00', 'Worek na śmieci 35L', 'p', 'a258a74e-3a9d-4e5e-99fe-f9db5f46abab');
INSERT INTO public.product VALUES ('2026-04-15 05:26:59.394043+00', 'płatki kukurydziane', 'p', 'bcd4602c-8289-4a02-9f4a-b68e852251b8');
INSERT INTO public.product VALUES ('2025-08-15 11:45:02.322632+00', 'cebula', 'g', '1e552df8-8861-458f-b6d4-bbd537e63ffa');
INSERT INTO public.product VALUES ('2025-08-15 11:45:52.209796+00', 'cukinia', 'g', 'b92343d4-8683-453d-9505-d0cc231ad16d');
INSERT INTO public.product VALUES ('2025-08-15 11:46:21.581486+00', 'pomidor', 'g', 'b287535a-334a-405f-b3ed-a9a3471314ee');
INSERT INTO public.product VALUES ('2025-08-20 20:49:21.979729+00', 'Karkówka', 'g', 'd7179aaf-4b39-4237-bf7e-42bddf3c713d');
INSERT INTO public.product VALUES ('2025-08-21 15:23:55.277169+00', 'chleb bezglutenowy jasny', 'g', '02f9f332-9bd3-42fc-9aee-b43748522a6b');
INSERT INTO public.product VALUES ('2025-08-21 15:25:22.365685+00', 'pomidory koktajlowe', 'g', 'c7aaf154-9b6b-4151-9db1-34e726ae73f0');
INSERT INTO public.product VALUES ('2025-08-21 15:25:57.265919+00', 'ser cheddar w plastrach', 'g', 'c16d2a95-4b0e-4cd8-9a71-d4e4362e382c');
INSERT INTO public.product VALUES ('2025-08-21 15:26:19.728967+00', 'szynka z indyka', 'g', '8fa99216-09b7-43c7-8c26-1c347ceff92f');
INSERT INTO public.product VALUES ('2025-08-21 15:26:33.579348+00', 'szpinak', 'g', '87c4c70a-89c4-4f26-b464-aab414f369ac');
INSERT INTO public.product VALUES ('2025-08-21 15:28:17.210774+00', 'ser feta', 'g', '3527f64e-adc5-45f1-bf05-4d48bd746f82');
INSERT INTO public.product VALUES ('2025-08-21 15:29:21.33+00', 'twaróg półtłusty', 'g', 'a122deb9-deb0-4a6f-a840-6d01b436459f');
INSERT INTO public.product VALUES ('2025-08-21 15:29:33.765144+00', 'chleb żytni na zakwasie', 'g', '19bddadb-431d-4d73-966b-82799060efc9');
INSERT INTO public.product VALUES ('2025-08-21 15:30:19.789409+00', 'chleb', 'g', '3cafb3be-6f92-4019-87d7-6a0269f3b2ae');
INSERT INTO public.product VALUES ('2025-08-21 15:30:36.781613+00', 'jogurt naturalny', 'g', 'ad31b6a5-6e1c-4198-8bd9-d4fb265ce8f9');
INSERT INTO public.product VALUES ('2025-08-21 15:30:49.032249+00', 'pierś z kurczaka', 'g', '63d5c8c5-8cd4-4d89-8b2b-bc6bc19256f1');
INSERT INTO public.product VALUES ('2025-08-21 15:31:02.476899+00', 'szparagi', 'g', '02f29e80-e84b-42e2-be01-ad863e17d14e');
INSERT INTO public.product VALUES ('2025-08-21 15:31:28.145342+00', 'jogurt grecki', 'g', 'd467e93b-e65a-47b3-b8dc-2e7e5b22b081');
INSERT INTO public.product VALUES ('2025-08-21 15:31:56.904647+00', 'mozzarella', 'g', '2826b9db-eefc-4a15-a011-1496a4e71907');
INSERT INTO public.product VALUES ('2025-08-21 15:32:16.017634+00', 'parówki z indyka pikok', 'g', '995522db-efc1-49d7-b515-f6220b69630f');
INSERT INTO public.product VALUES ('2025-08-21 15:32:27.997055+00', 'rzodkiew', 'g', 'd02d7f07-8342-48ef-af2e-8373878f0099');
INSERT INTO public.product VALUES ('2025-08-21 15:32:40.028595+00', 'ziemniaki', 'g', '10d5c5bc-7bcb-4921-a5aa-44b1d90a7b6c');
INSERT INTO public.product VALUES ('2025-08-21 15:33:00.612541+00', 'wołowina rostbef', 'g', '8d3a7db6-0a4d-48a5-a60f-565553780c62');
INSERT INTO public.product VALUES ('2025-08-21 19:27:08.070276+00', 'pomidor', 'g', '658b2ece-0e55-44dc-a7a0-5b443d7c21cf');
INSERT INTO public.product VALUES ('2025-08-23 13:46:03.076082+00', 'pomidory z puszki', 'g', 'bfe5ae9b-2a28-4082-9d88-3c20f81cf1a0');
INSERT INTO public.product VALUES ('2025-08-23 13:46:40.704648+00', 'papryka czerwona', 'g', 'c82aaed1-8165-4287-bf22-399f2c5000e4');
INSERT INTO public.product VALUES ('2025-08-23 13:47:05.812175+00', 'tuńczyk w sosie własnym', 'g', '4fcad449-d381-48b1-b14d-aec371bc9dce');
INSERT INTO public.product VALUES ('2025-08-23 13:47:19.835252+00', 'cebula czerwona', 'g', '708b732b-2474-443e-9f0b-7cab2c829f6f');
INSERT INTO public.product VALUES ('2025-08-23 13:48:25.095449+00', 'wołowina, polędwica', 'g', '14588547-71a0-4f7b-92da-adc74a784d0e');
INSERT INTO public.product VALUES ('2025-08-23 13:49:19.566225+00', 'Ser halloumi', 'g', '80081285-3d56-4784-b190-247a86384795');
INSERT INTO public.product VALUES ('2025-08-23 13:49:41.211734+00', 'bakłażan', 'g', 'cd94be2d-5343-4d2f-9919-f0ae0a333538');
INSERT INTO public.product VALUES ('2025-08-23 13:50:01.740489+00', 'papryka żółta', 'g', 'dde9b2b7-763f-4c22-8aa0-785f5cf373a3');
INSERT INTO public.product VALUES ('2025-08-23 13:50:31.779604+00', 'marchew', 'g', '87fdb822-c4cb-4724-9964-4e29c1f68918');
INSERT INTO public.product VALUES ('2025-08-23 13:51:22.829944+00', 'tahini', 'g', 'ca8e8122-445d-4d46-bde9-fa2f7c9e91e9');
INSERT INTO public.product VALUES ('2025-08-23 13:51:33.492853+00', 'antrykot wołowy', 'g', '427d4fe9-b6ef-4236-a758-5edb5a5e58b6');
INSERT INTO public.product VALUES ('2025-08-23 13:52:07.145925+00', 'brokuły', 'g', '2e1b0e02-b56b-4f44-8d3f-9a2be41106c9');
INSERT INTO public.product VALUES ('2025-08-23 13:52:39.734035+00', 'makaron konjac ("0 kalorii")', 'g', '3e45a733-0b01-464d-a31e-c826e60a73fd');
INSERT INTO public.product VALUES ('2025-08-23 13:53:24.884037+00', 'łosoś', 'g', '98fe79e4-cc95-41a9-96d8-5a23196dd72c');
INSERT INTO public.product VALUES ('2025-08-23 13:53:46.77914+00', 'śmietanka 36%', 'g', 'ea0d5b50-9e16-4356-a4aa-260401f80779');
INSERT INTO public.product VALUES ('2025-08-24 19:10:02.363132+00', 'skyr', 'g', 'b187fe2d-e0fb-4aa3-8ad0-c52abc8c447a');
INSERT INTO public.product VALUES ('2025-08-27 19:14:21.865075+00', 'jabłka', 'g', '85425c96-c73d-4bdd-8744-a9de2cd61bd9');
INSERT INTO public.product VALUES ('2025-08-28 15:42:21.448018+00', 'puszka pomidorów krojonych', 'g', '8fbc71cd-8458-4569-8918-12986918da34');
INSERT INTO public.product VALUES ('2025-08-28 15:46:48.376109+00', 'mięso wołowe mielone z polędwicy', 'g', 'd3ae4cb2-8d5b-4197-9e25-49f7b2c4fa1a');
INSERT INTO public.product VALUES ('2025-08-28 15:48:11.822188+00', 'mozzarella light', 'g', 'cb23806f-36df-473d-bf69-8f06e7f7c9c8');
INSERT INTO public.product VALUES ('2025-08-28 15:49:19.723715+00', 'koncentrat pomidorowy 30%', 'g', 'eda9d26f-870f-4f03-b01b-2384948a1d06');
INSERT INTO public.product VALUES ('2025-08-28 15:49:57.156748+00', 'jarmuż', 'g', '80202b80-35a4-4ac7-8f1a-dc20b0b1998e');
INSERT INTO public.product VALUES ('2025-08-28 15:50:31.355747+00', 'boczek bez kości', 'g', 'a6df24dd-c66c-4292-ad62-493c3ced8adf');
INSERT INTO public.product VALUES ('2025-08-28 15:52:47.66009+00', 'ser gouda w plastrach', 'g', '9479d9d2-821b-4d63-9acb-adc8fcd901b8');
INSERT INTO public.product VALUES ('2025-08-28 15:53:36.267096+00', 'łopatka wieprzowa mielona', 'g', 'a9215e52-7050-45e8-a659-72a8470d0423');
INSERT INTO public.product VALUES ('2025-08-28 15:54:48.800221+00', 'śmietana 18%', 'g', 'a7018a1a-a366-431e-9a93-2c7dcfa7a78b');
INSERT INTO public.product VALUES ('2025-08-28 15:57:21.621374+00', 'cebulka dymka', 'g', '36522d2b-ecc4-43bb-aec0-8230f11b1572');
INSERT INTO public.product VALUES ('2025-08-30 07:43:36.641864+00', 'oliwki czarne', 'g', 'c6542921-2c89-4dcb-aa34-dbee7f5e6e27');
INSERT INTO public.product VALUES ('2025-09-04 14:55:20.994335+00', 'ogórek zielony długi', 'g', '86ccd716-9836-44a7-8204-72f8cc454466');
INSERT INTO public.product VALUES ('2025-09-06 08:38:18.258721+00', 'śmietana ', 'g', 'f904a6c4-8f63-43ed-883e-cbd49e9d71f6');
INSERT INTO public.product VALUES ('2025-09-09 14:47:15.991656+00', 'wiórki kokosowe', 'g', 'e03fa423-36c0-4687-bf6e-6df16c3ade71');
INSERT INTO public.product VALUES ('2025-09-09 15:03:52.201372+00', 'fasola czerwona', 'g', '04415a70-2ddf-4a80-b140-74c948dfbfd2');
INSERT INTO public.product VALUES ('2025-09-13 13:58:14.818713+00', 'fenkuł', 'g', 'b56a3539-25ef-4fc2-b163-af38946bd74c');
INSERT INTO public.product VALUES ('2025-09-13 13:59:05.330616+00', 'rzodkiewka', 'g', '59b98b1c-6a31-4ab7-83dd-f4714ac75274');
INSERT INTO public.product VALUES ('2025-09-13 13:59:12.974137+00', 'pomidory', 'g', 'f211d3d9-b5f5-462a-883a-f97b269d0def');
INSERT INTO public.product VALUES ('2025-09-13 14:00:11.541446+00', 'ser twarogowy półtłusty', 'g', '7fa512fe-cda8-4918-83fa-2f04348c1a05');
INSERT INTO public.product VALUES ('2025-09-13 14:00:51.530548+00', 'kuskus', 'g', '089c9254-6ca6-424b-815b-443c940714e4');
INSERT INTO public.product VALUES ('2025-09-13 14:01:11.743768+00', 'sok pomarańczowy', 'g', '52d88cb1-b20e-401b-a6bb-5217cf3fb158');
INSERT INTO public.product VALUES ('2025-09-13 14:01:33.485414+00', 'majonez light', 'g', 'df326aa3-faa7-485b-a7c8-22c38d42ee49');
INSERT INTO public.product VALUES ('2025-09-13 14:01:48.461329+00', 'kukurydza konserwowa', 'g', '23886aa5-0810-41dc-9371-4f852ba44010');
INSERT INTO public.product VALUES ('2025-09-13 14:02:01.741184+00', 'orzechy pinii', 'g', 'dcc12a7d-393e-4887-b150-29ca23626a2c');
INSERT INTO public.product VALUES ('2025-09-13 14:02:14.041285+00', 'pesto zielone z bazylii', 'g', '54fef4fd-b7f5-48d6-bed6-ba22b05411e7');
INSERT INTO public.product VALUES ('2025-09-18 14:21:31.125948+00', 'serek wiejski', 'g', '6b7ab5f1-361f-463c-a9de-1299d8ab7ffe');
INSERT INTO public.product VALUES ('2025-09-18 14:25:07.177537+00', 'pędy bambusa', 'g', 'b4b69fb3-5afd-446c-840f-f8a7e62948e7');
INSERT INTO public.product VALUES ('2025-09-18 14:25:59.685232+00', 'tofu naturalne', 'g', '2e50b67b-da84-48a3-93f1-bbd84933e72d');
INSERT INTO public.product VALUES ('2025-09-18 14:29:37.443482+00', 'grzyby shitake suszone', 'g', '0500da5b-33fe-4f9a-9f11-5aec65ac3363');
INSERT INTO public.product VALUES ('2025-09-18 14:32:51.851938+00', 'sos sojowy ciemny', 'g', 'cc8c1ba7-c1cc-463c-9d7f-f64842403249');
INSERT INTO public.product VALUES ('2025-09-18 14:33:06.826196+00', 'ocet ryżowy', 'g', '5a3b83cf-a1c9-4991-9fd3-49939c3a3ac8');
INSERT INTO public.product VALUES ('2025-09-18 14:33:30.501003+00', 'skrobia ziemniaczana', 'g', 'd3d5047d-5a22-4458-af12-2b68edc06f7e');
INSERT INTO public.product VALUES ('2025-09-18 14:35:11.615196+00', 'olej sezamowy', 'g', 'e074aac6-35e3-44be-9837-c640c757b8de');
INSERT INTO public.product VALUES ('2025-09-18 14:40:16.687962+00', 'ementaler pełnotłusty w plastrach', 'g', '08b1b94f-5cbf-4956-8bfa-028260167bee');
INSERT INTO public.product VALUES ('2025-09-18 14:42:06.691291+00', 'rukola', 'g', '865255d1-8728-4f84-a47a-469019d3dc2b');
INSERT INTO public.product VALUES ('2025-09-18 14:43:08.682477+00', 'franfurterki pikok pure', 'g', 'f2951c73-9fd4-4a56-904d-4d4bd555a54b');
INSERT INTO public.product VALUES ('2025-09-18 14:43:48.718339+00', 'roszpunka', 'g', 'fdf2e5a6-9af0-4acd-b5c9-776aad888caf');
INSERT INTO public.product VALUES ('2025-09-20 07:03:51.423876+00', 'pstrąg tęczowy', 'g', 'c958152d-634c-4fa7-9702-397b74735690');
INSERT INTO public.product VALUES ('2025-09-25 14:58:33.640407+00', 'serek', 'g', '88e3c3c9-c96f-492c-a6a0-775d5b8bc5ae');
INSERT INTO public.product VALUES ('2025-09-25 14:58:57.906385+00', 'borówki', 'g', 'ddf90d14-dd45-4dc9-8366-59049ab3827f');
INSERT INTO public.product VALUES ('2025-09-25 15:11:58.849962+00', 'ser parmezan', 'g', 'ed99ecbc-64d3-43de-890b-bcb2185b9e23');
INSERT INTO public.product VALUES ('2025-09-25 15:24:57.253827+00', 'łosoś wędzony', 'g', 'ec64e576-1a3d-460f-ad44-c2c7733961d2');
INSERT INTO public.product VALUES ('2025-09-27 05:22:54.214032+00', 'Orzechy włoaskie', 'g', '9fc9c008-1a39-40d6-9abf-a8ba2d536df7');
INSERT INTO public.product VALUES ('2025-09-27 05:24:59.048382+00', 'Mix sałat', 'g', '6bfe3cca-9f9c-457a-99ef-7d571a639aad');
INSERT INTO public.product VALUES ('2025-09-27 05:26:19.18443+00', 'avocado', 'g', 'b1ed2dce-93fb-4685-b4dc-7e0c5351fb6a');
INSERT INTO public.product VALUES ('2025-09-27 06:20:38.645853+00', 'mięso wołowe mielone z rostbefu', 'g', 'f17ff180-3a7a-40e3-85f8-56123cebf5fb');
INSERT INTO public.product VALUES ('2025-09-27 06:21:22.46286+00', 'Boczek wędzony', 'g', '798d17a5-91de-4e46-8364-6c0baac8fef2');
INSERT INTO public.product VALUES ('2025-09-27 06:21:45.672431+00', 'ser cheddar', 'g', '9b1759d1-6e9e-4fb3-a413-1d55e07e5592');
INSERT INTO public.product VALUES ('2025-09-27 06:23:27.948282+00', 'Serek mascapone', 'g', 'f94857e8-46ba-43b5-9100-a714993b28ec');
INSERT INTO public.product VALUES ('2025-10-02 15:06:35.59993+00', 'papryka zielona', 'g', 'e3e9090c-bd1c-49af-8d34-8dbdbeef2798');
INSERT INTO public.product VALUES ('2025-10-02 15:07:09.18398+00', 'kiełki brokuła', 'g', '8b3096a0-4fe6-4edf-a75c-135b2a6166a8');
INSERT INTO public.product VALUES ('2025-10-02 15:09:38.383183+00', 'groszek zielony', 'g', '5daf380b-506d-4f3c-b9dc-c0263af9e8dd');
INSERT INTO public.product VALUES ('2025-10-02 15:16:29.914306+00', 'pieczarki', 'g', 'e04471bf-5345-4356-95b3-added3582270');
INSERT INTO public.product VALUES ('2025-10-02 15:20:53.479595+00', 'oliwki zielone, marynowane, konserwowe', 'g', '04fa4474-5104-44aa-a107-3554f0870419');
INSERT INTO public.product VALUES ('2025-10-02 15:22:50.854194+00', 'mąka migdałowa', 'g', '14a83567-3a02-4ce4-8e56-eedaf04f440a');
INSERT INTO public.product VALUES ('2025-10-02 15:23:42.774164+00', 'serek śmietankowy', 'g', 'fcec7897-4713-4dc4-8bc8-1a156c21ef27');
INSERT INTO public.product VALUES ('2025-09-27 06:22:19.732661+00', 'Pierś z indyka', 'g', '6f8357e6-5172-462f-b5bc-a9a302cffec3');
INSERT INTO public.product VALUES ('2025-10-11 06:03:25.211772+00', 'oscypek', 'g', 'f2ae88d0-d31d-48fb-a67e-c832a461b067');
INSERT INTO public.product VALUES ('2025-10-11 06:04:34.846887+00', 'udko z kurczaka', 'g', '1e8f2519-55e8-43da-b723-2732cccfba60');
INSERT INTO public.product VALUES ('2025-10-11 07:02:21.775396+00', 'Wędlina', 'g', 'e16c198b-0578-467e-9a22-c8aea715fd9d');
INSERT INTO public.product VALUES ('2025-10-11 07:07:20.028236+00', 'Ser żółty w kostce', 'g', 'a4a97fb4-83df-4f38-86cc-82699159d0cf');
INSERT INTO public.product VALUES ('2025-10-16 10:11:45.135621+00', 'ogórki kiszone', 'g', 'b4ce2ad4-7bf8-468f-b6d1-4c6765b61ea2');
INSERT INTO public.product VALUES ('2025-10-16 10:14:35.179303+00', 'borowiki mrożone', 'g', '140b5233-8da5-4201-bc77-02bdd8f70b2d');
INSERT INTO public.product VALUES ('2025-10-16 10:14:47.115479+00', 'szalotka', 'g', '38dbf180-e347-4c86-867f-7c8460a01386');
INSERT INTO public.product VALUES ('2025-10-16 10:19:22.556362+00', 'szynka parmeńska', 'g', '56da395a-839e-4d42-ba24-5c9bf2a36fbe');
INSERT INTO public.product VALUES ('2025-10-16 10:20:04.080969+00', 'przecier pomidorowy', 'g', 'b76cd392-57e9-450b-83db-0cc998878193');
INSERT INTO public.product VALUES ('2025-10-17 18:35:59.697433+00', 'dynia', 'g', '71788706-3e11-490c-b879-917143bce66a');
INSERT INTO public.product VALUES ('2025-10-27 16:09:16.381636+00', 'mleczko kokosowe', 'g', '3f6fa98f-901f-48ff-882c-53617e5a1733');
INSERT INTO public.product VALUES ('2025-10-27 16:13:06.646225+00', 'śmietanka 30%', 'g', '81d2b6ef-105d-4850-bc17-c9f1d6f16c8f');
INSERT INTO public.product VALUES ('2025-10-30 16:57:09.013518+00', 'maliny', 'g', 'fde2c152-7be1-4510-84aa-a270bb756c65');
INSERT INTO public.product VALUES ('2025-10-30 17:09:25.153807+00', 'sałata', 'g', '7026ddde-7a43-4a77-80d8-f467c47481a2');
INSERT INTO public.product VALUES ('2025-11-16 09:36:00.112636+00', 'skrzydełka', 'g', 'b2db558f-45e3-4047-8054-648fc5d8aaa5');
INSERT INTO public.product VALUES ('2025-11-17 14:52:11.321877+00', 'mozzarella (kulki)', 'g', '98d197f4-7829-459a-bf8e-f33484c91aa0');
INSERT INTO public.product VALUES ('2025-11-20 16:02:26.308239+00', 'wieprzowina, karkówa', 'g', '4701375d-cbeb-44ef-a8f9-7782e067b21c');
INSERT INTO public.product VALUES ('2025-11-20 16:11:41.936937+00', 'miso', 'g', '92002710-4ff9-45c8-b29a-559df40c864a');
INSERT INTO public.product VALUES ('2025-11-22 09:56:42.792528+00', 'imbir', 'g', '117c1582-92b9-4062-99fa-7380e15076cf');
INSERT INTO public.product VALUES ('2025-11-27 14:21:26.090618+00', 'ser twarogowy tłusty', 'g', 'cbae5d3e-4d1a-438a-b126-ad81d19ba100');
INSERT INTO public.product VALUES ('2025-11-27 14:21:40.97406+00', 'śmietana 12%', 'g', '7dada3ff-dc29-4809-a889-00441eccf348');
INSERT INTO public.product VALUES ('2025-11-27 14:23:30.671115+00', 'kalafior', 'g', '9b2074c3-0183-4890-a4a0-bc9a4c9b0dee');
INSERT INTO public.product VALUES ('2025-11-27 14:27:13.085355+00', 'chorizo', 'g', 'ae75e379-c38b-4822-a6b8-e968d0912dba');
INSERT INTO public.product VALUES ('2025-11-27 14:31:48.320074+00', 'ananas', 'g', '29996b34-014b-45ce-ae51-2ff1b3261f7f');
INSERT INTO public.product VALUES ('2025-12-13 08:50:24.624714+00', 'grzyby', 'g', 'd5cd6bd2-e27e-4593-a337-592337e8ea51');
INSERT INTO public.product VALUES ('2025-12-30 12:31:43.478607+00', 'łopatka wieprzowa', 'g', '18c95ad9-f8b8-4367-a6a9-a2a27ba2f5af');
INSERT INTO public.product VALUES ('2026-01-03 09:59:33.680977+00', 'mięso wołowe mielone', 'g', '6609d074-b03a-47d8-8fd3-7ea101a7dc2b');
INSERT INTO public.product VALUES ('2026-01-08 14:09:08.43849+00', 'mąka', 'g', '6f8d4baf-36c0-4105-b835-aa27b634c19f');
INSERT INTO public.product VALUES ('2026-01-08 14:10:28.973993+00', 'karczek wołowy', 'g', 'f3681fa8-55fc-4066-8f0e-a558adfe7dfb');
INSERT INTO public.product VALUES ('2026-01-08 14:11:03.621228+00', 'łopatki wieprzowej', 'g', 'e4f27d3d-7af1-46b7-82f0-b22ec550b16a');
INSERT INTO public.product VALUES ('2026-01-08 14:13:55.86014+00', 'kiełbasa', 'g', '8436c49a-41e7-4f62-abdd-7ad797add02e');
INSERT INTO public.product VALUES ('2026-01-14 11:00:21.686126+00', 'makrela', 'g', 'f213d1f2-b8c8-4c67-a848-3df2a050c3d2');
INSERT INTO public.product VALUES ('2026-01-14 11:07:44.29861+00', 'kiełbasa z kurczaka', 'g', '225ce0c3-dd21-4990-9907-2f683ccc966e');
INSERT INTO public.product VALUES ('2026-01-14 11:10:54.665171+00', 'hummus klasyczny', 'g', '49ff72f1-cf41-41b9-b7df-b7336d8d6f9a');
INSERT INTO public.product VALUES ('2026-01-23 16:54:53.156328+00', 'banan', 'g', '34dc998a-6d98-4c2b-acf2-d75cc8290356');
INSERT INTO public.product VALUES ('2026-01-29 06:36:39.156206+00', 'roszponka', 'g', '197be7f2-e17a-492b-9430-cc6d72cc3b25');
INSERT INTO public.product VALUES ('2026-01-29 06:42:13.130608+00', 'udka z kurczaka', 'g', '90d2e30d-3f20-4a3b-ad13-a15462fe0f49');
INSERT INTO public.product VALUES ('2026-01-31 07:32:32.524657+00', 'sos sojowy bezglutenowy', 'g', 'ed230560-9425-419b-a032-f7647b863c34');
INSERT INTO public.product VALUES ('2026-02-07 09:55:09.428908+00', 'pudding czekoladowy', 'g', '178a3f33-56ca-4941-91da-a6fcaa3a31a0');
INSERT INTO public.product VALUES ('2026-02-11 14:42:44.804669+00', 'awokado', 'g', '306b07f0-0dfe-41ca-a6b0-7fe71b7a97ff');
INSERT INTO public.product VALUES ('2026-02-11 14:48:29.717906+00', 'kiełki słonecznika', 'g', '4cfbf1a7-390c-4a0d-af1c-fbad1680e384');
INSERT INTO public.product VALUES ('2026-02-11 14:49:42.622916+00', 'pestki dyni', 'g', '8dad75e4-bb8e-4470-8e82-f60b17fad637');
INSERT INTO public.product VALUES ('2026-02-14 07:33:24.980458+00', 'kiełki rzodkiewki', 'g', '40cbca42-80bd-479a-b27f-cc15cff92a46');
INSERT INTO public.product VALUES ('2026-02-21 07:25:36.607121+00', 'warzywa na patelnie włoskie', 'g', '984bf5a5-6297-48f6-bd31-1fda0e23a474');
INSERT INTO public.product VALUES ('2026-02-21 07:30:41.809456+00', 'passata pomidorowa', 'g', '14a4dd60-4a6a-4940-a63e-09f8f714b250');
INSERT INTO public.product VALUES ('2026-02-21 07:30:59.954233+00', 'mięso wieprzowe z szynki', 'g', 'fcbe8036-7506-4fc8-aea8-c1ced59e40ff');
INSERT INTO public.product VALUES ('2026-02-21 07:31:28.315224+00', 'makarok z czerwonej soczewicy', 'g', 'ad78d746-4265-4d13-a4c0-f3017d2bbf0a');
INSERT INTO public.product VALUES ('2026-02-21 07:33:33.379532+00', 'truskawki', 'g', '6400deca-4ecb-43fe-a914-a44dffd7541e');
INSERT INTO public.product VALUES ('2026-02-21 07:35:32.161781+00', 'mango', 'g', '9afa59b7-cb6b-4beb-bce8-e9da01473acc');
INSERT INTO public.product VALUES ('2026-02-26 16:40:32.722251+00', 'soczewica czerwona', 'g', '3e5c945d-323a-491e-bb87-d7047dedb499');
INSERT INTO public.product VALUES ('2026-02-26 16:40:47.836113+00', 'szpinak mrożony', 'g', '3c862a5b-0e26-4bfc-8a9a-2faede4a3829');
INSERT INTO public.product VALUES ('2026-02-26 16:42:52.269451+00', 'gruszki', 'g', '1b5470f3-6e4e-4290-b17c-dcb8092ed2d9');
INSERT INTO public.product VALUES ('2026-02-26 16:42:57.446057+00', 'burak', 'g', '90b4aafd-249d-4aa5-8d65-6c0b106c4de3');
INSERT INTO public.product VALUES ('2026-03-05 15:36:52.986632+00', 'twaróg chudy', 'g', '8e8ba99b-c390-4ad5-bf02-016b1367f2d2');
INSERT INTO public.product VALUES ('2026-03-07 08:39:37.712838+00', 'chleb pełnoziarnisty z żyta', 'g', '1aee05f0-c3ea-4a05-8289-86bb9924de6f');
INSERT INTO public.product VALUES ('2026-03-07 08:40:02.551367+00', 'masło', 'g', 'fd1a53b7-a2b6-4950-a9d2-8ef2ca1f41cc');
INSERT INTO public.product VALUES ('2026-03-07 08:46:15.137368+00', 'pomarańcza', 'g', '94d639cb-7dcc-4a39-b1e7-0703bb48c081');
INSERT INTO public.product VALUES ('2026-03-07 08:48:45.868762+00', 'czekolada gorzka', 'g', '347f4f7e-4e43-4289-8d98-100088c2dcb0');
INSERT INTO public.product VALUES ('2026-03-07 08:58:26.208038+00', 'mięso mielone z indyka', 'g', 'ef78bdcf-1b1b-4ac7-81e5-3d92de5dea17');
INSERT INTO public.product VALUES ('2026-03-07 08:59:06.054605+00', 'makaron spaghetti pełnoziarnisty', 'g', '97b989c2-417a-4e88-b235-1f98957ddbdb');
INSERT INTO public.product VALUES ('2026-03-07 09:02:48.36652+00', 'żelatyna', 'g', '5e20176b-b22d-45d5-9c90-e7d1926fe5ed');
INSERT INTO public.product VALUES ('2026-03-07 09:13:09.671411+00', 'ryż', 'g', '57231a1f-b819-45db-a1e9-2f866877e1b6');
INSERT INTO public.product VALUES ('2026-03-12 14:55:29.952948+00', 'nasiona słonecznika', 'g', '33e7c1c7-9f1a-4d30-89c2-85c40da047cd');
INSERT INTO public.product VALUES ('2026-03-12 14:56:51.822096+00', 'fasola biała', 'g', 'ca9e2514-28e9-406a-84c1-4b0498ac70a9');
INSERT INTO public.product VALUES ('2026-03-12 15:06:46.150526+00', 'makrela wędzona', 'g', '5f632f72-6c76-4f39-a6b0-ab23696acdb0');
INSERT INTO public.product VALUES ('2026-03-12 15:09:19.979392+00', 'soda oczyszczona', 'g', 'db3318e3-6790-461e-b267-4f9f0f18c25a');
INSERT INTO public.product VALUES ('2026-03-12 15:10:48.996917+00', 'schab wieprzowy', 'g', '89a76b78-0eee-4914-bac7-fa0023e02543');
INSERT INTO public.product VALUES ('2026-03-23 10:54:29.715611+00', 'polędwicka, indyk', 'g', '70138eed-3a82-4936-b8cd-5af518d31d61');
INSERT INTO public.product VALUES ('2026-03-23 10:55:30.98621+00', 'makaron  ryżowy ', 'g', '4ed0d2fa-cc75-4121-9fec-51e6584448ff');
INSERT INTO public.product VALUES ('2026-03-23 11:04:56.518699+00', 'ser żółty', 'g', '577b5044-7bb7-4317-9d16-381dbf7c23b5');
INSERT INTO public.product VALUES ('2026-03-25 05:47:20.77306+00', 'bajgiel pełnoziarnisty', 'g', '0e249d23-79b1-40d0-a57f-5db975a41f25');
INSERT INTO public.product VALUES ('2026-03-25 05:52:46.21049+00', 'fasola szparagowa', 'g', 'ffe8146c-2d46-4254-8d1a-75e1845b8b50');
INSERT INTO public.product VALUES ('2026-03-25 05:55:44.789473+00', 'czarne jagody', 'g', 'c6704a16-920d-4831-8692-a27913823e48');
INSERT INTO public.product VALUES ('2026-04-11 06:45:00.135645+00', 'ricotta', 'g', '69b32f06-da44-4fdb-937f-ee8708a471cb');
INSERT INTO public.product VALUES ('2025-09-13 14:00:56.464068+00', 'penne pełnoziarniste', 'g', '173ed2c8-7658-4b52-952a-d384466562c8');
INSERT INTO public.product VALUES ('2026-03-23 11:02:24.637121+00', 'makaron penne pełnoziarnisty', 'g', '9a9d4685-7323-4808-962f-778d66032860');
INSERT INTO public.product VALUES ('2026-04-18 07:01:59.896149+00', 'pietruszka', 'g', '68d66dd1-b888-412a-99ec-74d6891bc202');


--
-- Data for Name: meal_ingredient; Type: TABLE DATA; Schema: public; Owner: -
--
INSERT INTO public.meal_ingredient VALUES ('9a4f7f2f-3e84-43f8-8e4a-b8c83ecd003f', '10d5c5bc-7bcb-4921-a5aa-44b1d90a7b6c', '2ae0f11f-1724-4802-a028-61e74c13c9c8', '400', 'b032d89a-749d-44b6-9cec-751bd5373164', '2026-07-21 18:06:14.469259+00', '2026-07-21 18:06:14.469259+00', null);
INSERT INTO public.meal_ingredient VALUES ('4d91a18b-18f5-4a01-bc33-8b0ea7ad3e85', '1e552df8-8861-458f-b6d4-bbd537e63ffa', '2ae0f11f-1724-4802-a028-61e74c13c9c8', '1000', 'b032d89a-749d-44b6-9cec-751bd5373164', '2026-07-21 18:04:14.732286+00', '2026-07-21 18:04:14.732286+00', null);


--
-- Data for Name: user_meal; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_meal VALUES ('6c3714bf-1e19-43ad-889f-13ff0e73f7e0', 'b032d89a-749d-44b6-9cec-751bd5373164', NULL, NULL, NULL, NULL, '2ae0f11f-1724-4802-a028-61e74c13c9c8', NULL, NULL, '2026-05-07 19:52:18.775241+00', '2026-05-07 19:52:18.775241+00', NULL);
INSERT INTO public.user_meal VALUES ('9dc15350-64f5-4389-9caa-78a8622b0b29', 'a8869542-9b9e-4a30-af7a-eac9cb84dda9', NULL, NULL, NULL, NULL, '68a905eb-9d6d-4fe4-b368-a43f731fbe7c', NULL, NULL, '2026-05-19 19:33:05.189586+00', '2026-05-19 19:33:05.189586+00', NULL);
INSERT INTO public.user_meal VALUES ('571f89d6-6ff3-457c-8964-94075a12d850', 'b032d89a-749d-44b6-9cec-751bd5373164', NULL, NULL, NULL, NULL, '68a905eb-9d6d-4fe4-b368-a43f731fbe7c', NULL, NULL, '2026-07-15 21:03:14.351384+00', '2026-07-15 21:03:14.351384+00', NULL);


--
-- Data for Name: menu_item; Type: TABLE DATA; Schema: public; Owner: -
--


--
-- Data for Name: shopping_list; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: product_in_shopping_list; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: user_meal_ingredient; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_meal_ingredient VALUES ('40077588-debd-4270-924a-3ca30711dc8a', '4d91a18b-18f5-4a01-bc33-8b0ea7ad3e85', '571f89d6-6ff3-457c-8964-94075a12d850', null, '68a905eb-9d6d-4fe4-b368-a43f731fbe7c', null, null, null, '2026-07-21 18:47:32.433453+00', '2026-07-21 18:47:32.433453+00', null);
INSERT INTO public.user_meal_ingredient VALUES ('35824c66-c780-4985-81d9-b685945f855f', '9a4f7f2f-3e84-43f8-8e4a-b8c83ecd003f', '571f89d6-6ff3-457c-8964-94075a12d850', null, '68a905eb-9d6d-4fe4-b368-a43f731fbe7c', null, null, null, '2026-07-21 18:45:40.313603+00', '2026-07-21 18:45:40.313603+00', null);


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 329, true);


--
-- PostgreSQL database dump complete
--

