--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    address_id integer NOT NULL,
    user_id integer,
    addr character varying(100) NOT NULL
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- Name: addresses_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.addresses ALTER COLUMN address_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.addresses_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ordercomposition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ordercomposition (
    order_comp_id integer NOT NULL,
    purchase_id integer,
    prod_id integer,
    positions_count integer NOT NULL,
    summ_price integer NOT NULL,
    CONSTRAINT ordercomposition_summ_price_check CHECK ((summ_price > 0))
);


ALTER TABLE public.ordercomposition OWNER TO postgres;

--
-- Name: ordercomposition_order_comp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ordercomposition ALTER COLUMN order_comp_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ordercomposition_order_comp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: phone_numbers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phone_numbers (
    pn_id integer NOT NULL,
    user_id integer,
    phone_number character varying(12) NOT NULL
);


ALTER TABLE public.phone_numbers OWNER TO postgres;

--
-- Name: phone_numbers_pn_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.phone_numbers ALTER COLUMN pn_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.phone_numbers_pn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    prod_id integer NOT NULL,
    prod_name character varying(200) NOT NULL,
    prod_count integer NOT NULL,
    price integer NOT NULL,
    prod_desc character varying(200),
    CONSTRAINT products_price_check CHECK ((price > 0))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.products ALTER COLUMN prod_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_prod_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchases (
    purchase_id integer NOT NULL,
    user_id integer,
    order_date date,
    total_price integer NOT NULL,
    CONSTRAINT purchases_order_date_check CHECK (((order_date > '1920-01-01'::date) AND (order_date < '2025-01-01'::date))),
    CONSTRAINT purchases_total_price_check CHECK ((total_price > 0))
);


ALTER TABLE public.purchases OWNER TO postgres;

--
-- Name: purchases_purchase_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.purchases ALTER COLUMN purchase_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.purchases_purchase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    fio character varying(200) NOT NULL,
    email character varying(70) NOT NULL,
    user_password character varying(30) NOT NULL,
    birthday date,
    CONSTRAINT users_birthday_check CHECK (((birthday > '1920-01-01'::date) AND (birthday < '2024-09-01'::date)))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (address_id, user_id, addr) FROM stdin;
4	35	Некий адрес 1
7	35	Некий адрес 1
8	36	Некий адрес 2
9	36	Некий адрес 3
\.


--
-- Data for Name: ordercomposition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ordercomposition (order_comp_id, purchase_id, prod_id, positions_count, summ_price) FROM stdin;
89	64	73	3	8273
90	65	73	3	8273
91	66	73	3	8273
92	67	73	3	8273
93	68	73	3	8273
94	69	74	2	10000
95	69	73	5	9273
96	70	75	1	3937
97	70	76	99	9373
98	71	77	5	92730
\.


--
-- Data for Name: phone_numbers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.phone_numbers (pn_id, user_id, phone_number) FROM stdin;
4	35	89085720618
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (prod_id, prod_name, prod_count, price, prod_desc) FROM stdin;
73	Брюки	10	10000	Это новые брюки
74	Телефон	19	50000	Это функциональный телефон
75	Наушники	1	3937	Это наушники к телефону
76	Шар	10000	94	Это воздушный шар
77	Телевизор	2	46000	Это классный телевизор
\.


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchases (purchase_id, user_id, order_date, total_price) FROM stdin;
64	35	2008-12-01	29283
65	35	2008-12-01	29283
66	35	2008-12-01	29283
67	35	2008-12-01	29283
68	35	2008-12-01	29283
69	36	2019-06-18	100000
70	36	2017-09-09	28734
71	37	2021-05-29	494872
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, fio, email, user_password, birthday) FROM stdin;
35	Иванов Иван	 new@mail.ru	new 	1990-01-02
36	Петров Петр 	 petr@mail.ru	petr	1982-10-12
37	Павлов Павел	 pavel@mail.ru	pavel	2000-03-03
\.


--
-- Name: addresses_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addresses_address_id_seq', 9, true);


--
-- Name: ordercomposition_order_comp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ordercomposition_order_comp_id_seq', 98, true);


--
-- Name: phone_numbers_pn_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.phone_numbers_pn_id_seq', 4, true);


--
-- Name: products_prod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_prod_id_seq', 77, true);


--
-- Name: purchases_purchase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchases_purchase_id_seq', 71, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 37, true);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (address_id);


--
-- Name: ordercomposition ordercomposition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordercomposition
    ADD CONSTRAINT ordercomposition_pkey PRIMARY KEY (order_comp_id);


--
-- Name: phone_numbers phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT phone_numbers_pkey PRIMARY KEY (pn_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (prod_id);


--
-- Name: products products_prod_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_prod_name_key UNIQUE (prod_name);


--
-- Name: products products_prod_name_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_prod_name_key1 UNIQUE (prod_name);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (purchase_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: addresses addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: ordercomposition ordercomposition_prod_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordercomposition
    ADD CONSTRAINT ordercomposition_prod_id_fkey FOREIGN KEY (prod_id) REFERENCES public.products(prod_id);


--
-- Name: ordercomposition ordercomposition_purchase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordercomposition
    ADD CONSTRAINT ordercomposition_purchase_id_fkey FOREIGN KEY (purchase_id) REFERENCES public.purchases(purchase_id);


--
-- Name: phone_numbers phone_numbers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT phone_numbers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: purchases purchases_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

