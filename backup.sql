--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

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
-- Name: seq_account; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_account
    START WITH 1284
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_account OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    idaccounttype bigint,
    idaccount bigint DEFAULT nextval('public.seq_account'::regclass) NOT NULL,
    idclassificationcf integer,
    idlinked integer,
    idparent bigint,
    accnumber character varying(30),
    accname character varying(100),
    tax character varying(5),
    balance double precision,
    display smallint,
    description character varying(224),
    userin character varying(30),
    usermod character varying(30),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    active boolean,
    idunit integer NOT NULL,
    idaccounttmp integer,
    idpos integer,
    permanent boolean,
    lock boolean,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0,
    debit_balance numeric(12,0),
    credit_balance numeric(12,0)
);


ALTER TABLE public.account OWNER TO postgres;

--
-- Name: accountpos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accountpos (
    idpos integer NOT NULL,
    namepos character varying(20),
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.accountpos OWNER TO postgres;

--
-- Name: accountsubtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accountsubtype (
    idaccountsubtype bigint NOT NULL,
    idaccounttype bigint,
    accsubname character varying(20)
);


ALTER TABLE public.accountsubtype OWNER TO postgres;

--
-- Name: accounttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounttype (
    idaccounttype bigint NOT NULL,
    acctypename character varying(60),
    idclassificationcf integer,
    display integer,
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1
);


ALTER TABLE public.accounttype OWNER TO postgres;

--
-- Name: amounttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.amounttype (
    idamounttype integer NOT NULL,
    name character varying(30),
    "desc" character varying(80),
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone
);


ALTER TABLE public.amounttype OWNER TO postgres;

--
-- Name: app_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_config (
    unit_id integer NOT NULL,
    logo_path character varying(1000),
    background_path character varying(1000),
    tnc_url character varying(1000),
    register_button smallint DEFAULT 1,
    payment_option smallint DEFAULT 1
);


ALTER TABLE public.app_config OWNER TO postgres;

--
-- Name: approval_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.approval_history (
    status smallint DEFAULT 0,
    datein timestamp(6) without time zone,
    approval_logid integer NOT NULL,
    user_approver_userid integer,
    type_approval character varying,
    trxid integer,
    datemod timestamp(6) without time zone,
    notes character varying(500)
);


ALTER TABLE public.approval_history OWNER TO postgres;

--
-- Name: COLUMN approval_history.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.approval_history.status IS '0 Pending 1. Approved 2. Rejected';


--
-- Name: COLUMN approval_history.type_approval; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.approval_history.type_approval IS 'CASHIN/CASHOUT/JOURNAL';


--
-- Name: asset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset (
    asset_id integer NOT NULL,
    idunit integer,
    asset_code character varying(255),
    asset_name character varying(255),
    coa_fixed_asset_id integer,
    coa_credit_id integer,
    coa_deprec_id integer,
    coa_accum_deprec_id integer,
    is_depreciate smallint DEFAULT 1,
    length_year smallint,
    value_year smallint,
    opening_depreciate numeric(12,2),
    coa_equity_first_deprec_id integer,
    acquisition_price numeric(12,2),
    acquisiton_date date,
    asset_value_balance numeric(12,2),
    total_depreciation numeric(12,2),
    dispose_date date,
    dispose_price numeric(10,2),
    dispose_coa_id integer,
    dispose_memo character varying(255),
    dispose_journal_id integer,
    dispose_is_sell smallint DEFAULT 1,
    dispose_coa_liability_id integer,
    asset_memo character varying(255),
    dispose_number character varying(255),
    startdate_depreciate date
);


ALTER TABLE public.asset OWNER TO postgres;

--
-- Name: COLUMN asset.is_depreciate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.asset.is_depreciate IS '1. No 2. Yes';


--
-- Name: COLUMN asset.dispose_is_sell; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.asset.dispose_is_sell IS '1. No 2. Yes';


--
-- Name: asset_depreciation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_depreciation (
    asset_depreciation_id integer NOT NULL,
    depreciation_date date,
    depreciation_amount numeric(12,2),
    depreciation_status smallint DEFAULT 1,
    asset_id integer,
    journal_id integer,
    datein timestamp(6) without time zone,
    userin integer,
    status smallint DEFAULT 1,
    depreciation_no character varying(20),
    startdate date,
    enddate date
);


ALTER TABLE public.asset_depreciation OWNER TO postgres;

--
-- Name: COLUMN asset_depreciation.depreciation_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.asset_depreciation.depreciation_status IS '1. Pending 2. Approved 3. Canceled';


--
-- Name: COLUMN asset_depreciation.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.asset_depreciation.status IS '1. Pending 2. Approved';


--
-- Name: asset_journal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_journal (
    asset_id integer NOT NULL,
    journal_id integer NOT NULL
);


ALTER TABLE public.asset_journal OWNER TO postgres;

--
-- Name: balance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.balance (
    balance_id integer NOT NULL,
    user_id integer,
    current_balance numeric(12,2),
    datemod timestamp(6) without time zone
);


ALTER TABLE public.balance OWNER TO postgres;

--
-- Name: balance_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.balance_history (
    balance_history_id integer NOT NULL,
    balance_id integer,
    trx_type smallint,
    last_balance numeric(12,2),
    trx_amount numeric(12,2),
    end_balance numeric(12,2),
    datein timestamp(6) without time zone,
    billing_id integer
);


ALTER TABLE public.balance_history OWNER TO postgres;

--
-- Name: COLUMN balance_history.trx_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.balance_history.trx_type IS '1. Top Up 2. Billing Payment';


--
-- Name: bank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank (
    bank_id integer NOT NULL,
    bank_name character varying(150),
    branch_name character varying(225),
    address character varying(225),
    account_number character varying(150),
    account_name character varying(100),
    idunit integer,
    display int2vector,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    deleted smallint DEFAULT 0,
    status smallint
);


ALTER TABLE public.bank OWNER TO postgres;

--
-- Name: billing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billing (
    billing_id integer NOT NULL,
    user_id integer,
    billing_date date,
    due_date date,
    payment_method smallint,
    status smallint DEFAULT 1,
    num_member integer,
    price_unit numeric(12,2),
    amount_due numeric(12,2),
    paid_amount numeric(12,2),
    datein timestamp(6) without time zone,
    idunit integer
);


ALTER TABLE public.billing OWNER TO postgres;

--
-- Name: COLUMN billing.payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.billing.payment_method IS '1. Current Balance 2. Bank Transfer 3 Credit Card 3. Administrator';


--
-- Name: COLUMN billing.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.billing.status IS '1. Unpaid 2. Paid';


--
-- Name: brand; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brand (
    idunit integer,
    brand_name character varying(105),
    brand_desc character varying(225),
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    status smallint,
    deleted smallint DEFAULT 0,
    brand_id integer NOT NULL,
    idbrand integer,
    display smallint
);


ALTER TABLE public.brand OWNER TO postgres;

--
-- Name: business; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business (
    business_id integer NOT NULL,
    business_name character varying(255),
    business_desc character varying(1000),
    startdate date,
    enddate date,
    logo character varying(255),
    address text,
    website character varying(255),
    email character varying(255),
    legal_name character varying(255),
    license_no character varying(255),
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0,
    idunit integer,
    display smallint,
    business_type smallint DEFAULT 1,
    business_code character varying(50),
    show_in_ecommerce smallint DEFAULT 0,
    business_icon character varying(200),
    business_banner character varying(200),
    gps_coordinate character varying(500),
    phone_number character varying(100),
    whatsapp_number character varying(100),
    city_id integer
);


ALTER TABLE public.business OWNER TO postgres;

--
-- Name: COLUMN business.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.business.status IS '1. Active 2. Inactive ';


--
-- Name: COLUMN business.business_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.business.business_type IS '1. Other 2. Saving n Loan';


--
-- Name: COLUMN business.show_in_ecommerce; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.business.show_in_ecommerce IS '0: No 1: Yes';


--
-- Name: business_deposit_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business_deposit_history (
    business_deposit_his_id integer NOT NULL,
    business_investor_id integer,
    date_trx timestamp(6) without time zone,
    current_balance numeric(12,2),
    trx_amount numeric(12,2),
    new_balance numeric(12,2),
    noref character varying(255),
    remarks character varying(255),
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    deleted smallint DEFAULT 0,
    status smallint,
    display smallint
);


ALTER TABLE public.business_deposit_history OWNER TO postgres;

--
-- Name: business_investor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business_investor (
    business_investor_id integer NOT NULL,
    member_id integer,
    total_amount numeric(12,2),
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0,
    business_id integer
);


ALTER TABLE public.business_investor OWNER TO postgres;

--
-- Name: bussinestype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bussinestype (
    idbussinestype bigint NOT NULL,
    namebussines character varying(150),
    description character varying(200),
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1
);


ALTER TABLE public.bussinestype OWNER TO postgres;

--
-- Name: cashbank_approval_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cashbank_approval_config (
    unit_id integer NOT NULL,
    new_journal_status smallint DEFAULT 0,
    delete_journal_status smallint DEFAULT 0,
    delete_journal_userid smallint,
    new_cashout_status smallint DEFAULT 0,
    delete_cashout_status smallint DEFAULT 0,
    delete_cashout_userid smallint
);


ALTER TABLE public.cashbank_approval_config OWNER TO postgres;

--
-- Name: cashbank_approver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cashbank_approver (
    type character varying(20) NOT NULL,
    user_approver_userid integer NOT NULL,
    user_approver_order smallint
);


ALTER TABLE public.cashbank_approver OWNER TO postgres;

--
-- Name: COLUMN cashbank_approver.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cashbank_approver.type IS 'JOURNAL, CASHIN, CASHOUT';


--
-- Name: classificationcf; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classificationcf (
    idclassificationcf integer NOT NULL,
    classname character varying(20),
    description character varying(200),
    prefixno integer
);


ALTER TABLE public.classificationcf OWNER TO postgres;

--
-- Name: TABLE classificationcf; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.classificationcf IS 'classification cash flow';


--
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    clientid integer NOT NULL,
    dateregistered date,
    packageid integer,
    nextinvoice date
);


ALTER TABLE public.client OWNER TO postgres;

--
-- Name: closebook; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.closebook (
    idclossing integer NOT NULL,
    tanggal date,
    idunit integer,
    userin character varying(20),
    type character varying(20)
);


ALTER TABLE public.closebook OWNER TO postgres;

--
-- Name: seq_clossing; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_clossing
    START WITH 2330
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_clossing OWNER TO postgres;

--
-- Name: clossing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clossing (
    idclossing integer DEFAULT nextval('public.seq_clossing'::regclass) NOT NULL,
    idaccounttype bigint,
    idaccount bigint NOT NULL,
    idclassificationcf integer,
    idlinked integer,
    idparent bigint,
    accnumber character varying(30),
    accname character varying(100),
    balance double precision,
    display smallint,
    description character varying(224),
    userin character varying(30),
    usermod character varying(30),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    active boolean,
    idunit integer,
    idaccounttmp integer,
    month character varying(2),
    year integer,
    dateclose date,
    idpos integer
);


ALTER TABLE public.clossing OWNER TO postgres;

--
-- Name: collateral_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collateral_attribute (
    collateral_attribute_id integer NOT NULL,
    collateral_category smallint,
    unit_id integer,
    attribute_type smallint DEFAULT 1,
    attribute_name character varying(300)
);


ALTER TABLE public.collateral_attribute OWNER TO postgres;

--
-- Name: COLUMN collateral_attribute.collateral_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collateral_attribute.collateral_category IS '1: Tanah 2: Bangunan 3:Kendaraan bermotor 4: Mesin-mesin pabrik 5: Surat berharga dan saham 6: Pesawat udara atau kapal laut 7: Emas atau Logam Mulia 8: Lainnya';


--
-- Name: COLUMN collateral_attribute.attribute_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collateral_attribute.attribute_type IS '1: String 2: Numeric 3: Image 4: Document';


--
-- Name: company; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company (
    idcompany bigint NOT NULL,
    idbussinestype bigint,
    companyname character varying(200),
    companyaddress text,
    companyaddress2 text,
    companyaddress3 text,
    companyaddress4 text,
    companyaddress5 text,
    telp character varying(200),
    fax character varying(200),
    email character varying(200),
    website character varying(100),
    country character varying(100),
    npwp character varying(200),
    userin integer,
    usermod integer,
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer,
    curfinanceyear integer,
    lastmonthfinanceyear character varying(2),
    conversionmonth character varying(2),
    numaccperiod integer,
    logo character varying(100),
    idlocation integer,
    type smallint,
    deleted smallint,
    status smallint
);


ALTER TABLE public.company OWNER TO postgres;

--
-- Name: COLUMN company.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.company.type IS '1: Head Office 2: Branch';


--
-- Name: credit_balance_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_balance_history (
    credit_balance_id integer NOT NULL,
    current_balance numeric(24,2),
    trx_amount numeric(24,2),
    new_balance numeric(24,2),
    datein timestamp(6) without time zone,
    trx_id integer,
    trx_type integer,
    customer_by_type smallint,
    customer_id integer,
    member_id integer
);


ALTER TABLE public.credit_balance_history OWNER TO postgres;

--
-- Name: COLUMN credit_balance_history.trx_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.credit_balance_history.trx_type IS '1. Credit Memo Sales Order 2. Loan 3. Saving 4. Buying Digital Goods 5. Other';


--
-- Name: COLUMN credit_balance_history.customer_by_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.credit_balance_history.customer_by_type IS '1. Member 2. Non Member';


--
-- Name: seq_master; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_master
    START WITH 97
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_master OWNER TO postgres;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency (
    idcurrency integer DEFAULT nextval('public.seq_master'::regclass) NOT NULL,
    namecurr character varying(20),
    symbol character varying(5),
    description character varying(100),
    display inet,
    userin integer,
    usermod integer,
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    idunit integer,
    rate numeric(12,2),
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.currency OWNER TO postgres;

--
-- Name: seq_customer; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_customer
    START WITH 205
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_customer OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    idcustomer bigint DEFAULT nextval('public.seq_customer'::regclass) NOT NULL,
    idcustomertype integer,
    idpayment bigint,
    nocustomer character varying(50),
    namecustomer character varying(50),
    address character varying(225),
    shipaddress character varying(225),
    billaddress character varying(225),
    telephone character varying(20),
    handphone character varying(20),
    fax character varying(20),
    email character varying(150),
    website character varying(50),
    city character varying(50),
    state character varying(50),
    postcode character varying(10),
    country character varying(50),
    highestpayment double precision,
    avgdaypayment integer,
    lastpayment timestamp(6) without time zone DEFAULT NULL::timestamp without time zone,
    lastsales double precision,
    incomeaccount bigint,
    notes character varying(225),
    userin integer,
    usermod integer,
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0,
    display smallint,
    idunit integer NOT NULL,
    credit_balance numeric(12,2),
    password character varying(100),
    lastlogin timestamp(6) without time zone,
    api_key character varying(200),
    delivery_longitude character varying(500),
    delivery_latitude character varying(500),
    fcm_token character varying(500),
    city_id integer,
    provider_user_id character varying(200),
    provider character varying(200)
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: COLUMN customer.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.customer.status IS '0. Inactive 1. Active ';


--
-- Name: COLUMN customer.provider; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.customer.provider IS 'google/facebook';


--
-- Name: customertype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customertype (
    idcustomertype integer NOT NULL,
    namecustype character varying(20),
    description character varying(225),
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    idunit integer NOT NULL,
    display smallint,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.customertype OWNER TO postgres;

--
-- Name: day_name; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.day_name (
    day_id integer NOT NULL,
    day_name character varying(100)
);


ALTER TABLE public.day_name OWNER TO postgres;

--
-- Name: debt_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.debt_payment (
    debt_payment_id integer NOT NULL,
    idregistrasihutang integer,
    reference_no character varying(100),
    current_balance numeric(12,0),
    payment_amount numeric(12,0),
    new_balance numeric(12,0),
    notes character varying(500),
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.debt_payment OWNER TO postgres;

--
-- Name: COLUMN debt_payment.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.debt_payment.status IS '1. Completed 2. Canceled';


--
-- Name: deposit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deposit (
    deposit_id integer NOT NULL,
    idunit integer NOT NULL,
    idjournal integer
);


ALTER TABLE public.deposit OWNER TO postgres;

--
-- Name: seq_disbursment; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_disbursment
    START WITH 33
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_disbursment OWNER TO postgres;

--
-- Name: disbursment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disbursment (
    iddisbursment bigint DEFAULT nextval('public.seq_disbursment'::regclass) NOT NULL,
    idpurchase bigint,
    idaccount bigint,
    idjournal bigint,
    datepay date,
    nocheque character varying(50),
    memo character varying(225),
    totalowed numeric(12,2),
    totalpaid numeric(12,2),
    balance numeric(12,2),
    payee text,
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    idregistrasihutang integer
);


ALTER TABLE public.disbursment OWNER TO postgres;

--
-- Name: disease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disease (
    disease_id integer NOT NULL,
    disease_code character varying(100),
    disease_name character varying,
    disease_desc text,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.disease OWNER TO postgres;

--
-- Name: doctor_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_schedule (
    schedule_id integer NOT NULL,
    doctor_id integer,
    day_id integer,
    timesheet_1_start time(6) without time zone,
    timesheet_1_end time(6) without time zone,
    timesheet_2_start time(6) without time zone,
    timesheet_2_end time(6) without time zone,
    timesheet_3_start time(6) without time zone,
    timesheet_3_end time(6) without time zone,
    timesheet_4_start time(6) without time zone,
    timesheet_4_end time(6) without time zone,
    status smallint DEFAULT 1
);


ALTER TABLE public.doctor_schedule OWNER TO postgres;

--
-- Name: COLUMN doctor_schedule.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.doctor_schedule.status IS '1. Active 2. Inactive';


--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    idemployee bigint NOT NULL,
    code character varying(50),
    firstname character varying(50),
    lastname character varying(50),
    address character varying(225),
    telephone character varying(20),
    handphone character varying(20),
    fax character varying(20),
    email character varying(50),
    website character varying(20),
    city character varying(50),
    state character varying(50),
    postcode character varying(10),
    country character varying(15),
    notes character varying(225),
    display smallint,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    idemployeetype integer,
    idunit integer,
    idkawin integer,
    pegawaitglmasuk date,
    norek character varying(50),
    namabank character varying(50),
    keaktifan character varying(32),
    tglresign date,
    idjenisptkp integer,
    idupload integer,
    deleted smallint DEFAULT 0,
    user_id integer,
    is_login integer,
    status smallint DEFAULT 1,
    group_id integer,
    birth_date date,
    birth_location character varying(150),
    no_id character varying(50),
    marital_status smallint,
    business_id integer
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: employeetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employeetype (
    idemployeetype integer NOT NULL,
    nametype character varying(20),
    description text,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    idaccountpayroll integer,
    idunit integer,
    display integer,
    idaccount integer,
    payrolltypeid integer,
    fare double precision,
    idaccountpaythr integer,
    idaccountthr integer,
    idcompany integer,
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1
);


ALTER TABLE public.employeetype OWNER TO postgres;

--
-- Name: employeetypeakunlink; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employeetypeakunlink (
    idemployeetype integer,
    idaccountpayroll integer,
    idaccount integer,
    idaccountpaythr integer,
    idaccountthr integer,
    idunit integer
);


ALTER TABLE public.employeetypeakunlink OWNER TO postgres;

--
-- Name: forgot_pass; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forgot_pass (
    forgot_id integer NOT NULL,
    user_id integer,
    token character varying(225),
    expired_date timestamp(6) without time zone,
    datein timestamp(6) without time zone,
    status integer DEFAULT 1
);


ALTER TABLE public.forgot_pass OWNER TO postgres;

--
-- Name: frequency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.frequency (
    idfrequency integer NOT NULL,
    namefreq character varying(20)
);


ALTER TABLE public.frequency OWNER TO postgres;

--
-- Name: hakakses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hakakses (
    sys_menu_id integer NOT NULL,
    group_id integer NOT NULL,
    view boolean,
    edit boolean,
    delete boolean,
    usermod character varying(20),
    datemod timestamp(6) without time zone,
    add boolean
);


ALTER TABLE public.hakakses OWNER TO postgres;

--
-- Name: seq_inventory; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_inventory
    START WITH 559
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_inventory OWNER TO postgres;

--
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    idinventory bigint DEFAULT nextval('public.seq_inventory'::regclass) NOT NULL,
    idjournal bigint,
    invno character varying(30),
    nameinventory character varying(225),
    description character varying(225),
    isinventory boolean,
    issell boolean,
    isbuy boolean,
    cosaccount bigint DEFAULT 0,
    incomeaccount bigint,
    assetaccount bigint,
    qtystock integer,
    images character varying(30),
    cost double precision,
    numperunit integer,
    minstock integer,
    idprimarysupplier bigint,
    sellingprice double precision,
    idselingtax integer,
    unitmeasuresell character varying(30),
    numperunitsell integer,
    notes character varying(225),
    display integer,
    userin integer,
    usermod integer,
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    yearbuy integer,
    monthbuy character varying(2),
    datebuy date,
    idinventorycat integer,
    idbuytax integer,
    idunit integer,
    residu double precision,
    umur integer,
    akumulasibeban double precision,
    bebanberjalan double precision,
    nilaibuku double precision,
    bebanperbulan double precision,
    akumulasiakhir double precision,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0,
    sku_no character varying(30),
    brand_id integer,
    idbrand integer,
    idsupplier integer,
    inventory_type integer,
    measurement_id_one integer,
    measurement_id_two integer,
    measurement_id_tre integer,
    bahan_coil_id integer,
    diameter numeric(12,2),
    ketebalan numeric(12,2),
    berat numeric(12,2),
    lebar numeric(12,2),
    tinggi numeric(12,2),
    panjang numeric(12,2),
    konversi_coil_name character varying(150),
    panjang_satuan_id integer,
    tinggi_satuan_id integer,
    lebar_satuan_id integer,
    berat_satuan_id integer,
    ketebalan_satuan_id integer,
    diameter_satuan_id integer,
    idinventory_parent integer,
    nominal_persediaan numeric(12,2),
    hpp_per_unit numeric(12,2),
    unitmeasure numeric(10,0),
    no_batch character varying(35),
    no_transaction character varying(20),
    ratio_two double precision,
    ratio_tre double precision,
    is_traceablity boolean,
    grouped smallint
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- Name: COLUMN inventory.inventory_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inventory.inventory_type IS '1: Finished Goods 2: Raw Material 3: Processed Goods 4: Package Goods';


--
-- Name: COLUMN inventory.idinventory_parent; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.inventory.idinventory_parent IS 'berasal dari idinventory asal. dibuat berdasarkan batch di goods receipt';


--
-- Name: inventory_adjust; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_adjust (
    inventory_adjust_id integer NOT NULL,
    idunit integer NOT NULL,
    status integer,
    idaccount_adjs integer,
    notes character varying(225),
    userin integer,
    datein timestamp(6) without time zone,
    date_adjustment date
);


ALTER TABLE public.inventory_adjust OWNER TO postgres;

--
-- Name: inventory_adjust_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_adjust_items (
    inventory_adjust_item_id integer NOT NULL,
    inventory_adjust_id integer NOT NULL,
    idunit integer NOT NULL,
    idinventory integer,
    warehouse_id integer,
    qty_adjustment numeric(12,2),
    variance numeric(12,2),
    item_value numeric(12,2),
    total_value numeric(12,2),
    cost numeric(12,2),
    sellingprice numeric(12,2),
    datein timestamp(6) without time zone,
    qty_stock numeric(12,2)
);


ALTER TABLE public.inventory_adjust_items OWNER TO postgres;

--
-- Name: inventory_count; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_count (
    inventory_count_id integer NOT NULL,
    idunit integer NOT NULL,
    status integer,
    type_id integer,
    notes character varying(225),
    date_count date,
    userin integer,
    datein timestamp(6) without time zone
);


ALTER TABLE public.inventory_count OWNER TO postgres;

--
-- Name: inventory_count_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_count_items (
    inventory_count_item_id integer NOT NULL,
    inventory_count_id integer NOT NULL,
    idunit integer,
    idinventory integer,
    warehouse_id integer,
    qty_count numeric(12,2),
    variance numeric(12,2),
    item_value numeric(12,2),
    total_value numeric(12,2),
    cost numeric(12,2),
    sellingprice numeric(12,2),
    datein timestamp(6) without time zone,
    qty_stock numeric(12,2)
);


ALTER TABLE public.inventory_count_items OWNER TO postgres;

--
-- Name: inventory_supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_supplier (
    idinventory integer NOT NULL,
    idsupplier integer NOT NULL
);


ALTER TABLE public.inventory_supplier OWNER TO postgres;

--
-- Name: inventory_transfer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_transfer (
    transfer_stock_id integer NOT NULL,
    idunit integer NOT NULL,
    requestedby_d integer,
    approvedby_id integer,
    request_date date,
    approved_date date,
    memo character varying(225),
    no_transfer character varying(225),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    userin integer,
    usermod integer
);


ALTER TABLE public.inventory_transfer OWNER TO postgres;

--
-- Name: inventory_transfer_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_transfer_item (
    inventory_transfer_item_id integer NOT NULL,
    transfer_stock_id integer,
    idunit integer NOT NULL,
    idinventory integer,
    qty_transfer integer,
    note character varying(225),
    datein timestamp(6) without time zone,
    warehouse_source_id integer,
    warehouse_dest_id integer
);


ALTER TABLE public.inventory_transfer_item OWNER TO postgres;

--
-- Name: inventorycat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventorycat (
    idinventorycat integer NOT NULL,
    namecat character varying(60),
    description text,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0,
    idunit integer,
    show_in_ecomm smallint DEFAULT 0,
    icon character varying(200),
    "default" smallint DEFAULT 0,
    sort_by smallint DEFAULT 0
);


ALTER TABLE public.inventorycat OWNER TO postgres;

--
-- Name: invoice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice (
    id_invoice integer NOT NULL,
    id_member_saving character varying(225),
    id_xd character varying(225),
    user_id character varying(225),
    xendit_fee_amount character varying(225),
    sni_fee_amount character varying(225),
    status character varying(225),
    merchant_name character varying(225),
    merchant_profile_picture_url character varying(225),
    amount character varying(225),
    payer_email character varying(225),
    description character varying(225),
    expiry_date timestamp(6) without time zone,
    invoice_url character varying(225),
    should_exclude_credit_card character varying(225),
    should_send_email character varying(225)
);


ALTER TABLE public.invoice OWNER TO postgres;

--
-- Name: seq_invoice_bank; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_invoice_bank
    START WITH 13
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_invoice_bank OWNER TO postgres;

--
-- Name: invoice_bank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_bank (
    id_invoice integer,
    bank_code character varying(255),
    collection_type character varying(255),
    bank_account_number character varying(255),
    transfer_amount character varying(255),
    bank_branch character varying(255),
    account_holder_name character varying(255),
    identity_amount character varying(255),
    id_invoice_bank integer DEFAULT nextval('public.seq_invoice_bank'::regclass) NOT NULL
);


ALTER TABLE public.invoice_bank OWNER TO postgres;

--
-- Name: seq_journal; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_journal
    START WITH 4497
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_journal OWNER TO postgres;

--
-- Name: journal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journal (
    idjournal bigint DEFAULT nextval('public.seq_journal'::regclass) NOT NULL,
    idjournaltype bigint,
    nojournal character varying(100),
    name character varying(225),
    datejournal date,
    memo character varying(225),
    totaldebit numeric(24,2),
    totalcredit numeric(24,2),
    totaltax numeric(24,2),
    isrecuring boolean,
    year integer,
    month character varying(2),
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    lastbalance numeric(24,2),
    currbalance numeric(24,2),
    balance numeric(24,2),
    idunit integer,
    idcurrency integer,
    idreconcile integer,
    idclossing integer,
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1,
    is_panjar smallint DEFAULT 0
);


ALTER TABLE public.journal OWNER TO postgres;

--
-- Name: COLUMN journal.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.journal.status IS '0. Pending 1. Approved 2. Rejected';


--
-- Name: seq_journalitem; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_journalitem
    START WITH 11301
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_journalitem OWNER TO postgres;

--
-- Name: journalitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journalitem (
    idjournalitem bigint DEFAULT nextval('public.seq_journalitem'::regclass) NOT NULL,
    idjournal bigint,
    idaccount bigint,
    idtax integer,
    debit numeric(24,2),
    credit numeric(24,2),
    memo character varying(225),
    lastbalance numeric(24,2),
    currbalance numeric(24,2)
);


ALTER TABLE public.journalitem OWNER TO postgres;

--
-- Name: journaltype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.journaltype (
    idjournaltype bigint NOT NULL,
    namejournal character varying(20),
    description character varying(225),
    deleted integer DEFAULT 0,
    status integer DEFAULT 1
);


ALTER TABLE public.journaltype OWNER TO postgres;

--
-- Name: linkedacc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.linkedacc (
    idlinked integer NOT NULL,
    idaccounttype bigint,
    namelinked character varying(200),
    description character varying(224),
    idaccount integer,
    display integer
);


ALTER TABLE public.linkedacc OWNER TO postgres;

--
-- Name: TABLE linkedacc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.linkedacc IS 'linked account';


--
-- Name: linkedaccunit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.linkedaccunit (
    idlinked integer NOT NULL,
    idaccount integer,
    idunit integer NOT NULL
);


ALTER TABLE public.linkedaccunit OWNER TO postgres;

--
-- Name: seq_linkpiutang; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_linkpiutang
    START WITH 21
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_linkpiutang OWNER TO postgres;

--
-- Name: linkpiutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.linkpiutang (
    idlinkpiutang integer DEFAULT nextval('public.seq_linkpiutang'::regclass) NOT NULL,
    idaccountpiutang integer,
    idaccount integer,
    description character varying(225),
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer,
    idunit integer
);


ALTER TABLE public.linkpiutang OWNER TO postgres;

--
-- Name: location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location (
    location_id integer NOT NULL,
    location_name character varying(50),
    location_desc character varying(500),
    location_address character varying(1200),
    status smallint,
    deleted smallint,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    idunit integer,
    display smallint
);


ALTER TABLE public.location OWNER TO postgres;

--
-- Name: log_cron; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_cron (
    datein timestamp(6) without time zone,
    num_of_billing integer
);


ALTER TABLE public.log_cron OWNER TO postgres;

--
-- Name: log_deprecation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_deprecation (
    idlog_deprec integer,
    asset_id integer,
    asset_name character varying(255),
    asset_deprec_id integer,
    idunit integer,
    datein timestamp(6) without time zone
);


ALTER TABLE public.log_deprecation OWNER TO postgres;

--
-- Name: seq_loginlog; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_loginlog
    START WITH 3437
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_loginlog OWNER TO postgres;

--
-- Name: loginlog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loginlog (
    pegawainid character varying(20),
    jammasuk time(6) without time zone,
    tanggal date,
    bulan character varying(16),
    tahun character varying(16),
    is_referral character varying(50),
    browser character varying(50),
    version character varying(50),
    mobile character varying(50),
    robot character varying(50),
    referrer character varying(50),
    agent_string character varying(225),
    userin character varying(50),
    usermod character varying(50),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    ipaddress character varying(25),
    loginlogid integer DEFAULT nextval('public.seq_loginlog'::regclass) NOT NULL,
    username character varying(225)
);


ALTER TABLE public.loginlog OWNER TO postgres;

--
-- Name: stock_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_history_id_seq OWNER TO postgres;

--
-- Name: master_city; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.master_city (
    city_id integer DEFAULT nextval('public.stock_history_id_seq'::regclass) NOT NULL,
    province_id integer,
    province character varying(100),
    type character varying,
    city_name character varying(50),
    postal_code character varying(20)
);


ALTER TABLE public.master_city OWNER TO postgres;

--
-- Name: medical_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_action (
    medical_action_id integer NOT NULL,
    medical_action_name character varying(500),
    medical_action_desc text,
    deleted smallint,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    service_fee numeric(12,0),
    medical_action_amount numeric(12,2)
);


ALTER TABLE public.medical_action OWNER TO postgres;

--
-- Name: medical_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_record (
    medical_record_id integer NOT NULL,
    patient_id integer,
    medical_record_desc text,
    medical_record_no character varying(100),
    medical_record_date date,
    doctor_id integer,
    nurse_id integer,
    medical_status smallint DEFAULT 1,
    payment_status smallint DEFAULT 1,
    medicine_status smallint DEFAULT 1,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    receipt_number character varying(200),
    deleted smallint DEFAULT 0,
    notes text,
    sales_id integer,
    service_amount numeric(12,2) DEFAULT 0,
    additional_amount numeric(12,2) DEFAULT 0,
    discount_amount numeric(12,2) DEFAULT 0,
    subtotal numeric(12,2),
    memo character varying(200),
    shpping_fee numeric(12,0),
    grand_total numeric(12,0),
    payment_method smallint DEFAULT 1,
    paid_date date
);


ALTER TABLE public.medical_record OWNER TO postgres;

--
-- Name: COLUMN medical_record.medical_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.medical_record.medical_status IS '1. Valid 2 Invalid 3. Canceled';


--
-- Name: COLUMN medical_record.payment_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.medical_record.payment_status IS '1. Unpaid 2. Paid 3. Canceled 4. Refunded';


--
-- Name: COLUMN medical_record.medicine_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.medical_record.medicine_status IS '1. Menunggu Pembayaran
2. Dalam Proses
3. Sudah Tersedia
4. Sudah Diterima
5. Dibatalkan
6. Retur';


--
-- Name: COLUMN medical_record.payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.medical_record.payment_method IS '1. Credit 2. Cash';


--
-- Name: medical_record_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_record_action (
    medical_record_id integer NOT NULL,
    medical_action_id integer NOT NULL,
    notes character varying(1000),
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    deleted smallint DEFAULT 0,
    service_fee numeric(12,2) DEFAULT 0
);


ALTER TABLE public.medical_record_action OWNER TO postgres;

--
-- Name: medical_record_disease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_record_disease (
    medical_record_id integer NOT NULL,
    disease_id integer NOT NULL,
    notes character varying(1000),
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.medical_record_disease OWNER TO postgres;

--
-- Name: medical_record_drug; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_record_drug (
    medical_record_id integer NOT NULL,
    product_id integer NOT NULL,
    notes character varying(1000),
    qty numeric(12,2),
    product_unit_id integer,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    deleted smallint DEFAULT 0,
    subtotal numeric(12,2) DEFAULT 0
);


ALTER TABLE public.medical_record_drug OWNER TO postgres;

--
-- Name: nsp_trx_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nsp_trx_log (
    id character varying(225),
    external_id character varying(225),
    user_id character varying(225),
    is_high character varying(225),
    status character varying(225),
    merchant_name character varying(225),
    amount character varying(225),
    payer_email character varying(225),
    description character varying(225),
    paid_amount character varying(225),
    payment_method character varying(225),
    adjusted_received_amount character varying(225),
    datein character varying(225)
);


ALTER TABLE public.nsp_trx_log OWNER TO postgres;

--
-- Name: nusafin_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nusafin_key (
    unit_id integer NOT NULL,
    api_key_live character varying(500),
    api_key_dev character varying(500)
);


ALTER TABLE public.nusafin_key OWNER TO postgres;

--
-- Name: package; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.package (
    packageid integer NOT NULL,
    packagename character varying(30),
    price real,
    description character varying(225)
);


ALTER TABLE public.package OWNER TO postgres;

--
-- Name: patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient (
    patient_id integer NOT NULL,
    birthday_date date,
    no_tlp character varying(255),
    no_mobile character varying(255),
    address text,
    email character varying(255),
    no_id character varying(255),
    country character varying(255),
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    deleted integer DEFAULT 0,
    display smallint,
    id_type smallint,
    patient_name character varying(225),
    remarks text,
    member_id integer,
    patient_photo character varying(40),
    patient_type_id smallint,
    status smallint,
    patient_no character varying(225),
    gender_type smallint,
    np_number character varying(225),
    divisi character varying(255),
    business_id integer,
    patient_parent_id integer DEFAULT 0,
    benefit_id_type smallint DEFAULT 0,
    relationship_type smallint
);


ALTER TABLE public.patient OWNER TO postgres;

--
-- Name: COLUMN patient.patient_type_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.patient.patient_type_id IS '1. Anggota 2. Non Anggota';


--
-- Name: COLUMN patient.gender_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.patient.gender_type IS '1. Male 2. Female';


--
-- Name: COLUMN patient.benefit_id_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.patient.benefit_id_type IS '1. Asuransi Umum 2. Admedika 3. BPJS 4. Kopetri';


--
-- Name: patient_family; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_family (
    patient_family_id integer NOT NULL,
    relationship_type smallint,
    patient_id integer,
    family_name character varying(500),
    family_address character varying(1000),
    family_phone character varying(100),
    deleted smallint DEFAULT 0,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer
);


ALTER TABLE public.patient_family OWNER TO postgres;

--
-- Name: COLUMN patient_family.relationship_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.patient_family.relationship_type IS '1. Suami/Istri 2. Anak 3. Lainnya';


--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    idpayment bigint NOT NULL,
    namepayment character varying(30),
    description character varying(150),
    userin character varying(30),
    usermod character varying(30),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    deleted smallint,
    status smallint
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: seq_asuransiemp; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_asuransiemp
    START WITH 31
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_asuransiemp OWNER TO postgres;

--
-- Name: payment_log_xd; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_log_xd (
    id character varying(255),
    user_id character varying(255),
    external_id character varying(255),
    is_high character varying(255),
    status character varying(255),
    merchant_name character varying(255),
    amount character varying(255),
    received_amount character varying(255),
    payer_email character varying(255),
    description character varying(255),
    xendit_fee_amount character varying(255),
    expiry_date character varying(255),
    invoice_url character varying(255),
    paid_amount character varying(255),
    payment_method character varying(255),
    adjusted_received_amount character varying(255),
    adjusted_xendit_fee_amount character varying(255),
    datein character varying(255),
    payment_log_id character varying(255) DEFAULT nextval('public.seq_asuransiemp'::regclass) NOT NULL,
    payment_id character varying(255),
    callback_virtual_account_id character varying(255),
    owner_id character varying(255),
    account_number character varying(255),
    bank_code character varying(255),
    merchant_code character varying(255),
    date_trx character varying(225),
    fixed smallint
);


ALTER TABLE public.payment_log_xd OWNER TO postgres;

--
-- Name: payment_term; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_term (
    id_payment_term integer NOT NULL,
    term_name character varying(60),
    term_desc character varying(150),
    display integer,
    deleted integer,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    status smallint DEFAULT 1
);


ALTER TABLE public.payment_term OWNER TO postgres;

--
-- Name: payroll; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll (
    idpayroll integer NOT NULL,
    idjournal integer,
    month character varying(2),
    year integer,
    userin integer,
    datein timestamp(6) without time zone,
    idunit integer
);


ALTER TABLE public.payroll OWNER TO postgres;

--
-- Name: payroll_asuransi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_asuransi (
    idasuransi integer NOT NULL,
    idasuransitype integer,
    idasuransipaytype integer,
    namapremi character varying(30),
    deskripsi character varying(200),
    fixamount double precision,
    percentemployee double precision,
    percentcompany double precision,
    coa_id_ap_emp integer,
    coa_id_ap_cmp integer,
    userin character varying(20),
    datein timestamp(6) without time zone,
    usermod character varying(20),
    datemod timestamp(6) without time zone,
    display integer,
    tampilemp character varying(2),
    tampilcmp character varying(2),
    idunit integer,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.payroll_asuransi OWNER TO postgres;

--
-- Name: payroll_asuransiemp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_asuransiemp (
    idasuransiemp integer NOT NULL,
    idasuransi integer,
    idemployee bigint,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer
);


ALTER TABLE public.payroll_asuransiemp OWNER TO postgres;

--
-- Name: payroll_asuransipayhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_asuransipayhistory (
    percente double precision,
    percentc double precision,
    amounte double precision,
    amountc double precision,
    userin character varying(20),
    datein timestamp(6) without time zone,
    month character varying(2) NOT NULL,
    year integer NOT NULL,
    idasuransi integer NOT NULL,
    idemployee integer NOT NULL
);


ALTER TABLE public.payroll_asuransipayhistory OWNER TO postgres;

--
-- Name: payroll_asuransipaytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_asuransipaytype (
    idasuransipaytype integer NOT NULL,
    nametype character varying(50)
);


ALTER TABLE public.payroll_asuransipaytype OWNER TO postgres;

--
-- Name: payroll_asuransitype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_asuransitype (
    idasuransitype integer NOT NULL,
    nametype character varying(20),
    column_3 character(10)
);


ALTER TABLE public.payroll_asuransitype OWNER TO postgres;

--
-- Name: payroll_asuransiunit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_asuransiunit (
    idasuransi integer,
    idaccountemp integer,
    idaccountcomp integer,
    idunit integer
);


ALTER TABLE public.payroll_asuransiunit OWNER TO postgres;

--
-- Name: payroll_jenisptkp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_jenisptkp (
    idjenisptkp integer NOT NULL,
    namaptkp character varying(20),
    deskripsi character varying(225),
    totalptkp double precision,
    display integer,
    userin character varying(32),
    usermod character varying(32),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.payroll_jenisptkp OWNER TO postgres;

--
-- Name: payroll_potongan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_potongan (
    idpotongan integer NOT NULL,
    idpotongantype integer,
    idamounttype integer,
    idsiklus integer,
    idemployee bigint,
    startdate date,
    enddate date,
    totalpotongan numeric,
    sisapotongan numeric,
    jumlahpotongan numeric,
    userin character varying(20),
    datein timestamp(6) without time zone,
    usermod character varying(20),
    datemod timestamp(6) without time zone,
    jumlahangsuran integer,
    keterangan character varying(225),
    sisaangsuran integer,
    display integer,
    idupload integer
);


ALTER TABLE public.payroll_potongan OWNER TO postgres;

--
-- Name: payroll_potonganhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_potonganhistory (
    idpotongan integer,
    idprosesgaji bigint,
    datepaid date,
    jumlahpotongan numeric,
    sisapotongan numeric,
    totalpotongan numeric,
    userin character varying(20),
    datein character varying(20),
    sisaangsuran integer,
    month character varying(2),
    year integer,
    idemployee integer
);


ALTER TABLE public.payroll_potonganhistory OWNER TO postgres;

--
-- Name: payroll_potongantype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_potongantype (
    idpotongantype integer NOT NULL,
    namepotongan character varying(50),
    descpotongan character varying(50),
    jenispotongan character varying,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer,
    idcompany integer,
    idunit integer,
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1
);


ALTER TABLE public.payroll_potongantype OWNER TO postgres;

--
-- Name: payroll_proceed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_proceed (
    idemployee integer NOT NULL,
    firstname character varying(225),
    lastname character varying(225),
    namaunit character varying(100),
    nametype character varying(100),
    jumlahjam integer,
    jumlahkehadiran integer,
    totalgaji double precision,
    totaltunjangan double precision,
    pph21 double precision,
    totalpotongan double precision,
    totalpembayaran double precision,
    payname character varying(100),
    userin character varying(100),
    code character varying(100),
    userid integer,
    idemployeetype integer,
    payrolltypeid integer,
    pembayaranperjamkehadiran double precision,
    premiinsurance text,
    ptkp double precision,
    wajibpajak double precision,
    jenispph21 character varying(53),
    tarifpajak double precision,
    pphterhutang double precision,
    month character varying(2) NOT NULL,
    year integer NOT NULL,
    datein timestamp(6) without time zone,
    idunit integer NOT NULL,
    idpayroll integer,
    penambahangaji double precision,
    numtanggungan integer,
    tglpenggajian date
);


ALTER TABLE public.payroll_proceed OWNER TO postgres;

--
-- Name: payroll_prosesgaji; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_prosesgaji (
    idprosesgaji bigint NOT NULL,
    idsallary integer,
    idpotongan integer,
    idtunjangan integer,
    jenpph character varying(30),
    totalpotongan numeric,
    totaltunjangan numeric,
    biayajabatan numeric,
    pph21 numeric,
    totalpembayaran numeric,
    userin character varying(30),
    usermod character varying(30),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    bulan character varying(2),
    tahun integer,
    idemployee integer,
    gajipokok double precision,
    idunit integer
);


ALTER TABLE public.payroll_prosesgaji OWNER TO postgres;

--
-- Name: payroll_prosesgaji_tmp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_prosesgaji_tmp (
    idemployee integer,
    jumlah double precision,
    userin integer,
    idaccountpayroll integer,
    idaccountkas integer,
    idunit integer,
    accnumberpayroll character varying(30)
);


ALTER TABLE public.payroll_prosesgaji_tmp OWNER TO postgres;

--
-- Name: COLUMN payroll_prosesgaji_tmp.jumlah; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.payroll_prosesgaji_tmp.jumlah IS 'tabel temporary untuk penyimpanan hasil proses gaji yang selanjutnya disimpan ke dalam jurnal
';


--
-- Name: payroll_sallary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_sallary (
    idsallary integer NOT NULL,
    idemployee bigint,
    basicsallary numeric,
    nosk character varying(50),
    tglmulai date,
    tglakhir date,
    notes character varying(222),
    userin character varying(20),
    datein timestamp(6) without time zone,
    usermod character varying(20),
    datemod timestamp(6) without time zone,
    jabatan character varying(100)
);


ALTER TABLE public.payroll_sallary OWNER TO postgres;

--
-- Name: payroll_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_settings (
    payrollsettingid integer NOT NULL,
    payrolltypeid integer,
    payrollname character varying(100),
    payrolldesc character varying(225),
    fare real,
    datein timestamp(6) without time zone,
    userin character varying(32),
    datemod timestamp(6) without time zone,
    usermod character varying(32),
    display integer
);


ALTER TABLE public.payroll_settings OWNER TO postgres;

--
-- Name: payroll_tambahangaji; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_tambahangaji (
    idtambahangaji integer NOT NULL,
    idemployee bigint,
    idtambahangajitype integer NOT NULL,
    idsiklus integer,
    namatambahan character varying(100),
    startdate date,
    enddate date,
    jumlah numeric,
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    keterangan character varying(225),
    deleted smallint DEFAULT 0
);


ALTER TABLE public.payroll_tambahangaji OWNER TO postgres;

--
-- Name: payroll_tambahangajihistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_tambahangajihistory (
    idtambahangaji integer,
    idpayroll bigint,
    datepaid date,
    userin character varying(20),
    datein timestamp(6) without time zone,
    month character varying(2),
    year integer,
    jumlah double precision,
    idemployee integer
);


ALTER TABLE public.payroll_tambahangajihistory OWNER TO postgres;

--
-- Name: payroll_tambahangajitype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_tambahangajitype (
    idtambahangajitype integer NOT NULL,
    idunit bigint,
    tambahantype character varying(50),
    deskripsi character varying(200),
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer,
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1
);


ALTER TABLE public.payroll_tambahangajitype OWNER TO postgres;

--
-- Name: payroll_tmp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_tmp (
    idemployee integer NOT NULL,
    firstname character varying(225),
    lastname character varying(225),
    namaunit character varying(100),
    nametype character varying(100),
    jumlahjam integer,
    jumlahkehadiran integer,
    totalgaji double precision,
    totaltunjangan double precision,
    pph21 double precision,
    totalpotongan double precision,
    totalpembayaran double precision,
    payname character varying(100),
    userin character varying(100),
    code character varying(100),
    userid integer,
    idemployeetype integer,
    payrolltypeid integer,
    pembayaranperjamkehadiran double precision,
    premiinsurance text,
    ptkp double precision,
    wajibpajak double precision,
    jenispph21 character varying(53),
    tarifpajak double precision,
    pphterhutang double precision,
    idunit integer NOT NULL,
    penambahangaji double precision,
    numtanggungan integer
);


ALTER TABLE public.payroll_tmp OWNER TO postgres;

--
-- Name: payroll_tunjangan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_tunjangan (
    idtunjangan integer NOT NULL,
    idtunjtype integer,
    idamounttype integer,
    idemployee bigint,
    idsiklus integer,
    namatunjangan character varying(100),
    startdate date,
    enddate date,
    jumlah numeric,
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    persen double precision,
    idupload integer,
    multiplier_id integer,
    idunit integer
);


ALTER TABLE public.payroll_tunjangan OWNER TO postgres;

--
-- Name: payroll_tunjanganhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_tunjanganhistory (
    idtunjangan integer,
    idprosesgaji bigint,
    datepaid date,
    userin character varying(20),
    datein timestamp(6) without time zone,
    month character varying(2),
    year integer,
    jumlah double precision,
    idemployee integer
);


ALTER TABLE public.payroll_tunjanganhistory OWNER TO postgres;

--
-- Name: payroll_tunjangantype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_tunjangantype (
    idtunjtype integer NOT NULL,
    idunit bigint,
    nametunj character varying(50),
    desctunj character varying(200),
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer,
    idcompany integer,
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1
);


ALTER TABLE public.payroll_tunjangantype OWNER TO postgres;

--
-- Name: payroll_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_type (
    payrolltypeid integer NOT NULL,
    payname character varying(100),
    description character varying(225),
    datein timestamp(6) without time zone,
    userin character varying,
    datemod timestamp(6) without time zone,
    usermod character varying,
    display integer,
    deleted integer DEFAULT 0,
    status integer DEFAULT 1
);


ALTER TABLE public.payroll_type OWNER TO postgres;

--
-- Name: seq_piutanghistory; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_piutanghistory
    START WITH 220
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_piutanghistory OWNER TO postgres;

--
-- Name: piutanghistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.piutanghistory (
    idregistrasipiutang integer,
    month character varying(2),
    year integer,
    tanggal date,
    diterima numeric(12,2),
    sisa numeric(12,2),
    idjournal integer,
    source character varying(20),
    userin character varying,
    datein timestamp(6) without time zone,
    idreceivemoney integer,
    idpiutanghistory integer DEFAULT nextval('public.seq_piutanghistory'::regclass) NOT NULL
);


ALTER TABLE public.piutanghistory OWNER TO postgres;

--
-- Name: seq_piutangpayhistory; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_piutangpayhistory
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_piutangpayhistory OWNER TO postgres;

--
-- Name: piutangpayhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.piutangpayhistory (
    idregistrasipiutang integer NOT NULL,
    month character varying(2),
    year integer,
    penerimaan numeric(12,2),
    jumlah numeric(12,2),
    sisapiutang numeric(12,2),
    idunit integer,
    datein timestamp(6) without time zone,
    userin integer,
    tglpenerimaan date,
    idjournal integer,
    piutangpayhistory_id integer DEFAULT nextval('public.seq_piutangpayhistory'::regclass) NOT NULL
);


ALTER TABLE public.piutangpayhistory OWNER TO postgres;

--
-- Name: poly_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poly_type (
    polytpe_id integer NOT NULL,
    polytpe_name character varying(100),
    polytpe_desc character varying(200),
    deleted smallint DEFAULT 0,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    location_id integer,
    status smallint
);


ALTER TABLE public.poly_type OWNER TO postgres;

--
-- Name: pos_payment_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_payment_type (
    pos_payment_type_id bigint NOT NULL,
    payment_type_name character varying(30),
    description character varying(150),
    userin character varying(30),
    usermod character varying(30),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    deleted smallint,
    status smallint
);


ALTER TABLE public.pos_payment_type OWNER TO postgres;

--
-- Name: pos_preferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_preferences (
    unit_id integer NOT NULL,
    user_id integer NOT NULL,
    platform character varying(200),
    version character varying(200),
    printer_device character varying(200),
    barcode_device character varying(200),
    latitude character varying(200),
    longitude character varying(200),
    fcm_token character varying(200),
    current_version character varying(200),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone
);


ALTER TABLE public.pos_preferences OWNER TO postgres;

--
-- Name: seq_product; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_product
    START WITH 23
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_product OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id integer DEFAULT nextval('public.seq_product'::regclass) NOT NULL,
    product_name character varying(150),
    product_no character varying(150),
    product_type_id integer,
    idbrand integer,
    product_description text,
    cost_price numeric(12,0),
    buy_price numeric(12,2),
    wholesale_price numeric(12,2),
    retail_price numeric(12,2),
    weight double precision,
    weight_measurement_id integer,
    idunit integer,
    product_parent_id integer,
    product_image character varying(225),
    stock_available numeric(12,0),
    stock_commited numeric(12,2),
    stock_incoming numeric(12,2),
    stock_max_online numeric(12,2),
    available_on_pos smallint DEFAULT 1,
    only_for_member smallint DEFAULT 0,
    no_sku character varying(225),
    no_barcode character varying(225),
    no_supplier character varying(225),
    is_sellable smallint DEFAULT 1,
    is_purchasable smallint DEFAULT 1,
    is_taxable smallint DEFAULT 1,
    idsupplier integer,
    status smallint,
    deleted smallint DEFAULT 0,
    member_price numeric(12,2),
    wholesale_price_member numeric(12,2),
    retail_price_member numeric(12,2),
    idinventorycat integer,
    inventory_class_id integer,
    business_id integer,
    coa_sales_id integer,
    coa_purchase_id integer,
    coa_tax_sales_id integer,
    coa_tax_purchase_id integer,
    location_id integer,
    is_consignment smallint DEFAULT 1,
    consignment_base_price numeric(12,2),
    consignment_owner_id integer,
    consignment_owner_type_id integer,
    product_unit_id integer,
    product_balance numeric(12,2),
    product_location_id integer,
    coa_inventory_id integer,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    stock_monitor smallint DEFAULT 0,
    minimum_stock integer,
    show_in_ecommerce smallint DEFAULT 1,
    ecommerce_cat_id integer,
    weight_per_unit integer DEFAULT 500,
    expired_date date
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: COLUMN product.available_on_pos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.available_on_pos IS '1';


--
-- Name: COLUMN product.is_sellable; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.is_sellable IS '1. no 2. yes';


--
-- Name: COLUMN product.is_purchasable; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.is_purchasable IS '1. no 2. yes';


--
-- Name: COLUMN product.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.status IS '1. Active 2. Inactive  3. Draft';


--
-- Name: COLUMN product.is_consignment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.is_consignment IS '1. No 2. Yes';


--
-- Name: COLUMN product.consignment_owner_type_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.consignment_owner_type_id IS '1. Member 2. Non Member';


--
-- Name: COLUMN product.stock_monitor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.stock_monitor IS '0. No 1. Yes ';


--
-- Name: COLUMN product.show_in_ecommerce; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product.show_in_ecommerce IS '0. No 1. Yes';


--
-- Name: product_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_attribute (
    product_id integer,
    attribute_id integer
);


ALTER TABLE public.product_attribute OWNER TO postgres;

--
-- Name: product_composition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_composition (
    product_id integer,
    product_composition_id integer,
    composition_no character varying(100),
    qty numeric(12,2),
    product_unit_id integer,
    notes character varying(500),
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    composition_type smallint DEFAULT 1,
    fee_amount numeric(12,0)
);


ALTER TABLE public.product_composition OWNER TO postgres;

--
-- Name: COLUMN product_composition.composition_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_composition.composition_type IS '1. medicine 2. service and other fee';


--
-- Name: product_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_image (
    product_image_id integer NOT NULL,
    product_id integer,
    deleted smallint DEFAULT 0,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    image_thumbnail character varying(500),
    image_fullsize character varying(500),
    image_caption character varying(500),
    order_by integer
);


ALTER TABLE public.product_image OWNER TO postgres;

--
-- Name: product_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_location (
    product_location_id integer NOT NULL,
    location_name character varying(150),
    notes text,
    deleted smallint,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    idunit integer,
    status smallint
);


ALTER TABLE public.product_location OWNER TO postgres;

--
-- Name: seq_product_type; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_product_type
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_product_type OWNER TO postgres;

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_type (
    product_type_id integer DEFAULT nextval('public.seq_product_type'::regclass) NOT NULL,
    display smallint,
    userin character varying(20),
    datein date,
    usermod character varying(20),
    datemod date,
    product_type_name character varying(50),
    product_type_desc character varying(150),
    status smallint,
    deleted smallint,
    idunit integer
);


ALTER TABLE public.product_type OWNER TO postgres;

--
-- Name: product_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_unit (
    product_unit_id integer NOT NULL,
    idunit integer,
    product_unit_code character varying(225),
    product_unit_name character varying(522),
    deleted smallint DEFAULT 0,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer
);


ALTER TABLE public.product_unit OWNER TO postgres;

--
-- Name: purchase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase (
    purchase_id bigint NOT NULL,
    idpayment bigint,
    idtax integer,
    idjournal bigint,
    idcustomer bigint,
    date_quote date,
    no_purchase_quote character varying(30),
    subtotal double precision,
    freight double precision,
    tax double precision,
    disc double precision,
    totalamount double precision,
    paidtoday double precision,
    unpaid_amount double precision,
    comments text,
    isrecuring boolean,
    startdate date,
    recuntildate date,
    recnumtimes integer,
    alertto integer,
    notifto integer,
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    status integer,
    idcurrency integer,
    idunit integer,
    noinvoice character varying(20),
    due_date date,
    nopo character varying(30),
    purchaseman_id integer,
    type integer,
    purchase_id_quote integer,
    date_purchase date,
    no_purchase_order character varying(50),
    ddays integer,
    eomddays integer,
    percentagedisc integer,
    daydisc integer,
    notes_si text,
    invoice_status smallint,
    delivery_date date,
    idshipping integer,
    invoice_date date,
    idaccount_hppenjualan integer,
    idaccount_persediaan integer,
    expireddate date,
    include_tax integer,
    idjournal_do integer,
    total_dpp double precision,
    idjournal_invoice integer,
    dmax integer,
    shipaddress text,
    idtaxcomments character varying(50),
    id_inv integer,
    id_purchase_source integer,
    source smallint DEFAULT 1,
    pos_payment_type_id integer,
    id_member integer,
    other_fee double precision,
    invoice_no character varying(100),
    total real,
    dpp real,
    customer_type smallint,
    coa_payment_id integer
);


ALTER TABLE public.purchase OWNER TO postgres;

--
-- Name: COLUMN purchase.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase.type IS '1:Quotation 2:Order';


--
-- Name: COLUMN purchase.invoice_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase.invoice_status IS '[1,''Open''], [2, ''Canceled''], [3, ''Unpaid''], [4, ''Partially Paid''], [5, ''Paid'']';


--
-- Name: COLUMN purchase.include_tax; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase.include_tax IS '1: Include 0: Exclude';


--
-- Name: COLUMN purchase.id_purchase_source; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase.id_purchase_source IS 'jika field ini terisi maka data purchase ini terbentuk dari purchase invoice yang dibatalkan. id_purchase_source adalah asal purchase_id yg dibatalkan';


--
-- Name: COLUMN purchase.source; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase.source IS '1. Web 2. POS';


--
-- Name: COLUMN purchase.customer_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase.customer_type IS '1. Member 2. Non Member';


--
-- Name: seq_purchaseitem; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_purchaseitem
    START WITH 101
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_purchaseitem OWNER TO postgres;

--
-- Name: purchase_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_item (
    purchase_item_id bigint DEFAULT nextval('public.seq_purchaseitem'::regclass) NOT NULL,
    purchase_id bigint,
    qty integer,
    price double precision,
    disc double precision,
    total double precision,
    measurement_id integer,
    ratetax numeric(12,2),
    size numeric(12,2),
    measurement_id_size integer,
    warehouse_id integer,
    qty_kirim integer,
    qty_return integer,
    deleted smallint DEFAULT 0,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    product_id integer,
    description character varying(255),
    total_tax numeric(12,2)
);


ALTER TABLE public.purchase_item OWNER TO postgres;

--
-- Name: purchase_receipt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_receipt (
    purchase_receipt_id integer NOT NULL,
    purchase_receipt_no character varying(150),
    purchase_id integer,
    receipt_date date,
    journal_id integer,
    status integer DEFAULT 1,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    memo character varying(512),
    total_qty_received numeric(12,2),
    total_rest_qty numeric(12,2),
    total_received numeric(12,2),
    idjournal_receive integer
);


ALTER TABLE public.purchase_receipt OWNER TO postgres;

--
-- Name: COLUMN purchase_receipt.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_receipt.status IS '1. Open 2. Partially Received 3. Fully Received 4. Canceled';


--
-- Name: purchase_receipt_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_receipt_item (
    purchase_receipt_item_id integer NOT NULL,
    purchase_item_id integer,
    purchase_receipt_id integer,
    qty_received numeric(12,2),
    notes character varying(512),
    datemod timestamp(6) without time zone,
    rest_qty numeric(12,2)
);


ALTER TABLE public.purchase_receipt_item OWNER TO postgres;

--
-- Name: purchase_return; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_return (
    purchase_return_id integer NOT NULL,
    purchase_id integer,
    status smallint DEFAULT 1,
    memo character varying(255),
    date_return date,
    total_qty_return integer,
    total_amount_return numeric(12,2),
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    deleted smallint DEFAULT 0,
    no_return character varying(150),
    journal_id integer,
    idunit integer
);


ALTER TABLE public.purchase_return OWNER TO postgres;

--
-- Name: COLUMN purchase_return.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_return.status IS '1. Open 2. Approved 3. Canceled';


--
-- Name: purchase_return_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_return_item (
    purchase_return_item_id integer NOT NULL,
    purchase_return_id integer,
    purchase_item_id integer,
    qty_purchase numeric(12,2),
    qty_retur numeric(12,2),
    notes character varying(255),
    datemod timestamp(6) without time zone
);


ALTER TABLE public.purchase_return_item OWNER TO postgres;

--
-- Name: seq_receivemoney; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_receivemoney
    START WITH 79
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_receivemoney OWNER TO postgres;

--
-- Name: receivemoney; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receivemoney (
    idreceivemoney bigint DEFAULT nextval('public.seq_receivemoney'::regclass) NOT NULL,
    idpayment bigint,
    idjournal bigint,
    idtax integer,
    depositaccount bigint,
    payorid bigint,
    notrans character varying(20),
    datetrans date,
    total double precision,
    balance double precision,
    memo character varying(225),
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    receivefrom character varying(30),
    tax double precision,
    idunit integer,
    subtotal double precision,
    idreceivemoneyimport integer,
    user_id integer,
    status smallint DEFAULT 1,
    business_id integer,
    receivefrom_type smallint,
    receivefrom_id integer
);


ALTER TABLE public.receivemoney OWNER TO postgres;

--
-- Name: COLUMN receivemoney.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.receivemoney.status IS '0: Open 1: Approved 3: Reject';


--
-- Name: COLUMN receivemoney.receivefrom_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.receivemoney.receivefrom_type IS '1. Member 2. Non member';


--
-- Name: seq_receivemoneyimport; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_receivemoneyimport
    START WITH 31
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_receivemoneyimport OWNER TO postgres;

--
-- Name: receivemoneyimport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receivemoneyimport (
    idreceivemoneyimport integer DEFAULT nextval('public.seq_receivemoneyimport'::regclass) NOT NULL,
    filename character varying(50),
    totalamount double precision,
    notrans character varying(50),
    datetrans date,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    idunit integer,
    tipe character varying(10)
);


ALTER TABLE public.receivemoneyimport OWNER TO postgres;

--
-- Name: seq_receivemoneyitem; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_receivemoneyitem
    START WITH 91
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_receivemoneyitem OWNER TO postgres;

--
-- Name: receivemoneyitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receivemoneyitem (
    idreceivemoneyitem bigint DEFAULT nextval('public.seq_receivemoneyitem'::regclass) NOT NULL,
    idaccount bigint,
    idreceivemoney bigint,
    amount numeric(24,2),
    memo character varying(225),
    ratetax double precision,
    float8 double precision,
    denda double precision,
    datereceive date
);


ALTER TABLE public.receivemoneyitem OWNER TO postgres;

--
-- Name: seq_receivepayment; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_receivepayment
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_receivepayment OWNER TO postgres;

--
-- Name: receivepayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receivepayment (
    idreceivepayment integer DEFAULT nextval('public.seq_receivepayment'::regclass) NOT NULL,
    idcustomer bigint,
    idsales bigint,
    idpayment bigint,
    idjournal bigint,
    nopayment character varying(20),
    depositaccount bigint,
    datepayment date,
    memo character varying(225),
    ampount double precision,
    charge double precision,
    disc double precision,
    balance double precision,
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone
);


ALTER TABLE public.receivepayment OWNER TO postgres;

--
-- Name: seq_reconcile; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_reconcile
    START WITH 30
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_reconcile OWNER TO postgres;

--
-- Name: reconcile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reconcile (
    idreconcile bigint DEFAULT nextval('public.seq_reconcile'::regclass) NOT NULL,
    idaccount bigint,
    idjournal bigint,
    datestatement date,
    newbalance double precision,
    calcbalance double precision,
    outbalance double precision,
    lastdate date,
    servamount double precision,
    servno character varying(20),
    servdate date,
    servtax double precision,
    expenseaccount bigint,
    servmemo character varying(225),
    intamount double precision,
    intno character varying(20),
    intdate date,
    inttax double precision,
    incomeaccount bigint,
    intmemo character varying(225),
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    idunit integer,
    accbalance double precision
);


ALTER TABLE public.reconcile OWNER TO postgres;

--
-- Name: seq_registrasihutang; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_registrasihutang
    START WITH 47
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_registrasihutang OWNER TO postgres;

--
-- Name: registrasihutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registrasihutang (
    idregistrasihutang integer DEFAULT nextval('public.seq_registrasihutang'::regclass) NOT NULL,
    idunit integer,
    idacchutang integer,
    idacckenahutang integer,
    jumlah double precision,
    sisahutang double precision,
    idjournal integer,
    memo character varying(225),
    userin character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    usermod character varying(20),
    display integer,
    month character varying,
    year integer,
    mulaihutang date,
    jatuhtempo date,
    idsupplier integer,
    customer_type integer
);


ALTER TABLE public.registrasihutang OWNER TO postgres;

--
-- Name: seq_registrasipiutang; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_registrasipiutang
    START WITH 229
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_registrasipiutang OWNER TO postgres;

--
-- Name: registrasipiutang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registrasipiutang (
    idregistrasipiutang integer DEFAULT nextval('public.seq_registrasipiutang'::regclass) NOT NULL,
    idaccount integer,
    bulan character varying(2),
    tahun integer,
    description character varying(225),
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer,
    jumlah double precision,
    idunit integer,
    sisapiutang double precision,
    idaccountlink integer,
    tglpiutang date,
    idjournal integer,
    idpelanggan integer,
    autodecrease integer,
    idcustomer integer,
    customer_type smallint
);


ALTER TABLE public.registrasipiutang OWNER TO postgres;

--
-- Name: COLUMN registrasipiutang.customer_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.registrasipiutang.customer_type IS '1. Member 2. Non Member';


--
-- Name: role_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_menu (
    group_id integer NOT NULL,
    roleid integer NOT NULL,
    status character varying(10)
);


ALTER TABLE public.role_menu OWNER TO postgres;

--
-- Name: seq_role; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_role
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_role OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    roleid integer DEFAULT nextval('public.seq_role'::regclass) NOT NULL,
    rolename character varying(225),
    sys_menu_id integer,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    idsales bigint NOT NULL,
    idpayment bigint,
    idjournal bigint,
    idcustomer bigint,
    date_quote timestamp(6) without time zone,
    no_sales_quote character varying(30),
    subtotal double precision,
    freight double precision,
    tax double precision,
    disc double precision,
    totalamount double precision,
    paidtoday double precision,
    comments text,
    isrecuring boolean,
    startdate date,
    recuntildate date,
    recnumtimes integer,
    alertto integer,
    notifto integer,
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    status integer,
    idcurrency integer,
    idunit integer,
    noinvoice character varying(20),
    nopo character varying(30),
    salesman_id integer,
    type integer,
    idsales_quote integer,
    date_sales date,
    no_sales_order character varying(50),
    ddays integer,
    eomddays integer,
    percentagedisc integer,
    daydisc integer,
    invoice_status smallint,
    delivery_date date,
    idshipping integer,
    invoice_date date,
    idaccount_hppenjualan integer,
    idaccount_persediaan integer,
    expireddate date,
    include_tax integer,
    idjournal_do integer,
    total_dpp double precision,
    idjournal_invoice integer,
    dmax integer,
    shipaddress text,
    idtaxcomments character varying(50),
    id_inv integer,
    id_sales_source integer,
    source smallint DEFAULT 1,
    pos_payment_type_id integer,
    id_member integer,
    other_fee double precision,
    unpaid_amount double precision,
    due_date date,
    invoice_no character varying(100),
    total numeric(24,2),
    dpp numeric(24,2),
    customer_type smallint,
    memo text,
    id_payment_term integer,
    tax_id integer,
    order_status smallint DEFAULT 1,
    payment_amount numeric(12,0),
    change_amount numeric(12,0),
    payment_method smallint,
    shipping_method smallint,
    shipping_address_id integer,
    id_member_loan integer,
    tax_rate numeric(12,2),
    shipping_address_notes character varying(1000),
    shipping_coordinate character varying(100),
    member_loan_quota numeric(12,0) DEFAULT 0,
    member_loan_balance numeric(12,0) DEFAULT 0,
    shipping_method_code character varying(50),
    shipping_city_id integer
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: COLUMN sales.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales.type IS '1:Quotation 2:Order';


--
-- Name: COLUMN sales.invoice_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales.invoice_status IS '[1,''Open''], [2, ''Canceled''], [3, ''Unpaid''], [4, ''Partially Paid''], [5, ''Paid'']';


--
-- Name: COLUMN sales.include_tax; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales.include_tax IS '1: Include 0: Exclude';


--
-- Name: COLUMN sales.id_sales_source; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales.id_sales_source IS 'jika field ini terisi maka data sales ini terbentuk dari sales invoice yang dibatalkan. id_sales_source adalah asal idsales yg dibatalkan';


--
-- Name: COLUMN sales.source; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales.source IS '1. Web 2. POS';


--
-- Name: COLUMN sales.customer_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales.customer_type IS '1. Member 2. Non Member';


--
-- Name: COLUMN sales.order_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales.order_status IS '1. Menunggu Konfirmasi 2. Pesanan Diproses 3. Pesanan Dikirim 4. Pesanan Tiba 5. Pesanan Dikomplain 6. Pesanan Selesai 7. Pesanan Dibatalkan';


--
-- Name: COLUMN sales.payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales.payment_method IS '1:COD,2:Virtual Account,3:Manual Transfer,4;Credit Card,5:eWallet,6:Paylater:7:other';


--
-- Name: sales_calc_tax_tmp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_calc_tax_tmp (
    sales_id integer,
    ratetax numeric(12,2),
    total_tax numeric(12,2),
    tax_id integer
);


ALTER TABLE public.sales_calc_tax_tmp OWNER TO postgres;

--
-- Name: sales_journal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_journal (
    sales_journal_id integer NOT NULL,
    idsales integer,
    idjournal integer,
    typejournal integer,
    userin integer,
    datein timestamp(6) without time zone,
    coa_debit_id integer,
    coa_credit_id integer
);


ALTER TABLE public.sales_journal OWNER TO postgres;

--
-- Name: COLUMN sales_journal.typejournal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales_journal.typejournal IS '1. Create Sales 2. Payment';


--
-- Name: sales_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_payment (
    sales_payment_id integer NOT NULL,
    sales_id integer,
    journal_id integer,
    due_amount numeric(12,2),
    paid_amount numeric(12,2),
    balance_amount numeric(12,2),
    date_trx date,
    datein timestamp(6) without time zone,
    userin integer,
    status smallint DEFAULT 1,
    no_reference character varying(50),
    idunit integer,
    discount_amount numeric(12,2) DEFAULT 0,
    notes character varying(500)
);


ALTER TABLE public.sales_payment OWNER TO postgres;

--
-- Name: COLUMN sales_payment.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales_payment.status IS '1. Paid 2. Unpaid 3. Canceled';


--
-- Name: sales_return; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_return (
    sales_return_id integer NOT NULL,
    sales_id integer,
    status smallint DEFAULT 1,
    memo character varying(255),
    date_return date,
    total_qty_return integer,
    total_amount_return numeric(12,2),
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    deleted smallint DEFAULT 0,
    no_return character varying(150),
    journal_id integer,
    idunit integer,
    return_type smallint DEFAULT 1
);


ALTER TABLE public.sales_return OWNER TO postgres;

--
-- Name: COLUMN sales_return.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales_return.status IS '1. Open 2. Approved 3. Canceled';


--
-- Name: COLUMN sales_return.return_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sales_return.return_type IS '1. Items Return 2. Replacement';


--
-- Name: sales_return_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_return_item (
    sales_return_item_id integer NOT NULL,
    sales_return_id integer,
    sales_item_id integer,
    qty_sale numeric(12,2),
    qty_retur numeric(12,2),
    notes character varying(255),
    datemod timestamp(6) without time zone
);


ALTER TABLE public.sales_return_item OWNER TO postgres;

--
-- Name: seq_salesitem; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_salesitem
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_salesitem OWNER TO postgres;

--
-- Name: salesitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salesitem (
    idsalesitem bigint DEFAULT nextval('public.seq_salesitem'::regclass) NOT NULL,
    idsales bigint,
    qty integer,
    price double precision,
    disc double precision,
    total double precision,
    measurement_id integer,
    ratetax numeric(12,2),
    size numeric(12,2),
    measurement_id_size integer,
    warehouse_id integer,
    qty_kirim integer,
    qty_return integer,
    deleted smallint DEFAULT 0,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    product_id integer,
    description character varying(255),
    total_tax numeric(12,2),
    disc_rate numeric(12,2),
    cost_price numeric(12,0) DEFAULT 0
);


ALTER TABLE public.salesitem OWNER TO postgres;

--
-- Name: seq_accountlog; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_accountlog
    START WITH 146
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_accountlog OWNER TO postgres;

--
-- Name: seq_amounttype; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_amounttype
    START WITH 19
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_amounttype OWNER TO postgres;

--
-- Name: seq_asuransi; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_asuransi
    START WITH 28
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_asuransi OWNER TO postgres;

--
-- Name: seq_asuransipayhistory; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_asuransipayhistory
    START WITH 82
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_asuransipayhistory OWNER TO postgres;

--
-- Name: seq_bom_detail; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_bom_detail
    START WITH 19
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_bom_detail OWNER TO postgres;

--
-- Name: seq_dataanak; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_dataanak
    START WITH 21
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_dataanak OWNER TO postgres;

--
-- Name: seq_datasutri; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_datasutri
    START WITH 30
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_datasutri OWNER TO postgres;

--
-- Name: seq_employee; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_employee
    START WITH 48
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_employee OWNER TO postgres;

--
-- Name: seq_employeetype; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_employeetype
    START WITH 39
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_employeetype OWNER TO postgres;

--
-- Name: seq_goodsreceipt; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_goodsreceipt
    START WITH 14
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_goodsreceipt OWNER TO postgres;

--
-- Name: seq_goodsreceived; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_goodsreceived
    START WITH 14
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_goodsreceived OWNER TO postgres;

--
-- Name: seq_group; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_group
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_group OWNER TO postgres;

--
-- Name: seq_inventoryadjitem; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_inventoryadjitem
    START WITH 23
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_inventoryadjitem OWNER TO postgres;

--
-- Name: seq_inventoryadjusment; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_inventoryadjusment
    START WITH 63
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_inventoryadjusment OWNER TO postgres;

--
-- Name: seq_invoice; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_invoice
    START WITH 17
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_invoice OWNER TO postgres;

--
-- Name: seq_loan_member; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_loan_member
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_loan_member OWNER TO postgres;

--
-- Name: seq_loan_transaction; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_loan_transaction
    START WITH 5
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_loan_transaction OWNER TO postgres;

--
-- Name: seq_member_saving; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_member_saving
    START WITH 138
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_member_saving OWNER TO postgres;

--
-- Name: seq_payroll; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_payroll
    START WITH 69
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_payroll OWNER TO postgres;

--
-- Name: seq_pelanggan; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_pelanggan
    START WITH 23
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_pelanggan OWNER TO postgres;

--
-- Name: seq_potongan; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_potongan
    START WITH 39
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_potongan OWNER TO postgres;

--
-- Name: seq_prosesgaji; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_prosesgaji
    START WITH 32
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_prosesgaji OWNER TO postgres;

--
-- Name: seq_purchase; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_purchase
    START WITH 41
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_purchase OWNER TO postgres;

--
-- Name: seq_return; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_return
    START WITH 32
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_return OWNER TO postgres;

--
-- Name: seq_riwayatpembsiswa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_riwayatpembsiswa
    START WITH 21
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_riwayatpembsiswa OWNER TO postgres;

--
-- Name: seq_sales_invoice_do; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_sales_invoice_do
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_sales_invoice_do OWNER TO postgres;

--
-- Name: seq_sallary; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_sallary
    START WITH 22
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_sallary OWNER TO postgres;

--
-- Name: seq_saving_history; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_saving_history
    START WITH 81
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_saving_history OWNER TO postgres;

--
-- Name: seq_saving_interest; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_saving_interest
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_saving_interest OWNER TO postgres;

--
-- Name: seq_saving_type; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_saving_type
    START WITH 23
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_saving_type OWNER TO postgres;

--
-- Name: seq_shu_generate; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_shu_generate
    START WITH 21
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_shu_generate OWNER TO postgres;

--
-- Name: seq_siswa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_siswa
    START WITH 562
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_siswa OWNER TO postgres;

--
-- Name: seq_siswapembayaran; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_siswapembayaran
    START WITH 57
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_siswapembayaran OWNER TO postgres;

--
-- Name: seq_spendmoney; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_spendmoney
    START WITH 672
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_spendmoney OWNER TO postgres;

--
-- Name: seq_spendmoneyitem; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_spendmoneyitem
    START WITH 722
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_spendmoneyitem OWNER TO postgres;

--
-- Name: seq_supplier; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_supplier
    START WITH 72
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_supplier OWNER TO postgres;

--
-- Name: seq_sys_menu; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_sys_menu
    START WITH 188
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_sys_menu OWNER TO postgres;

--
-- Name: seq_tambahangaji; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_tambahangaji
    START WITH 25
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_tambahangaji OWNER TO postgres;

--
-- Name: seq_tambahangajitype; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_tambahangajitype
    START WITH 24
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_tambahangajitype OWNER TO postgres;

--
-- Name: seq_tax; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_tax
    START WITH 37
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_tax OWNER TO postgres;

--
-- Name: seq_thr; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_thr
    START WITH 23
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_thr OWNER TO postgres;

--
-- Name: seq_transferkas; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_transferkas
    START WITH 63
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_transferkas OWNER TO postgres;

--
-- Name: seq_tunjangan; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_tunjangan
    START WITH 53
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_tunjangan OWNER TO postgres;

--
-- Name: seq_unit; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_unit
    START WITH 53
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_unit OWNER TO postgres;

--
-- Name: seq_upload; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_upload
    START WITH 34
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_upload OWNER TO postgres;

--
-- Name: seq_user_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_user_id
    START WITH 119
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_user_id OWNER TO postgres;

--
-- Name: sequence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sequence (
    idunit integer,
    sequence integer
);


ALTER TABLE public.sequence OWNER TO postgres;

--
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    price_per_unit numeric(12,2)
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- Name: sextype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sextype (
    idsex integer NOT NULL,
    name character varying(20)
);


ALTER TABLE public.sextype OWNER TO postgres;

--
-- Name: shu_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shu_config (
    shu_config_id integer NOT NULL,
    datein timestamp(6) without time zone,
    userin integer,
    shu_config_name character varying(150),
    deleted smallint DEFAULT 0
);


ALTER TABLE public.shu_config OWNER TO postgres;

--
-- Name: shu_generate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shu_generate (
    shu_generate_id integer DEFAULT nextval('public.seq_shu_generate'::regclass) NOT NULL,
    shu_config_id integer,
    status integer,
    userin integer,
    datein timestamp(6) without time zone,
    approved_by integer,
    idunit integer,
    omzet_member numeric(12,0),
    omzet_nonmember numeric(12,0),
    total_revenue numeric(12,0),
    total_expense numeric(12,0),
    shu_notax numeric(12,0),
    tax_pph numeric(12,0),
    shu_aftertax numeric(12,0),
    cadangan_percent numeric(12,2),
    usaha_percent numeric(12,2),
    modal_percent numeric(12,2),
    pengurus_percent numeric(12,2),
    karyawan_percent numeric(12,2),
    pendidikan_percent numeric(12,2),
    sosial_percent numeric(12,2),
    lainnya_percent numeric(12,2),
    idjournal integer,
    shu_period integer,
    cadangan_result numeric(12,2),
    usaha_result numeric(12,2),
    modal_result numeric(12,2),
    pengurus_result numeric(12,2),
    karyawan_result numeric(12,2),
    pendidikan_result numeric(12,2),
    sosial_result numeric(12,2),
    lainnya_result numeric(12,2),
    business_id integer,
    startdate date,
    enddate date,
    total_loan_revenue numeric(12,2),
    total_other_revenue_cashbank numeric(12,2),
    total_member_saving numeric(12,2),
    total_other_income numeric(12,2)
);


ALTER TABLE public.shu_generate OWNER TO postgres;

--
-- Name: COLUMN shu_generate.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.shu_generate.status IS '1. Draft 2. Approved 3. Rejected 4. Canceled';


--
-- Name: shu_member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shu_member (
    shu_generate_id integer NOT NULL,
    id_member integer NOT NULL,
    simp_pokok numeric(12,2),
    simp_wajib numeric(12,2),
    total_modal_member numeric(12,2),
    total_usaha_member numeric(12,2),
    jasa_modal numeric(12,2),
    jasa_usaha numeric(12,2),
    total_shu numeric(12,2),
    datein timestamp(6) without time zone
);


ALTER TABLE public.shu_member OWNER TO postgres;

--
-- Name: shu_share; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shu_share (
    shu_share_id integer NOT NULL,
    shu_config_id integer,
    shu_share_name character varying(225),
    shu_share_desc text,
    percentage real,
    datein timestamp(6) without time zone,
    userin integer,
    deleted smallint DEFAULT 0,
    payable_coa_id integer,
    cashbank_coa_id integer,
    unit_id integer,
    shu_type smallint
);


ALTER TABLE public.shu_share OWNER TO postgres;

--
-- Name: COLUMN shu_share.shu_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.shu_share.shu_type IS '1. Jasa Modal 2. Jasa Usaha 3. Lainnya';


--
-- Name: shu_share_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shu_share_result (
    shu_share_result_id integer NOT NULL,
    shu_share_id integer,
    amount numeric(12,2),
    shu_generate_id integer,
    percentage numeric(12,2),
    datemod timestamp(6) without time zone
);


ALTER TABLE public.shu_share_result OWNER TO postgres;

--
-- Name: siklus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siklus (
    idsiklus integer NOT NULL,
    namasiklus character varying(20),
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1
);


ALTER TABLE public.siklus OWNER TO postgres;

--
-- Name: spendmoney; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spendmoney (
    idspendmoney bigint DEFAULT nextval('public.seq_spendmoney'::regclass) NOT NULL,
    idtax integer,
    idjournal bigint,
    idaccount bigint,
    totalpaid double precision,
    tax double precision,
    balance double precision,
    display integer,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    idunit integer,
    subtotal double precision,
    notrans character varying(20),
    datetrans date,
    memo character varying(225),
    month character varying(2),
    year integer,
    spendfrom character varying(50),
    idimport integer,
    depositaccount integer,
    total double precision,
    status smallint DEFAULT 1,
    business_id integer,
    receiver_id integer,
    receiver_type smallint,
    tax_id integer
);


ALTER TABLE public.spendmoney OWNER TO postgres;

--
-- Name: COLUMN spendmoney.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.spendmoney.status IS '1: Open 2: Confirmed 3: Rejected';


--
-- Name: COLUMN spendmoney.receiver_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.spendmoney.receiver_type IS '1. Member 2. Non member';


--
-- Name: spendmoneyitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spendmoneyitem (
    idspendmoneyitem bigint DEFAULT nextval('public.seq_spendmoneyitem'::regclass) NOT NULL,
    idspendmoney bigint,
    idaccount bigint,
    amount double precision,
    memo character varying(225),
    ratetax double precision
);


ALTER TABLE public.spendmoneyitem OWNER TO postgres;

--
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    staff_id integer NOT NULL,
    group_id integer,
    user_id integer,
    staff_name character varying(200),
    staff_address character varying(500),
    staff_mobilephone character varying(20),
    staff_email character varying(50),
    staff_whatsapp character varying(20),
    staff_photo character varying(200),
    polytpe_id integer,
    status integer DEFAULT 1,
    account_number character varying(100),
    account_name character varying(100),
    bank_name character varying(100),
    no_identity character varying(100),
    staff_number character varying(100),
    location_id integer,
    staff_type_id integer,
    deleted smallint DEFAULT 0,
    fee_monthly numeric(12,0),
    fee_per_patient numeric(12,0)
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- Name: COLUMN staff.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.user_id IS '(null)';


--
-- Name: COLUMN staff.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.staff.status IS '1. Inactive 2. Active 3. On Paid Leave 4. Terminate';


--
-- Name: staff_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_type (
    staff_type_id integer NOT NULL,
    staff_type_name character varying(150),
    datein timestamp(6) without time zone,
    userin integer,
    deleted smallint,
    status smallint,
    datemod timestamp(6) without time zone,
    usermod integer
);


ALTER TABLE public.staff_type OWNER TO postgres;

--
-- Name: stock_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_history (
    stock_history_id integer DEFAULT nextval('public.stock_history_id_seq'::regclass) NOT NULL,
    product_id integer NOT NULL,
    type_adjustment integer,
    no_transaction character varying(100) NOT NULL,
    datein timestamp(6) without time zone DEFAULT now(),
    notes character varying(225),
    idjournal integer,
    current_qty numeric(12,2),
    trx_qty numeric(12,2),
    new_qty numeric(12,2),
    reference_id integer,
    stock_opname_id integer
);


ALTER TABLE public.stock_history OWNER TO postgres;

--
-- Name: COLUMN stock_history.type_adjustment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.stock_history.type_adjustment IS '1:Order,2:Stock In By PO 3:Stock In By Cash 4:Stock Opname Plus 5:Stock Opname Minus 6: Sales Return 7: Purchase Return 8:Sales 9:Opening Balance 10:Cancelation 11: Transfer Stock';


--
-- Name: stock_opname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_opname (
    stock_opname_id integer NOT NULL,
    enddate date,
    memo character varying(522),
    status smallint DEFAULT 1,
    approved_by integer,
    approved_date timestamp(6) without time zone,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    record_date date,
    idunit integer,
    startdate date,
    deleted smallint DEFAULT 0,
    opname_number character varying(23),
    idjournal_stock_opname integer
);


ALTER TABLE public.stock_opname OWNER TO postgres;

--
-- Name: COLUMN stock_opname.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.stock_opname.status IS '1. Open 2. Approved 3. Rejected';


--
-- Name: stock_opname_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_opname_item (
    stock_opname_id integer NOT NULL,
    product_id integer NOT NULL,
    current_stock numeric(12,2),
    adjustment_stock numeric(12,2),
    variance numeric(12,2),
    notes character varying(525),
    datein timestamp(6) without time zone,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.stock_opname_item OWNER TO postgres;

--
-- Name: subscription; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscription (
    subscription_id integer NOT NULL,
    subscription_name character varying(50),
    min_member integer,
    max_member integer,
    price_per_unit numeric(12,0)
);


ALTER TABLE public.subscription OWNER TO postgres;

--
-- Name: subscription_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscription_unit (
    subscription_id integer NOT NULL,
    idunit integer NOT NULL,
    min_member integer,
    max_member integer,
    price_per_unit numeric(12,0)
);


ALTER TABLE public.subscription_unit OWNER TO postgres;

--
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    idsupplier bigint NOT NULL,
    idpayment bigint,
    idshipping bigint,
    code character varying(50),
    namesupplier character varying(50),
    companyaddress text,
    companyaddress2 text,
    companyaddress3 text,
    companyaddress4 text,
    shipaddress character varying(225),
    billaddress character varying(225),
    telephone character varying(30),
    handphone character varying(30),
    fax character varying(30),
    email character varying(30),
    website character varying(30),
    city character varying(50),
    state character varying(50),
    postcode character varying(10),
    country character varying(15),
    highestpo double precision,
    avgdaypay integer,
    lastpayment timestamp(6) without time zone,
    lastpurchase double precision,
    expenseaccount bigint,
    notes character varying(225),
    userin character varying(30),
    usermod character varying(30),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    idunit integer,
    status smallint DEFAULT 1 NOT NULL,
    deleted smallint DEFAULT 0 NOT NULL,
    supplier_type_id integer,
    display smallint,
    idaccount_hppenjualan integer,
    idaccount_persediaan integer
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- Name: supplier_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier_type (
    supplier_type_id integer NOT NULL,
    idunit integer,
    supplier_type_name character varying(150),
    supplier_type_desc character varying(225),
    display smallint,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone,
    status smallint DEFAULT (1)::smallint NOT NULL,
    deleted smallint DEFAULT (0)::smallint NOT NULL
);


ALTER TABLE public.supplier_type OWNER TO postgres;

--
-- Name: sys_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_group (
    group_id integer DEFAULT nextval('public.seq_group'::regclass) NOT NULL,
    group_name character varying(100),
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer,
    description character varying(225),
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1,
    idunit integer,
    "default" smallint DEFAULT 0,
    member_group smallint DEFAULT 2
);


ALTER TABLE public.sys_group OWNER TO postgres;

--
-- Name: COLUMN sys_group.member_group; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sys_group.member_group IS '1. yes 2. No';


--
-- Name: sys_group_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_group_menu (
    sys_menu_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.sys_group_menu OWNER TO postgres;

--
-- Name: sys_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_menu (
    sys_menu_id integer DEFAULT nextval('public.seq_sys_menu'::regclass) NOT NULL,
    menu_name character varying(200),
    menu_link character varying(225),
    parent integer,
    sort integer,
    status integer,
    icon character varying(100),
    display integer,
    description character varying(225),
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    first_load_store_id character varying(100)
);


ALTER TABLE public.sys_menu OWNER TO postgres;

--
-- Name: sys_menu_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_menu_unit (
    sys_menu_id integer,
    idunit integer
);


ALTER TABLE public.sys_menu_unit OWNER TO postgres;

--
-- Name: sys_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_user (
    user_id integer DEFAULT nextval('public.seq_user_id'::regclass) NOT NULL,
    username character varying(200),
    password character varying(224),
    email character varying(150),
    laslogin timestamp(6) without time zone,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    group_id integer,
    realname character varying(30),
    idunitbak integer,
    iduserparent integer,
    display integer,
    clientid integer,
    idcompany integer,
    deleted integer DEFAULT 0,
    idunit integer,
    nik character varying(150),
    phone character varying(100),
    address character varying(225),
    jobname character varying(150),
    api_key character varying(255),
    fcm_token character varying(500),
    latitude character varying(200),
    longitude character varying(200)
);


ALTER TABLE public.sys_user OWNER TO postgres;

--
-- Name: tax; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax (
    idtax integer DEFAULT nextval('public.seq_tax'::regclass) NOT NULL,
    code character varying(20),
    nametax character varying(50),
    description character varying(225),
    rate double precision,
    userin character varying(20),
    usermod character varying(20),
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    display integer,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0,
    idunit smallint,
    coa_expense_id integer,
    coa_ap_id integer,
    coa_cash_id integer,
    coa_ppn_sales_id integer,
    coa_ppn_purchase_id integer,
    coa_ppn_rate real,
    coa_pph23_sales_id integer,
    coa_pph23_purchase_id integer,
    coa_pph23_rate real,
    is_tax_ppn smallint DEFAULT 0,
    is_tax_pph23 smallint DEFAULT 0
);


ALTER TABLE public.tax OWNER TO postgres;

--
-- Name: COLUMN tax.is_tax_ppn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tax.is_tax_ppn IS '0. No 1. Yes';


--
-- Name: COLUMN tax.is_tax_pph23; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tax.is_tax_pph23 IS '0. No 1. Yes';


--
-- Name: tax_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_unit (
    tax_unit_id integer NOT NULL,
    idunit integer,
    idtax integer,
    coa_collection_id integer,
    coa_paysource_id integer,
    rate real,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.tax_unit OWNER TO postgres;

--
-- Name: taxhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxhistory (
    idtax integer NOT NULL,
    taxval real,
    rate real,
    datein timestamp(6) without time zone,
    idpurchase integer,
    idjournal integer NOT NULL,
    type character varying(20)
);


ALTER TABLE public.taxhistory OWNER TO postgres;

--
-- Name: taxlinkunit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxlinkunit (
    idtax integer,
    idunit integer,
    acccollectedtax integer,
    acctaxpaid integer
);


ALTER TABLE public.taxlinkunit OWNER TO postgres;

--
-- Name: taxtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxtype (
    idtaxtype integer NOT NULL,
    nametypetax character varying(40),
    description character varying(225),
    deleted smallint DEFAULT 0,
    status smallint DEFAULT 1
);


ALTER TABLE public.taxtype OWNER TO postgres;

--
-- Name: transfer_stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfer_stock (
    transfer_stock_id integer NOT NULL,
    transfer_stock_no character varying(50),
    transfer_stock_date date,
    transfer_stock_notes text,
    status smallint,
    deleted smallint DEFAULT 0,
    datein timestamp(6) without time zone,
    userin integer,
    datemod timestamp(6) without time zone,
    usermod integer,
    bussiness_origin_id integer,
    bussiness_destination_id integer,
    idunit integer
);


ALTER TABLE public.transfer_stock OWNER TO postgres;

--
-- Name: transfer_stock_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfer_stock_detail (
    transfer_stock_id integer NOT NULL,
    product_id integer NOT NULL,
    current_qty integer,
    transfer_qty integer,
    notes text,
    location_origin_id integer,
    current_destination_id integer,
    datein timestamp(6) without time zone
);


ALTER TABLE public.transfer_stock_detail OWNER TO postgres;

--
-- Name: transferkas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transferkas (
    idtransferkas integer DEFAULT nextval('public.seq_transferkas'::regclass) NOT NULL,
    idaccountsumber integer,
    idaccounttujuan integer,
    idunit integer,
    memo character varying(225),
    tanggal date,
    nominal double precision,
    userin character varying(20),
    datein timestamp(6) without time zone,
    usermod character varying(20),
    datemod timestamp(6) without time zone,
    idjournal integer
);


ALTER TABLE public.transferkas OWNER TO postgres;

--
-- Name: unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unit (
    idunit bigint DEFAULT nextval('public.seq_unit'::regclass) NOT NULL,
    namaunit character varying(50),
    deskripsi character varying(225),
    alamat character varying(225),
    display smallint,
    userin integer,
    usermod integer,
    datein timestamp(6) without time zone,
    datemod timestamp(6) without time zone,
    alamat2 character varying(225),
    alamat3 character varying(225),
    telp character varying(225),
    fax character varying(225),
    email character varying(225),
    website character varying(225),
    country character varying(225),
    npwp character varying(225),
    curfinanceyear integer,
    lastmonthfinanceyear character varying(225),
    conversionmonth character varying(225),
    numaccperiod integer,
    curfinancemonth character varying(2),
    startfinancemonth character varying(2),
    startfinanceyear integer,
    idbussinestype integer,
    logo character varying(225),
    idcompany integer,
    dateformat character varying(20),
    is_taxable smallint,
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0,
    idaccount_hppenjualan smallint,
    idaccount_persediaan smallint,
    year_establised integer,
    coop_num_member_id integer,
    nolisence character varying(225),
    nusafin_api_key character varying(225),
    api_key character varying(255),
    next_payment_date date,
    show_in_reg_form smallint DEFAULT 1,
    default_tax_sales_id integer,
    default_tax_purchase_id integer,
    config_si_payment_note text,
    config_si_footnote text,
    config_sales_autoprint smallint DEFAULT 1
);


ALTER TABLE public.unit OWNER TO postgres;

--
-- Name: unit_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unit_item (
    unit_item_id integer NOT NULL,
    unit_name character varying(120),
    status smallint DEFAULT 1,
    deleted smallint DEFAULT 0
);


ALTER TABLE public.unit_item OWNER TO postgres;

--
-- Name: upload; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.upload (
    idupload integer NOT NULL,
    orig_name character varying(30),
    userin character varying(20),
    datein timestamp(6) without time zone,
    type character varying
);


ALTER TABLE public.upload OWNER TO postgres;

--
-- Name: userunit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userunit (
    user_id integer NOT NULL,
    idunit bigint NOT NULL
);


ALTER TABLE public.userunit OWNER TO postgres;

--
-- Name: variant_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variant_option (
    variant_id integer NOT NULL,
    variant_name character varying(225),
    variant_desc character varying(225),
    deleted smallint DEFAULT 0,
    display smallint DEFAULT 0,
    status smallint,
    userin integer,
    datein timestamp(6) without time zone,
    usermod integer,
    datemod timestamp(6) without time zone
);


ALTER TABLE public.variant_option OWNER TO postgres;

--
-- Name: withdrawal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.withdrawal (
    withdrawal_id integer NOT NULL,
    idunit integer NOT NULL,
    idjournal integer
);


ALTER TABLE public.withdrawal OWNER TO postgres;

--
-- Name: wizard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wizard (
    user_id integer NOT NULL,
    datein timestamp(6) without time zone,
    realname character varying(225),
    address text,
    email character varying(225),
    handphone character varying(225),
    coop_name character varying(225),
    coop_year character varying(225),
    coop_nolicence character varying(225),
    coop_address text,
    coop_telp character varying(225),
    coop_type_kons character varying(225),
    coop_type_simpin character varying(225) DEFAULT 0,
    coop_type_jasa character varying(225),
    coop_type_prod character varying(225),
    coop_num_member_id integer,
    coop_type_lainnya character varying(225)
);


ALTER TABLE public.wizard OWNER TO postgres;

--
-- Name: COLUMN wizard.coop_type_simpin; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.wizard.coop_type_simpin IS '0. Notfinish 1. Finished';


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account (idaccounttype, idaccount, idclassificationcf, idlinked, idparent, accnumber, accname, tax, balance, display, description, userin, usermod, datein, datemod, active, idunit, idaccounttmp, idpos, permanent, lock, status, deleted, debit_balance, credit_balance) FROM stdin;
\.


--
-- Data for Name: accountpos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accountpos (idpos, namepos, status, deleted) FROM stdin;
\.


--
-- Data for Name: accountsubtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accountsubtype (idaccountsubtype, idaccounttype, accsubname) FROM stdin;
\.


--
-- Data for Name: accounttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounttype (idaccounttype, acctypename, idclassificationcf, display, deleted, status) FROM stdin;
\.


--
-- Data for Name: amounttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.amounttype (idamounttype, name, "desc", userin, usermod, datein, datemod) FROM stdin;
\.


--
-- Data for Name: app_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_config (unit_id, logo_path, background_path, tnc_url, register_button, payment_option) FROM stdin;
\.


--
-- Data for Name: approval_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.approval_history (status, datein, approval_logid, user_approver_userid, type_approval, trxid, datemod, notes) FROM stdin;
\.


--
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset (asset_id, idunit, asset_code, asset_name, coa_fixed_asset_id, coa_credit_id, coa_deprec_id, coa_accum_deprec_id, is_depreciate, length_year, value_year, opening_depreciate, coa_equity_first_deprec_id, acquisition_price, acquisiton_date, asset_value_balance, total_depreciation, dispose_date, dispose_price, dispose_coa_id, dispose_memo, dispose_journal_id, dispose_is_sell, dispose_coa_liability_id, asset_memo, dispose_number, startdate_depreciate) FROM stdin;
\.


--
-- Data for Name: asset_depreciation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_depreciation (asset_depreciation_id, depreciation_date, depreciation_amount, depreciation_status, asset_id, journal_id, datein, userin, status, depreciation_no, startdate, enddate) FROM stdin;
\.


--
-- Data for Name: asset_journal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_journal (asset_id, journal_id) FROM stdin;
\.


--
-- Data for Name: balance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.balance (balance_id, user_id, current_balance, datemod) FROM stdin;
\.


--
-- Data for Name: balance_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.balance_history (balance_history_id, balance_id, trx_type, last_balance, trx_amount, end_balance, datein, billing_id) FROM stdin;
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank (bank_id, bank_name, branch_name, address, account_number, account_name, idunit, display, userin, datein, usermod, datemod, deleted, status) FROM stdin;
\.


--
-- Data for Name: billing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing (billing_id, user_id, billing_date, due_date, payment_method, status, num_member, price_unit, amount_due, paid_amount, datein, idunit) FROM stdin;
\.


--
-- Data for Name: brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brand (idunit, brand_name, brand_desc, userin, datein, usermod, datemod, status, deleted, brand_id, idbrand, display) FROM stdin;
\.


--
-- Data for Name: business; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business (business_id, business_name, business_desc, startdate, enddate, logo, address, website, email, legal_name, license_no, userin, datein, usermod, datemod, status, deleted, idunit, display, business_type, business_code, show_in_ecommerce, business_icon, business_banner, gps_coordinate, phone_number, whatsapp_number, city_id) FROM stdin;
\.


--
-- Data for Name: business_deposit_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business_deposit_history (business_deposit_his_id, business_investor_id, date_trx, current_balance, trx_amount, new_balance, noref, remarks, datein, userin, datemod, usermod, deleted, status, display) FROM stdin;
\.


--
-- Data for Name: business_investor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business_investor (business_investor_id, member_id, total_amount, datein, userin, datemod, usermod, status, deleted, business_id) FROM stdin;
\.


--
-- Data for Name: bussinestype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bussinestype (idbussinestype, namebussines, description, deleted, status) FROM stdin;
\.


--
-- Data for Name: cashbank_approval_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cashbank_approval_config (unit_id, new_journal_status, delete_journal_status, delete_journal_userid, new_cashout_status, delete_cashout_status, delete_cashout_userid) FROM stdin;
\.


--
-- Data for Name: cashbank_approver; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cashbank_approver (type, user_approver_userid, user_approver_order) FROM stdin;
\.


--
-- Data for Name: classificationcf; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classificationcf (idclassificationcf, classname, description, prefixno) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (clientid, dateregistered, packageid, nextinvoice) FROM stdin;
\.


--
-- Data for Name: closebook; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.closebook (idclossing, tanggal, idunit, userin, type) FROM stdin;
\.


--
-- Data for Name: clossing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clossing (idclossing, idaccounttype, idaccount, idclassificationcf, idlinked, idparent, accnumber, accname, balance, display, description, userin, usermod, datein, datemod, active, idunit, idaccounttmp, month, year, dateclose, idpos) FROM stdin;
\.


--
-- Data for Name: collateral_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collateral_attribute (collateral_attribute_id, collateral_category, unit_id, attribute_type, attribute_name) FROM stdin;
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company (idcompany, idbussinestype, companyname, companyaddress, companyaddress2, companyaddress3, companyaddress4, companyaddress5, telp, fax, email, website, country, npwp, userin, usermod, datein, datemod, display, curfinanceyear, lastmonthfinanceyear, conversionmonth, numaccperiod, logo, idlocation, type, deleted, status) FROM stdin;
1	\N	Wijawa Farma	Jln. A. Yani No 201	\N	\N	\N	\N	\N	\N	apotekwijayafarma001@gmail.com	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	logo-pharmacy.jpg	\N	\N	0	\N
\.


--
-- Data for Name: credit_balance_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_balance_history (credit_balance_id, current_balance, trx_amount, new_balance, datein, trx_id, trx_type, customer_by_type, customer_id, member_id) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency (idcurrency, namecurr, symbol, description, display, userin, usermod, datein, datemod, idunit, rate, status, deleted) FROM stdin;
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (idcustomer, idcustomertype, idpayment, nocustomer, namecustomer, address, shipaddress, billaddress, telephone, handphone, fax, email, website, city, state, postcode, country, highestpayment, avgdaypayment, lastpayment, lastsales, incomeaccount, notes, userin, usermod, datein, datemod, status, deleted, display, idunit, credit_balance, password, lastlogin, api_key, delivery_longitude, delivery_latitude, fcm_token, city_id, provider_user_id, provider) FROM stdin;
1	1	\N	Test - 011	Testx	x	cc	cc	x	x	cc	cc	cc	x	x	cc	cc	\N	\N	\N	\N	\N	c	\N	\N	\N	\N	1	1	\N	12	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
205	1	\N	dd	dd	dd	dd	d	d	d	d	d	d	d	d	d	d	\N	\N	\N	\N	\N		\N	\N	\N	\N	0	1	\N	12	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
206	5	\N	Supp 001	PT. ABC	xx	xx	xx	981871	89100				Yogyakarta	Bantul			\N	\N	\N	\N	\N		\N	\N	\N	\N	1	0	\N	12	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: customertype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customertype (idcustomertype, namecustype, description, userin, datein, usermod, datemod, idunit, display, status, deleted) FROM stdin;
3	Vendor	-	\N	\N	\N	\N	12	\N	1	1
1	Suplier	\N	1	2020-07-15 20:56:27	\N	\N	12	\N	1	1
2	Customer	-	\N	\N	\N	\N	12	\N	1	1
4	Member	-	\N	\N	\N	\N	12	\N	1	1
5	Supplier	Supplier	\N	\N	\N	\N	12	\N	1	0
\.


--
-- Data for Name: day_name; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.day_name (day_id, day_name) FROM stdin;
\.


--
-- Data for Name: debt_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.debt_payment (debt_payment_id, idregistrasihutang, reference_no, current_balance, payment_amount, new_balance, notes, datein, userin, datemod, usermod, status, deleted) FROM stdin;
\.


--
-- Data for Name: deposit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deposit (deposit_id, idunit, idjournal) FROM stdin;
\.


--
-- Data for Name: disbursment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disbursment (iddisbursment, idpurchase, idaccount, idjournal, datepay, nocheque, memo, totalowed, totalpaid, balance, payee, display, userin, usermod, datein, datemod, idregistrasihutang) FROM stdin;
\.


--
-- Data for Name: disease; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disease (disease_id, disease_code, disease_name, disease_desc, datein, userin, datemod, usermod, deleted) FROM stdin;
\.


--
-- Data for Name: doctor_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor_schedule (schedule_id, doctor_id, day_id, timesheet_1_start, timesheet_1_end, timesheet_2_start, timesheet_2_end, timesheet_3_start, timesheet_3_end, timesheet_4_start, timesheet_4_end, status) FROM stdin;
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (idemployee, code, firstname, lastname, address, telephone, handphone, fax, email, website, city, state, postcode, country, notes, display, userin, usermod, datein, datemod, idemployeetype, idunit, idkawin, pegawaitglmasuk, norek, namabank, keaktifan, tglresign, idjenisptkp, idupload, deleted, user_id, is_login, status, group_id, birth_date, birth_location, no_id, marital_status, business_id) FROM stdin;
1	9019000	Admin	\N	Cilacap	\N	08919819991	\N	ekacandrika@gmail.com	\N	\N	\N	\N	\N	=	\N	\N	1	\N	2020-08-13 20:08:38	\N	12	\N	\N	\N	\N	Aktif	\N	\N	\N	0	1	0	1	1	2020-08-13	Cilacap	38991891001	1	\N
2	877189991	xxxx	\N	xxxx	\N	xxx	\N	xxx	\N	\N	\N	\N	\N	zzz	\N	1	\N	2020-08-13 20:08:36	\N	\N	12	\N	\N	\N	\N	Non Aktif	\N	\N	\N	1	\N	1	1	1	1971-08-13	xxxx	xxxx	2	\N
\.


--
-- Data for Name: employeetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employeetype (idemployeetype, nametype, description, userin, usermod, datein, datemod, idaccountpayroll, idunit, display, idaccount, payrolltypeid, fare, idaccountpaythr, idaccountthr, idcompany, deleted, status) FROM stdin;
\.


--
-- Data for Name: employeetypeakunlink; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employeetypeakunlink (idemployeetype, idaccountpayroll, idaccount, idaccountpaythr, idaccountthr, idunit) FROM stdin;
\.


--
-- Data for Name: forgot_pass; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.forgot_pass (forgot_id, user_id, token, expired_date, datein, status) FROM stdin;
\.


--
-- Data for Name: frequency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.frequency (idfrequency, namefreq) FROM stdin;
\.


--
-- Data for Name: hakakses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hakakses (sys_menu_id, group_id, view, edit, delete, usermod, datemod, add) FROM stdin;
1	1	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory (idinventory, idjournal, invno, nameinventory, description, isinventory, issell, isbuy, cosaccount, incomeaccount, assetaccount, qtystock, images, cost, numperunit, minstock, idprimarysupplier, sellingprice, idselingtax, unitmeasuresell, numperunitsell, notes, display, userin, usermod, datein, datemod, yearbuy, monthbuy, datebuy, idinventorycat, idbuytax, idunit, residu, umur, akumulasibeban, bebanberjalan, nilaibuku, bebanperbulan, akumulasiakhir, status, deleted, sku_no, brand_id, idbrand, idsupplier, inventory_type, measurement_id_one, measurement_id_two, measurement_id_tre, bahan_coil_id, diameter, ketebalan, berat, lebar, tinggi, panjang, konversi_coil_name, panjang_satuan_id, tinggi_satuan_id, lebar_satuan_id, berat_satuan_id, ketebalan_satuan_id, diameter_satuan_id, idinventory_parent, nominal_persediaan, hpp_per_unit, unitmeasure, no_batch, no_transaction, ratio_two, ratio_tre, is_traceablity, grouped) FROM stdin;
\.


--
-- Data for Name: inventory_adjust; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_adjust (inventory_adjust_id, idunit, status, idaccount_adjs, notes, userin, datein, date_adjustment) FROM stdin;
\.


--
-- Data for Name: inventory_adjust_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_adjust_items (inventory_adjust_item_id, inventory_adjust_id, idunit, idinventory, warehouse_id, qty_adjustment, variance, item_value, total_value, cost, sellingprice, datein, qty_stock) FROM stdin;
\.


--
-- Data for Name: inventory_count; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_count (inventory_count_id, idunit, status, type_id, notes, date_count, userin, datein) FROM stdin;
\.


--
-- Data for Name: inventory_count_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_count_items (inventory_count_item_id, inventory_count_id, idunit, idinventory, warehouse_id, qty_count, variance, item_value, total_value, cost, sellingprice, datein, qty_stock) FROM stdin;
\.


--
-- Data for Name: inventory_supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_supplier (idinventory, idsupplier) FROM stdin;
\.


--
-- Data for Name: inventory_transfer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_transfer (transfer_stock_id, idunit, requestedby_d, approvedby_id, request_date, approved_date, memo, no_transfer, datein, datemod, userin, usermod) FROM stdin;
\.


--
-- Data for Name: inventory_transfer_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_transfer_item (inventory_transfer_item_id, transfer_stock_id, idunit, idinventory, qty_transfer, note, datein, warehouse_source_id, warehouse_dest_id) FROM stdin;
\.


--
-- Data for Name: inventorycat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventorycat (idinventorycat, namecat, description, userin, usermod, datein, datemod, display, status, deleted, idunit, show_in_ecomm, icon, "default", sort_by) FROM stdin;
97	Obat Bebas		12	12	2020-07-16 00:07:26	2020-07-16 00:07:26	\N	1	0	\N	0	\N	0	0
98	Obat Resep		12	12	2020-07-16 00:07:58	2020-07-16 00:07:58	\N	1	0	\N	0	\N	0	0
99	Obat Generik		12	12	2020-07-16 00:07:10	2020-07-16 00:07:10	\N	1	0	\N	0	\N	0	0
\.


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice (id_invoice, id_member_saving, id_xd, user_id, xendit_fee_amount, sni_fee_amount, status, merchant_name, merchant_profile_picture_url, amount, payer_email, description, expiry_date, invoice_url, should_exclude_credit_card, should_send_email) FROM stdin;
\.


--
-- Data for Name: invoice_bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_bank (id_invoice, bank_code, collection_type, bank_account_number, transfer_amount, bank_branch, account_holder_name, identity_amount, id_invoice_bank) FROM stdin;
\.


--
-- Data for Name: journal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journal (idjournal, idjournaltype, nojournal, name, datejournal, memo, totaldebit, totalcredit, totaltax, isrecuring, year, month, display, userin, usermod, datein, datemod, lastbalance, currbalance, balance, idunit, idcurrency, idreconcile, idclossing, deleted, status, is_panjar) FROM stdin;
\.


--
-- Data for Name: journalitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journalitem (idjournalitem, idjournal, idaccount, idtax, debit, credit, memo, lastbalance, currbalance) FROM stdin;
\.


--
-- Data for Name: journaltype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.journaltype (idjournaltype, namejournal, description, deleted, status) FROM stdin;
\.


--
-- Data for Name: linkedacc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.linkedacc (idlinked, idaccounttype, namelinked, description, idaccount, display) FROM stdin;
\.


--
-- Data for Name: linkedaccunit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.linkedaccunit (idlinked, idaccount, idunit) FROM stdin;
\.


--
-- Data for Name: linkpiutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.linkpiutang (idlinkpiutang, idaccountpiutang, idaccount, description, userin, usermod, datein, datemod, display, idunit) FROM stdin;
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location (location_id, location_name, location_desc, location_address, status, deleted, userin, datein, usermod, datemod, idunit, display) FROM stdin;
\.


--
-- Data for Name: log_cron; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_cron (datein, num_of_billing) FROM stdin;
\.


--
-- Data for Name: log_deprecation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_deprecation (idlog_deprec, asset_id, asset_name, asset_deprec_id, idunit, datein) FROM stdin;
\.


--
-- Data for Name: loginlog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loginlog (pegawainid, jammasuk, tanggal, bulan, tahun, is_referral, browser, version, mobile, robot, referrer, agent_string, userin, usermod, datein, datemod, ipaddress, loginlogid, username) FROM stdin;
\.


--
-- Data for Name: master_city; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.master_city (city_id, province_id, province, type, city_name, postal_code) FROM stdin;
\.


--
-- Data for Name: medical_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_action (medical_action_id, medical_action_name, medical_action_desc, deleted, datein, userin, datemod, usermod, service_fee, medical_action_amount) FROM stdin;
\.


--
-- Data for Name: medical_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_record (medical_record_id, patient_id, medical_record_desc, medical_record_no, medical_record_date, doctor_id, nurse_id, medical_status, payment_status, medicine_status, datein, userin, datemod, usermod, receipt_number, deleted, notes, sales_id, service_amount, additional_amount, discount_amount, subtotal, memo, shpping_fee, grand_total, payment_method, paid_date) FROM stdin;
\.


--
-- Data for Name: medical_record_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_record_action (medical_record_id, medical_action_id, notes, datein, userin, datemod, usermod, deleted, service_fee) FROM stdin;
\.


--
-- Data for Name: medical_record_disease; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_record_disease (medical_record_id, disease_id, notes, datein, userin, datemod, usermod, deleted) FROM stdin;
\.


--
-- Data for Name: medical_record_drug; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_record_drug (medical_record_id, product_id, notes, qty, product_unit_id, userin, datein, usermod, datemod, deleted, subtotal) FROM stdin;
\.


--
-- Data for Name: nsp_trx_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nsp_trx_log (id, external_id, user_id, is_high, status, merchant_name, amount, payer_email, description, paid_amount, payment_method, adjusted_received_amount, datein) FROM stdin;
\.


--
-- Data for Name: nusafin_key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nusafin_key (unit_id, api_key_live, api_key_dev) FROM stdin;
\.


--
-- Data for Name: package; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.package (packageid, packagename, price, description) FROM stdin;
\.


--
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient (patient_id, birthday_date, no_tlp, no_mobile, address, email, no_id, country, datein, userin, datemod, usermod, deleted, display, id_type, patient_name, remarks, member_id, patient_photo, patient_type_id, status, patient_no, gender_type, np_number, divisi, business_id, patient_parent_id, benefit_id_type, relationship_type) FROM stdin;
\.


--
-- Data for Name: patient_family; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_family (patient_family_id, relationship_type, patient_id, family_name, family_address, family_phone, deleted, datein, userin, datemod, usermod) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (idpayment, namepayment, description, userin, usermod, datein, datemod, deleted, status) FROM stdin;
\.


--
-- Data for Name: payment_log_xd; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_log_xd (id, user_id, external_id, is_high, status, merchant_name, amount, received_amount, payer_email, description, xendit_fee_amount, expiry_date, invoice_url, paid_amount, payment_method, adjusted_received_amount, adjusted_xendit_fee_amount, datein, payment_log_id, payment_id, callback_virtual_account_id, owner_id, account_number, bank_code, merchant_code, date_trx, fixed) FROM stdin;
\.


--
-- Data for Name: payment_term; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_term (id_payment_term, term_name, term_desc, display, deleted, userin, datein, usermod, datemod, status) FROM stdin;
\.


--
-- Data for Name: payroll; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll (idpayroll, idjournal, month, year, userin, datein, idunit) FROM stdin;
\.


--
-- Data for Name: payroll_asuransi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_asuransi (idasuransi, idasuransitype, idasuransipaytype, namapremi, deskripsi, fixamount, percentemployee, percentcompany, coa_id_ap_emp, coa_id_ap_cmp, userin, datein, usermod, datemod, display, tampilemp, tampilcmp, idunit, deleted) FROM stdin;
\.


--
-- Data for Name: payroll_asuransiemp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_asuransiemp (idasuransiemp, idasuransi, idemployee, userin, usermod, datein, datemod, display) FROM stdin;
\.


--
-- Data for Name: payroll_asuransipayhistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_asuransipayhistory (percente, percentc, amounte, amountc, userin, datein, month, year, idasuransi, idemployee) FROM stdin;
\.


--
-- Data for Name: payroll_asuransipaytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_asuransipaytype (idasuransipaytype, nametype) FROM stdin;
\.


--
-- Data for Name: payroll_asuransitype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_asuransitype (idasuransitype, nametype, column_3) FROM stdin;
\.


--
-- Data for Name: payroll_asuransiunit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_asuransiunit (idasuransi, idaccountemp, idaccountcomp, idunit) FROM stdin;
\.


--
-- Data for Name: payroll_jenisptkp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_jenisptkp (idjenisptkp, namaptkp, deskripsi, totalptkp, display, userin, usermod, datein, datemod, status, deleted) FROM stdin;
\.


--
-- Data for Name: payroll_potongan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_potongan (idpotongan, idpotongantype, idamounttype, idsiklus, idemployee, startdate, enddate, totalpotongan, sisapotongan, jumlahpotongan, userin, datein, usermod, datemod, jumlahangsuran, keterangan, sisaangsuran, display, idupload) FROM stdin;
\.


--
-- Data for Name: payroll_potonganhistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_potonganhistory (idpotongan, idprosesgaji, datepaid, jumlahpotongan, sisapotongan, totalpotongan, userin, datein, sisaangsuran, month, year, idemployee) FROM stdin;
\.


--
-- Data for Name: payroll_potongantype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_potongantype (idpotongantype, namepotongan, descpotongan, jenispotongan, userin, usermod, datein, datemod, display, idcompany, idunit, deleted, status) FROM stdin;
\.


--
-- Data for Name: payroll_proceed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_proceed (idemployee, firstname, lastname, namaunit, nametype, jumlahjam, jumlahkehadiran, totalgaji, totaltunjangan, pph21, totalpotongan, totalpembayaran, payname, userin, code, userid, idemployeetype, payrolltypeid, pembayaranperjamkehadiran, premiinsurance, ptkp, wajibpajak, jenispph21, tarifpajak, pphterhutang, month, year, datein, idunit, idpayroll, penambahangaji, numtanggungan, tglpenggajian) FROM stdin;
\.


--
-- Data for Name: payroll_prosesgaji; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_prosesgaji (idprosesgaji, idsallary, idpotongan, idtunjangan, jenpph, totalpotongan, totaltunjangan, biayajabatan, pph21, totalpembayaran, userin, usermod, datein, datemod, bulan, tahun, idemployee, gajipokok, idunit) FROM stdin;
\.


--
-- Data for Name: payroll_prosesgaji_tmp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_prosesgaji_tmp (idemployee, jumlah, userin, idaccountpayroll, idaccountkas, idunit, accnumberpayroll) FROM stdin;
\.


--
-- Data for Name: payroll_sallary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_sallary (idsallary, idemployee, basicsallary, nosk, tglmulai, tglakhir, notes, userin, datein, usermod, datemod, jabatan) FROM stdin;
\.


--
-- Data for Name: payroll_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_settings (payrollsettingid, payrolltypeid, payrollname, payrolldesc, fare, datein, userin, datemod, usermod, display) FROM stdin;
\.


--
-- Data for Name: payroll_tambahangaji; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_tambahangaji (idtambahangaji, idemployee, idtambahangajitype, idsiklus, namatambahan, startdate, enddate, jumlah, display, userin, usermod, datein, datemod, keterangan, deleted) FROM stdin;
\.


--
-- Data for Name: payroll_tambahangajihistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_tambahangajihistory (idtambahangaji, idpayroll, datepaid, userin, datein, month, year, jumlah, idemployee) FROM stdin;
\.


--
-- Data for Name: payroll_tambahangajitype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_tambahangajitype (idtambahangajitype, idunit, tambahantype, deskripsi, userin, usermod, datein, datemod, display, deleted, status) FROM stdin;
\.


--
-- Data for Name: payroll_tmp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_tmp (idemployee, firstname, lastname, namaunit, nametype, jumlahjam, jumlahkehadiran, totalgaji, totaltunjangan, pph21, totalpotongan, totalpembayaran, payname, userin, code, userid, idemployeetype, payrolltypeid, pembayaranperjamkehadiran, premiinsurance, ptkp, wajibpajak, jenispph21, tarifpajak, pphterhutang, idunit, penambahangaji, numtanggungan) FROM stdin;
\.


--
-- Data for Name: payroll_tunjangan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_tunjangan (idtunjangan, idtunjtype, idamounttype, idemployee, idsiklus, namatunjangan, startdate, enddate, jumlah, display, userin, usermod, datein, datemod, persen, idupload, multiplier_id, idunit) FROM stdin;
\.


--
-- Data for Name: payroll_tunjanganhistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_tunjanganhistory (idtunjangan, idprosesgaji, datepaid, userin, datein, month, year, jumlah, idemployee) FROM stdin;
\.


--
-- Data for Name: payroll_tunjangantype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_tunjangantype (idtunjtype, idunit, nametunj, desctunj, userin, usermod, datein, datemod, display, idcompany, deleted, status) FROM stdin;
\.


--
-- Data for Name: payroll_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_type (payrolltypeid, payname, description, datein, userin, datemod, usermod, display, deleted, status) FROM stdin;
\.


--
-- Data for Name: piutanghistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.piutanghistory (idregistrasipiutang, month, year, tanggal, diterima, sisa, idjournal, source, userin, datein, idreceivemoney, idpiutanghistory) FROM stdin;
\.


--
-- Data for Name: piutangpayhistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.piutangpayhistory (idregistrasipiutang, month, year, penerimaan, jumlah, sisapiutang, idunit, datein, userin, tglpenerimaan, idjournal, piutangpayhistory_id) FROM stdin;
\.


--
-- Data for Name: poly_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poly_type (polytpe_id, polytpe_name, polytpe_desc, deleted, datein, userin, datemod, usermod, location_id, status) FROM stdin;
\.


--
-- Data for Name: pos_payment_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_payment_type (pos_payment_type_id, payment_type_name, description, userin, usermod, datein, datemod, deleted, status) FROM stdin;
\.


--
-- Data for Name: pos_preferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_preferences (unit_id, user_id, platform, version, printer_device, barcode_device, latitude, longitude, fcm_token, current_version, datein, datemod) FROM stdin;
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (product_id, product_name, product_no, product_type_id, idbrand, product_description, cost_price, buy_price, wholesale_price, retail_price, weight, weight_measurement_id, idunit, product_parent_id, product_image, stock_available, stock_commited, stock_incoming, stock_max_online, available_on_pos, only_for_member, no_sku, no_barcode, no_supplier, is_sellable, is_purchasable, is_taxable, idsupplier, status, deleted, member_price, wholesale_price_member, retail_price_member, idinventorycat, inventory_class_id, business_id, coa_sales_id, coa_purchase_id, coa_tax_sales_id, coa_tax_purchase_id, location_id, is_consignment, consignment_base_price, consignment_owner_id, consignment_owner_type_id, product_unit_id, product_balance, product_location_id, coa_inventory_id, datein, userin, datemod, usermod, stock_monitor, minimum_stock, show_in_ecommerce, ecommerce_cat_id, weight_per_unit, expired_date) FROM stdin;
1	bodtrex migra	\N	\N	\N	-	\N	1500.00	\N	\N	\N	\N	12	\N	\N	\N	\N	\N	\N	\N	0	DASBDF	DASBDF	\N	2	2	1	\N	1	1	\N	\N	2500.00	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	0.00	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	2020-07-15
2	Ampicilin	\N	\N	\N	\N	0	7500.00	\N	9000.00	\N	\N	12	\N	\N	20	\N	\N	\N	1	0	1	1	\N	1	2	1	\N	1	1	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
7	Ampicilin	\N	\N	\N	\N	0	7500.00	\N	9000.00	\N	\N	12	\N	\N	20	\N	\N	\N	1	0	71888100211	71888100211	\N	2	2	1	\N	1	1	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
8	Ampicilin	\N	\N	\N	\N	0	7500.00	\N	9000.00	\N	\N	12	\N	\N	20	\N	\N	\N	1	0	71888100211	71888100211	\N	2	2	1	\N	1	1	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
9	Ampicilin	\N	\N	\N	\N	0	7500.00	\N	9000.00	\N	\N	12	\N	\N	20	\N	\N	\N	1	0	71888100211	71888100211	\N	2	2	1	\N	1	1	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
3	Ampicilin	\N	\N	\N	\N	0	7500.00	\N	9000.00	\N	\N	12	\N	\N	10	\N	\N	\N	1	0	71888100211	71888100211	\N	2	2	1	\N	1	1	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
4	Ampicilin	\N	\N	\N	\N	0	7500.00	\N	9000.00	\N	\N	12	\N	\N	10	\N	\N	\N	1	0	71888100211	71888100211	\N	2	2	1	\N	1	1	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
5	Ampicilin	\N	\N	\N	\N	0	7500.00	\N	9000.00	\N	\N	12	\N	\N	20	\N	\N	\N	1	0	71888100211	71888100211	\N	2	2	1	\N	1	1	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
6	Ampicilin	\N	\N	\N	\N	0	7500.00	\N	9000.00	\N	\N	12	\N	\N	20	\N	\N	\N	1	0	71888100211	71888100211	\N	2	2	1	\N	1	1	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
10	Ampicilin	\N	\N	\N	\N	0	7500.00	\N	9000.00	\N	\N	12	\N	\N	10	\N	\N	\N	1	0	71888100211	71888100211	\N	2	2	1	\N	1	1	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	75000.00	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
11	Racikan A	\N	\N	\N		\N	14000.00	\N	\N	\N	\N	12	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	2	2	1	\N	1	1	\N	\N	34500.00	\N	1	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	0.00	\N	\N	\N	\N	\N	\N	0	\N	1	\N	500	\N
\.


--
-- Data for Name: product_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_attribute (product_id, attribute_id) FROM stdin;
\.


--
-- Data for Name: product_composition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_composition (product_id, product_composition_id, composition_no, qty, product_unit_id, notes, datein, userin, datemod, usermod, composition_type, fee_amount) FROM stdin;
11	10	\N	8.00	\N		2020-07-15 17:07:10	1	2020-07-15 17:07:10	1	2	5000
\.


--
-- Data for Name: product_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_image (product_image_id, product_id, deleted, datein, userin, datemod, usermod, image_thumbnail, image_fullsize, image_caption, order_by) FROM stdin;
\.


--
-- Data for Name: product_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_location (product_location_id, location_name, notes, deleted, userin, datein, usermod, datemod, idunit, status) FROM stdin;
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_type (product_type_id, display, userin, datein, usermod, datemod, product_type_name, product_type_desc, status, deleted, idunit) FROM stdin;
\.


--
-- Data for Name: product_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_unit (product_unit_id, idunit, product_unit_code, product_unit_name, deleted, datein, userin, datemod, usermod) FROM stdin;
1	12	25 mg	mili gram	0	2020-07-15 08:07:12	12	2020-07-15 08:07:12	12
\.


--
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase (purchase_id, idpayment, idtax, idjournal, idcustomer, date_quote, no_purchase_quote, subtotal, freight, tax, disc, totalamount, paidtoday, unpaid_amount, comments, isrecuring, startdate, recuntildate, recnumtimes, alertto, notifto, display, userin, usermod, datein, datemod, status, idcurrency, idunit, noinvoice, due_date, nopo, purchaseman_id, type, purchase_id_quote, date_purchase, no_purchase_order, ddays, eomddays, percentagedisc, daydisc, notes_si, invoice_status, delivery_date, idshipping, invoice_date, idaccount_hppenjualan, idaccount_persediaan, expireddate, include_tax, idjournal_do, total_dpp, idjournal_invoice, dmax, shipaddress, idtaxcomments, id_inv, id_purchase_source, source, pos_payment_type_id, id_member, other_fee, invoice_no, total, dpp, customer_type, coa_payment_id) FROM stdin;
\.


--
-- Data for Name: purchase_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_item (purchase_item_id, purchase_id, qty, price, disc, total, measurement_id, ratetax, size, measurement_id_size, warehouse_id, qty_kirim, qty_return, deleted, userin, datein, usermod, datemod, product_id, description, total_tax) FROM stdin;
\.


--
-- Data for Name: purchase_receipt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_receipt (purchase_receipt_id, purchase_receipt_no, purchase_id, receipt_date, journal_id, status, userin, datein, usermod, datemod, memo, total_qty_received, total_rest_qty, total_received, idjournal_receive) FROM stdin;
\.


--
-- Data for Name: purchase_receipt_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_receipt_item (purchase_receipt_item_id, purchase_item_id, purchase_receipt_id, qty_received, notes, datemod, rest_qty) FROM stdin;
\.


--
-- Data for Name: purchase_return; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_return (purchase_return_id, purchase_id, status, memo, date_return, total_qty_return, total_amount_return, datein, userin, datemod, usermod, deleted, no_return, journal_id, idunit) FROM stdin;
\.


--
-- Data for Name: purchase_return_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_return_item (purchase_return_item_id, purchase_return_id, purchase_item_id, qty_purchase, qty_retur, notes, datemod) FROM stdin;
\.


--
-- Data for Name: receivemoney; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receivemoney (idreceivemoney, idpayment, idjournal, idtax, depositaccount, payorid, notrans, datetrans, total, balance, memo, display, userin, usermod, datein, datemod, receivefrom, tax, idunit, subtotal, idreceivemoneyimport, user_id, status, business_id, receivefrom_type, receivefrom_id) FROM stdin;
\.


--
-- Data for Name: receivemoneyimport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receivemoneyimport (idreceivemoneyimport, filename, totalamount, notrans, datetrans, userin, usermod, datein, datemod, idunit, tipe) FROM stdin;
\.


--
-- Data for Name: receivemoneyitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receivemoneyitem (idreceivemoneyitem, idaccount, idreceivemoney, amount, memo, ratetax, float8, denda, datereceive) FROM stdin;
\.


--
-- Data for Name: receivepayment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receivepayment (idreceivepayment, idcustomer, idsales, idpayment, idjournal, nopayment, depositaccount, datepayment, memo, ampount, charge, disc, balance, display, userin, usermod, datein, datemod) FROM stdin;
\.


--
-- Data for Name: reconcile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reconcile (idreconcile, idaccount, idjournal, datestatement, newbalance, calcbalance, outbalance, lastdate, servamount, servno, servdate, servtax, expenseaccount, servmemo, intamount, intno, intdate, inttax, incomeaccount, intmemo, display, userin, usermod, datein, datemod, idunit, accbalance) FROM stdin;
\.


--
-- Data for Name: registrasihutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registrasihutang (idregistrasihutang, idunit, idacchutang, idacckenahutang, jumlah, sisahutang, idjournal, memo, userin, datein, datemod, usermod, display, month, year, mulaihutang, jatuhtempo, idsupplier, customer_type) FROM stdin;
\.


--
-- Data for Name: registrasipiutang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registrasipiutang (idregistrasipiutang, idaccount, bulan, tahun, description, userin, usermod, datein, datemod, display, jumlah, idunit, sisapiutang, idaccountlink, tglpiutang, idjournal, idpelanggan, autodecrease, idcustomer, customer_type) FROM stdin;
\.


--
-- Data for Name: role_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_menu (group_id, roleid, status) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (roleid, rolename, sys_menu_id, deleted) FROM stdin;
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales (idsales, idpayment, idjournal, idcustomer, date_quote, no_sales_quote, subtotal, freight, tax, disc, totalamount, paidtoday, comments, isrecuring, startdate, recuntildate, recnumtimes, alertto, notifto, display, userin, usermod, datein, datemod, status, idcurrency, idunit, noinvoice, nopo, salesman_id, type, idsales_quote, date_sales, no_sales_order, ddays, eomddays, percentagedisc, daydisc, invoice_status, delivery_date, idshipping, invoice_date, idaccount_hppenjualan, idaccount_persediaan, expireddate, include_tax, idjournal_do, total_dpp, idjournal_invoice, dmax, shipaddress, idtaxcomments, id_inv, id_sales_source, source, pos_payment_type_id, id_member, other_fee, unpaid_amount, due_date, invoice_no, total, dpp, customer_type, memo, id_payment_term, tax_id, order_status, payment_amount, change_amount, payment_method, shipping_method, shipping_address_id, id_member_loan, tax_rate, shipping_address_notes, shipping_coordinate, member_loan_quota, member_loan_balance, shipping_method_code, shipping_city_id) FROM stdin;
2	1	\N	\N	\N	\N	90000	\N	\N	0	90000	90000	import sales	\N	\N	\N	\N	\N	\N	\N	1	\N	2020-07-15 20:07:13	\N	5	\N	\N	\N	\N	\N	2	\N	2020-07-15	SO20070002	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N	\N	\N	0	\N	\N	\N	\N	1	\N	\N	\N	6	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	\N	\N
3	1	\N	\N	\N	\N	90000	\N	\N	0	90000	90000	import sales	\N	\N	\N	\N	\N	\N	\N	1	\N	2020-07-15 20:07:23	\N	5	\N	\N	\N	\N	\N	2	\N	2020-07-15	SO20070002	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N	\N	\N	0	\N	\N	\N	\N	1	\N	\N	\N	6	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	\N	\N
1	1	\N	\N	\N	\N	9000	\N	\N	0	9000	9000	\N	\N	\N	\N	\N	\N	\N	0	1	\N	2020-07-15 19:07:28	\N	5	\N	12	\N	\N	\N	2	\N	2020-07-15	SO20070001	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N	\N	\N	0	\N	\N	\N	\N	2	\N	\N	\N	6	10000	1000	\N	\N	\N	\N	\N	\N	\N	0	0	\N	\N
4	1	\N	\N	\N	\N	90000	\N	\N	0	90000	90000	import sales	\N	\N	\N	\N	\N	\N	0	1	\N	2020-07-15 20:07:19	\N	5	\N	12	\N	\N	\N	2	\N	2020-07-15	SO20070002	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N	\N	\N	0	\N	\N	\N	\N	1	\N	\N	\N	6	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	\N	\N
5	1	\N	\N	\N	\N	90000	\N	\N	0	90000	90000	import sales	\N	\N	\N	\N	\N	\N	0	1	\N	2020-07-15 20:07:15	\N	5	\N	12	\N	\N	\N	2	\N	2020-07-15	SO20070003	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N	\N	\N	0	\N	\N	\N	\N	1	\N	\N	\N	6	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	\N	\N
\.


--
-- Data for Name: sales_calc_tax_tmp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_calc_tax_tmp (sales_id, ratetax, total_tax, tax_id) FROM stdin;
\.


--
-- Data for Name: sales_journal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_journal (sales_journal_id, idsales, idjournal, typejournal, userin, datein, coa_debit_id, coa_credit_id) FROM stdin;
\.


--
-- Data for Name: sales_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_payment (sales_payment_id, sales_id, journal_id, due_amount, paid_amount, balance_amount, date_trx, datein, userin, status, no_reference, idunit, discount_amount, notes) FROM stdin;
\.


--
-- Data for Name: sales_return; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_return (sales_return_id, sales_id, status, memo, date_return, total_qty_return, total_amount_return, datein, userin, datemod, usermod, deleted, no_return, journal_id, idunit, return_type) FROM stdin;
\.


--
-- Data for Name: sales_return_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_return_item (sales_return_item_id, sales_return_id, sales_item_id, qty_sale, qty_retur, notes, datemod) FROM stdin;
\.


--
-- Data for Name: salesitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salesitem (idsalesitem, idsales, qty, price, disc, total, measurement_id, ratetax, size, measurement_id_size, warehouse_id, qty_kirim, qty_return, deleted, userin, datein, usermod, datemod, product_id, description, total_tax, disc_rate, cost_price) FROM stdin;
1	1	1	9000	0	9000	\N	\N	\N	\N	\N	\N	\N	0	1	2020-07-15 19:25:28	\N	\N	10	\N	\N	\N	0
2	2	10	9000	0	90000	\N	\N	\N	\N	\N	\N	\N	0	1	2020-07-15 20:03:13	\N	\N	3	\N	\N	\N	0
3	3	10	9000	0	90000	\N	\N	\N	\N	\N	\N	\N	0	1	2020-07-15 20:09:23	\N	\N	4	\N	\N	\N	0
4	4	10	9000	0	90000	\N	\N	\N	\N	\N	\N	\N	0	1	2020-07-15 20:10:19	\N	\N	5	\N	\N	\N	0
5	5	10	9000	0	90000	\N	\N	\N	\N	\N	\N	\N	0	1	2020-07-15 20:13:15	\N	\N	6	\N	\N	\N	0
\.


--
-- Data for Name: sequence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sequence (idunit, sequence) FROM stdin;
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settings (price_per_unit) FROM stdin;
\.


--
-- Data for Name: sextype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sextype (idsex, name) FROM stdin;
\.


--
-- Data for Name: shu_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shu_config (shu_config_id, datein, userin, shu_config_name, deleted) FROM stdin;
\.


--
-- Data for Name: shu_generate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shu_generate (shu_generate_id, shu_config_id, status, userin, datein, approved_by, idunit, omzet_member, omzet_nonmember, total_revenue, total_expense, shu_notax, tax_pph, shu_aftertax, cadangan_percent, usaha_percent, modal_percent, pengurus_percent, karyawan_percent, pendidikan_percent, sosial_percent, lainnya_percent, idjournal, shu_period, cadangan_result, usaha_result, modal_result, pengurus_result, karyawan_result, pendidikan_result, sosial_result, lainnya_result, business_id, startdate, enddate, total_loan_revenue, total_other_revenue_cashbank, total_member_saving, total_other_income) FROM stdin;
\.


--
-- Data for Name: shu_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shu_member (shu_generate_id, id_member, simp_pokok, simp_wajib, total_modal_member, total_usaha_member, jasa_modal, jasa_usaha, total_shu, datein) FROM stdin;
\.


--
-- Data for Name: shu_share; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shu_share (shu_share_id, shu_config_id, shu_share_name, shu_share_desc, percentage, datein, userin, deleted, payable_coa_id, cashbank_coa_id, unit_id, shu_type) FROM stdin;
\.


--
-- Data for Name: shu_share_result; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shu_share_result (shu_share_result_id, shu_share_id, amount, shu_generate_id, percentage, datemod) FROM stdin;
\.


--
-- Data for Name: siklus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.siklus (idsiklus, namasiklus, deleted, status) FROM stdin;
\.


--
-- Data for Name: spendmoney; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spendmoney (idspendmoney, idtax, idjournal, idaccount, totalpaid, tax, balance, display, userin, usermod, datein, datemod, idunit, subtotal, notrans, datetrans, memo, month, year, spendfrom, idimport, depositaccount, total, status, business_id, receiver_id, receiver_type, tax_id) FROM stdin;
\.


--
-- Data for Name: spendmoneyitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spendmoneyitem (idspendmoneyitem, idspendmoney, idaccount, amount, memo, ratetax) FROM stdin;
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff (staff_id, group_id, user_id, staff_name, staff_address, staff_mobilephone, staff_email, staff_whatsapp, staff_photo, polytpe_id, status, account_number, account_name, bank_name, no_identity, staff_number, location_id, staff_type_id, deleted, fee_monthly, fee_per_patient) FROM stdin;
\.


--
-- Data for Name: staff_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_type (staff_type_id, staff_type_name, datein, userin, deleted, status, datemod, usermod) FROM stdin;
\.


--
-- Data for Name: stock_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_history (stock_history_id, product_id, type_adjustment, no_transaction, datein, notes, idjournal, current_qty, trx_qty, new_qty, reference_id, stock_opname_id) FROM stdin;
1	10	8	STCK20070001	2020-07-15 19:25:00	\N	\N	-8.00	1.00	-9.00	1	\N
2	3	8	STCK20070002	2020-07-15 20:03:00	\N	\N	20.00	10.00	10.00	2	\N
3	4	8	STCK20070003	2020-07-15 20:09:00	\N	\N	20.00	10.00	10.00	3	\N
4	5	8	STCK20070004	2020-07-15 20:10:00	\N	\N	20.00	10.00	10.00	4	\N
5	6	8	STCK20070005	2020-07-15 20:13:00	\N	\N	20.00	10.00	10.00	5	\N
6	10	10	STCK20070006	2020-07-15 20:13:00	\N	\N	-9.00	1.00	-8.00	1	\N
7	5	10	STCK20070007	2020-07-15 20:13:00	\N	\N	10.00	10.00	20.00	4	\N
8	6	10	STCK20070008	2020-07-15 20:14:00	\N	\N	10.00	10.00	20.00	5	\N
9	10	4	STCK20070009	2020-07-15 20:40:29	\N	\N	-8.00	18.00	10.00	\N	1
\.


--
-- Data for Name: stock_opname; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_opname (stock_opname_id, enddate, memo, status, approved_by, approved_date, userin, datein, usermod, datemod, record_date, idunit, startdate, deleted, opname_number, idjournal_stock_opname) FROM stdin;
1	\N	\N	2	1	2020-07-15 20:40:29	1	2020-07-15 20:07:29	1	2020-07-15 20:07:29	2020-07-15	12	\N	0	#SP20070001	\N
\.


--
-- Data for Name: stock_opname_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_opname_item (stock_opname_id, product_id, current_stock, adjustment_stock, variance, notes, datein, deleted) FROM stdin;
1	10	-8.00	10.00	18.00		2020-07-15 20:07:29	0
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription (subscription_id, subscription_name, min_member, max_member, price_per_unit) FROM stdin;
\.


--
-- Data for Name: subscription_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_unit (subscription_id, idunit, min_member, max_member, price_per_unit) FROM stdin;
\.


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier (idsupplier, idpayment, idshipping, code, namesupplier, companyaddress, companyaddress2, companyaddress3, companyaddress4, shipaddress, billaddress, telephone, handphone, fax, email, website, city, state, postcode, country, highestpo, avgdaypay, lastpayment, lastpurchase, expenseaccount, notes, userin, usermod, datein, datemod, idunit, status, deleted, supplier_type_id, display, idaccount_hppenjualan, idaccount_persediaan) FROM stdin;
\.


--
-- Data for Name: supplier_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier_type (supplier_type_id, idunit, supplier_type_name, supplier_type_desc, display, userin, datein, usermod, datemod, status, deleted) FROM stdin;
\.


--
-- Data for Name: sys_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_group (group_id, group_name, userin, usermod, datein, datemod, display, description, deleted, status, idunit, "default", member_group) FROM stdin;
1	Admin	\N	286	2019-04-24 11:04:26	2019-08-03 17:08:20	\N	Administrator	0	1	12	0	2
2	Inventory	\N	\N	2019-02-11 09:02:46	2019-02-11 09:02:46	\N	Inventory	0	1	12	0	2
4	Pemesan	\N	\N	2019-04-24 11:04:26	2019-04-24 11:04:26	\N	\N	0	1	12	0	2
3	Kasir	\N	\N	2019-02-11 09:02:46	2019-02-11 09:02:46	\N	Penjualan	0	1	12	0	2
5	Apotek	\N	\N	2019-04-24 11:04:26	2019-04-24 11:04:26	\N	\N	0	1	12	0	2
\.


--
-- Data for Name: sys_group_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_group_menu (sys_menu_id, group_id) FROM stdin;
1439	1
1438	1
1437	1
1443	1
6	1
44	1
10	1
12	1
25	1
7	1
22	1
23	1
24	1
\.


--
-- Data for Name: sys_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_menu (sys_menu_id, menu_name, menu_link, parent, sort, status, icon, display, description, userin, usermod, datein, datemod, first_load_store_id) FROM stdin;
145	Retur Penjualan	sales.SalesReturnGrid	139	5	\N		1		11	11	2017-03-09 09:03:13	2017-07-07 22:07:03	SalesReturnGrid
177	Permintaan Pembelian	purchase2.PurchaseRequisitionGrid	15	1	\N		1		11	11	2017-04-24 03:04:52	2017-07-07 22:07:50	PurchaseRequisitionGridID
136	Faktur Pembelian	purchase2.TabPurchaseInvoicePanel	15	4	\N		1		staff	11	2017-03-08 19:03:50	2017-07-07 22:07:05	PurchaseInvoiceUnpaidGrid
144	Faktur Penjualan	sales.TabSalesInvoicePanel	139	4	\N		1		11	11	2017-03-09 09:03:49	2017-07-07 22:07:33	SalesInvoiceUnpaidGrid
134	Surat Pesanan	purchase2.PurchaseOrderGrid	15	2	\N		1		staff	11	2017-03-08 19:03:26	2017-07-07 22:07:14	PurchaseOrderGridID
135	Penerimaan Barang	purchase2.TabGoodsReceipt	15	3	\N		1		staff	11	2017-03-08 19:03:39	2017-07-07 14:07:55	GoodsReceiptGridID
37	Neraca Saldo	reportNeracaSaldo	27	8	\N	\N	0	\N	\N	\N	\N	\N	\N
40	Buku Besar	reportGeneralLedger	27	7	\N		0		\N	11	\N	2017-07-07 11:07:14	\N
41	Jurnal Kas Keluar	reportKasKeluar	27	4	\N		0		\N	11	\N	2017-07-07 10:07:20	\N
43	Arus Kas	reportArusKas	27	9	\N		0		\N	11	\N	2017-07-07 10:07:33	\N
38	Neraca	reportNeraca	27	9	\N		0		\N	11	\N	2017-07-07 22:07:45	\N
53	Pengaturan	\N	0	14	\N	pengaturan	0	\N	\N	\N	\N	\N	\N
102	Menu Aplikasi	GridTreeSysMenu	53	6	\N	\N	0	Pengaturan menu aplikasi	\N	\N	\N	\N	\N
116	Jabatan	GridSysGroup	53	5	\N		0	Pengalolaan Kelomok User dan Modul Aksesnya	administrator	administrator	2015-05-03 12:05:00	2015-05-03 12:05:00	\N
11	Jurnal	money.PortJournal	57	5	\N	jurnal	1		\N	11	\N	2017-07-07 11:07:41	-
6	Daftar Inventory	TabInventory	2	6	\N	\N	\N	\N	\N	\N	\N	\N	-
1439	Pembelian	purchasing.TabPurchasingDataPanel	0	9	\N	beli	\N	Mengelola Pembelian Barang	\N	132	\N	2019-03-19 20:03:24	-
1	Pengaturan	pengaturan	0	10	\N	\N	\N	\N	\N	\N	\N	\N	-
12	Pengaturan	settings	0	11	\N	\N	\N	\N	\N	\N	\N	\N	\N
25	Pelaporan	report.AllReportingGrid	0	12	\N	laporan	\N	\N	\N	\N	\N	\N	-
7	Inventory		0	11	\N	inventory	\N	\N	\N	\N	\N	\N	
1437	Kartu Stock	inventory.GridStockCard	7	\N	\N	\N	\N	Mencatat Pergerakan Stock	\N	\N	\N	\N	-
1443	Stok Opname	inventory.GridStockOpname	7	2	\N	\N	\N	Memonitor stok 	\N	\N	\N	\N	GridStockOpname
1438	Daftar Produk	inventory.GridInventory	7	\N	\N	\N	\N	\N	\N	\N	\N	\N	-
22	Penerimaan Resep	pharmacy.Gridpharmacyreceipt	0	7	\N	laporan	\N	\N	\N	\N	\N	\N	GridpharmacyreceiptID
44	Penjualan	sales2.TabSalesDataPanel	0	9	\N	jual	\N	\N	\N	\N	\N	\N	-
23	Data Kontak	master.TabMasterCustomer	0	4	\N	contact-icon	\N	\N	\N	\N	\N	\N	GridCustomerID
10	User Group	GridSysGroup	12	8	\N	akun	1	Pengalolaan Kelomok User dan Modul Aksesnya	administrator	administrator	2015-05-03 12:05:00	2015-05-03 12:05:00	\N
24	Data Pegawai	employee.GridemployeeGrid	0	2	\N	karyawan	\N	\N	\N	\N	\N	\N	GridemployeeGrid
\.


--
-- Data for Name: sys_menu_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_menu_unit (sys_menu_id, idunit) FROM stdin;
\.


--
-- Data for Name: sys_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_user (user_id, username, password, email, laslogin, userin, usermod, datein, datemod, group_id, realname, idunitbak, iduserparent, display, clientid, idcompany, deleted, idunit, nik, phone, address, jobname, api_key, fcm_token, latitude, longitude) FROM stdin;
1	apotekwijayafarma001@gmail.com	apotekkita	apotekwijayafarma001@gmail.com	2020-08-13 20:08:17	\N	\N	2019-02-08 21:02:26	\N	1	\N	\N	\N	\N	\N	\N	0	12	\N	\N	\N	\N	YXBvdGVrd2lqYXlhZmFybWEwMDFAZ21haWwuY29tOmFwb3Rla2tpdGE=	\N	\N	\N
2	xxx	123	xxx	\N	2	\N	2020-08-13 20:08:36	\N	1	\N	12	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: tax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax (idtax, code, nametax, description, rate, userin, usermod, datein, datemod, display, status, deleted, idunit, coa_expense_id, coa_ap_id, coa_cash_id, coa_ppn_sales_id, coa_ppn_purchase_id, coa_ppn_rate, coa_pph23_sales_id, coa_pph23_purchase_id, coa_pph23_rate, is_tax_ppn, is_tax_pph23) FROM stdin;
\.


--
-- Data for Name: tax_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_unit (tax_unit_id, idunit, idtax, coa_collection_id, coa_paysource_id, rate, datein, userin, datemod, usermod, status, deleted) FROM stdin;
\.


--
-- Data for Name: taxhistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxhistory (idtax, taxval, rate, datein, idpurchase, idjournal, type) FROM stdin;
\.


--
-- Data for Name: taxlinkunit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxlinkunit (idtax, idunit, acccollectedtax, acctaxpaid) FROM stdin;
\.


--
-- Data for Name: taxtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxtype (idtaxtype, nametypetax, description, deleted, status) FROM stdin;
\.


--
-- Data for Name: transfer_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transfer_stock (transfer_stock_id, transfer_stock_no, transfer_stock_date, transfer_stock_notes, status, deleted, datein, userin, datemod, usermod, bussiness_origin_id, bussiness_destination_id, idunit) FROM stdin;
\.


--
-- Data for Name: transfer_stock_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transfer_stock_detail (transfer_stock_id, product_id, current_qty, transfer_qty, notes, location_origin_id, current_destination_id, datein) FROM stdin;
\.


--
-- Data for Name: transferkas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transferkas (idtransferkas, idaccountsumber, idaccounttujuan, idunit, memo, tanggal, nominal, userin, datein, usermod, datemod, idjournal) FROM stdin;
\.


--
-- Data for Name: unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unit (idunit, namaunit, deskripsi, alamat, display, userin, usermod, datein, datemod, alamat2, alamat3, telp, fax, email, website, country, npwp, curfinanceyear, lastmonthfinanceyear, conversionmonth, numaccperiod, curfinancemonth, startfinancemonth, startfinanceyear, idbussinestype, logo, idcompany, dateformat, is_taxable, status, deleted, idaccount_hppenjualan, idaccount_persediaan, year_establised, coop_num_member_id, nolisence, nusafin_api_key, api_key, next_payment_date, show_in_reg_form, default_tax_sales_id, default_tax_purchase_id, config_si_payment_note, config_si_footnote, config_sales_autoprint) FROM stdin;
12	Wijawa Farma	Wijawa Farma	Jln. A. Yani No 201	\N	\N	\N	\N	\N	\N	apotekwijayafarma001@gmail.com	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	apotek.logo	0	\N	\N	1	0	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	1
\.


--
-- Data for Name: unit_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unit_item (unit_item_id, unit_name, status, deleted) FROM stdin;
\.


--
-- Data for Name: upload; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.upload (idupload, orig_name, userin, datein, type) FROM stdin;
\.


--
-- Data for Name: userunit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userunit (user_id, idunit) FROM stdin;
2	12
\.


--
-- Data for Name: variant_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.variant_option (variant_id, variant_name, variant_desc, deleted, display, status, userin, datein, usermod, datemod) FROM stdin;
\.


--
-- Data for Name: withdrawal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.withdrawal (withdrawal_id, idunit, idjournal) FROM stdin;
\.


--
-- Data for Name: wizard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wizard (user_id, datein, realname, address, email, handphone, coop_name, coop_year, coop_nolicence, coop_address, coop_telp, coop_type_kons, coop_type_simpin, coop_type_jasa, coop_type_prod, coop_num_member_id, coop_type_lainnya) FROM stdin;
\.


--
-- Name: seq_account; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_account', 1284, false);


--
-- Name: seq_accountlog; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_accountlog', 146, false);


--
-- Name: seq_amounttype; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_amounttype', 19, false);


--
-- Name: seq_asuransi; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_asuransi', 29, false);


--
-- Name: seq_asuransiemp; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_asuransiemp', 31, false);


--
-- Name: seq_asuransipayhistory; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_asuransipayhistory', 83, false);


--
-- Name: seq_bom_detail; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_bom_detail', 20, false);


--
-- Name: seq_clossing; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_clossing', 2330, false);


--
-- Name: seq_customer; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_customer', 206, true);


--
-- Name: seq_dataanak; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_dataanak', 22, false);


--
-- Name: seq_datasutri; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_datasutri', 31, false);


--
-- Name: seq_disbursment; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_disbursment', 33, false);


--
-- Name: seq_employee; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_employee', 49, false);


--
-- Name: seq_employeetype; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_employeetype', 40, false);


--
-- Name: seq_goodsreceipt; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_goodsreceipt', 15, false);


--
-- Name: seq_goodsreceived; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_goodsreceived', 15, false);


--
-- Name: seq_group; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_group', 2, false);


--
-- Name: seq_inventory; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_inventory', 559, false);


--
-- Name: seq_inventoryadjitem; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_inventoryadjitem', 23, false);


--
-- Name: seq_inventoryadjusment; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_inventoryadjusment', 63, false);


--
-- Name: seq_invoice; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_invoice', 17, false);


--
-- Name: seq_invoice_bank; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_invoice_bank', 13, false);


--
-- Name: seq_journal; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_journal', 4497, false);


--
-- Name: seq_journalitem; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_journalitem', 11301, false);


--
-- Name: seq_linkpiutang; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_linkpiutang', 21, false);


--
-- Name: seq_loan_member; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_loan_member', 4, false);


--
-- Name: seq_loan_transaction; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_loan_transaction', 5, false);


--
-- Name: seq_loginlog; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_loginlog', 3437, false);


--
-- Name: seq_master; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_master', 99, true);


--
-- Name: seq_member_saving; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_member_saving', 138, false);


--
-- Name: seq_payroll; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_payroll', 70, false);


--
-- Name: seq_pelanggan; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_pelanggan', 24, false);


--
-- Name: seq_piutanghistory; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_piutanghistory', 220, false);


--
-- Name: seq_piutangpayhistory; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_piutangpayhistory', 2, false);


--
-- Name: seq_potongan; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_potongan', 40, false);


--
-- Name: seq_product; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_product', 23, false);


--
-- Name: seq_product_type; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_product_type', 2, false);


--
-- Name: seq_prosesgaji; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_prosesgaji', 33, false);


--
-- Name: seq_purchase; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_purchase', 42, false);


--
-- Name: seq_purchaseitem; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_purchaseitem', 101, false);


--
-- Name: seq_receivemoney; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_receivemoney', 79, false);


--
-- Name: seq_receivemoneyimport; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_receivemoneyimport', 31, false);


--
-- Name: seq_receivemoneyitem; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_receivemoneyitem', 91, false);


--
-- Name: seq_receivepayment; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_receivepayment', 2, false);


--
-- Name: seq_reconcile; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_reconcile', 30, false);


--
-- Name: seq_registrasihutang; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_registrasihutang', 47, false);


--
-- Name: seq_registrasipiutang; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_registrasipiutang', 229, false);


--
-- Name: seq_return; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_return', 32, false);


--
-- Name: seq_riwayatpembsiswa; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_riwayatpembsiswa', 22, false);


--
-- Name: seq_role; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_role', 5, false);


--
-- Name: seq_sales_invoice_do; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_sales_invoice_do', 3, false);


--
-- Name: seq_salesitem; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_salesitem', 2, false);


--
-- Name: seq_sallary; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_sallary', 23, false);


--
-- Name: seq_saving_history; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_saving_history', 81, false);


--
-- Name: seq_saving_interest; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_saving_interest', 2, false);


--
-- Name: seq_saving_type; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_saving_type', 23, false);


--
-- Name: seq_shu_generate; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_shu_generate', 21, false);


--
-- Name: seq_siswa; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_siswa', 563, false);


--
-- Name: seq_siswapembayaran; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_siswapembayaran', 58, false);


--
-- Name: seq_spendmoney; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_spendmoney', 672, false);


--
-- Name: seq_spendmoneyitem; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_spendmoneyitem', 722, false);


--
-- Name: seq_supplier; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_supplier', 72, false);


--
-- Name: seq_sys_menu; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_sys_menu', 188, false);


--
-- Name: seq_tambahangaji; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_tambahangaji', 26, false);


--
-- Name: seq_tambahangajitype; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_tambahangajitype', 25, false);


--
-- Name: seq_tax; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_tax', 37, false);


--
-- Name: seq_thr; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_thr', 24, false);


--
-- Name: seq_transferkas; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_transferkas', 63, false);


--
-- Name: seq_tunjangan; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_tunjangan', 54, false);


--
-- Name: seq_unit; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_unit', 53, false);


--
-- Name: seq_upload; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_upload', 34, false);


--
-- Name: seq_user_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_user_id', 119, false);


--
-- Name: stock_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_history_id_seq', 1, false);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (idaccount, idunit);


--
-- Name: accountpos accountpos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accountpos
    ADD CONSTRAINT accountpos_pkey PRIMARY KEY (idpos);


--
-- Name: accountsubtype accountsubtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accountsubtype
    ADD CONSTRAINT accountsubtype_pkey PRIMARY KEY (idaccountsubtype);


--
-- Name: accounttype accounttype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounttype
    ADD CONSTRAINT accounttype_pkey PRIMARY KEY (idaccounttype);


--
-- Name: amounttype amounttype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amounttype
    ADD CONSTRAINT amounttype_pkey PRIMARY KEY (idamounttype);


--
-- Name: app_config app_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_config
    ADD CONSTRAINT app_config_pkey PRIMARY KEY (unit_id);


--
-- Name: approval_history approval_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_history
    ADD CONSTRAINT approval_history_pkey PRIMARY KEY (approval_logid);


--
-- Name: asset_depreciation asset_depreciation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_depreciation
    ADD CONSTRAINT asset_depreciation_pkey PRIMARY KEY (asset_depreciation_id);


--
-- Name: asset_journal asset_journal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_journal
    ADD CONSTRAINT asset_journal_pkey PRIMARY KEY (asset_id, journal_id);


--
-- Name: asset asset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT asset_pkey PRIMARY KEY (asset_id);


--
-- Name: balance_history balance_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balance_history
    ADD CONSTRAINT balance_history_pkey PRIMARY KEY (balance_history_id);


--
-- Name: balance balance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balance
    ADD CONSTRAINT balance_pkey PRIMARY KEY (balance_id);


--
-- Name: bank bank_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (bank_id);


--
-- Name: billing billing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing
    ADD CONSTRAINT billing_pkey PRIMARY KEY (billing_id);


--
-- Name: brand brand_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand
    ADD CONSTRAINT brand_pkey PRIMARY KEY (brand_id);


--
-- Name: business_deposit_history business_deposit_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_deposit_history
    ADD CONSTRAINT business_deposit_history_pkey PRIMARY KEY (business_deposit_his_id);


--
-- Name: business_investor business_investor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_investor
    ADD CONSTRAINT business_investor_pkey PRIMARY KEY (business_investor_id);


--
-- Name: business business_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT business_pkey PRIMARY KEY (business_id);


--
-- Name: bussinestype bussinestype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bussinestype
    ADD CONSTRAINT bussinestype_pkey PRIMARY KEY (idbussinestype);


--
-- Name: classificationcf classificationcf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classificationcf
    ADD CONSTRAINT classificationcf_pkey PRIMARY KEY (idclassificationcf);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (clientid);


--
-- Name: closebook closebook_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.closebook
    ADD CONSTRAINT closebook_pkey PRIMARY KEY (idclossing);


--
-- Name: clossing clossing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clossing
    ADD CONSTRAINT clossing_pkey PRIMARY KEY (idclossing);


--
-- Name: collateral_attribute collateral_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collateral_attribute
    ADD CONSTRAINT collateral_attribute_pkey PRIMARY KEY (collateral_attribute_id);


--
-- Name: company company_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (idcompany);


--
-- Name: credit_balance_history credit_balance_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_balance_history
    ADD CONSTRAINT credit_balance_history_pkey PRIMARY KEY (credit_balance_id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (idcurrency);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (idcustomer);


--
-- Name: customertype customertype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customertype
    ADD CONSTRAINT customertype_pkey PRIMARY KEY (idcustomertype);


--
-- Name: day_name day_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.day_name
    ADD CONSTRAINT day_name_pkey PRIMARY KEY (day_id);


--
-- Name: debt_payment debt_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.debt_payment
    ADD CONSTRAINT debt_payment_pkey PRIMARY KEY (debt_payment_id);


--
-- Name: deposit deposit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT deposit_pkey PRIMARY KEY (deposit_id, idunit);


--
-- Name: disbursment disbursment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disbursment
    ADD CONSTRAINT disbursment_pkey PRIMARY KEY (iddisbursment);


--
-- Name: disease disease_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disease
    ADD CONSTRAINT disease_pkey PRIMARY KEY (disease_id);


--
-- Name: doctor_schedule doctor_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_schedule
    ADD CONSTRAINT doctor_schedule_pkey PRIMARY KEY (schedule_id);


--
-- Name: forgot_pass forgot_pass_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forgot_pass
    ADD CONSTRAINT forgot_pass_pkey PRIMARY KEY (forgot_id);


--
-- Name: frequency frequency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frequency
    ADD CONSTRAINT frequency_pkey PRIMARY KEY (idfrequency);


--
-- Name: hakakses hakakses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hakakses
    ADD CONSTRAINT hakakses_pkey PRIMARY KEY (sys_menu_id, group_id);


--
-- Name: inventory_adjust_items inventory_adjust_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjust_items
    ADD CONSTRAINT inventory_adjust_items_pkey PRIMARY KEY (inventory_adjust_item_id);


--
-- Name: inventory_adjust inventory_adjust_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_adjust
    ADD CONSTRAINT inventory_adjust_pkey PRIMARY KEY (inventory_adjust_id);


--
-- Name: inventory_count_items inventory_count_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_count_items
    ADD CONSTRAINT inventory_count_items_pkey PRIMARY KEY (inventory_count_item_id);


--
-- Name: inventory_count inventory_count_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_count
    ADD CONSTRAINT inventory_count_pkey PRIMARY KEY (inventory_count_id);


--
-- Name: inventory_supplier inventory_supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_supplier
    ADD CONSTRAINT inventory_supplier_pkey PRIMARY KEY (idinventory, idsupplier);


--
-- Name: inventory_transfer_item inventory_transfer_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transfer_item
    ADD CONSTRAINT inventory_transfer_item_pkey PRIMARY KEY (inventory_transfer_item_id);


--
-- Name: inventory_transfer inventory_transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_transfer
    ADD CONSTRAINT inventory_transfer_pkey PRIMARY KEY (transfer_stock_id);


--
-- Name: inventorycat inventorycat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventorycat
    ADD CONSTRAINT inventorycat_pkey PRIMARY KEY (idinventorycat);


--
-- Name: invoice_bank invoice_bank_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_bank
    ADD CONSTRAINT invoice_bank_pkey PRIMARY KEY (id_invoice_bank);


--
-- Name: invoice invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id_invoice);


--
-- Name: cashbank_approver journal_approver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cashbank_approver
    ADD CONSTRAINT journal_approver_pkey PRIMARY KEY (user_approver_userid, type);


--
-- Name: cashbank_approval_config journal_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cashbank_approval_config
    ADD CONSTRAINT journal_config_pkey PRIMARY KEY (unit_id);


--
-- Name: journal journal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journal
    ADD CONSTRAINT journal_pkey PRIMARY KEY (idjournal);


--
-- Name: journalitem journalitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journalitem
    ADD CONSTRAINT journalitem_pkey PRIMARY KEY (idjournalitem);


--
-- Name: journaltype journaltype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.journaltype
    ADD CONSTRAINT journaltype_pkey PRIMARY KEY (idjournaltype);


--
-- Name: linkedacc linkedacc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linkedacc
    ADD CONSTRAINT linkedacc_pkey PRIMARY KEY (idlinked);


--
-- Name: linkedaccunit linkedaccunit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linkedaccunit
    ADD CONSTRAINT linkedaccunit_pkey PRIMARY KEY (idlinked, idunit);


--
-- Name: linkpiutang linkpiutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linkpiutang
    ADD CONSTRAINT linkpiutang_pkey PRIMARY KEY (idlinkpiutang);


--
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (location_id);


--
-- Name: master_city master_city_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_city
    ADD CONSTRAINT master_city_pkey PRIMARY KEY (city_id);


--
-- Name: medical_action medical_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_action
    ADD CONSTRAINT medical_action_pkey PRIMARY KEY (medical_action_id);


--
-- Name: medical_record_action medical_record_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record_action
    ADD CONSTRAINT medical_record_action_pkey PRIMARY KEY (medical_action_id, medical_record_id);


--
-- Name: medical_record_disease medical_record_disease_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record_disease
    ADD CONSTRAINT medical_record_disease_pkey PRIMARY KEY (medical_record_id, disease_id);


--
-- Name: medical_record_drug medical_record_drug_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record_drug
    ADD CONSTRAINT medical_record_drug_pkey PRIMARY KEY (medical_record_id, product_id);


--
-- Name: medical_record medical_record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record
    ADD CONSTRAINT medical_record_pkey PRIMARY KEY (medical_record_id);


--
-- Name: patient_family member_family_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_family
    ADD CONSTRAINT member_family_pkey PRIMARY KEY (patient_family_id);


--
-- Name: nusafin_key nusafin_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nusafin_key
    ADD CONSTRAINT nusafin_key_pkey PRIMARY KEY (unit_id);


--
-- Name: package package_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package
    ADD CONSTRAINT package_pkey PRIMARY KEY (packageid);


--
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (patient_id);


--
-- Name: payment_log_xd payment_log_xd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_log_xd
    ADD CONSTRAINT payment_log_xd_pkey PRIMARY KEY (payment_log_id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (idpayment);


--
-- Name: payment_term payment_term_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_term
    ADD CONSTRAINT payment_term_pkey PRIMARY KEY (id_payment_term);


--
-- Name: payroll_asuransi payroll_asuransi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll_asuransi
    ADD CONSTRAINT payroll_asuransi_pkey PRIMARY KEY (idasuransi);


--
-- Name: payroll_jenisptkp payroll_jenisptkp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll_jenisptkp
    ADD CONSTRAINT payroll_jenisptkp_pkey PRIMARY KEY (idjenisptkp);


--
-- Name: payroll_potongantype payroll_potongantype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll_potongantype
    ADD CONSTRAINT payroll_potongantype_pkey PRIMARY KEY (idpotongantype);


--
-- Name: payroll_tambahangajitype payroll_tambahangajitype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll_tambahangajitype
    ADD CONSTRAINT payroll_tambahangajitype_pkey PRIMARY KEY (idtambahangajitype);


--
-- Name: payroll_tunjangantype payroll_tunjangantype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll_tunjangantype
    ADD CONSTRAINT payroll_tunjangantype_pkey PRIMARY KEY (idtunjtype);


--
-- Name: piutanghistory piutanghistory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.piutanghistory
    ADD CONSTRAINT piutanghistory_pkey PRIMARY KEY (idpiutanghistory);


--
-- Name: piutangpayhistory piutangpayhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.piutangpayhistory
    ADD CONSTRAINT piutangpayhistory_pkey PRIMARY KEY (piutangpayhistory_id);


--
-- Name: poly_type poly_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poly_type
    ADD CONSTRAINT poly_type_pkey PRIMARY KEY (polytpe_id);


--
-- Name: pos_payment_type pos_payment_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_payment_type
    ADD CONSTRAINT pos_payment_type_pkey PRIMARY KEY (pos_payment_type_id);


--
-- Name: pos_preferences pos_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_preferences
    ADD CONSTRAINT pos_preferences_pkey PRIMARY KEY (unit_id, user_id);


--
-- Name: product_image product_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_image
    ADD CONSTRAINT product_image_pkey PRIMARY KEY (product_image_id);


--
-- Name: product_location product_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_location
    ADD CONSTRAINT product_location_pkey PRIMARY KEY (product_location_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (product_type_id);


--
-- Name: product_unit product_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_unit
    ADD CONSTRAINT product_unit_pkey PRIMARY KEY (product_unit_id);


--
-- Name: purchase_item purchase_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_item
    ADD CONSTRAINT purchase_item_pkey PRIMARY KEY (purchase_item_id);


--
-- Name: purchase purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (purchase_id);


--
-- Name: purchase_receipt_item purchase_receipt_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_receipt_item
    ADD CONSTRAINT purchase_receipt_item_pkey PRIMARY KEY (purchase_receipt_item_id);


--
-- Name: purchase_receipt purchase_receipt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_receipt
    ADD CONSTRAINT purchase_receipt_pkey PRIMARY KEY (purchase_receipt_id);


--
-- Name: purchase_return_item purchase_return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_return_item
    ADD CONSTRAINT purchase_return_item_pkey PRIMARY KEY (purchase_return_item_id);


--
-- Name: purchase_return purchase_return_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_return
    ADD CONSTRAINT purchase_return_pkey PRIMARY KEY (purchase_return_id);


--
-- Name: receivemoney receivemoney_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receivemoney
    ADD CONSTRAINT receivemoney_pkey PRIMARY KEY (idreceivemoney);


--
-- Name: receivemoneyimport receivemoneyimport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receivemoneyimport
    ADD CONSTRAINT receivemoneyimport_pkey PRIMARY KEY (idreceivemoneyimport);


--
-- Name: receivemoneyitem receivemoneyitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receivemoneyitem
    ADD CONSTRAINT receivemoneyitem_pkey PRIMARY KEY (idreceivemoneyitem);


--
-- Name: receivepayment receivepayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receivepayment
    ADD CONSTRAINT receivepayment_pkey PRIMARY KEY (idreceivepayment);


--
-- Name: reconcile reconcile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reconcile
    ADD CONSTRAINT reconcile_pkey PRIMARY KEY (idreconcile);


--
-- Name: registrasihutang registrasihutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasihutang
    ADD CONSTRAINT registrasihutang_pkey PRIMARY KEY (idregistrasihutang);


--
-- Name: registrasipiutang registrasipiutang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasipiutang
    ADD CONSTRAINT registrasipiutang_pkey PRIMARY KEY (idregistrasipiutang);


--
-- Name: role_menu role_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_menu
    ADD CONSTRAINT role_menu_pkey PRIMARY KEY (group_id, roleid);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (roleid);


--
-- Name: sales_journal sales_journal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_journal
    ADD CONSTRAINT sales_journal_pkey PRIMARY KEY (sales_journal_id);


--
-- Name: sales_payment sales_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_payment
    ADD CONSTRAINT sales_payment_pkey PRIMARY KEY (sales_payment_id);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (idsales);


--
-- Name: sales_return_item sales_return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_return_item
    ADD CONSTRAINT sales_return_item_pkey PRIMARY KEY (sales_return_item_id);


--
-- Name: sales_return sales_return_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_return
    ADD CONSTRAINT sales_return_pkey PRIMARY KEY (sales_return_id);


--
-- Name: salesitem salesitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salesitem
    ADD CONSTRAINT salesitem_pkey PRIMARY KEY (idsalesitem);


--
-- Name: shu_config shu_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shu_config
    ADD CONSTRAINT shu_config_pkey PRIMARY KEY (shu_config_id);


--
-- Name: shu_generate shu_generate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shu_generate
    ADD CONSTRAINT shu_generate_pkey PRIMARY KEY (shu_generate_id);


--
-- Name: shu_member shu_member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shu_member
    ADD CONSTRAINT shu_member_pkey PRIMARY KEY (shu_generate_id, id_member);


--
-- Name: shu_share shu_share_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shu_share
    ADD CONSTRAINT shu_share_pkey PRIMARY KEY (shu_share_id);


--
-- Name: shu_share_result shu_share_result_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shu_share_result
    ADD CONSTRAINT shu_share_result_pkey PRIMARY KEY (shu_share_result_id);


--
-- Name: siklus siklus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siklus
    ADD CONSTRAINT siklus_pkey PRIMARY KEY (idsiklus);


--
-- Name: spendmoney spendmoney_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spendmoney
    ADD CONSTRAINT spendmoney_pkey PRIMARY KEY (idspendmoney);


--
-- Name: spendmoneyitem spendmoneyitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spendmoneyitem
    ADD CONSTRAINT spendmoneyitem_pkey PRIMARY KEY (idspendmoneyitem);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);


--
-- Name: staff_type staff_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_type
    ADD CONSTRAINT staff_type_pkey PRIMARY KEY (staff_type_id);


--
-- Name: stock_history stock_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_history
    ADD CONSTRAINT stock_history_pkey PRIMARY KEY (stock_history_id);


--
-- Name: stock_opname_item stock_opname_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_opname_item
    ADD CONSTRAINT stock_opname_item_pkey PRIMARY KEY (stock_opname_id, product_id);


--
-- Name: stock_opname stock_opname_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_opname
    ADD CONSTRAINT stock_opname_pkey PRIMARY KEY (stock_opname_id);


--
-- Name: subscription subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (subscription_id);


--
-- Name: subscription_unit subscription_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_unit
    ADD CONSTRAINT subscription_unit_pkey PRIMARY KEY (subscription_id, idunit);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (idsupplier);


--
-- Name: supplier_type supplier_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_type
    ADD CONSTRAINT supplier_type_pkey PRIMARY KEY (supplier_type_id);


--
-- Name: sys_group_menu sys_group_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_group_menu
    ADD CONSTRAINT sys_group_menu_pkey PRIMARY KEY (sys_menu_id, group_id);


--
-- Name: sys_group sys_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_group
    ADD CONSTRAINT sys_group_pkey PRIMARY KEY (group_id);


--
-- Name: sys_menu sys_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_menu
    ADD CONSTRAINT sys_menu_pkey PRIMARY KEY (sys_menu_id);


--
-- Name: sys_user sys_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT sys_user_pkey PRIMARY KEY (user_id);


--
-- Name: tax tax_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax
    ADD CONSTRAINT tax_pkey PRIMARY KEY (idtax);


--
-- Name: tax_unit tax_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_unit
    ADD CONSTRAINT tax_unit_pkey PRIMARY KEY (tax_unit_id);


--
-- Name: taxtype taxtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxtype
    ADD CONSTRAINT taxtype_pkey PRIMARY KEY (idtaxtype);


--
-- Name: transfer_stock_detail transfer_stock_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_stock_detail
    ADD CONSTRAINT transfer_stock_detail_pkey PRIMARY KEY (transfer_stock_id, product_id);


--
-- Name: transfer_stock transfer_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_stock
    ADD CONSTRAINT transfer_stock_pkey PRIMARY KEY (transfer_stock_id);


--
-- Name: transferkas transferkas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transferkas
    ADD CONSTRAINT transferkas_pkey PRIMARY KEY (idtransferkas);


--
-- Name: unit_item unit_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_item
    ADD CONSTRAINT unit_item_pkey PRIMARY KEY (unit_item_id);


--
-- Name: unit unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (idunit);


--
-- Name: upload upload_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload
    ADD CONSTRAINT upload_pkey PRIMARY KEY (idupload);


--
-- Name: userunit userunit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userunit
    ADD CONSTRAINT userunit_pkey PRIMARY KEY (user_id, idunit);


--
-- Name: variant_option variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variant_option
    ADD CONSTRAINT variant_option_pkey PRIMARY KEY (variant_id);


--
-- Name: withdrawal withdrawal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_pkey PRIMARY KEY (withdrawal_id, idunit);


--
-- Name: wizard wizard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wizard
    ADD CONSTRAINT wizard_pkey PRIMARY KEY (user_id);


--
-- Name: day_name_day_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX day_name_day_id_key ON public.day_name USING btree (day_id);


--
-- Name: location_location_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX location_location_id_key ON public.location USING btree (location_id);


--
-- Name: patient_family_pkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX patient_family_pkey ON public.patient_family USING btree (patient_family_id);


--
-- Name: patient_patient_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX patient_patient_id_key ON public.patient USING btree (patient_id);


--
-- Name: poly_type_polytpe_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX poly_type_polytpe_id_key ON public.poly_type USING btree (polytpe_id);


--
-- Name: roles_roleid_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX roles_roleid_key ON public.roles USING btree (roleid);


--
-- Name: staff_staff_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX staff_staff_id_key ON public.staff USING btree (staff_id);


--
-- Name: staff_type_staff_type_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX staff_type_staff_type_id_key ON public.staff_type USING btree (staff_type_id);


--
-- Name: sys_group_group_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sys_group_group_id_key ON public.sys_group USING btree (group_id);


--
-- Name: sys_user_user_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sys_user_user_id_key ON public.sys_user USING btree (user_id);


--
-- Name: account account_idaccounttype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_idaccounttype_fkey FOREIGN KEY (idaccounttype) REFERENCES public.accounttype(idaccounttype);


--
-- Name: account account_idpos_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_idpos_fkey FOREIGN KEY (idpos) REFERENCES public.accountpos(idpos);


--
-- Name: business business_idunit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT business_idunit_fkey FOREIGN KEY (idunit) REFERENCES public.unit(idunit);


--
-- Name: patient business_patient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT business_patient_fkey FOREIGN KEY (business_id) REFERENCES public.business(business_id);


--
-- Name: customer customer_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.master_city(city_id);


--
-- Name: debt_payment debt_payment_idregistrasihutang_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.debt_payment
    ADD CONSTRAINT debt_payment_idregistrasihutang_fkey FOREIGN KEY (idregistrasihutang) REFERENCES public.registrasihutang(idregistrasihutang);


--
-- Name: medical_record doctor_fk_medicrec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record
    ADD CONSTRAINT doctor_fk_medicrec FOREIGN KEY (doctor_id) REFERENCES public.staff(staff_id);


--
-- Name: doctor_schedule doctor_schedule_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_schedule
    ADD CONSTRAINT doctor_schedule_day_id_fkey FOREIGN KEY (day_id) REFERENCES public.day_name(day_id);


--
-- Name: doctor_schedule doctor_schedule_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_schedule
    ADD CONSTRAINT doctor_schedule_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.staff(staff_id);


--
-- Name: asset_depreciation fk_asset_depreciation_asset_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_depreciation
    ADD CONSTRAINT fk_asset_depreciation_asset_1 FOREIGN KEY (asset_id) REFERENCES public.asset(asset_id);


--
-- Name: asset_journal fk_asset_journal_asset_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_journal
    ADD CONSTRAINT fk_asset_journal_asset_1 FOREIGN KEY (asset_id) REFERENCES public.asset(asset_id);


--
-- Name: balance_history fk_balance_history_balance_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balance_history
    ADD CONSTRAINT fk_balance_history_balance_1 FOREIGN KEY (balance_id) REFERENCES public.balance(balance_id);


--
-- Name: balance_history fk_balance_history_billing_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balance_history
    ADD CONSTRAINT fk_balance_history_billing_1 FOREIGN KEY (billing_id) REFERENCES public.billing(billing_id);


--
-- Name: business_deposit_history fk_business_deposit_history_business_investor_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_deposit_history
    ADD CONSTRAINT fk_business_deposit_history_business_investor_1 FOREIGN KEY (business_investor_id) REFERENCES public.business_investor(business_investor_id);


--
-- Name: business_investor fk_business_investor_business_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_investor
    ADD CONSTRAINT fk_business_investor_business_1 FOREIGN KEY (business_id) REFERENCES public.business(business_id);


--
-- Name: deposit fk_deposit_journal_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT fk_deposit_journal_1 FOREIGN KEY (idjournal) REFERENCES public.journal(idjournal);


--
-- Name: patient_family member_family_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_family
    ADD CONSTRAINT member_family_member_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patient(patient_id);


--
-- Name: medical_record nurse_fk_medicrec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record
    ADD CONSTRAINT nurse_fk_medicrec FOREIGN KEY (nurse_id) REFERENCES public.staff(staff_id);


--
-- Name: medical_record patient_fk_medicrec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_record
    ADD CONSTRAINT patient_fk_medicrec FOREIGN KEY (patient_id) REFERENCES public.patient(patient_id);


--
-- Name: poly_type poly_type_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poly_type
    ADD CONSTRAINT poly_type_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(location_id);


--
-- Name: staff staff_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.sys_group(group_id);


--
-- Name: staff staff_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(location_id);


--
-- Name: staff staff_polytpe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_polytpe_id_fkey FOREIGN KEY (polytpe_id) REFERENCES public.poly_type(polytpe_id);


--
-- Name: staff staff_staff_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_staff_type_id_fkey FOREIGN KEY (staff_type_id) REFERENCES public.staff_type(staff_type_id);


--
-- Name: staff staff_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.sys_user(user_id);


--
-- PostgreSQL database dump complete
--

