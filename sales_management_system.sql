-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 17, 2022 at 04:57 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sales management system`
--

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `Id` int(11) NOT NULL,
  `FirstName` varchar(40) NOT NULL,
  `LastName` varchar(40) NOT NULL,
  `City` varchar(40) DEFAULT NULL,
  `Country` varchar(40) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`Id`, `FirstName`, `LastName`, `City`, `Country`, `Phone`) VALUES
(1, 'Maria', 'Anders', 'Berlin', 'Germany', '030-0074321'),
(2, 'Ana', 'Trujillo', 'México D.F.', 'Mexico', '(5) 555-4729'),
(3, 'Antonio', 'Moreno', 'México D.F.', 'Mexico', '(5) 555-3932'),
(4, 'Thomas', 'Hardy', 'London', 'UK', '(171) 555-7788'),
(5, 'Christina', 'Berglund', 'Luleå', 'Sweden', '0921-12 34 65');

-- --------------------------------------------------------

--
-- Table structure for table `orderitem`
--

CREATE TABLE `orderitem` (
  `Id` int(11) NOT NULL,
  `OrderId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orderitem`
--

INSERT INTO `orderitem` (`Id`, `OrderId`, `ProductId`, `Quantity`) VALUES
(1, 1, 4, 1),
(2, 1, 2, 1),
(3, 1, 3, 1),
(4, 1, 7, 1),
(5, 2, 2, 1),
(6, 2, 6, 1),
(7, 2, 3, 1),
(8, 2, 10, 1),
(9, 3, 2, 1),
(10, 3, 6, 1),
(11, 3, 10, 1),
(12, 4, 10, 1),
(13, 4, 2, 1),
(14, 4, 3, 1),
(15, 4, 4, 1),
(16, 4, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `Id` int(11) NOT NULL,
  `OrderDate` varchar(20) NOT NULL,
  `OrderNumber` varchar(10) DEFAULT NULL,
  `CustomerId` int(11) NOT NULL,
  `TotalAmount` decimal(12,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`Id`, `OrderDate`, `OrderNumber`, `CustomerId`, `TotalAmount`) VALUES
(1, '2022-11-17', '75542', 4, '81.00'),
(2, '2022-11-17', '73160', 4, '85.00'),
(3, '2022-11-17', '20556', 3, '75.00'),
(4, '2022-11-17', '62092', 3, '100.00');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `Id` int(11) NOT NULL,
  `ProductName` varchar(50) NOT NULL,
  `SupplierId` int(11) NOT NULL,
  `UnitPrice` decimal(12,2) DEFAULT 0.00,
  `Package` varchar(30) DEFAULT NULL,
  `IsDiscontinued` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`Id`, `ProductName`, `SupplierId`, `UnitPrice`, `Package`, `IsDiscontinued`) VALUES
(1, 'Chai', 1, '18.00', '10 boxes x 20 bags', b'0'),
(2, 'Chang', 1, '19.00', '24 - 12 oz bottles', b'0'),
(3, 'Aniseed Syrup', 2, '10.00', '12 - 550 ml bottles', b'0'),
(4, 'Chef Anton\'s Cajun Seasoning', 2, '22.00', '48 - 6 oz jars', b'0'),
(5, 'Chef Anton\'s Gumbo Mix', 2, '21.35', '36 boxes', b'1'),
(6, 'Grandma\'s Boysenberry Spread', 3, '25.00', '12 - 8 oz jars', b'0'),
(7, 'Uncle Bob\'s Organic Dried Pears', 3, '30.00', '12 - 1 lb pkgs.', b'0'),
(8, 'Northwoods Cranberry Sauce', 3, '40.00', '12 - 12 oz jars', b'0'),
(9, 'Mishi Kobe Niku', 4, '97.00', '18 - 500 g pkgs.', b'1'),
(10, 'Ikura', 5, '31.00', '12 - 200 ml jars', b'0');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `Id` int(11) NOT NULL,
  `SupplierName` varchar(40) NOT NULL,
  `ContactName` varchar(50) DEFAULT NULL,
  `ContactTitle` varchar(40) DEFAULT NULL,
  `City` varchar(40) DEFAULT NULL,
  `Country` varchar(40) DEFAULT NULL,
  `Phone` varchar(30) DEFAULT NULL,
  `EmailId` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`Id`, `SupplierName`, `ContactName`, `ContactTitle`, `City`, `Country`, `Phone`, `EmailId`) VALUES
(1, 'Exotic Liquids', 'Charlotte Cooper', NULL, 'London', 'UK', '(171) 555-2222', NULL),
(2, 'New Orleans Cajun Delights', 'Shelley Burke', NULL, 'New Orleans', 'USA', '(100) 555-4822', NULL),
(3, 'Grandma Kelly\'s Homestead', 'Regina Murphy', NULL, 'Ann Arbor', 'USA', '(313) 555-5735', '(313) 555-3349'),
(4, 'Tokyo Traders', 'Yoshi Nagase', NULL, 'Tokyo', 'Japan', '(03) 3555-5011', NULL),
(5, 'Cooperativa de Quesos \'Las Cabras\'', 'Antonio del Valle Saavedra', NULL, 'Oviedo', 'Spain', '(98) 598 76 54', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IndexCustomerName` (`LastName`,`FirstName`);

--
-- Indexes for table `orderitem`
--
ALTER TABLE `orderitem`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IndexOrderItemOrderId` (`OrderId`),
  ADD KEY `IndexOrderItemProductId` (`ProductId`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IndexOrderCustomerId` (`CustomerId`),
  ADD KEY `IndexOrderOrderDate` (`OrderDate`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IndexProductSupplierId` (`SupplierId`),
  ADD KEY `IndexProductName` (`ProductName`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IndexSupplierName` (`SupplierName`),
  ADD KEY `IndexSupplierCountry` (`Country`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orderitem`
--
ALTER TABLE `orderitem`
  ADD CONSTRAINT `orderitem_ibfk_1` FOREIGN KEY (`ProductId`) REFERENCES `product` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orderitem_ibfk_2` FOREIGN KEY (`OrderId`) REFERENCES `orders` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orderitem_ibfk_3` FOREIGN KEY (`ProductId`) REFERENCES `product` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `customer` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`SupplierId`) REFERENCES `supplier` (`Id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
