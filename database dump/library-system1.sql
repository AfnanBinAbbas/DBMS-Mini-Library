-- -- Database: library_system

-- -- ---------------------------------------------------------------------------------------------------------------

-- -- Table structure for table author -- --

-- CREATE TABLE author (
--   authorid SERIAL PRIMARY KEY,
--   name VARCHAR(200) NOT NULL,
--   status VARCHAR(10) NOT NULL
-- );

-- -- Dumping data for table author -- --

-- INSERT INTO author (name, status) VALUES
-- ('Alan Forbes', 'Enable'),
-- ('Lynn Beighley', 'Enable');

-- -- --------------------------------------------------------

-- -- Table structure for table book -- --

-- CREATE TABLE book (
--   bookid SERIAL PRIMARY KEY,
--   categoryid INT NOT NULL,
--   authorid INT NOT NULL,
--   rackid INT NOT NULL,
--   name TEXT NOT NULL,
--   picture VARCHAR(250) NOT NULL,
--   publisherid INT NOT NULL,
--   isbn VARCHAR(30) NOT NULL,
--   no_of_copy INT NOT NULL,
--   status VARCHAR(10) NOT NULL,
--   added_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- -- Dumping data for table book -- --

-- INSERT INTO book (categoryid, authorid, rackid, name, picture, publisherid, isbn, no_of_copy, status, added_on, updated_on) VALUES
-- (2, 2, 2, 'The Joy of PHP Programming', 'joy-php.jpg', 8, 'B00BALXN70', 10, 'Enable', '2022-06-12 11:12:48', '2022-06-12 11:13:27'),
-- (2, 3, 2, 'Head First PHP &amp; MySQL', 'header-first-php.jpg', 9, '0596006306', 10, 'Enable', '2022-06-12 11:16:01', '2022-06-12 11:16:01'),
-- (2, 2, 1, 'dsgsdgsd', '', 7, 'sdfsd2334', 23, 'Enable', '2022-06-12 13:29:14', '2022-06-12 13:29:14'),
-- (1, 2, 0, 'eeeeeebook', '', 2, 'hfdfhdfhd', 2, '', '2023-03-19 16:27:17', '2023-03-19 16:27:17'),
-- (1, 2, 0, 'aaaaaaaaaaaaaa', '', 2, 'bbbbbbbbbbbbbbbbbb', 2, '', '2023-03-19 17:37:56', '2023-03-19 17:37:56'),
-- (1, 2, 1, 'bbbbbbbbbbbbbb', '', 2, '4346436463463', 2, 'Enable', '2023-03-25 14:44:18', '2023-03-25 14:44:18');

-- -- --------------------------------------------------------

-- -- Table structure for table category -- --

-- CREATE TABLE category (
--   categoryid SERIAL PRIMARY KEY,
--   name VARCHAR(200) NOT NULL,
--   status VARCHAR(10) NOT NULL
-- );

-- -- Dumping data for table category -- --

-- INSERT INTO category (name, status) VALUES
-- ('Web Design', 'Enable'),
-- ('Programming', 'Enable'),
-- ('Commerce', 'Enable'),
-- ('Math', 'Enable'),
-- ('Web Development', 'Enable');

-- -- --------------------------------------------------------

-- -- Table structure for table issued_book -- --

-- CREATE TABLE issued_book (
--   issuebookid SERIAL PRIMARY KEY,
--   bookid INT NOT NULL,
--   userid INT NOT NULL,
--   issue_date_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
--   expected_return_date TIMESTAMP NOT NULL,
--   return_date_time TIMESTAMP NOT NULL,
--   status VARCHAR(20) NOT NULL
-- );

-- -- Dumping data for table issued_book -- --

-- INSERT INTO issued_book (bookid, userid, issue_date_time, expected_return_date, return_date_time, status) VALUES
-- (2, 2, '2022-06-12 15:33:45', '2022-06-15 16:27:59', '2022-06-16 16:27:59', 'Not Return'),
-- (1, 2, '2022-06-12 18:46:07', '2022-06-30 18:46:02', '2022-06-12 18:46:14', 'Returned'),
-- (7, 2, '2023-03-25 14:32:57', '2023-03-25 14:32:47', '2023-03-26 14:32:51', 'Issued');

-- -- --------------------------------------------------------

-- -- Table structure for table publisher -- --

-- CREATE TABLE publisher (
--   publisherid SERIAL PRIMARY KEY,
--   name VARCHAR(255) NOT NULL,
--   status VARCHAR(10) NOT NULL
-- );

-- -- Dumping data for table publisher -- --

-- INSERT INTO publisher (name, status) VALUES
-- ('Amazon publishing', 'Enable'),
-- ('Penguin books ltd.', 'Enable'),
-- ('Vintage Publishing', 'Enable'),
-- ('Macmillan Publishers', 'Enable'),
-- ('Simon & Schuster', 'Enable'),
-- ('HarperCollins', 'Enable'),
-- ('Plum Island', 'Enable'),
-- ('O’Reilly', 'Enable');

-- -- --------------------------------------------------------

-- -- Table structure for table rack -- --

-- CREATE TABLE rack (
--   rackid SERIAL PRIMARY KEY,
--   name VARCHAR(200) NOT NULL,
--   status VARCHAR(10) NOT NULL DEFAULT 'Enable'
-- );

-- -- Dumping data for table rack -- --

-- INSERT INTO rack (name, status) VALUES
-- ('R1', 'Enable'),
-- ('R2', 'Enable');

-- -- --------------------------------------------------------

-- -- Table structure for table user -- --

-- CREATE TABLE "user" (
--   id SERIAL PRIMARY KEY,
--   first_name VARCHAR(255),
--   last_name VARCHAR(255),
--   email VARCHAR(255),
--   password VARCHAR(64) NOT NULL,
--   role VARCHAR(10) DEFAULT 'admin'
-- );

-- -- Dumping data for table user -- --

-- INSERT INTO "user" (first_name, last_name, email, password, role) VALUES
-- ('Mark', 'Wood', 'mark@webdamn.com', '123', 'user'),
-- ('George', 'Smith', 'goerge@webdamn.com', '123', 'admin'),
-- ('Adam', NULL, 'adam@webdamn.com', '123', 'admin'),
-- ('aaa', 'bbbbb', 'ab@webdamn.com', '123', 'user');

-- -- Create a trigger to update the 'no_of_copy' column in the 'book' table -- --
-- CREATE OR REPLACE FUNCTION update_no_of_copy()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     IF TG_OP = 'INSERT' THEN
--         UPDATE book
--         SET no_of_copy = no_of_copy - 1
--         WHERE bookid = NEW.bookid;
--     ELSIF TG_OP = 'DELETE' THEN
--         UPDATE book
--         SET no_of_copy = no_of_copy + 1
--         WHERE bookid = OLD.bookid;
--     END IF;
--     RETURN NULL;
-- END;
-- $$ LANGUAGE plpgsql;
