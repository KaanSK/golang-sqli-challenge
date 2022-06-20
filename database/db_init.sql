--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

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
-- Name: juice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.juice (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.juice OWNER TO postgres;

--
-- Name: juice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.juice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.juice_id_seq OWNER TO postgres;

--
-- Name: juice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.juice_id_seq OWNED BY public.juice.id;


--
-- Name: super_secret_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.super_secret_table (
    flag character varying(50) NOT NULL
);


ALTER TABLE public.super_secret_table OWNER TO postgres;

--
-- Name: juice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.juice ALTER COLUMN id SET DEFAULT nextval('public.juice_id_seq'::regclass);


--
-- Data for Name: juice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.juice (name) FROM stdin;
juice-1
juice-2
juice-3
juice-4
\.


--
-- Data for Name: super_secret_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.super_secret_table (flag) FROM stdin;
CTF{KaanWasHere}
\.


--
-- Name: juice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.juice_id_seq', 5, true);


--
-- Name: juice juice_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.juice
    ADD CONSTRAINT juice_name_key UNIQUE (name);


--
-- Name: juice juice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.juice
    ADD CONSTRAINT juice_pkey PRIMARY KEY (id);


--
-- Name: super_secret_table super_secret_table_flag_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.super_secret_table
    ADD CONSTRAINT super_secret_table_flag_key UNIQUE (flag);


--
-- PostgreSQL database dump complete
--
