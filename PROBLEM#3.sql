-- Dimension Tables
CREATE TABLE Pet (
    pet_id INT PRIMARY KEY,
    pet_first_name VARCHAR(255),
    pet_last_name VARCHAR(255),
    pet_type VARCHAR(255)
);

CREATE TABLE Owner (
    owner_id INT PRIMARY KEY,
    owner_first_name VARCHAR(255),
    owner_last_name VARCHAR(255)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(255),
    course_instructor VARCHAR(255),
    course_price DECIMAL(10,2)
);

CREATE TABLE Date (
    date_id INT PRIMARY KEY,
    enrollment_date DATE,
    month VARCHAR(255),
    hold_date DATE
);

CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(255)
);

-- Fact Table
CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    pet_id INT,
    owner_id INT,
    course_id INT,
    date_id INT,
    location_id INT,
    grade VARCHAR(255),
    hold_type VARCHAR(255),
    hold_description VARCHAR(255),
    course_price DECIMAL(10,2),
    FOREIGN KEY (pet_id) REFERENCES Pet(pet_id),
    FOREIGN KEY (owner_id) REFERENCES Owner(owner_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (date_id) REFERENCES Date(date_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- 1) How many new pets are enrolled in each course per month?
SELECT COUNT(DISTINCT Enrollment.pet_id) as 'Number of new pets', Pet.pet_first_name, Pet.pet_last_name, Pet.pet_type, 
Owner.owner_first_name, Owner.owner_last_name, Date.enrollment_date, Date.month, Location.location_name
FROM Enrollment
JOIN Pet ON Enrollment.pet_id = Pet.pet_id
JOIN Owner ON Enrollment.owner_id = Owner.owner_id
JOIN Course ON Enrollment.course_id = Course.course_id
JOIN Date ON Enrollment.date_id = Date.date_id
JOIN Location ON Enrollment.location_id = Location.location_id
GROUP BY Pet.pet_first_name, Pet.pet_last_name, Pet.pet_type, Owner.owner_first_name, Owner.owner_last_name, Date.enrollment_date, Date.month, Location.location_name;

-- 2) Missing grades report?
SELECT Pet.pet_first_name, Pet.pet_last_name, Owner.owner_first_name, Owner.owner_last_name, Course.course_name, Course.course_instructor
FROM Enrollment
JOIN Pet ON Enrollment.pet_id = Pet.pet_id
JOIN Owner ON Enrollment.owner_id = Owner.owner_id
JOIN Course ON Enrollment.course_id = Course.course_id
WHERE Enrollment.grade IS NULL;

-- 3) Are there holds (financial hold, vaccinations) on the pets that would prevent them from continuing with their training?
SELECT Pet.pet_first_name, Pet.pet_last_name, Owner.owner_first_name, Owner.owner_last_name, Enrollment.hold_type, Enrollment.hold_description, Date.month, Date.hold_date, Course.course_price
FROM Enrollment
JOIN Pet ON Enrollment.pet_id = Pet.pet_id
JOIN Owner ON Enrollment.owner_id = Owner.owner_id
JOIN Course ON Enrollment.course_id = Course.course_id
JOIN Date ON Enrollment.date_id = Date.date_id
WHERE Enrollment.hold_type IN ('financial hold', 'vaccination hold');




