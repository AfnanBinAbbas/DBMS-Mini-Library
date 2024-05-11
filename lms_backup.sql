--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- SET statement_timeout = 0;
-- SET lock_timeout = 0;
-- SET idle_in_transaction_session_timeout = 0;
-- SET client_encoding = 'UTF8';
-- SET standard_conforming_strings = on;
-- SELECT pg_catalog.set_config('search_path', '', false);
-- SET check_function_bodies = false;
-- SET xmloption = content;
-- SET client_min_messages = warning;
-- SET row_security = off;

--
-- Name: update_no_of_copy(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_no_of_copy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE book
        SET no_of_copy = no_of_copy - 1
        WHERE bookid = NEW.bookid;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE book
        SET no_of_copy = no_of_copy + 1
        WHERE bookid = OLD.bookid;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_no_of_copy() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: author; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.author (
    authorid integer NOT NULL,
    name character varying(200) NOT NULL,
    status character varying(10) NOT NULL
);


ALTER TABLE public.author OWNER TO postgres;

--
-- Name: author_authorid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.author_authorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.author_authorid_seq OWNER TO postgres;

--
-- Name: author_authorid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.author_authorid_seq OWNED BY public.author.authorid;


--
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    bookid integer NOT NULL,
    categoryid integer NOT NULL,
    authorid integer NOT NULL,
    rackid integer NOT NULL,
    name text NOT NULL,
    picture character varying(250) NOT NULL,
    publisherid integer NOT NULL,
    isbn character varying(30) NOT NULL,
    no_of_copy integer NOT NULL,
    status character varying(10) NOT NULL,
    added_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.book OWNER TO postgres;

--
-- Name: book_bookid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.book_bookid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.book_bookid_seq OWNER TO postgres;

--
-- Name: book_bookid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.book_bookid_seq OWNED BY public.book.bookid;


--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    categoryid integer NOT NULL,
    name character varying(200) NOT NULL,
    status character varying(10) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_categoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_categoryid_seq OWNER TO postgres;

--
-- Name: category_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_categoryid_seq OWNED BY public.category.categoryid;


--
-- Name: issued_book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issued_book (
    issuebookid integer NOT NULL,
    bookid integer NOT NULL,
    userid integer NOT NULL,
    issue_date_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expected_return_date timestamp without time zone NOT NULL,
    return_date_time timestamp without time zone NOT NULL,
    status character varying(20) NOT NULL
);


ALTER TABLE public.issued_book OWNER TO postgres;

--
-- Name: issued_book_issuebookid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issued_book_issuebookid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.issued_book_issuebookid_seq OWNER TO postgres;

--
-- Name: issued_book_issuebookid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issued_book_issuebookid_seq OWNED BY public.issued_book.issuebookid;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    password character varying(64) NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: issued_books_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.issued_books_view AS
 SELECT ib.issuebookid,
    b.name AS book_name,
    (((u.first_name)::text || ' '::text) || (u.last_name)::text) AS user_name,
    ib.issue_date_time,
    ib.expected_return_date,
    ib.return_date_time,
    ib.status
   FROM ((public.issued_book ib
     JOIN public.book b ON ((ib.bookid = b.bookid)))
     JOIN public."user" u ON ((ib.userid = u.id)));


ALTER VIEW public.issued_books_view OWNER TO postgres;

--
-- Name: publisher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publisher (
    publisherid integer NOT NULL,
    name character varying(255) NOT NULL,
    status character varying(10) NOT NULL
);


ALTER TABLE public.publisher OWNER TO postgres;

--
-- Name: publisher_publisherid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publisher_publisherid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.publisher_publisherid_seq OWNER TO postgres;

--
-- Name: publisher_publisherid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publisher_publisherid_seq OWNED BY public.publisher.publisherid;


--
-- Name: rack; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rack (
    rackid integer NOT NULL,
    name character varying(200) NOT NULL,
    status character varying(10) DEFAULT 'Enable'::character varying NOT NULL
);


ALTER TABLE public.rack OWNER TO postgres;

--
-- Name: rack_rackid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rack_rackid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rack_rackid_seq OWNER TO postgres;

--
-- Name: rack_rackid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rack_rackid_seq OWNED BY public.rack.rackid;


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: author authorid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author ALTER COLUMN authorid SET DEFAULT nextval('public.author_authorid_seq'::regclass);


--
-- Name: book bookid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book ALTER COLUMN bookid SET DEFAULT nextval('public.book_bookid_seq'::regclass);


--
-- Name: category categoryid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN categoryid SET DEFAULT nextval('public.category_categoryid_seq'::regclass);


--
-- Name: issued_book issuebookid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_book ALTER COLUMN issuebookid SET DEFAULT nextval('public.issued_book_issuebookid_seq'::regclass);


--
-- Name: publisher publisherid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publisher ALTER COLUMN publisherid SET DEFAULT nextval('public.publisher_publisherid_seq'::regclass);


--
-- Name: rack rackid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rack ALTER COLUMN rackid SET DEFAULT nextval('public.rack_rackid_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: author; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.author (authorid, name, status) FROM stdin;
1	Alan Forbes	Enable
2	Lynn Beighley	Enable
\.


--
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book (bookid, categoryid, authorid, rackid, name, picture, publisherid, isbn, no_of_copy, status, added_on, updated_on) FROM stdin;
1	2	2	2	The Joy of PHP Programming	joy-php.jpg	8	B00BALXN70	10	Enable	2022-06-12 11:12:48	2022-06-12 11:13:27
2	2	3	2	Head First PHP &amp; MySQL	header-first-php.jpg	9	0596006306	10	Enable	2022-06-12 11:16:01	2022-06-12 11:16:01
3	2	2	1	dsgsdgsd		7	sdfsd2334	23	Enable	2022-06-12 13:29:14	2022-06-12 13:29:14
4	1	2	0	eeeeeebook		2	hfdfhdfhd	2		2023-03-19 16:27:17	2023-03-19 16:27:17
5	1	2	0	aaaaaaaaaaaaaa		2	bbbbbbbbbbbbbbbbbb	2		2023-03-19 17:37:56	2023-03-19 17:37:56
6	1	2	1	bbbbbbbbbbbbbb		2	4346436463463	2	Enable	2023-03-25 14:44:18	2023-03-25 14:44:18
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (categoryid, name, status) FROM stdin;
1	Web Design	Enable
2	Programming	Enable
3	Commerce	Enable
4	Math	Enable
5	Web Development	Enable
\.


--
-- Data for Name: issued_book; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issued_book (issuebookid, bookid, userid, issue_date_time, expected_return_date, return_date_time, status) FROM stdin;
1	2	2	2022-06-12 15:33:45	2022-06-15 16:27:59	2022-06-16 16:27:59	Not Return
2	1	2	2022-06-12 18:46:07	2022-06-30 18:46:02	2022-06-12 18:46:14	Returned
3	7	2	2023-03-25 14:32:57	2023-03-25 14:32:47	2023-03-26 14:32:51	Issued
\.


--
-- Data for Name: publisher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publisher (publisherid, name, status) FROM stdin;
1	Amazon publishing	Enable
2	Penguin books ltd.	Enable
3	Vintage Publishing	Enable
4	Macmillan Publishers	Enable
5	Simon & Schuster	Enable
6	HarperCollins	Enable
7	Plum Island	Enable
8	O’Reilly	Enable
\.


--
-- Data for Name: rack; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rack (rackid, name, status) FROM stdin;
1	R1	Enable
2	R2	Enable
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, first_name, last_name, email, password) FROM stdin;
1	Mark	Wood	mark@webdamn.com	123
2	George	Smith	goerge@webdamn.com	123
3	Adam	\N	adam@webdamn.com	123
4	aaa	bbbbb	ab@webdamn.com	123
6	Alan	Wood	admin@gmail.com	admin
7	George	Smith	user@gmail.com	user
\.


--
-- Name: author_authorid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.author_authorid_seq', 2, true);


--
-- Name: book_bookid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.book_bookid_seq', 6, true);


--
-- Name: category_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_categoryid_seq', 5, true);


--
-- Name: issued_book_issuebookid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issued_book_issuebookid_seq', 3, true);


--
-- Name: publisher_publisherid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publisher_publisherid_seq', 8, true);


--
-- Name: rack_rackid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rack_rackid_seq', 2, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 7, true);


--
-- Name: author author_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author
    ADD CONSTRAINT author_pkey PRIMARY KEY (authorid);


--
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (bookid);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (categoryid);


--
-- Name: issued_book issued_book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_book
    ADD CONSTRAINT issued_book_pkey PRIMARY KEY (issuebookid);


--
-- Name: publisher publisher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publisher
    ADD CONSTRAINT publisher_pkey PRIMARY KEY (publisherid);


--
-- Name: rack rack_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rack
    ADD CONSTRAINT rack_pkey PRIMARY KEY (rackid);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: issued_book update_no_of_copy_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_no_of_copy_trigger AFTER INSERT OR DELETE ON public.issued_book FOR EACH ROW EXECUTE FUNCTION public.update_no_of_copy();


--
-- PostgreSQL database dump complete
--

