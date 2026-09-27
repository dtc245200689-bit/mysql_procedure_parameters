-- Đảm bảo sử dụng đúng cơ sở dữ liệu mẫu classicmodels
USE classicmodels;

-- ===============================================================
-- TÌNH HUỐNG 1: THAM SỐ LOẠI IN (Tham số truyền vào mặc định)
-- ===============================================================
DELIMITER //

-- Xóa thủ tục cũ nếu đã tồn tại để tránh xung đột cấu trúc bảng
DROP PROCEDURE IF EXISTS getCusById //

CREATE PROCEDURE getCusById (
    IN cusNum INT(11)
)
BEGIN
    SELECT * FROM customers WHERE customerNumber = cusNum;
END //

DELIMITER ;

-- Gọi thực thi thử nghiệm Stored Procedure loại IN với mã khách hàng là 175
CALL getCusById(175);


-- ===============================================================
-- TÌNH HUỐNG 2: THAM SỐ LOẠI OUT (Lấy dữ liệu ra ngoài)
-- ===============================================================
DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomersCountByCity //

CREATE PROCEDURE GetCustomersCountByCity (
    IN in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //

DELIMITER ;

-- Gọi thực thi thủ tục loại OUT (sử dụng biến toàn cục có ký tự @ phía trước)
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total;


-- ===============================================================
-- TÌNH HUỐNG 3: THAM SỐ LOẠI INOUT (Kết hợp cả truyền vào và lấy ra)
-- ===============================================================
DELIMITER //

DROP PROCEDURE IF EXISTS SetCounter //

CREATE PROCEDURE SetCounter (
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //

DELIMITER ;

-- Khởi tạo biến lưu giá trị ban đầu bằng 1
SET @counter = 1;

-- Gọi thực thi liên tiếp để kiểm tra biến cộng dồn giá trị thay đổi
CALL SetCounter(@counter, 1); -- Kết quả biến tăng lên: 2
CALL SetCounter(@counter, 1); -- Kết quả biến tăng lên: 3
CALL SetCounter(@counter, 5); -- Kết quả biến tăng lên: 8

-- Hiển thị giá trị biến kết quả sau cùng ra màn hình
SELECT @counter; -- Kết quả trả về hiển thị chính xác là 8
