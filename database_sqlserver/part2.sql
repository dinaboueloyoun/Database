--Write a query that displays Full name of an employee who has more than
-- letters in his/her First Name
select e.Fname+' '+e.Lname [FullName]
from Employee e
where LEN( e.Fname)>3

--Write a query to display the total number of Programming books
--available in the library with alias name ‘NO OF PROGRAMMING
--BOOKS
Select COUNT(*) AS [NO OF PROGRAMMING BOOKS]
From Book b
Where b.Title LIKE '%Programming%';


--Write a query to display the number of books published by
--(HarperCollins) with the alias name 'NO_OF_BOOKS'.
select COUNT(*)[NO_OF_BOOKS]
from Book b ,Author a ,Book_Author t
where b.Id=t.Book_id and a.Id=t.Author_id
and a.Name='HarperCollins'

--query to display the User SSN and name, date of borrowing and due date of
--the User whose due date is before July 2022.
select u.SSN,u.User_Name,br.Borrow_date,br.Due_date
from Users u ,Borrowing br 
where u.SSN=br.User_ssn
and  br.Due_date < '2022-08-01'

---Write a query to display book title, author name and display in the
----following format,
----' [Book Title] is written by [Author Name]
select '[' + b.Title + '] is written by [' + a.Name + ']' 
from Book b ,Author a ,Book_Author t
where b.Id=t.Book_id and a.Id=t.Author_id

--Write a query to display the name of users who have letter 'A' in their
--names.
select u.User_Name
from Users u
where u.User_Name like '%A%'--Write a query that display user SSN who makes the most borrowingSELECT TOP 1 u.SSN, COUNT(br.Borrow_date) 
FROM Users u,Borrowing br
where u.SSN = br.User_ssn
GROUP BY u.SSN
ORDER BY COUNT(br.Borrow_date) DESC;


--Write a query that displays the total amount of money that each user paid
--for borrowing books.
select sum(br.Amount)
from Users u ,Borrowing br
where u.SSN=br.User_ssn
group by u.SSN

--write a query that displays the category which has the book that has the
--minimum amount of money for borrowing.
select  top 1 c.Cat_name
from Book b ,Category c ,Borrowing br 
where b.Id=br.Book_id and c.Id=b.Cat_id
group by c.Cat_name
order by min(br.Amount)

--write a query that displays the email of an employee if it's not found, --display address if it's not found, display date of birthday.
SELECT COALESCE(e.Email, e.Address, CONVERT(varchar, e.DOB)) 
FROM Employee e;

--Write a query to list the category and number of books in each category
--with the alias name 'Count Of Books'.
select c.Cat_name,count(b.Id)[Count Of Books]
from Book b ,Category c 
where c.Id=b.Cat_id
group by c.Cat_name

--Write a query that display books id which is not found in floor num = 1
--and shelf-code = A1.
select b.Id
from Book b ,Floor f ,Shelf s 
where b.Shelf_code=s.Code and s.Floor_num=f.Number
and not (f.Number=1 and s.Code='A1')


--Write a query that displays the floor number , Number of Blocks and
--number of employees working on that floor.
select f.Number,f.Num_blocks,count(e.Id) [number of employees]
from Floor f,Employee e
where f.Number=e.Floor_no
group by f.Number,f.Num_blocks

--Display Book Title and User Name to designate Borrowing that occurred
--within the period ‘3/1/2022’ and ‘10/1/2022’
select b.Title ,u.User_Name
from Book b,Users u ,Borrowing br
where b.Id=br.Book_id and u.SSN=br.User_ssn
and br.Borrow_date BETWEEN '2022-03-01' AND '2022-10-01'

--Display Employee Full Name and Name Of his/her Supervisor as
--Supervisor Name
select e.Fname+' '+e.Lname ,s.Fname [Supervisor Name]
from Employee e ,Employee s 
where e.Super_id=s.Id

--Select Employee name and his/her salary but if there is no salary display
--Employee bonus
select e.Fname, ISNULL(e.Salary,convert(varchar,e.Bouns))
from Employee e

--Display max and min salary for Employees
select max(e.Salary),min(e.Salary)
from Employee e

--Write a function that take Number and display if it is even or odd
go
create function  dbo.CheckEvenOdd (@num int)
returns varchar(5)
as
begin
    declare @res varchar(5)
	if(@num%2=0)
	set @res='Even'
	else
	set @res='Odd'
	return @res
end
go
select dbo.CheckEvenOdd (5)

--write a function that take category name and display Title of books in that
--category
go
create function GetTitleByCategory(@cat varchar(50))
returns varchar(50)
as
begin
declare @title varchar(50)
select @title= b.Title
from Book b ,Category c
where b.Cat_id=c.Id
and @cat=c.Cat_name
return  @title 
end
go
select dbo.GetTitleByCategory('Mathematics')

--write a function that takes the phone of the user and displays Book Title ,
--user-name, amount of money and due-date.
go
create function GetBookTitleByUserPhone(@phone varchar(50))
returns table
return
(
  select b.Title,u.User_Name,br.Amount,br.Due_date
  from Book b ,Users u,Borrowing br,User_phones up
  where b.Id=br.Book_id and u.SSN=br.User_ssn and up.User_ssn=u.SSN
  and @phone=up.Phone_num
)
go
select *from dbo.GetBookTitleByUserPhone('0123654122')

--Write a function that take user name and check if it's duplicated
--return Message in the following format ([User Name] is Repeated
--[Count] times) if it's not duplicated display msg with this format [user
--name] is not duplicated,if it's not Found Return [User Name] is Not
--Found
go
create function GetUserNameDuplicate(@name varchar(50))
returns varchar(50)
as
begin 
 declare @count int
 declare @mes varchar(70)
  SELECT @count = COUNT(*) 
    FROM Users u
    WHERE u.User_Name = @name
	IF @count = 0
        SET @mes = @name + ' is Not Found'
    ELSE IF @count = 1
        SET @mes = @name + ' is not duplicated'
    ELSE
        SET @mes = @name + ' is Repeated ' + CAST(@count AS VARCHAR(10)) + ' times'

    RETURN @mes

end
go
select dbo.CheckUserNameDuplicate('Ahmed')

--Create a scalar function that takes date and Format to return Date With
--That Format.
go
create function TakeFormatDate(@inputdate date, @format varchar(50))
returns varchar(50)
as
begin
    return format(@inputdate, @format)
end
go
select dbo.TakeFormatDate('2025-09-14', 'dd/MM/yyyy');

--Create a stored procedure to show the number of books per Category
go
CREATE PROCEDURE ShowBooksPerCategory
AS
BEGIN
    SELECT c.Cat_name, COUNT(b.Id)
    FROM Book b
    JOIN Category c ON b.Cat_id = c.Id
    GROUP BY c.Cat_name;
END
go
EXEC ShowBooksPerCategory;


--Create a stored procedure that will be used in case there is an old manager
--who has left the floor and a new one becomes his replacement. The
--procedure should take 3 parameters (old Emp.id, new Emp.id and the
--floor number) and it will be used to update the floor table.
go
create procedure NewManager
    @old_empid int,
    @new_empid int,
    @floor_no int
as
begin
    update floor 
    set MG_ID = @new_empid
    where Number = @floor_no
    and MG_ID= @old_empid;
end
go
exec NewManager 5, 345, 3;

--Create a view AlexAndCairoEmp that displays Employee data for users
--who live in Alex or Cairo.
go
create view AlexAndCairoEmp as
select *
from Employee e
where e.Address in ('Alex', 'Cairo')
go

select * from AlexAndCairoEmp

--create a view "V2" That displays number of books per shelf
go
create view v2 as
select s.Code , count(b.id) [number_of_books]
from shelf s
left join book b on b.shelf_code = s.code
group by s.code;
go
select * from v2

--create a view "V3" That display the shelf code that have maximum
--number of books using the previous view "V2"
go
create view v3 as
select code
from v2
where number_of_books = (
    select max(number_of_books) from v2
)
go
select * from v3


--Create a table named ‘ReturnedBooks’ With the Following Structure :
--User SSN Book Id Due Date
--Return
--Date
--fees
--then create A trigger that instead of inserting the data of returned book
--checks if the return date is the due date or not if not so the user must pay
--a fee and it will be 20% of the amount that was paid before
create table returnedbooks (
    userssn int,
    bookid int,
    duedate date,
    returndate date,
    fees decimal(10,2)
);
go
create trigger trg_returnedbooks
on returnedbooks
instead of insert
as
begin
    insert into returnedbooks(userssn, bookid, duedate, returndate, fees)
    select 
        i.userssn,
        i.bookid,
        i.duedate,
        i.returndate,
        case 
            when i.returndate > i.duedate then 20
            else 0
        end as fees
    from inserted i;
end;
go

--In the Floor table insert new Floor With Number of blocks 2 , employee
--with SSN = 20 as a manager for this Floor,The start date for this manager
--is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5)
--moved to be the manager of the new Floor (id = 7), and they give Mr. Ali
--Mohamed(his SSN =12) His position .
insert into Floor(number, num_blocks, mg_id)
values (7, 2, 20);

update Floor
set mg_id = 5
where number = 7;

update floor
set mg_id = 12
where mg_id = 5 and number <> 7;


--.Create view name (v_2006_check) that will display Manager id, Floor
--Number where he/she works , Number of Blocks and the Hiring Date
--which must be from the first of March and the end of May 2022.this view
--will be used to insert data so make sure that the coming new data must
--match the condition then try to insert this 2 rows and
--Mention What will happen {3 Point}

--Employee Id Floor Number Number of Blocks Hiring Date

--2 6 2 7-8-2023

--4 7 1 4-8-2022
go
create view v_2006_check
as
select mg_id, number, num_blocks, hiring_date
from floor
where hiring_date between '2022-03-01' and '2022-05-31';

go
insert into v_2006_check (mg_id, number, num_blocks, hiring_date)
values
(2, 6, 2, '2023-07-08'),
(4, 7, 1, '2022-04-08');

--Create a trigger to prevent anyone from Modifying or Delete or Insert in
--the Employee table ( Display a message for user to tell him that he can’t
--take any action with this Table)
go
create trigger prevent
on employee
instead of insert, update, delete
as
begin
    print 'you cannot insert, update, or delete any data in the employee table';
end
go
insert into employee(id, fname)
values (1, 'dina') -- it  not allowed

update employee
set fname = 'dina'
where id = 5  -- it  not allowed

delete from employee
where id = 1  -- it  not allowed

--.Testing Referential Integrity , Mention What Will Happen When:
--A. Add a new User Phone Number with User_SSN = 50 in
--User_Phones Table {1 Point}
--B. Modify the employee id 20 in the employee table to 21 {1 Point}
--C. Delete the employee with id 1 {1 Point}
--D. Delete the employee with id 12

insert into user_phones (user_ssn, phone_num)
values (50, '011050400') --The INSERT statement conflicted with the FOREIGN KEY constraint "FK_User_phones_User".


update employee
set id = 21
where id = 20 -- This trigger prevents any INSERT, UPDATE, or DELETE operations.


delete from employee
where id = 1 -- This trigger prevents any INSERT, UPDATE, or DELETE operations.

delete from employee
where id = 12;  -- This trigger prevents any INSERT, UPDATE, or DELETE operations.


create clustered index index_employee_salary
on employee(salary) --table can only have one clustered index By default, the Primary Key (PK_Employee) is already a clustered index

--Try to Create Login With Your Name And give yourself access Only to
--Employee and Floor tables then allow this login to select and insert data
--into tables and deny Delete and update (Don't Forget To take screenshot
--to every step) 

CREATE LOGIN [DinaAbouElyoun]
WITH PASSWORD = 'fdaa123#';

USE Library;
CREATE USER DinaUser FOR LOGIN DinaAbouElyoun;

GRANT SELECT, INSERT ON dbo.Employee TO DinaUser;
GRANT SELECT, INSERT ON dbo.Floor TO DinaUser;


