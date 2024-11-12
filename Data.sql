-- Tạo cơ sở dữ liệu
CREATE DATABASE QLBGSneaker;
GO

USE QLBGSneaker;
GO



-- Bảng Users (Thông tin người dùng)
CREATE TABLE Users (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UserID AS CAST((LEFT('US' + RIGHT(CAST(ID AS VARCHAR(5)), 3), 15)) AS VARCHAR(10)) PERSISTED NOT NULL UNIQUE,
    UserName NVARCHAR(155) UNIQUE NOT NULL,
    Gender NVARCHAR(10) NOT NULL,
    Email NVARCHAR(155) UNIQUE NOT NULL,
    Password NVARCHAR(155) NOT NULL,
    PhoneNumber VARCHAR(12) UNIQUE NOT NULL,
    Image VARCHAR(50) DEFAULT 'User.jpg',
    Role INT DEFAULT 0,
    CONSTRAINT CK_Gender_Type CHECK (Gender IN (N'Nam', 'Nữ')),
    CONSTRAINT CK_Role CHECK (Role IN (0, 1, 2, 3))
);

-- Bảng Related_staff (Nhân viên)
CREATE TABLE Related_staff (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID AS CAST((LEFT('Emp' + RIGHT(CAST(ID AS VARCHAR(5)), 3), 15)) AS VARCHAR(10)) PERSISTED NOT NULL UNIQUE,
    UserID VARCHAR(10) UNIQUE NOT NULL,
    Address NVARCHAR(255),
    StartDate DATE,
    EmploymentStatus NVARCHAR(50),
    CONSTRAINT FK_Related_staff_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Bảng Shopping_Cart (Giỏ hàng của người dùng)
CREATE TABLE Shopping_Cart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    UserID VARCHAR(10) UNIQUE NOT NULL,
    Subtotal DECIMAL(18, 2) DEFAULT 0,
    CONSTRAINT FK_Cart_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Bảng Favorites (Danh sách yêu thích của người dùng)
CREATE TABLE Favorites (
    FavoriteID INT IDENTITY(1,1) PRIMARY KEY,
    UserID VARCHAR(10) UNIQUE NOT NULL,
    CONSTRAINT FK_Favorites_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Bảng Colours (Màu sắc)
CREATE TABLE Colours (
    ColourID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL UNIQUE
);

-- Bảng Icons (Biểu tượng của giày)
CREATE TABLE Icons (
    IconID VARCHAR(4) PRIMARY KEY,
    Name NVARCHAR(155) UNIQUE NOT NULL,
    Quantity INT DEFAULT 0
);

-- Bảng Shoes (Thông tin giày)
CREATE TABLE Shoes (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    IconID VARCHAR(4),
    ShoesID VARCHAR(10) NOT NULL UNIQUE,
    StyleType NVARCHAR(20),
    Price DECIMAL(10, 2) NOT NULL,
    Discount DECIMAL(5, 2) DEFAULT 0,
    Active BIT DEFAULT 1,  -- Trạng thái hoạt động
    TypeShoes NVARCHAR(255) NOT NULL,  -- Loại giày
    Comment NVARCHAR(555),  -- Bình luận về giày
    StarRating INT CHECK(StarRating > 0 AND StarRating <= 5),  -- Đánh giá sao
    CONSTRAINT FK_Shoes_IconID FOREIGN KEY (IconID) REFERENCES Icons(IconID)
);

-- Bảng Sale (Thông tin các đợt giảm giá của giày)
CREATE TABLE Sale (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    ShoesID VARCHAR(10) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    DiscountPercentage DECIMAL(5, 2) NOT NULL,
    EmployeeID VARCHAR(10),
    CONSTRAINT FK_Sale_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
    CONSTRAINT FK_Sale_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES Related_staff(EmployeeID)
);

-- Bảng Orders (Thông tin đơn hàng)
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID VARCHAR(10) NOT NULL,
    PaymentInfo NVARCHAR(255) DEFAULT N'Thanh Toán Bằng Tiền Mặt',
    EstimatedDeliveryHandlingFee DECIMAL(10, 2) DEFAULT 0,
    Email NVARCHAR(100) NOT NULL,
    Total DECIMAL(10, 2) NOT NULL,
    PaymentStatus NVARCHAR(50) DEFAULT N'False',
    RecipientAddress NVARCHAR(255) NOT NULL,
    RecipientName NVARCHAR(100) NOT NULL,
    RecipientPhoneNumber VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Orders_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Bảng Order_Detail (Chi tiết đơn hàng)
CREATE TABLE Order_Detail (
    OrderID INT NOT NULL,
    ShoesID VARCHAR(10) NOT NULL,
    Quantity INT NOT NULL,
    OrderTime DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (OrderID, ShoesID),
    CONSTRAINT FK_Order_Detail_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_Order_Detail_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID)
);

-- Bảng OrderSystem (Hệ thống đơn hàng - Trạng thái đơn hàng)
CREATE TABLE OrderSystem (
    OrderSystemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    EmployeeID VARCHAR(10),
    OrderDate DATE DEFAULT GETDATE(),
    Status NVARCHAR(50) DEFAULT N'Chưa Xác Nhận',
    CONSTRAINT FK_OrderSystem_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderSystem_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES Related_staff(EmployeeID)
);

-- Bảng Cart_Detail (Chi tiết giỏ hàng)
CREATE TABLE Cart_Detail (
    CartID INT NOT NULL,
    ShoesID VARCHAR(10) NOT NULL,
    StyleType NVARCHAR(20),
    ColourID INT NOT NULL,
    Size INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    BuyingSelection_Status BIT DEFAULT 0,
    PRIMARY KEY (CartID, ShoesID, ColourID, StyleType, Size),
    CONSTRAINT FK_Cart_Detail_CartID FOREIGN KEY (CartID) REFERENCES Shopping_Cart(CartID),
    CONSTRAINT FK_Cart_Detail_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
    CONSTRAINT FK_Cart_Detail_ColourID FOREIGN KEY (ColourID) REFERENCES Colours(ColourID)
);

-- Bảng Colour_Detail (Chi tiết màu sắc của giày)
CREATE TABLE Colour_Detail (
    ColourID INT NOT NULL,
    ShoesID VARCHAR(10) NOT NULL,
    PRIMARY KEY (ShoesID, ColourID),
    CONSTRAINT FK_Colour_Detail_ColourID FOREIGN KEY (ColourID) REFERENCES Colours(ColourID),
    CONSTRAINT FK_Colour_Detail_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID)
);

-- Bảng Images (Hình ảnh của giày)
CREATE TABLE Images (
    ImageID INT IDENTITY(1,1) PRIMARY KEY,
    ShoesID VARCHAR(10) NOT NULL,
    ImageURL NVARCHAR(255) NOT NULL,
    ImageDescription NVARCHAR(255),
    CONSTRAINT FK_Images_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID)
);
