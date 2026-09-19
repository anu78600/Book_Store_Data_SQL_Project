-- Book Store Data SQL Project...

-- Create Database.
Create Database OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
Drop Table If Exists Books;

Create Table Books (
		Book_ID Serial Primary Key,
		Title Varchar(100),
		Author Varchar(100),
		Genre Varchar(50),
		Published_Year INT,
		Price NUMERIC(10,2),
		Stock INT
);

Drop Table IF Exists Customers;

Create Table Customers(
		Customer_ID Serial Primary KEY,
		Name Varchar(100),
		Email Varchar(100),
		Phone Varchar(15),
		City Varchar(50),
		Country Varchar(150)
);

Drop Table If Exists Orders;

Create Table Orders(
		Order_ID Serial Primary Key,
		Customer_ID INT References Customers(Customer_ID),
		Book_ID INT References Books(Book_ID),
		Order_Date Date,
		Quantity INT,
		Total_Amount Numeric(10,2)

);

Select * From Books;
Select * From Customers;
Select * From Orders;

-- Import Data Into Books Table

Copy Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
From 'C:\csv\Books.csv'
CSV Header;

-- Import Data into Customers Table

COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:/csv/Customers.csv'
DELIMITER ','
CSV HEADER;

-- Import Data into Orders Table
Copy Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
From 'C:\csv\Orders.csv'
Delimiter ','
CSV Header;

----------------------------------------------------------------------------------------------------------------

-- 1) Retrieve all books in the 'Fiction' genre:

Select Title,Genre From Books
Where Genre = 'Fiction';

-- 2) Find books published after the year 1950:

Select * From Books
Where Published_Year > 1950;

-- 3) List all the customer from the canada.

Select Name,City,Country From Customers
Where Country = 'Canada';

-- 4) Show orders placed in November 2023.

Select * From Orders
Where Order_Date Between '01-11-23' And '30-11-23';

-- 5) Retrieve the total Stock of books available.

Select Sum(Stock) AS Total_Stock
From Books;

-- 6) Find the details of the most expensive book.

Select * From Books
Order By Price DESC Limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book.

Select c.Name,o.Quantity From Customers c
Join Orders o
ON c.Customer_ID = o.Customer_ID
Where o.quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20.

Select * From Orders
Where Total_Amount > 20;

-- 9) List all the genres available in the Books Table.

Select Distinct genre  From Books;

-- 10) Find the book with the lowest stock.

Select * From Books
Order By stock Limit 5;

-- 11) Calculate the total revenue generated from all orders.

Select Sum(total_amount) AS Total_revenue From Orders;


-- Advance Questions.

-- 1) Retrieve the total number of books sold for each genre:

Select b.Genre, Sum(o.Quantity) AS Total_Book_Sold
From Books b
Join Orders o
ON o.book_id = b.book_id
Group By b.genre;

-- 2) Find the average price of books in the 'Fantasy' genre:

Select avg(price) From Books
Where genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
Select c.Name,c.Customer_ID, Count(o.Order_id) AS Total_order 
From Customers c
Join Orders o
ON c.Customer_ID = o.Customer_ID
Group by c.Customer_ID
Having Count(o.Order_id) >= 2;

-- 4) Find the most frequently Ordered Book:

Select o.Book_id, b.title, Count(o.Order_id) AS Order_Count 
From Orders o
Join Books b ON o.Book_id = b.Book_id
Group By o.Book_id, b.title
Order By Order_Count Desc Limit 1;

-- 5) Show the top 3 most Expensive books of 'Fantasy' Genre:

Select * From Books
Where genre = 'Fantasy'
Order By Price DESC Limit 3;

-- 6) Retrieve the total quantity of books sold by each author:

Select Distinct b.Author, Sum(o.quantity) AS Total_Books_Sold
From Books b
Join Orders o ON b.book_id = o.book_id
Group By b.Author
Order By Total_Books_Sold DESC;

-- 7) List the cities where customers who spent over $30 are located:

Select Distinct c.city, c.name, o.total_amount
From Orders o
Join Customers c
ON o.customer_id = c.customer_id
Where o.total_amount > 30;

-- 8) Find the customer who spent the most on orders:

Select Distinct c.name, Sum(o.total_amount) AS total_spent
From Orders o
Join Customers c
ON o.customer_id = c.customer_id
Group By c.name
Order By total_spent DESC Limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:

Select b.book_id, b.title, b.stock, Coalesce(Sum(o.quantity),0) AS Order_quantity,
	b.stock - Coalesce(Sum(o.quantity),0) AS remaning_quantity
From Books b
	Left Join Orders o
	ON b.book_id = o.book_id
Group By b.book_id;



