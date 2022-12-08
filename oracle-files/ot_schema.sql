--------------------------------------------------------------------------------------
-- Name	       : OT (Oracle Tutorial) Sample Database
-- Link	       : http://www.oracletutorial.com/oracle-sample-database/
-- Version     : 1.0
-- Last Updated: July-28-2017
-- Copyright   : Copyright � 2017 by www.oracletutorial.com. All Rights Reserved.
-- Notice      : Use this sample database for the educational purpose only.
--               Credit the site oracletutorial.com explitly in your materials that
--               use this sample database.
--------------------------------------------------------------------------------------


---------------------------------------------------------------------------
-- execute the following statements to create tables
---------------------------------------------------------------------------
-- regions
CREATE TABLE c##streamsets.regions
  (
    region_id NUMBER GENERATED BY DEFAULT AS IDENTITY
    START WITH 5 PRIMARY KEY,
    region_name VARCHAR2( 50 ) NOT NULL
  );
-- countries table
CREATE TABLE c##streamsets.countries
  (
    country_id   CHAR( 2 ) PRIMARY KEY  ,
    country_name VARCHAR2( 40 ) NOT NULL,
    region_id    NUMBER                 , -- fk
    CONSTRAINT fk_countries_regions FOREIGN KEY( region_id )
      REFERENCES c##streamsets.regions( region_id ) 
      ON DELETE CASCADE
  );

-- location
CREATE TABLE c##streamsets.locations
  (
    location_id NUMBER GENERATED BY DEFAULT AS IDENTITY START WITH 24 
                PRIMARY KEY       ,
    address     VARCHAR2( 255 ) NOT NULL,
    postal_code VARCHAR2( 20 )          ,
    city        VARCHAR2( 50 )          ,
    state       VARCHAR2( 50 )          ,
    country_id  CHAR( 2 )               , -- fk
    CONSTRAINT fk_locations_countries 
      FOREIGN KEY( country_id )
      REFERENCES c##streamsets.countries( country_id ) 
      ON DELETE CASCADE
  );
-- warehouses
CREATE TABLE c##streamsets.warehouses
  (
    warehouse_id NUMBER 
                 GENERATED BY DEFAULT AS IDENTITY START WITH 10 
                 PRIMARY KEY,
    warehouse_name VARCHAR( 255 ) ,
    location_id    NUMBER( 12, 0 ), -- fk
    CONSTRAINT fk_warehouses_locations 
      FOREIGN KEY( location_id )
      REFERENCES c##streamsets.locations( location_id ) 
      ON DELETE CASCADE
  );
-- employees
CREATE TABLE c##streamsets.employees
  (
    employee_id NUMBER 
                GENERATED BY DEFAULT AS IDENTITY START WITH 108 
                PRIMARY KEY,
    first_name VARCHAR( 255 ) NOT NULL,
    last_name  VARCHAR( 255 ) NOT NULL,
    email      VARCHAR( 255 ) NOT NULL,
    phone      VARCHAR( 50 ) NOT NULL ,
    hire_date  DATE NOT NULL          ,
    manager_id NUMBER( 12, 0 )        , -- fk
    job_title  VARCHAR( 255 ) NOT NULL,
    CONSTRAINT fk_employees_manager 
        FOREIGN KEY( manager_id )
        REFERENCES c##streamsets.employees( employee_id )
        ON DELETE CASCADE
  );
-- product category
CREATE TABLE c##streamsets.product_categories
  (
    category_id NUMBER 
                GENERATED BY DEFAULT AS IDENTITY START WITH 6 
                PRIMARY KEY,
    category_name VARCHAR2( 255 ) NOT NULL
  );

-- products table
CREATE TABLE c##streamsets.products
  (
    product_id NUMBER 
               GENERATED BY DEFAULT AS IDENTITY START WITH 289 
               PRIMARY KEY,
    product_name  VARCHAR2( 255 ) NOT NULL,
    description   VARCHAR2( 2000 )        ,
    standard_cost NUMBER( 9, 2 )          ,
    list_price    NUMBER( 9, 2 )          ,
    category_id   NUMBER NOT NULL         ,
    CONSTRAINT fk_products_categories 
      FOREIGN KEY( category_id )
      REFERENCES c##streamsets.product_categories( category_id ) 
      ON DELETE CASCADE
  );
-- customers
CREATE TABLE c##streamsets.customers
  (
    customer_id NUMBER 
                GENERATED BY DEFAULT AS IDENTITY START WITH 320 
                PRIMARY KEY,
    name         VARCHAR2( 255 ) NOT NULL,
    address      VARCHAR2( 255 )         ,
    website      VARCHAR2( 255 )         ,
    credit_limit NUMBER( 8, 2 )
  );
-- contacts
CREATE TABLE c##streamsets.contacts
  (
    contact_id NUMBER 
               GENERATED BY DEFAULT AS IDENTITY START WITH 320 
               PRIMARY KEY,
    first_name  VARCHAR2( 255 ) NOT NULL,
    last_name   VARCHAR2( 255 ) NOT NULL,
    email       VARCHAR2( 255 ) NOT NULL,
    phone       VARCHAR2( 20 )          ,
    customer_id NUMBER                  ,
    CONSTRAINT fk_contacts_customers 
      FOREIGN KEY( customer_id )
      REFERENCES c##streamsets.customers( customer_id ) 
      ON DELETE CASCADE
  );
-- orders table
CREATE TABLE c##streamsets.orders
  (
    order_id NUMBER 
             GENERATED BY DEFAULT AS IDENTITY START WITH 106 
             PRIMARY KEY,
    customer_id NUMBER( 6, 0 ) NOT NULL, -- fk
    status      VARCHAR( 20 ) NOT NULL ,
    salesman_id NUMBER( 6, 0 )         , -- fk
    order_date  DATE NOT NULL          ,
    CONSTRAINT fk_orders_customers 
      FOREIGN KEY( customer_id )
      REFERENCES c##streamsets.customers( customer_id )
      ON DELETE CASCADE,
    CONSTRAINT fk_orders_employees 
      FOREIGN KEY( salesman_id )
      REFERENCES c##streamsets.employees( employee_id ) 
      ON DELETE SET NULL
  );
-- order items
CREATE TABLE c##streamsets.order_items
  (
    order_id   NUMBER( 12, 0 )                                , -- fk
    item_id    NUMBER( 12, 0 )                                ,
    product_id NUMBER( 12, 0 ) NOT NULL                       , -- fk
    quantity   NUMBER( 8, 2 ) NOT NULL                        ,
    unit_price NUMBER( 8, 2 ) NOT NULL                        ,
    CONSTRAINT pk_order_items 
      PRIMARY KEY( order_id, item_id ),
    CONSTRAINT fk_order_items_products 
      FOREIGN KEY( product_id )
      REFERENCES c##streamsets.products( product_id ) 
      ON DELETE CASCADE,
    CONSTRAINT fk_order_items_orders 
      FOREIGN KEY( order_id )
      REFERENCES c##streamsets.orders( order_id ) 
      ON DELETE CASCADE
  );
-- inventories
CREATE TABLE c##streamsets.inventories
  (
    product_id   NUMBER( 12, 0 )        , -- fk
    warehouse_id NUMBER( 12, 0 )        , -- fk
    quantity     NUMBER( 8, 0 ) NOT NULL,
    CONSTRAINT pk_inventories 
      PRIMARY KEY( product_id, warehouse_id ),
    CONSTRAINT fk_inventories_products 
      FOREIGN KEY( product_id )
      REFERENCES c##streamsets.products( product_id ) 
      ON DELETE CASCADE,
    CONSTRAINT fk_inventories_warehouses 
      FOREIGN KEY( warehouse_id )
      REFERENCES c##streamsets.warehouses( warehouse_id ) 
      ON DELETE CASCADE
  );