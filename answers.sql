-- Create the database (if it doesn't exist)
-- CREATE DATABASE IF NOT EXISTS SchoolDB;

-- use SchoolDB;

-- Tables:

-- 1. Students Table
-- Stores basic information about each student.
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1), -- Unique identifier for each student
    FirstName VARCHAR(255) NOT NULL,       -- Student's first name
    LastName VARCHAR(255) NOT NULL,        -- Student's last name
    DateOfBirth DATE,                     -- Student's date of birth
   Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')), -- Student's gender
    Email VARCHAR(255) UNIQUE,              -- Student's email address (must be unique)
    PhoneNumber VARCHAR(20),              -- Student's phone number
    Address VARCHAR(255),                   -- Student's address
    EnrollmentDate DATE NOT NULL            -- Date when the student enrolled
);

-- 2. Teachers Table
CREATE TABLE Teachers (
    TeacherID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    PhoneNumber VARCHAR(20),
    HireDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    Department VARCHAR(255),
    Salary DECIMAL(10, 2) 
);

-- 3. Courses Table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName VARCHAR(255) NOT NULL,
    Description TEXT,
    Credits INT NOT NULL,
    Department VARCHAR(255)
);


-- 4. Classes Table
CREATE TABLE Classes (
    ClassID INT PRIMARY KEY IDENTITY(1,1),
    CourseID INT NOT NULL,
    TeacherID INT NOT NULL,
    ClassName VARCHAR(255),
    ClassTime TIME,
    ClassLocation VARCHAR(255),
    Semester VARCHAR(20),  
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);


-- Enrollments Table (Junction Table for Students and Classes)
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    ClassID INT NOT NULL,
    EnrollmentDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    UNIQUE (StudentID, ClassID) -- Prevent duplicate enrollments in the same class
);

-- 6. Assignments Table
CREATE TABLE Assignments (
    AssignmentID INT PRIMARY KEY IDENTITY(1,1),
    ClassID INT NOT NULL,
    AssignmentName VARCHAR(255) NOT NULL,
    DueDate DATETIME,
    PointsPossible INT NOT NULL,
    Description TEXT,
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

-- 7. Grades Table
CREATE TABLE Grades (
    GradeID INT PRIMARY KEY IDENTITY(1,1),
    EnrollmentID INT NOT NULL,
    AssignmentID INT NOT NULL,
    Grade DECIMAL(5, 2), -- Allows grades like 95.5 or 80
    SubmissionDate DATETIME,
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID),
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
    UNIQUE (EnrollmentID, AssignmentID) -- Each student only gets one grade per assignment.
);




-- Indexes (for performance)
CREATE INDEX idx_student_lastname ON Students(LastName);
CREATE INDEX idx_teacher_lastname ON Teachers(LastName);
CREATE INDEX idx_course_name ON Courses(CourseName);
CREATE INDEX idx_enrollment_studentid ON Enrollments(StudentID);
CREATE INDEX idx_enrollment_classid ON Enrollments(ClassID);

-- Sample Data 
-- Insert some sample data into each table.

-- Students
INSERT INTO Students (FirstName, LastName, DateOfBirth, Gender, Email, PhoneNumber, Address, EnrollmentDate) VALUES
('Brian', 'Kibet', '2003-05-10', 'male', 'briankibet@outlook.com', '0711224562', '83 sosiot', '2021-01-01'),
('Mary', 'Maggy', '2004-11-15', 'female', 'marymeggen@gmail.com', '103436512', '12 nakuru', '2021-01-01'),
('Bill', 'Masai', '2004-02-20', 'Male', 'billm678@gmail.com', '0722003405', '2154 Nairobi', '2022-04-01'),
('Wairimu', 'Njoki', '2005-01-01', 'Female', 'wanjoki05@outlook.com', '0114133239', '34 Eldoret', '2022-08-01')
;

-- Teachers
INSERT INTO Teachers (FirstName, LastName, Email, PhoneNumber, Department, Salary) VALUES
('John', 'Mark', 'jmark24@gmail.com', '0716868188', 'Geography', 80000.00),
('May.', 'Fridah', 'fridamay.sc@yahoo.com', '103541234', 'Kiswahili', 75000.00),
('Maxon', 'Quintin', 'qmaxon@gmail.com', '0723444722', 'English', 70000.00),
('Jean', 'Vicky', 'vickyj@gmail.com', '0712123330', 'Science', '9000.00');


-- Courses
INSERT INTO Courses (CourseName, Description, Credits, Department) VALUES
('Physical Geography', 'Internal land forming Processes', 4, 'Geography'),
('Chemistry', 'Organic chemistry', 5, 'Science'),
('English Literature', 'Survey of major works of English literature', 3, 'English'),
('Kiswahili Fasihi', 'Fasihi simulizi', 2, 'Kiswahili');


-- Classes
INSERT INTO Classes (CourseID, TeacherID, ClassName, ClassTime, ClassLocation, Semester) VALUES
(1, 1, 'Geography', '09:00:00', 'Room 101', 'Semister one'),
(2, 2, 'Chemistry', '10:00:00', 'Lab201', 'Semister one'),
(3, 3, 'Fasihi', '10:30:00', 'Room 102', 'Semister one'),
(4, 4, 'English', '13:00:00', 'Auditorium', 'Semister one');

-- Enrollments
INSERT INTO Enrollments (StudentID, ClassID) VALUES
(1, 1), -- Brian in Geography
(1, 2), -- Brian in Chemistry
(2, 2), -- Fridah in Chemistry
(3, 3), -- Bill in English 
(4, 4); -- Wairimu in Fasihi

-- Assignments
INSERT INTO Assignments (ClassID, AssignmentName, DueDate, PointsPossible, Description) VALUES
(1, 'Homework 1', '2025-05-15 23:59:00', 20, 'First homework assignment'),
(2, 'Lab Report', '2025-05-12 23:59:00', 30, 'Report on the lab experiment'),
(3, 'Essay 1', '2025-05-19 23:59:00', 40, 'First essay assignment'),
(4, 'Fasihi simulizi', '2025-05-15 23:59:00', 50, 'First narrative summary');


-- Grades
INSERT INTO Grades (EnrollmentID, AssignmentID, Grade) VALUES
(1, 1, 18.00), -- Brian in Geography , Homework 1 grade
(1, 2, 25.00), -- Brian in Chemistry, Lab Report grade
(2, 2, 28.00), -- Fridah in Chemistry, Lab Report grade
(3, 3, 35.00), -- Bill in English, Easy 1 grade
(4, 4, 38.00); -- Wairimu in Kiswahili, Fasihi simulizi grade

