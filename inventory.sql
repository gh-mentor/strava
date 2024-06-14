/*
This file contains a script of Transact SQL (T-SQL) command to interact with a database 'inventory'.
Requirements:
- SQL Server 2022 is installed and running
- database 'inventory' already exists.
Details:
- Sets the default database to 'inventory'.
- Creates a 'categories' table and related 'products' table if they do not already exist.
- Remove all rows from the tables.
- Populates the 'categories' table with sample data.
- Populates the 'products' table with sample data.
- Creates stored procedures to get all categories.
- Creates a stored procedure to get all products in a specific category.
- Creates a stored procudure to get all products in a specific price range sorted by price in ascending order.
Errors:
- if the database 'Inventory' does not exist, the script will print an error message and exit.
*/

-- Check if the database 'inventory' exists, if not, print an error message and exit.
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'inventory')
BEGIN
    PRINT 'The database Inventory does not exist. Please create the database and run this script again.';
    RETURN;
END
GO

-- Set the default database to 'inventory'.
USE inventory;

-- Create the 'categories' table if it does not already exist.
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'categories')
BEGIN
    CREATE TABLE categories (
        category_id INT PRIMARY KEY,
        category_name NVARCHAR(50) NOT NULL
    );
END

-- Create the 'products' table if it does not already exist. 
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'products')
BEGIN
    CREATE TABLE products (
        -- Add a product_id column as the primary key.
        product_id INT PRIMARY KEY,
        -- Add a product_name column to store the name of the product.
        product_name NVARCHAR(50) NOT NULL,
        category_id INT,
        price DECIMAL(10, 2),
        -- Add a created_at column to store the date and time the product was created.
        created_at DATETIME DEFAULT GETDATE(),
        -- add a updated_at column to store the date and time the product was last updated.
        updated_at DATETIME DEFAULT GETDATE(),
        -- Add a foreign key constraint to link the products table to the categories table.
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
    );
END

-- Remove all rows from the 'products' table then the 'categories' table.
TRUNCATE TABLE products;
TRUNCATE TABLE categories;


-- Populate the 'categories' table with sample data.
INSERT INTO categories (category_id, category_name)
VALUES (1, 'Electronics and Wiring'),
       (2, 'Clothing'),
       (3, 'Books'),
       (4, 'Home & Kitchen'),
       (5, 'Toys'),
       (6, 'Sports & Outdoors'),
       (7, 'Beauty & Personal Care');

-- Populate the 'products' table with sample data.
INSERT INTO products (product_id, product_name, category_id, price)
VALUES (1, 'Smartphone', 1, 799.99),
       (2, 'Laptop', 1, 1299.99),
       (3, 'T-shirt', 2, 19.99),
       (4, 'Jeans', 2, 49.99),
       (5, 'Novel', 3, 9.99),
       (6, 'Cookware Set', 4, 79.99),
       (7, 'Action Figure', 5, 14.99),
       (8, 'Board Game', 5, 24.99),
         (9, 'Soccer Ball', 6, 19.99),
         (10, 'Yoga Mat', 6, 29.99),
         (11, 'Shampoo', 7, 6.99);

-- Create a stored procedure to get all categories.
IF OBJECT_ID('spGetAllCategories', 'P') IS NOT NULL
    DROP PROCEDURE spGetAllCategories;
GO

CREATE PROCEDURE spGetAllCategories
AS
BEGIN
    SELECT * FROM categories;
END
GO

-- Create a stored procedure to get all products in a specific category.
IF OBJECT_ID('spGetProductsByCategory', 'P') IS NOT NULL
    DROP PROCEDURE spGetProductsByCategory;
GO

CREATE PROCEDURE spGetProductsByCategory
    @category_id INT
AS
BEGIN
    SELECT * FROM products WHERE category_id = @category_id;
END
GO

-- Create a stored procedure to get all products in a specific price range sorted by price in ascending order.
IF OBJECT_ID('spGetProductsByPriceRange', 'P') IS NOT NULL
    DROP PROCEDURE spGetProductsByPriceRange;
GO

CREATE PROCEDURE spGetProductsByPriceRange
    @min_price DECIMAL(10, 2),
    @max_price DECIMAL(10, 2)
AS
BEGIN
    SELECT * FROM products WHERE price BETWEEN @min_price AND @max_price ORDER BY price ASC;
END
GO

-- Print a success message.
PRINT 'Database inventory has been initialized successfully.';

