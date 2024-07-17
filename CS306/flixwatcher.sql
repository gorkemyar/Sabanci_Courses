-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 24, 2021 at 08:35 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flixwatcher`
--

-- --------------------------------------------------------

--
-- Table structure for table `Actors`
--

CREATE TABLE `Actors` (
  `Actor_Id` int(11) NOT NULL,
  `Actor_Name` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Actors`
--

INSERT INTO `Actors` (`Actor_Id`, `Actor_Name`) VALUES
(1, 'furkan'),
(2, 'Morgan Freeman'),
(3, 'Leonardo Dicaprio'),
(4, 'Brad Pitt'),
(5, 'Gillian Murphy'),
(6, 'Christian Bale'),
(7, 'Hugh Jackman'),
(8, 'Heath Ledger');

-- --------------------------------------------------------

--
-- Table structure for table `Actresses`
--

CREATE TABLE `Actresses` (
  `Actress_ID` int(11) NOT NULL,
  `Actress_Name` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Actresses`
--

INSERT INTO `Actresses` (`Actress_ID`, `Actress_Name`) VALUES
(1, 'selim'),
(2, 'Scarlett Johannasson'),
(3, 'Angelina Jolie'),
(4, 'Emma Watson'),
(5, 'Adriana Lima'),
(6, 'Monique Gabriella Curnen'),
(7, 'Maggie Gillienhell');

-- --------------------------------------------------------

--
-- Table structure for table `Award`
--

CREATE TABLE `Award` (
  `Award_Type` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Award`
--

INSERT INTO `Award` (`Award_Type`) VALUES
('Academy'),
('Emmy'),
('Golden Globe'),
('Golden Orange'),
('Gorkem'),
('Nobel'),
('Oscar');

-- --------------------------------------------------------

--
-- Table structure for table `Directors`
--

CREATE TABLE `Directors` (
  `Director_ID` int(11) NOT NULL,
  `Director_Name` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Directors`
--

INSERT INTO `Directors` (`Director_ID`, `Director_Name`) VALUES
(1, 'murat'),
(2, 'Christopher Nolan'),
(3, 'Frank Darabont'),
(4, 'Richard Schenkman'),
(5, 'Peter Jackson'),
(6, 'Sidney Lumet');

-- --------------------------------------------------------

--
-- Table structure for table `Duration`
--

CREATE TABLE `Duration` (
  `Duration_time` int(11) DEFAULT NULL,
  `Shows_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Duration`
--

INSERT INTO `Duration` (`Duration_time`, `Shows_ID`) VALUES
(152, 6),
(169, 7),
(130, 8),
(178, 9),
(148, 10),
(87, 11),
(152, 12),
(97, 13);

-- --------------------------------------------------------

--
-- Table structure for table `Films`
--

CREATE TABLE `Films` (
  `Is_sequal` binary(1) DEFAULT NULL,
  `Shows_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Films`
--

INSERT INTO `Films` (`Is_sequal`, `Shows_ID`) VALUES
(0x30, 6),
(0x30, 7),
(0x30, 8),
(0x31, 9),
(0x31, 10),
(0x31, 11),
(0x31, 12),
(0x30, 13);

-- --------------------------------------------------------

--
-- Table structure for table `Gained`
--

CREATE TABLE `Gained` (
  `Shows_ID` int(11) NOT NULL,
  `Award_Type` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Gained`
--

INSERT INTO `Gained` (`Shows_ID`, `Award_Type`) VALUES
(6, 'Oscar'),
(7, 'Oscar'),
(8, 'Emmy'),
(9, 'Oscar'),
(10, 'Golden Orange'),
(11, 'Gorkem'),
(12, 'Oscar'),
(13, 'Oscar');

-- --------------------------------------------------------

--
-- Table structure for table `Genre`
--

CREATE TABLE `Genre` (
  `Genre_Name` text,
  `Genre_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Genre`
--

INSERT INTO `Genre` (`Genre_Name`, `Genre_ID`) VALUES
('action', 1),
('Horror', 2),
('Thriller', 3),
('Adventure', 4),
('Romantic', 5),
('Drama', 6),
('Fantasy', 7),
('Comedy', 8),
('Crime', 9);

-- --------------------------------------------------------

--
-- Table structure for table `Has`
--

CREATE TABLE `Has` (
  `Shows_ID` int(11) NOT NULL,
  `Genre_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Has`
--

INSERT INTO `Has` (`Shows_ID`, `Genre_ID`) VALUES
(12, 1),
(8, 3),
(11, 3),
(6, 6),
(10, 6),
(7, 7),
(9, 7),
(13, 9);

-- --------------------------------------------------------

--
-- Table structure for table `Languages`
--

CREATE TABLE `Languages` (
  `Subtitle` text,
  `Voice` text,
  `Shows_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Languages`
--

INSERT INTO `Languages` (`Subtitle`, `Voice`, `Shows_ID`) VALUES
('English', 'English', 6),
('English', 'English', 7),
('English', 'English', 8),
('English', 'English', 9),
('Italian', 'English', 10),
('English', 'English', 11),
('English', 'English', 12),
('English', 'English', 13);

-- --------------------------------------------------------

--
-- Table structure for table `Made_By`
--

CREATE TABLE `Made_By` (
  `Shows_ID` int(11) NOT NULL,
  `Producer_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Made_By`
--

INSERT INTO `Made_By` (`Shows_ID`, `Producer_ID`) VALUES
(8, 22),
(9, 22),
(10, 22),
(11, 22),
(12, 22),
(13, 22),
(6, 23),
(7, 24);

-- --------------------------------------------------------

--
-- Table structure for table `Netflix_Availability`
--

CREATE TABLE `Netflix_Availability` (
  `Start_Date` date DEFAULT NULL,
  `End_Date` date DEFAULT NULL,
  `Shows_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Producers`
--

CREATE TABLE `Producers` (
  `Producer_ID` int(11) NOT NULL,
  `Producer_Name` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Producers`
--

INSERT INTO `Producers` (`Producer_ID`, `Producer_Name`) VALUES
(22, 'Warner Bros'),
(23, 'Castle Rock Entertainment'),
(24, 'Francis Ford Coppola');

-- --------------------------------------------------------

--
-- Table structure for table `Restrictions`
--

CREATE TABLE `Restrictions` (
  `Restriction_type` text,
  `Shows_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Restrictions`
--

INSERT INTO `Restrictions` (`Restriction_type`, `Shows_ID`) VALUES
('+13', 6),
('+18', 7),
('+13', 8),
('+13', 9),
('+18', 10),
('+11', 11),
('+18', 12),
('+18', 13);

-- --------------------------------------------------------

--
-- Table structure for table `Shows`
--

CREATE TABLE `Shows` (
  `Shows_ID` int(11) NOT NULL,
  `Shows_Name` text,
  `Box_Office_Gross` double DEFAULT NULL,
  `IMDB_Rating` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Shows`
--

INSERT INTO `Shows` (`Shows_ID`, `Shows_Name`, `Box_Office_Gross`, `IMDB_Rating`) VALUES
(6, 'Shawshank Redemption', 58300000, 9.3),
(7, 'Interstellar', 100000000, 8.6),
(8, 'Prestige', 1231231, 8.3),
(9, 'Lord of the Rings', 100000000, 8.2),
(10, 'Godfather', 123123123, 9.2),
(11, 'Man from Earth', 100000, 7.9),
(12, 'Dark Knight', 1000000000, 9),
(13, '12 Angry Men', 1000, 9);

-- --------------------------------------------------------

--
-- Table structure for table `Sponsors_Actor`
--

CREATE TABLE `Sponsors_Actor` (
  `Producer_ID` int(11) NOT NULL,
  `Actor_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Sponsors_Actor`
--

INSERT INTO `Sponsors_Actor` (`Producer_ID`, `Actor_ID`) VALUES
(22, 1),
(23, 3),
(24, 6);

-- --------------------------------------------------------

--
-- Table structure for table `Sponsors_Actress`
--

CREATE TABLE `Sponsors_Actress` (
  `Producer_ID` int(11) NOT NULL,
  `Actress_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Sponsors_Actress`
--

INSERT INTO `Sponsors_Actress` (`Producer_ID`, `Actress_ID`) VALUES
(22, 1),
(23, 4),
(24, 5);

-- --------------------------------------------------------

--
-- Table structure for table `Sponsors_Director`
--

CREATE TABLE `Sponsors_Director` (
  `Producer_ID` int(11) NOT NULL,
  `Director_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Sponsors_Director`
--

INSERT INTO `Sponsors_Director` (`Producer_ID`, `Director_ID`) VALUES
(23, 2),
(24, 3),
(22, 4);

-- --------------------------------------------------------

--
-- Table structure for table `TV_Shows`
--

CREATE TABLE `TV_Shows` (
  `Seasons_num` int(11) DEFAULT NULL,
  `Shows_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Year_Made_in`
--

CREATE TABLE `Year_Made_in` (
  `Releasing_Year` int(11) DEFAULT NULL,
  `Year_ID` int(11) NOT NULL,
  `Shows_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Year_Made_in`
--

INSERT INTO `Year_Made_in` (`Releasing_Year`, `Year_ID`, `Shows_ID`) VALUES
(1994, 1, 6),
(2014, 2, 7),
(1999, 3, 9),
(1972, 4, 10),
(2007, 5, 11),
(2008, 6, 12);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Actors`
--
ALTER TABLE `Actors`
  ADD PRIMARY KEY (`Actor_Id`);

--
-- Indexes for table `Actresses`
--
ALTER TABLE `Actresses`
  ADD PRIMARY KEY (`Actress_ID`);

--
-- Indexes for table `Award`
--
ALTER TABLE `Award`
  ADD PRIMARY KEY (`Award_Type`);

--
-- Indexes for table `Directors`
--
ALTER TABLE `Directors`
  ADD PRIMARY KEY (`Director_ID`);

--
-- Indexes for table `Duration`
--
ALTER TABLE `Duration`
  ADD PRIMARY KEY (`Shows_ID`);

--
-- Indexes for table `Films`
--
ALTER TABLE `Films`
  ADD PRIMARY KEY (`Shows_ID`);

--
-- Indexes for table `Gained`
--
ALTER TABLE `Gained`
  ADD PRIMARY KEY (`Shows_ID`,`Award_Type`),
  ADD KEY `Award_Type` (`Award_Type`);

--
-- Indexes for table `Genre`
--
ALTER TABLE `Genre`
  ADD PRIMARY KEY (`Genre_ID`);

--
-- Indexes for table `Has`
--
ALTER TABLE `Has`
  ADD PRIMARY KEY (`Shows_ID`),
  ADD KEY `Genre_ID` (`Genre_ID`);

--
-- Indexes for table `Languages`
--
ALTER TABLE `Languages`
  ADD PRIMARY KEY (`Shows_ID`);

--
-- Indexes for table `Made_By`
--
ALTER TABLE `Made_By`
  ADD PRIMARY KEY (`Shows_ID`),
  ADD KEY `Producer_ID` (`Producer_ID`);

--
-- Indexes for table `Netflix_Availability`
--
ALTER TABLE `Netflix_Availability`
  ADD PRIMARY KEY (`Shows_ID`);

--
-- Indexes for table `Producers`
--
ALTER TABLE `Producers`
  ADD PRIMARY KEY (`Producer_ID`);

--
-- Indexes for table `Restrictions`
--
ALTER TABLE `Restrictions`
  ADD PRIMARY KEY (`Shows_ID`);

--
-- Indexes for table `Shows`
--
ALTER TABLE `Shows`
  ADD PRIMARY KEY (`Shows_ID`);

--
-- Indexes for table `Sponsors_Actor`
--
ALTER TABLE `Sponsors_Actor`
  ADD PRIMARY KEY (`Producer_ID`),
  ADD KEY `Actor_ID` (`Actor_ID`);

--
-- Indexes for table `Sponsors_Actress`
--
ALTER TABLE `Sponsors_Actress`
  ADD PRIMARY KEY (`Producer_ID`),
  ADD KEY `Actress_ID` (`Actress_ID`);

--
-- Indexes for table `Sponsors_Director`
--
ALTER TABLE `Sponsors_Director`
  ADD PRIMARY KEY (`Producer_ID`),
  ADD KEY `Director_ID` (`Director_ID`);

--
-- Indexes for table `TV_Shows`
--
ALTER TABLE `TV_Shows`
  ADD PRIMARY KEY (`Shows_ID`);

--
-- Indexes for table `Year_Made_in`
--
ALTER TABLE `Year_Made_in`
  ADD PRIMARY KEY (`Year_ID`),
  ADD KEY `Shows_ID` (`Shows_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Actors`
--
ALTER TABLE `Actors`
  MODIFY `Actor_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Actresses`
--
ALTER TABLE `Actresses`
  MODIFY `Actress_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `Directors`
--
ALTER TABLE `Directors`
  MODIFY `Director_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `Genre`
--
ALTER TABLE `Genre`
  MODIFY `Genre_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `Producers`
--
ALTER TABLE `Producers`
  MODIFY `Producer_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `Shows`
--
ALTER TABLE `Shows`
  MODIFY `Shows_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `Year_Made_in`
--
ALTER TABLE `Year_Made_in`
  MODIFY `Year_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Duration`
--
ALTER TABLE `Duration`
  ADD CONSTRAINT `duration_ibfk_1` FOREIGN KEY (`Shows_ID`) REFERENCES `Shows` (`Shows_ID`) ON DELETE CASCADE;

--
-- Constraints for table `Gained`
--
ALTER TABLE `Gained`
  ADD CONSTRAINT `gained_ibfk_1` FOREIGN KEY (`Shows_ID`) REFERENCES `Shows` (`Shows_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `gained_ibfk_2` FOREIGN KEY (`Award_Type`) REFERENCES `Award` (`Award_Type`) ON DELETE CASCADE;

--
-- Constraints for table `Has`
--
ALTER TABLE `Has`
  ADD CONSTRAINT `has_ibfk_1` FOREIGN KEY (`Shows_ID`) REFERENCES `Shows` (`Shows_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `has_ibfk_2` FOREIGN KEY (`Genre_ID`) REFERENCES `Genre` (`Genre_ID`) ON DELETE CASCADE;

--
-- Constraints for table `Languages`
--
ALTER TABLE `Languages`
  ADD CONSTRAINT `languages_ibfk_1` FOREIGN KEY (`Shows_ID`) REFERENCES `Shows` (`Shows_ID`) ON DELETE CASCADE;

--
-- Constraints for table `Made_By`
--
ALTER TABLE `Made_By`
  ADD CONSTRAINT `made_by_ibfk_1` FOREIGN KEY (`Shows_ID`) REFERENCES `Shows` (`Shows_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `made_by_ibfk_2` FOREIGN KEY (`Producer_ID`) REFERENCES `Producers` (`Producer_ID`) ON DELETE CASCADE;

--
-- Constraints for table `Netflix_Availability`
--
ALTER TABLE `Netflix_Availability`
  ADD CONSTRAINT `netflix_availability_ibfk_1` FOREIGN KEY (`Shows_ID`) REFERENCES `Shows` (`Shows_ID`) ON DELETE CASCADE;

--
-- Constraints for table `Restrictions`
--
ALTER TABLE `Restrictions`
  ADD CONSTRAINT `restrictions_ibfk_1` FOREIGN KEY (`Shows_ID`) REFERENCES `Shows` (`Shows_ID`) ON DELETE CASCADE;

--
-- Constraints for table `Sponsors_Actor`
--
ALTER TABLE `Sponsors_Actor`
  ADD CONSTRAINT `sponsors_actor_ibfk_1` FOREIGN KEY (`Producer_ID`) REFERENCES `Producers` (`Producer_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `sponsors_actor_ibfk_2` FOREIGN KEY (`Actor_ID`) REFERENCES `Actors` (`Actor_Id`) ON DELETE CASCADE;

--
-- Constraints for table `Sponsors_Actress`
--
ALTER TABLE `Sponsors_Actress`
  ADD CONSTRAINT `sponsors_actress_ibfk_1` FOREIGN KEY (`Producer_ID`) REFERENCES `Producers` (`Producer_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `sponsors_actress_ibfk_2` FOREIGN KEY (`Actress_ID`) REFERENCES `Actresses` (`Actress_ID`) ON DELETE CASCADE;

--
-- Constraints for table `Sponsors_Director`
--
ALTER TABLE `Sponsors_Director`
  ADD CONSTRAINT `sponsors_director_ibfk_1` FOREIGN KEY (`Producer_ID`) REFERENCES `Producers` (`Producer_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `sponsors_director_ibfk_2` FOREIGN KEY (`Director_ID`) REFERENCES `Directors` (`Director_ID`) ON DELETE CASCADE;

--
-- Constraints for table `Year_Made_in`
--
ALTER TABLE `Year_Made_in`
  ADD CONSTRAINT `year_made_in_ibfk_1` FOREIGN KEY (`Shows_ID`) REFERENCES `Shows` (`Shows_ID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
