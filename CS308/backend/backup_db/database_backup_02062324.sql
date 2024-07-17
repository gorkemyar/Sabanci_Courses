--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.2 (Debian 14.2-1.pgdg110+1)

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
-- Name: orderstatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.orderstatus AS ENUM (
    'PROCESSING',
    'INTRANSIT',
    'DELIVERED'
);


--
-- Name: usertype; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.usertype AS ENUM (
    'CUSTOMER',
    'SALES_MANAGER',
    'PRODUCT_MANAGER'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.address (
    id integer NOT NULL,
    user_id integer,
    name character varying(100) NOT NULL,
    full_address character varying(100) NOT NULL,
    postal_code character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    province character varying(100) NOT NULL,
    country character varying(100) NOT NULL,
    personal_name character varying(100) NOT NULL,
    phone_number character varying(100) NOT NULL
);


--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.address_id_seq OWNED BY public.address.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category (
    id integer NOT NULL,
    title character varying NOT NULL,
    image_url character varying,
    order_id integer
);


--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;


--
-- Name: category_subcategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category_subcategory (
    id integer NOT NULL,
    category_id integer,
    subcategory_id integer
);


--
-- Name: category_subcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_subcategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_subcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_subcategory_id_seq OWNED BY public.category_subcategory.id;


--
-- Name: comment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comment (
    id integer NOT NULL,
    product_id integer,
    content character varying(1000) NOT NULL,
    user_id integer,
    rate integer,
    is_active boolean
);


--
-- Name: comment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comment_id_seq OWNED BY public.comment.id;


--
-- Name: credit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credit (
    id integer NOT NULL,
    payment_method character varying(100),
    card_name character varying(100),
    cardnumber character varying(100),
    "CW" character varying(100),
    expiry_date character varying(100),
    user_id integer
);


--
-- Name: credit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.credit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.credit_id_seq OWNED BY public.credit.id;


--
-- Name: favorite; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorite (
    id integer NOT NULL,
    product_id integer,
    user_id integer
);


--
-- Name: favorite_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favorite_id_seq OWNED BY public.favorite.id;


--
-- Name: order; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."order" (
    id integer NOT NULL,
    quantity integer,
    order_status public.orderstatus,
    created_at timestamp without time zone,
    user_id integer,
    product_id integer,
    address_id integer,
    credit_id integer
);


--
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_id_seq OWNED BY public."order".id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product (
    id integer NOT NULL,
    category_subcategory_id integer,
    title character varying(125) NOT NULL,
    description character varying NOT NULL,
    stock integer,
    price double precision,
    model character varying,
    number character varying,
    distributor character varying
);


--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- Name: productphoto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.productphoto (
    id integer NOT NULL,
    is_active boolean,
    photo_url character varying NOT NULL,
    product_id integer
);


--
-- Name: productphoto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.productphoto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: productphoto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.productphoto_id_seq OWNED BY public.productphoto.id;


--
-- Name: productrate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.productrate (
    id integer NOT NULL,
    rate integer,
    user_id integer,
    product_id integer
);


--
-- Name: productrate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.productrate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: productrate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.productrate_id_seq OWNED BY public.productrate.id;


--
-- Name: shoppingcart; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shoppingcart (
    id integer NOT NULL,
    quantity integer,
    is_active boolean,
    created_at timestamp without time zone,
    user_id integer,
    product_id integer
);


--
-- Name: shoppingcart_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shoppingcart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shoppingcart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shoppingcart_id_seq OWNED BY public.shoppingcart.id;


--
-- Name: subcategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subcategory (
    id integer NOT NULL,
    title character varying NOT NULL,
    order_id integer
);


--
-- Name: subcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subcategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subcategory_id_seq OWNED BY public.subcategory.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    full_name character varying,
    email character varying NOT NULL,
    hashed_password character varying NOT NULL,
    is_active boolean,
    user_type public.usertype
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: address id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.address ALTER COLUMN id SET DEFAULT nextval('public.address_id_seq'::regclass);


--
-- Name: category id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- Name: category_subcategory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_subcategory ALTER COLUMN id SET DEFAULT nextval('public.category_subcategory_id_seq'::regclass);


--
-- Name: comment id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comment ALTER COLUMN id SET DEFAULT nextval('public.comment_id_seq'::regclass);


--
-- Name: credit id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit ALTER COLUMN id SET DEFAULT nextval('public.credit_id_seq'::regclass);


--
-- Name: favorite id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite ALTER COLUMN id SET DEFAULT nextval('public.favorite_id_seq'::regclass);


--
-- Name: order id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order" ALTER COLUMN id SET DEFAULT nextval('public.order_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- Name: productphoto id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productphoto ALTER COLUMN id SET DEFAULT nextval('public.productphoto_id_seq'::regclass);


--
-- Name: productrate id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productrate ALTER COLUMN id SET DEFAULT nextval('public.productrate_id_seq'::regclass);


--
-- Name: shoppingcart id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shoppingcart ALTER COLUMN id SET DEFAULT nextval('public.shoppingcart_id_seq'::regclass);


--
-- Name: subcategory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory ALTER COLUMN id SET DEFAULT nextval('public.subcategory_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.address (id, user_id, name, full_address, postal_code, city, province, country, personal_name, phone_number) FROM stdin;
1	2	asd	sdsd	123	dfsfd	asdsa	asd	sdasd	123456
2	3	My Home	Tüysüzler Mah. Altun Sokak	41100	İzmit		TR	Gorkem Yar	0535 332 3835
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alembic_version (version_num) FROM stdin;
2d652bc0c682
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category (id, title, image_url, order_id) FROM stdin;
1	LIVING ROOM	categories/bbc2ed75-5436-4c69-895d-e467f80963bc.jpeg	0
3	STUDY ROOM	categories/c37ef0fe-f3aa-446f-a2a2-2654df4a2ac3.jpeg	0
4	DINING ROOM	categories/3c891cd4-5585-4083-9eaa-f45db8e32903.jpeg	0
5	BEDROOM	categories/3a7f8ee7-f2a7-4a85-b325-304a44df5ca4.jpeg	0
6	DECORATION	categories/0f9ba1ff-7bf2-4643-a096-380dc946d48f.jpeg	0
2	KITCHEN	categories/0f9ba1ff-7bf2-4643-a096-380dc946d48f.jpeg	0
\.


--
-- Data for Name: category_subcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category_subcategory (id, category_id, subcategory_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
6	1	6
7	1	7
12	3	12
13	3	13
14	3	14
15	3	15
16	3	16
17	4	17
18	4	18
19	4	19
20	4	20
21	4	21
22	5	22
23	5	23
24	5	24
25	5	25
26	5	26
27	5	27
28	5	28
29	5	29
30	5	30
31	6	31
32	6	32
33	6	33
34	6	34
35	6	35
8	2	8
9	2	9
10	2	10
11	2	11
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.comment (id, product_id, content, user_id, rate, is_active) FROM stdin;
1	27	bu bir commentdir	3	3	f
\.


--
-- Data for Name: credit; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.credit (id, payment_method, card_name, cardnumber, "CW", expiry_date, user_id) FROM stdin;
1	Tek cekim	Gorkem Yar	1111 1222 3312 3123	201	02/23	3
2	My card	Gorkem Yar	1231 1231 3121 1231	201	12/02/23	3
3	string	string	gAAAAABimLk6nyi0icM2dFK09Z1G9ll3W8rlB_HJ46C4z0fJy3VZsNsn2lbtkQMUsiGtWVWQjB7VsR3TR-e_6GglBID3Afj5HA==	string	string	1
\.


--
-- Data for Name: favorite; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.favorite (id, product_id, user_id) FROM stdin;
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."order" (id, quantity, order_status, created_at, user_id, product_id, address_id, credit_id) FROM stdin;
1	1	PROCESSING	\N	3	6	2	1
2	3	PROCESSING	\N	3	2	2	1
3	3	PROCESSING	\N	3	27	2	2
4	3	PROCESSING	\N	3	30	2	1
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product (id, category_subcategory_id, title, description, stock, price, model, number, distributor) FROM stdin;
1	\N	LUCE KATLANABİLİR MASA MEŞE (NT3-573)	Warranty Status: 1year(s)Ayak Malzemesi: Metal\nMasa Fonksiyonu: Katlanır\nMasa Malzemesi: Suntalam\nForm: Dikdörtgen\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Ölçü   Kapalı Pozisyon: Genişlik: 59cm Derinlik: 78cm Yükseklik: 74 cm  Açık Pozisyon: Genişlik: 117cm Derinlik: 78cm Yükseklik: 74 cm    Malzeme  Üst Tabla   18mm Yongalevha   Ayaklar   Metal üzeri parlak statik boya    Talimatlar  Ürün 2 Paket halinde gönderilmektedir  2 Kanat Açılıp Kapanır   4 Menteşeli Masif Köprü Sistem Sayesinde Eğilmez   Kullanılan malzemeler doğal ve uzun ömürlü bir materyaldir  FSC orman yönetimi sertifikasyonuna sahip materyaller kullanılmıştır  Çelik bağlantı aparatları sayesinde uzun yıllar dayanıklı kullanım sağlar\nDemonte Parçalar: Tüm parçalar demonte gönderilir.\nAhşap Bakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Direkt güneş ışığından koruyunuz. Sıcak yüzeylerin ve suyun uzun süreli yüzeye temasından kaçınınız.\nÜrün Grubu: Mutfak Masası\nÖlçü: \t60 x 80\t\nÜrün Tipleri: Masa\nMasa Genişliği: 80\nMasa Derinliği: 60\n	4	659	Kitchen	Kitchen Table	Voidture Inc.
9	\N	DEKORAZİ ULUDAĞ AÇILIR MASA (DZ2-214)	Warranty Status: 5year(s)Ayak Malzemesi: Ayaklar için fırında kurutulmuş 1. kalite kayın ağacı kullanılmıştır.\nMasa Fonksiyonu: Açılır\nMasa Malzemesi: Suntalam\nForm: Dikdörtgen\nMalzeme: Avrupa E1 kalite standartlarında kanserojen madde içermeyen çevreye ve sağlığa zararsız suntalam malzemeden üretilmiştir.\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\n	5	909	Kitchen	Kitchen Table	Voidture Inc.
12	\N	DEKORFİM PRATİK KATLANIR FLAMİNGO BEYAZ MASA (VX4-107)	Warranty Status: 5year(s)Ayak Malzemesi: Metal\nMasa Fonksiyonu: Katlanır\nMasa Malzemesi: Suntalam\nForm: Dikdörtgen\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nDemonte Parçalar: Tüm parçalar demonte gönderilir.\n	8	644	Kitchen	Kitchen Table	Voidture Inc.
13	\N	FİONA MUTFAK MASASI BEYAZ AHŞAP AYAK (NT3-458)	Warranty Status: 3year(s)Ayak Malzemesi: Kayın Ağacı\nMasa Fonksiyonu: Sabit\nMasa Malzemesi: Suntalam\nForm: Dikdörtgen\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Üst Tabla 18mm 1, Kalite E1 Yongalevha \nAyaklar Kayın Ağacı üzeri şeffaf akrilik vernik\n2 Yıl Garanti \nPratik Montaj \nMasanın ipek yüzeyi ve masif kayın ağacı ayakları, mutfağınıza sıcak ve doğal bir his verir\nHer ayak sadece bir bağlantıya sahip olduğundan kolaylıkla monte edilir\nYüzey ahşaba doğallığını kaybettirmeyen ve daha dayanıklı bir hale getiren koruyucu bir cila ile kaplanmıştır\nFSC orman yönetimi sertifikasyonuna sahip materyaller kullanılmıştırÇelik bağlantı aparatları sayesinde uzun yıllar dayanıklı kullanım sağlar.\nDemonte Parçalar: Ayaklar demonte gönderilmektedir.\nAhşap Bakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Direkt güneş ışığından koruyunuz. Sıcak yüzeylerin ve suyun uzun süreli yüzeye temasından kaçınınız.\nÜrün Grubu: Mutfak Masası\nÖlçü: \t90 x 55\t\nÜrün Tipleri: Masa\nMasa Genişliği: 90\nMasa Derinliği: 55\n	8	334	Kitchen	Kitchen Table	Voidture Inc.
2	\N	YUVARLAK MASA 90CM MEŞE (NT3-825)	Warranty Status: 3year(s)Ayak Malzemesi: Kayın Ağacı\nMasa Fonksiyonu: Sabit\nMasa Malzemesi: Suntalam\nForm: Yuvarlak\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Ebatlar    Gövde : 90x90 Yükseklik: 73cm    Malzeme  Üst Tabla :18mm Suntalam  Ayaklar: Masif Kayınağacı    Kurulum Bilgisi  Kurulum İçin herhangi bir el aleti gerekmemektedir.    Talimat&Bilgilendirme    Ürün ayaklarında doğal vernik işlemi yapılmıştır.  Ayaklarda renk tonu farklılıkları görülebilir.\nDemonte Parçalar: Ayaklar demonte gönderilmektedir.\nAhşap Bakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Direkt güneş ışığından koruyunuz. Sıcak yüzeylerin ve suyun uzun süreli yüzeye temasından kaçınınız.\n	2	464	Kitchen	Kitchen Table	Voidture Inc.
3	\N	NALA YEMEK MASASI 160 CM (BA3-1214)	Warranty Status: 3year(s)Ayak Malzemesi: Metal\nAyak Rengi: Siyah\nMasa Fonksiyonu: Sabit\nMasa Malzemesi: Ahşap\nMasa Ölçüsü: 160x90\nForm: Dikdörtgen\nAhşap Bakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Direkt güneş ışığından koruyunuz. Sıcak yüzeylerin ve suyun uzun süreli yüzeye temasından kaçınınız.\nDemonte Parçalar: Ayaklar demonte gönderilmektedir.\n	7	1840	Kitchen	Kitchen Table	Voidture Inc.
4	\N	YUVARLAK MASA 90CM BEYAZ (NT3-826)	Warranty Status: 5year(s)Ayak Malzemesi: Kayın Ağacı\nMasa Fonksiyonu: Sabit\nMasa Malzemesi: Suntalam\nForm: Yuvarlak\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Ebatlar    Gövde : 90x90 Yükseklik: 73cm    Malzeme  Üst Tabla :18mm Suntalam  Ayaklar: Masif Kayınağacı    Kurulum Bilgisi  Kurulum İçin herhangi bir el aleti gerekmemektedir.    Talimat&Bilgilendirme    Ürün ayaklarında doğal vernik işlemi yapılmıştır.  Ayaklarda renk tonu farklılıkları görülebilir.\nDemonte Parçalar: Ayaklar demonte gönderilmektedir.\nAhşap Bakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Direkt güneş ışığından koruyunuz. Sıcak yüzeylerin ve suyun uzun süreli yüzeye temasından kaçınınız.\n	0	464	Kitchen	Kitchen Table	Voidture Inc.
5	\N	SEMBOL ÇİZİLMEZ MEŞE KAPLAMA MASA BÜYÜK (AC3-319)	Warranty Status: 1year(s)Ayak Malzemesi: Ahşap\nMasa Fonksiyonu: Açılır\nMasa Malzemesi: Ahşap\nForm: Dikdörtgen\nMalzeme: Ahşap\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Ayaklar ve yan bölüm beyaz lake cilalıdır. Sadece masa ayakları kurulum gerektirir.\nÖlçü: \t120 x 80\t\nÜrün Grubu: Mutfak Masası\nMasa Ölçüsü: 120 x 80\nÜrün Özelliği: Açılır\nMasa Genişliği: 120\nMasa Derinliği: 80\n	8	2940	Kitchen	Kitchen Table	Voidture Inc.
15	\N	DİKİLİ 120 CM AÇILIR YUVARLAK MASA (FE6-143)	Warranty Status: 4year(s)Ayak Malzemesi: Masif Ahşap\nMasa Fonksiyonu: Açılır\nMasa Malzemesi: MDF\nForm: Yuvarlak\nMalzeme: Ahşap\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: * Masanın Tablası 1. Sınıf Mdf   * Ayak Gürgen Ağacındandır. * Kullanılan Cila ve Boya Malzemeleri Antikanserojendir. * Lake Boyalıdır. *Açılır Parça 30 cm dir. Kitabeli Açılır Otomatik Değildir.\nDemonte Parçalar: Ayaklar demonte gönderilmektedir.\nAhşap Bakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Direkt güneş ışığından koruyunuz. Sıcak yüzeylerin ve suyun uzun süreli yüzeye temasından kaçınınız.\n	8	4240	Kitchen	Kitchen Table	Voidture Inc.
16	\N	DECOR ÇİZİLMEZ MASA BÜYÜK (AC3-317)	Warranty Status: 4year(s)Ayak Malzemesi: Kayın Ağacı\nMasa Fonksiyonu: Açılır\nMasa Malzemesi: MDF\nForm: Dikdörtgen\nMalzeme: MDF\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Ürün 1. sınıf gürgen ağacından üretilmiştir. Ayaklar ve yan bölüm siyah lake cilalıdır. Masanın üst tablasında çizilmez kaplama kullanılmıştır. açılır masadır.  Sadece masa ayakları kurulum gerektirir.\nÖlçü: \t120 x 80\t\nÜrün Grubu: Mutfak Masası\nMasa Ölçüsü: 120 x 80\nÜrün Özelliği: Açılır\nMasa Genişliği: 120\nMasa Derinliği: 80\n	9	3040	Kitchen	Kitchen Table	Voidture Inc.
6	\N	YUVARLAK MASA 70X70- BEYAZ (NT3-585)	Warranty Status: 1year(s)Ayak Malzemesi: Kayın Ağacı\nMasa Fonksiyonu: Sabit\nMasa Malzemesi: Suntalam\nForm: Yuvarlak\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Üst Tabla 18mm 1, Kalite E1 Yongalevha \nAyaklar Kayın Ağacı Fırın Kurusu Ayaklar Şeffaf Akrilik Vernik \n2 Yıl Garanti \nPratik Montaj\nMasanın  yüzeyi ve masif kayın ağacı ayakları, odanıza sıcak ve doğal bir his verir\nHer ayak sadece bir bağlantıya sahip olduğundan kolaylıkla monte edilir\nKayın ağacı doğal ve uzun ömürlü bir materyaldir\nYüzey ahşaba doğallığını kaybettirmeyen ve daha dayanıklı bir hale getiren koruyucu bir cila ile kaplanmıştır\nFSC orman yönetimi sertifikasyonuna sahip materyaller kullanılmıştır\nÇelik bağlantı aparatları sayesinde uzun yıllar dayanıklı kullanım sağlar\nDemonte Parçalar: Ayaklar demonte gönderilmektedir.\nAhşap Bakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Direkt güneş ışığından koruyunuz. Sıcak yüzeylerin ve suyun uzun süreli yüzeye temasından kaçınınız.\nÜrün Grubu: Mutfak Masası\nÖlçü: \t70 x 70\t\nÜrün Tipleri: Masa\nMasa Genişliği: 70\nMasa Derinliği: 70\n	4	444	Kitchen	Kitchen Table	Voidture Inc.
7	\N	VİNA MUTFAK MASASI ATLANTİK ANTRASİT (UV3-1392)	Warranty Status: 2year(s)Ayak Malzemesi: Ahşap\nMasa Fonksiyonu: Açılır\nMasa Malzemesi: Suntalam\nForm: Dikdörtgen\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nDemonte Parçalar: Ayaklar demonte gönderilmektedir.\nMasa Ölçüsü: 130 x 80\nÜrün Grubu: Mutfak Masası\n	7	2199	Kitchen	Kitchen Table	Voidture Inc.
8	\N	PRADO KATLANIR AHŞAP MASA MERMER SİYAH (PA3-1189)	Warranty Status: 1year(s)Ayak Malzemesi: Metal\nMasa Fonksiyonu: Katlanır\nMasa Malzemesi: Suntalam\nForm: Dikdörtgen\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Prado Portatif Kelebek Katlanır Ahşap Masa\n\nKatlanır özellikte olup kullanım sonrası az yer kaplar.\n\nBallkonunuzda ve mutfağınızda kullanım imkanı sağlar.\n\nŞık dayanıklı ve ergonomik yapısı ile uzun ömürlüdür.\n\nAyaklarında bulunan plastikler sayesinde kayma yapmazve zemine zarar vermez.\n\nÇocuklarınız üzerinde rahatlıkla ödevlerini yapabilir.\n\n10 kga kadar taşıyabilir.\n\nSilinebilir, temizliği kolaydır.\n\nSuntalam kalınlığı 18 mmdir.\n\nÜrün demonte olup, kolaylıkla kurulumu yapılabilir.\n\nHızlı ve hatasız kurulum için kutu içerisinde kurulum şeması ile uyumlu parçalar bulunmaktadır.\n\nRenk: Mermer Siyah\n\nÜrünün Açık Ölçüsü: 134x60x72cm\n\nÜrünün Kapalı Ölçüsü: 60x18xx72cm\n\nPaket Ölçüsü: 76x64x11cm\n\nDesi: 15\n\nAğırlık: 14,5kg\n	3	634	Kitchen	Kitchen Table	Voidture Inc.
10	\N	FİX MUTFAK BAR MASASI CEVİZ BEYAZ (EV4-1623)	Warranty Status: 2year(s)Ayak Malzemesi: Suntalam\nMasa Fonksiyonu: Sabit\nMasa Malzemesi: Suntalam\nForm: Dikdörtgen\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Ürünümüz de Ana ham madde olarak 1. Sınıf Yonga levha ( Suntalam ) kullanılmıştır.\n	7	854	Kitchen	Kitchen Table	Voidture Inc.
11	\N	FİX MUTFAK BAR MASASI CEVİZ SİYAH (EV4-1622)	Warranty Status: 3year(s)Ayak Malzemesi: Suntalam\nMasa Fonksiyonu: Sabit\nMasa Malzemesi: Suntalam\nForm: Dikdörtgen\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nEk Bilgiler: Ürünümüz de Ana ham madde olarak 1. Sınıf Yonga levha ( Suntalam ) kullanılmıştır.\n	4	854	Kitchen	Kitchen Table	Voidture Inc.
14	\N	EBRULİ METAL AYAKLI KATLANIR MASA (AG3-2169)	Warranty Status: 1year(s)Ayak Malzemesi: Metal\nMasa Fonksiyonu: Katlanır\nMasa Malzemesi: Suntalam\nForm: Dikdörtgen\nMalzeme: Suntalam\nBakım/Temizlik Önerisi: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Yüzeyin uzun süre su ile temasından kaçınınız.\nFonksiyon: Mobilyalarınızı nemli bezle silerek temizleyebilirsiniz. Direkt güneş ışığından koruyunuz. Sıcak yüzeylerin ve suyun uzun süreli yüzeye temasından kaçınınız.\nOturum Yumuşaklığı: Açılabilir Üst Tablalı\nKapak Fonksiyon: Siyah\nKonsol Malzemesi: Üst tabla 1. kalite sunta-lam malzemeden üretilmiştir. Ayakları nikel krom kaplamadır.\nKonsol Derinliği: Dikdörtgen\nMasa Formu: 45.5\nSandalye Fonksiyonu: 72\nKumaş Bakım/Temizlik Önerisi: Kapalı Hali:\nGenişlik: 75; 5\nDerinlik: 12\nYükseklik: 72\n\n18 mm birinci sınıf suntalam kullanılmıştır. \n\n0; 40 mm birinci sınıf PVC bant kullanılmıştır.\n	11	354	Kitchen	Kitchen Table	Voidture Inc.
28	12	FİONA ÇALIŞMA MASASI MEŞE AHŞAP AYAK (NT3-453)	Warranty Status: 4year(s)Malzeme: Suntalam Ürün Özelliği: Sabit Ek Bilgiler: Üst Tabla 18mm 1, Kalite E1 Yongalevha \nAyaklar Kayın Ağacı Fırın Kurusu Ayaklar Şeffaf Akrilik Vernik \n2 Yıl Garanti Pratik Montaj (Herhangi bir elaleti olmadan sadece ayakları saat yönünde çevirerek kısa sürede montaj işleminiz tamamlanır) \nMasanın ipek yüzeyi ve masif kayın ağacı ayakları, mutfağınıza sıcak ve doğal bir his verir\nHer ayak sadece bir bağlantıya sahip olduğundan kolaylıkla monte edilir\nKayın ağacı doğal ve uzun ömürlü bir materyaldir\nYüzey ahşaba doğallığını kaybettirmeyen ve daha dayanıklı bir hale getiren koruyucu bir cila ile kaplanmıştır\nFSC orman yönetimi sertifikasyonuna sahip materyaller kullanılmıştırÇelik bağlantı aparatları sayesinde uzun yıllar dayanıklı kullanım sağlar. Ürün Grubu: Çalışma Odası 	3	299	Living Room	Corner Chairs	Voidture Inc.
29	12	DEMAN MASİF ÇALIŞMA MASASI 120X60 (GA4-113)	Warranty Status: 2year(s)Malzeme: Masif Ürün Özelliği: Sabit Masa Ölçüsü: 120X60 Ayak Malzemesi: Ayaklar masif ahşaptan üretilmiştir. Demonte Parçalar: Tüm parçalar demonte gönderilir. Ürün Tipleri: Masif Kapak Fonksiyon: Ceviz 	4	739	Living Room	Corner Chairs	Voidture Inc.
31	12	FABİO ÇALIŞMA MASASI ATLANTİK (UV3-1381)	Warranty Status: 2year(s)Malzeme: Suntalam Ürün Özelliği: Sabit Ayak Malzemesi: Ahşap malzemeden üretilmiştir. Demonte Parçalar: Tüm parçalar demonte gönderilir. 	4	499	Living Room	Corner Chairs	Voidture Inc.
27	12	CERAMİCAL MSR 60X120 CM RAFLI ÇALIŞMA MASASI SAKRAMENTO (RC6-127)	Warranty Status: 1year(s)Malzeme: Metal Ürün Özelliği: Sabit Ayak Malzemesi: Ayaklar, 25x35 mm metal profilden imal edilmiştir. Üst Yüzey Malzemesi: Suntalam Raf Malzemesi: Suntalam 	5	329	Living Room	Corner Chairs	Voidture Inc.
30	12	BOFİGO METAL AYAKLI LAPTOP SEHPASI KAHVALTI MASASI ÇALIŞMA SEHPASI ÇAM (IF6-270)	Warranty Status: 1year(s)Malzeme: Suntalam Ürün Özelliği: Sabit Ayak Malzemesi: METAL Üst Yüzey Malzemesi: SUNTALAM Ek Bilgiler: Bofigo Metal Ayaklı Laptop Sehpası,özel kolisi içinde demonte olarak sevk edilir.\nLaptop Sehpamızın gövdesinde 18mm kalınlığında 1.kalite yonga levha kullanılmıştır.\nTSE, Avrupa Birliği EN, ISO 9001 ve FSC sertifikalarına sahiptir. E1 Standartları dahilinde, kanserojen madde içermez.\nLaptop Sehpamızın metal gövdesi, güçlü profil aksama sahiptir. Tüm yüzeyleri dekoratif toz boya ile boyanmıştır.\nUzun yıllar boyunca paslanma / renk değiştirmesi vb. herhangi bir problem olmadan kullanılacak şekilde tasarlanmıştır. Kullanılan güçlü profil sistemi sayesinde, dayanıklı ve güvenlidir.\nÜrünümüze ait kolay kurulum şeması paket içerisinde yer almaktadır. Şema üzerindeki aşamaları takip ederek 10 dakika içerisinde laptop sehpanızın kurulumunu tamamlayabilirsiniz.\n\n\nGörsel amaçlı objeler ürüne dahil değildir.\nLaptop Sehpamızı kargoda oluşabilecek hasarlara karşı korumak amacıyla, paketlenirken 140 gr koliler kullanılmakta ve tüm çevresi özel straforlar ile desteklenmektedir.\nÜrünün tüm aksamları Bofigo fabrikasında üretilmektedir. Bu sayede tüm üretim aşamaları kontrolümüz altındadır ve ürün Bofigo güvencesi taşımaktadır.\nBofigo Metal Ayaklı Laptop sehpası kullanım kolaylığı ve modern görüntüsü sayesinde evinize şıklık katar.\n \n\n\nÜrün Ölçüleri\n\n\nÜrün yüksekliği: 65,5cm\nÜrün genişliği: 60 cm\nÜrün derinliği: 35,5cm Demonte Parçalar: Tüm parçalar demonte gönderilir. 	4	145	Living Room	Corner Chairs	Voidture Inc.
\.


--
-- Data for Name: productphoto; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.productphoto (id, is_active, photo_url, product_id) FROM stdin;
1	t	products/223c8fc0-1918-4bbe-b6ef-4f56365ae5bc.jpg	1
2	t	products/73a8b506-b21d-495a-8844-58168ffa8764.jpg	1
3	t	products/9d771905-34ee-4039-ac15-1721fdd88042.jpg	1
4	t	products/40377472-26b8-4b81-b011-7d425c540769.jpg	2
5	t	products/c798be74-2b56-44a5-96a5-ea702c431bcc.jpg	2
6	t	products/ec48d35a-d606-47f0-956e-bd6c27460f30.jpg	2
7	t	products/271f2819-eb90-4664-a25e-c26c7a023560.jpg	2
8	t	products/cdc8f118-b5fa-429e-a6b5-1f642de3c3ca.jpg	2
9	t	products/f7155c40-ea85-4675-b960-a0b7fff31b79.jpg	3
10	t	products/2ebd774a-388f-4f84-bc4c-668069e7c938.jpg	3
11	t	products/e7b27040-362d-48da-bfe4-3d4b2aede8ba.jpg	3
12	t	products/76a737b6-3fb6-41a8-a4c9-70057f097664.jpg	3
13	t	products/61d5d3de-830d-48a3-a360-ed43204c961d.jpg	3
14	t	products/daba9011-41da-47f9-b11a-24dc42ed50ac.jpg	3
15	t	products/2cca0cb8-b91a-4fce-a570-3ced89f844c7.jpg	3
16	t	products/d819be89-a1cd-4b38-80b6-e36a854c743e.jpg	3
17	t	products/64b50eba-4e89-4bf0-ba9b-c6dacf3a2577.jpg	4
18	t	products/403a4e7e-ee49-43a9-b6e0-9fe83372681f.jpg	4
19	t	products/98f986f9-3446-4f4c-942b-88fcaab73646.jpg	4
20	t	products/e67f1a81-4100-4f51-8576-840fcf06e65d.jpg	4
21	t	products/f0562402-d8be-4ecd-b2a5-c920c3ed6e96.jpg	5
22	t	products/587af81a-d4bd-44c4-a398-5da594ff5f9c.jpg	5
23	t	products/8a371b02-b3e7-447f-970f-a4199bc05e20.jpg	5
24	t	products/aa3103ba-acbb-4207-b184-e32581b2952c.jpg	5
25	t	products/7ffc8d10-6d26-46b6-b615-673163950997.jpg	5
26	t	products/d6325bdf-d32d-4187-b8dc-b2d63afd49e9.jpg	5
27	t	products/1b12d6c8-6e65-4286-9c5e-e77e89f04bc2.jpg	5
29	t	products/2d497eb6-8f41-49d7-9fed-f29400c05b65.jpg	6
30	t	products/f143a34d-b068-404c-b017-303fcd32353b.jpg	6
31	t	products/53845700-168d-4b7b-bd94-60ee5e170d1f.jpg	6
32	t	products/3ca3b927-9509-40f1-bec2-d9c9cb6c7281.jpg	6
33	t	products/e2983ef4-3074-484f-9698-f513a7aee401.jpg	7
34	t	products/4716cce9-8f37-43d7-a9fd-3432d42a866c.jpg	8
35	t	products/2bb573e2-431b-44b3-8f85-16b6cf57098c.jpg	8
36	t	products/79217460-dbd4-4c68-b55e-dd8f8ef2449d.jpg	8
37	t	products/ed4badbb-53d6-4e48-9cdb-2aeb3cf68a5e.jpg	8
38	t	products/afdf2406-0768-46d4-bf1c-e679ae1c1d65.jpg	9
39	t	products/29da6adf-2ebc-4ff7-a45f-4563b8a47f63.jpg	9
40	t	products/6c836a16-066c-49e5-83e6-98b0e0bbb27f.jpg	9
41	t	products/dac84dc2-238c-46db-850b-f0980049e54b.jpg	9
42	t	products/f8451a82-bd70-48b3-89e4-94df1497abfc.jpg	9
43	t	products/d9625ce6-42d3-4786-a4c5-4286c60409cb.jpg	9
44	t	products/505fa00a-b570-4707-ab17-c5492795b24c.jpg	10
45	t	products/175e1122-7eb8-4e9c-857b-fb3d5933036e.jpg	10
46	t	products/397f39b0-bb84-479e-a19e-b9c3481fd175.jpg	11
47	t	products/224c58b6-d0f3-4d9a-9961-10fb5d0e4f28.jpg	11
48	t	products/1f4f1a99-1c28-417b-94b1-2b8f67abc986.jpg	12
49	t	products/6495c4e8-d9eb-467d-99c9-3746db266396.jpg	12
50	t	products/392260bb-009f-4cde-b1f7-15a4abdb6f94.jpg	13
51	t	products/d49949cf-e4b7-426e-86d7-7c211601523a.jpg	13
52	t	products/87b143d9-1485-47d6-b50d-43a657993544.jpg	13
53	t	products/386c8ec5-1d55-4791-815e-739cf5c1bbfd.jpg	14
54	t	products/d48f36f0-ca35-445c-89d0-c2a54c4ca60d.jpg	14
55	t	products/cddd5634-93bb-465e-bd2e-c4f3ef895d9f.jpg	14
56	t	products/463924da-13af-4da1-9fef-e0ca7dcf4f38.jpg	15
57	t	products/53174139-1173-4db8-8eb4-feb51726b397.jpg	15
58	t	products/d8b82bbb-8743-4050-9bcc-086f715f68ee.jpg	15
59	t	products/64bbc955-2a41-44dc-86ff-6d2f4eae900d.jpg	15
60	t	products/ed8bd372-bf41-46a6-bf97-0191c210246a.jpg	15
61	t	products/3b990db8-2254-4b77-9166-9a6663c727aa.jpg	16
62	t	products/987c68c7-e195-4d90-aaf4-c6163c267e3d.jpg	16
63	t	products/09e2b7e1-3829-41fe-84b8-21cad19f49f6.jpg	16
64	t	products/ec8c2d15-4be4-44c5-aa27-b9eefccd1753.jpg	16
69	t	products/19244847-77bb-4113-904a-056946845f39.jpg	\N
70	t	products/a01db629-67ae-420d-827a-c42a912bbff9.jpg	\N
71	t	products/3deaac5a-eabe-4543-8129-19785960564e.jpg	\N
72	t	products/51c82a63-8bce-4fcd-857a-e7f6c4f70a57.jpg	\N
73	t	products/e1175eff-fc55-4552-8992-86639f5a48f8.jpg	\N
74	t	products/f91dce00-7e4d-4478-93eb-e9f53ba881f9.jpg	\N
75	t	products/331bbbc1-059f-4d3e-9c0d-f291746108ad.jpg	\N
76	t	products/50b13b4c-a8c6-4ead-ac88-01726e155325.jpg	\N
77	t	products/451cc236-00a7-40b4-9553-190016014b6f.jpg	\N
78	t	products/733f9f28-d5b6-48e9-93e7-42ee9b26e457.jpg	\N
79	t	products/8cfcf325-55ec-4a76-8d55-ff25a60b7c7d.jpg	\N
80	t	products/eafeb0a2-1772-4cc6-81ab-b8b7f54ca7c7.jpg	\N
81	t	products/69484fc9-8731-4914-8e26-2c2bb3d292ae.jpg	\N
82	t	products/76eb56e8-e111-4a51-b77e-f0c07052d0c8.jpg	\N
83	t	products/64d405d7-a37a-4c97-90f7-eb66f6ee6149.jpg	\N
84	t	products/12cb29ae-0dfc-4760-8db9-2f41e540de2b.jpg	\N
85	t	products/caf9db14-b5a6-490a-b8d8-92199779e8bc.jpg	\N
86	t	products/08a135ae-bf1a-4894-bacc-f2a6bcb1165a.jpg	\N
87	t	products/fb527261-5851-4836-bd5e-72276ec51e7f.jpg	\N
89	t	products/c9fcd371-0d55-40e8-bfcc-3c6f2bc3b4c7.jpg	\N
88	t	products/39ba8ea4-7a51-4bc2-8f62-2a129a2bebe1.jpg	\N
90	t	products/7fb81477-1d86-4c09-ac33-500fa4c40f88.jpg	\N
93	t	products/5f521495-2b6a-48f7-87b6-ed40c5c457a6.jpg	\N
91	t	products/a05827dd-ae3c-44c6-8cea-c9b718ec1c20.jpg	\N
94	t	products/8bd31ee0-cb8d-4586-96e8-2189e41d30f3.jpg	\N
96	t	products/d3077c3f-ea64-4203-af87-b80c39ec3c8d.jpg	\N
65	t	products/c758140b-1618-494d-8fbf-f44f6cd57762.jpg	\N
66	t	products/4091b4d4-721e-43a5-8660-fdd6fc5d3fd8.jpg	\N
67	t	products/3f12c2a8-b6f2-4fe4-a29a-c7fc5ce4b8a6.jpg	\N
68	t	products/395f87a4-3eb9-457f-80db-96e97e6b9bdc.jpg	\N
92	t	products/6e67a172-14aa-4246-a462-f4931222957e.jpg	\N
95	t	products/e2c1097d-2c2b-475a-bf55-614be2d5d74f.jpg	\N
97	t	products/47b10d37-bfd7-40d2-9bec-a11d804ca7f6.jpg	27
98	t	products/bfb15e99-1277-49b3-baeb-dbb0bb498647.jpg	27
99	t	products/6f18d06a-3df6-419a-869b-dc9aacae092b.jpg	27
100	t	products/80d4e82e-b159-443b-8fb5-8180fe8185af.jpg	27
101	t	products/64b7409a-8558-414c-ba4b-47d60700013a.jpg	27
102	t	products/2841b860-5bec-4c2a-ba3d-8e2c398c2209.jpg	27
103	t	products/ed1f61cf-aed8-49b6-b5b5-600d72d3e817.jpg	27
104	t	products/c209c874-9d34-4998-b862-0094b96a0457.jpg	28
105	t	products/c126c187-830a-4f8d-83bf-e6c20a208cc4.jpg	28
106	t	products/3def55f5-3663-46d5-b0aa-3be36067f695.jpg	28
107	t	products/f6a7b22d-5ae3-4b13-a2e5-57b4b2409ada.jpg	29
108	t	products/b34d409e-c574-402f-bb71-61d86b043f14.jpg	29
109	t	products/e8cbe32d-178d-44e2-ad1d-f889a647e0a9.jpg	29
110	t	products/e8e71920-4d33-41c4-97dc-5155f5ce69d2.jpg	29
111	t	products/767546c2-cbea-4ef0-b76b-038e0166ac79.jpg	29
112	t	products/058a21c5-3252-4777-81f3-af6bdebe7a7d.jpg	30
113	t	products/b8b0693f-75c5-4231-adfb-1090733e1e44.jpg	30
114	t	products/dc3214d6-ed97-41ec-b56b-f2d66d246b42.jpg	30
115	t	products/35cb22af-1a08-4617-81ab-8731eca1139f.jpg	30
116	t	products/0a9bfc75-0177-4b48-9f97-5c8d0ca4a053.jpg	30
117	t	products/36d2c55a-60dc-4fce-bbe7-332bbdcd24c1.jpg	30
118	t	products/a3b66875-c21b-4f4b-9e52-7132c87dcc58.jpg	31
119	t	products/1253face-52b3-410c-8a5c-aef2c4d5fc85.jpg	31
120	t	products/a2c6625a-10dd-446d-ae3a-23b3d51317b9.jpg	31
121	t	products/9ef46b02-8b9b-4a30-aece-8961bee39b2a.jpg	31
122	t	products/2b3a3747-3fd2-4fa0-a513-11418aa2dcb5.jpg	31
123	t	products/a0249eb2-f16c-4a67-8dd9-4ea3e3c35794.jpg	31
124	t	products/57f5a4ff-c30e-4ddb-83f0-034ff8006f9c.jpg	31
125	t	products/36fcdb2e-c757-482e-871b-b05a79ac61a2.jpg	31
\.


--
-- Data for Name: productrate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.productrate (id, rate, user_id, product_id) FROM stdin;
1	3	3	27
\.


--
-- Data for Name: shoppingcart; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shoppingcart (id, quantity, is_active, created_at, user_id, product_id) FROM stdin;
\.


--
-- Data for Name: subcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subcategory (id, title, order_id) FROM stdin;
1	Sofa Set	1
2	Corner Chair	2
3	Armchair	3
4	Chair	4
5	Bookcase	5
6	Hassock	6
7	Television Unit	7
8	Kitchen Table	1
9	Kitchen Chair	2
10	Kitchen Cabinet	3
11	Kitchen Textile	4
12	Study Desk	1
13	Study Chair	2
14	Bookshelf	3
15	Wall Shelf	4
16	Gaming Chair	5
17	Dining Room Set	1
18	Dining Table	2
19	Dining Table Set	3
20	Dining Chair	4
21	Console and Showcase	5
22	Bedroom Set	1
23	Wardrobe	2
24	Dresser	3
25	Bedside Table	4
26	Bed Base	5
27	Bedstead	6
28	Bed	7
29	Pillow and Quilt	8
30	Bedroom Textile	9
31	Mirror	1
32	Wall Clock	2
33	Decorative Object	3
34	Vase and Flowerpot	4
35	Curtain	5
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."user" (id, full_name, email, hashed_password, is_active, user_type) FROM stdin;
1	string	user@example.com	$2b$12$wmB9a5a7/k2oEn0RLwGKWeri2kyQvtQcWPIquvsGreCuFhL4pF0NO	t	\N
2	Selim	selimgul@sabanciuniv.edu	$2b$12$xHh.CIHjYiQo5QuX.muU9OJiu9yKJGiz3ybPijaIO3pJLm6OqsmhG	t	\N
3	Gorkem Yar	gorkemyar@sabanciuniv.edu	$2b$12$umybtTseou8mKeCKget6UuqfecO.oQR5IKOdFpF.ba1dX3KebpOa.	t	\N
4	Bükre Aleyna Kitapci	aleyna123kitapci@gmail.com	$2b$12$zk1N4u7u38jW4SB9C97y5e93FwyQTzNECDqD.zAs9HTW2o8FRiItW	t	\N
5	Selim	selimgul123@sabanciuniv.edu	$2b$12$8P/0pdKErP8Z.fwPXn/s7eOlPAoNB787gwjHNMbL1hu6Yxsks3d2u	t	\N
6	Rebah Özkoç	rebahozkoc@sabanciuniv.edu	$2b$12$eLe3BeAzg1UOQ0S6V3VDbOvxqyu1xSLGt0rokV7Z17Edxshq0uLFy	t	\N
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.address_id_seq', 2, true);


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.category_id_seq', 8, true);


--
-- Name: category_subcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.category_subcategory_id_seq', 37, true);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.comment_id_seq', 1, true);


--
-- Name: credit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.credit_id_seq', 3, true);


--
-- Name: favorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.favorite_id_seq', 1, false);


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_id_seq', 4, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_id_seq', 31, true);


--
-- Name: productphoto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.productphoto_id_seq', 126, true);


--
-- Name: productrate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.productrate_id_seq', 1, true);


--
-- Name: shoppingcart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.shoppingcart_id_seq', 4, true);


--
-- Name: subcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.subcategory_id_seq', 37, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_id_seq', 6, true);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: category_subcategory category_subcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_subcategory
    ADD CONSTRAINT category_subcategory_pkey PRIMARY KEY (id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: credit credit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit
    ADD CONSTRAINT credit_pkey PRIMARY KEY (id);


--
-- Name: favorite favorite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT favorite_pkey PRIMARY KEY (id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: productphoto productphoto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productphoto
    ADD CONSTRAINT productphoto_pkey PRIMARY KEY (id);


--
-- Name: productrate productrate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productrate
    ADD CONSTRAINT productrate_pkey PRIMARY KEY (id);


--
-- Name: shoppingcart shoppingcart_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shoppingcart
    ADD CONSTRAINT shoppingcart_pkey PRIMARY KEY (id);


--
-- Name: subcategory subcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory
    ADD CONSTRAINT subcategory_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: ix_category_subcategory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_category_subcategory_id ON public.category_subcategory USING btree (id);


--
-- Name: ix_favorite_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_favorite_id ON public.favorite USING btree (id);


--
-- Name: ix_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_order_id ON public."order" USING btree (id);


--
-- Name: ix_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_product_id ON public.product USING btree (id);


--
-- Name: ix_shoppingcart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_shoppingcart_id ON public.shoppingcart USING btree (id);


--
-- Name: ix_user_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_user_email ON public."user" USING btree (email);


--
-- Name: ix_user_full_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_full_name ON public."user" USING btree (full_name);


--
-- Name: ix_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_id ON public."user" USING btree (id);


--
-- Name: address address_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: category_subcategory category_subcategory_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_subcategory
    ADD CONSTRAINT category_subcategory_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- Name: category_subcategory category_subcategory_subcategory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_subcategory
    ADD CONSTRAINT category_subcategory_subcategory_id_fkey FOREIGN KEY (subcategory_id) REFERENCES public.subcategory(id);


--
-- Name: comment comment_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: comment comment_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: credit credit_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit
    ADD CONSTRAINT credit_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: favorite favorite_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT favorite_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: favorite favorite_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT favorite_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: order order_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address(id);


--
-- Name: order order_credit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_credit_id_fkey FOREIGN KEY (credit_id) REFERENCES public.credit(id);


--
-- Name: order order_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: order order_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: product product_category_subcategory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_category_subcategory_id_fkey FOREIGN KEY (category_subcategory_id) REFERENCES public.category_subcategory(id);


--
-- Name: productphoto productphoto_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productphoto
    ADD CONSTRAINT productphoto_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: productrate productrate_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productrate
    ADD CONSTRAINT productrate_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: productrate productrate_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productrate
    ADD CONSTRAINT productrate_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: shoppingcart shoppingcart_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shoppingcart
    ADD CONSTRAINT shoppingcart_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: shoppingcart shoppingcart_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shoppingcart
    ADD CONSTRAINT shoppingcart_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

