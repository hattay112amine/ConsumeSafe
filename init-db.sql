-- ============================================================
-- ConsumeSafe Database Initialization Script
-- ============================================================
-- Database: consumesafe
-- Character Set: utf8mb4
-- Created: 2026-01-07
-- ============================================================

USE consumesafe;

-- ============================================================
-- Create Products Table
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(500),
    category VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    barcode VARCHAR(100),
    boycotted BOOLEAN NOT NULL DEFAULT FALSE,
    boycott_reason VARCHAR(500),
    tunisian BOOLEAN NOT NULL DEFAULT FALSE,
    image_url VARCHAR(255),
    price DECIMAL(10, 2),
    details VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_boycotted (boycotted),
    INDEX idx_tunisian (tunisian),
    INDEX idx_category (category),
    FULLTEXT INDEX ft_search (name, brand, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Create Alternatives Table
-- ============================================================
CREATE TABLE IF NOT EXISTS alternatives (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    boycotted_product_id BIGINT NOT NULL,
    alternative_product_id BIGINT NOT NULL,
    reason VARCHAR(500),
    similarity_score DECIMAL(3, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (boycotted_product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (alternative_product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_boycotted_product (boycotted_product_id),
    INDEX idx_alternative_product (alternative_product_id),
    INDEX idx_similarity (similarity_score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Insert Boycotted Products
-- ============================================================
INSERT INTO products (name, description, category, brand, barcode, boycotted, boycott_reason, tunisian, image_url, price, details) VALUES
('كوكا كولا', 'مشروب غازي', 'المشروبات', 'Coca-Cola', '5449000000036', TRUE, 'شركة تدعم الاحتلال الإسرائيلي', FALSE, NULL, 2.5, 'مشروب غازي'),
('نسكافيه', 'قهوة سريعة الذوبان', 'القهوة', 'Nescafé', '7613034728899', TRUE, 'منتجات نستله تدعم الاحتلال', FALSE, NULL, 5.0, 'قهوة سريعة الذوبان'),
('منتجات ستاربكس', 'قهوة وحلويات', 'المقاهي', 'Starbucks', NULL, TRUE, 'ستاربكس تدعم سياسات الاحتلال', FALSE, NULL, 6.0, 'منتجات القهوة والحلويات'),
('بيبسي', 'مشروب غازي', 'المشروبات', 'PepsiCo', '012000003100', TRUE, 'شركة تدعم الاحتلال', FALSE, NULL, 2.5, 'مشروب غازي'),
('آيفون', 'هاتف ذكي', 'الهواتف', 'Apple', NULL, TRUE, 'شركة أمريكية تدعم الاحتلال', FALSE, NULL, 1200.0, 'هاتف ذكي فاخر');

-- ============================================================
-- Insert Tunisian Products
-- ============================================================
INSERT INTO products (name, description, category, brand, barcode, boycotted, boycott_reason, tunisian, image_url, price, details) VALUES
('قهوة الهلال التونسية', 'قهوة محلية الصنع', 'القهوة', 'الهلال', '9876543210', FALSE, NULL, TRUE, NULL, 3.5, 'قهوة تونسية عالية الجودة'),
('عصير البرتقال التونسي', 'عصير طازج', 'المشروبات', 'الصفاقسي', '1234567890', FALSE, NULL, TRUE, NULL, 2.0, 'عصير برتقال من ولاية صفاقس'),
('تمر التمرة', 'تمر جاف', 'الحلويات', 'التمرة التونسية', '5555555555', FALSE, NULL, TRUE, NULL, 15.0, 'تمر تونسي من واحات الساحل'),
('حريسة تونسية', 'معجون حار', 'التوابل', 'الأم علياء', '3333333333', FALSE, NULL, TRUE, NULL, 4.5, 'حريسة تقليدية تونسية'),
('ملوحية تونسية', 'حبوب كاملة', 'الحبوب', 'الحقل التونسي', '4444444444', FALSE, NULL, TRUE, NULL, 8.0, 'ملوحية من المناطق الشمالية'),
('زيت الزيتون التونسي', 'زيت عضوي', 'الزيوت', 'واحة التونس', '6666666666', FALSE, NULL, TRUE, NULL, 18.0, 'زيت زيتون بكر ممتاز من صفاقس'),
('عسل تونسي', 'عسل طبيعي', 'المحليات', 'نحل التونس', '7777777777', FALSE, NULL, TRUE, NULL, 25.0, 'عسل سدر من الشمال');

-- ============================================================
-- Insert Alternatives (Relations)
-- ============================================================
INSERT INTO alternatives (boycotted_product_id, alternative_product_id, reason, similarity_score) VALUES
((SELECT id FROM products WHERE name = 'كوكا كولا'), (SELECT id FROM products WHERE name = 'عصير البرتقال التونسي'), 'عصير تونسي بديل صحي', 0.85),
((SELECT id FROM products WHERE name = 'نسكافيه'), (SELECT id FROM products WHERE name = 'قهوة الهلال التونسية'), 'قهوة تونسية الصنع', 0.90),
((SELECT id FROM products WHERE name = 'منتجات ستاربكس'), (SELECT id FROM products WHERE name = 'قهوة الهلال التونسية'), 'قهوة تونسية عالية الجودة', 0.88),
((SELECT id FROM products WHERE name = 'كوكا كولا'), (SELECT id FROM products WHERE name = 'تمر التمرة'), 'حلويات صحية تونسية', 0.75),
((SELECT id FROM products WHERE name = 'بيبسي'), (SELECT id FROM products WHERE name = 'عصير البرتقال التونسي'), 'عصير تونسي طبيعي', 0.85),
((SELECT id FROM products WHERE name = 'آيفون'), (SELECT id FROM products WHERE name = 'عسل تونسي'), 'منتج تونسي جودة عالية', 0.60);

-- ============================================================
-- Create Users Table (Future use)
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Create Reviews Table (Future use)
-- ============================================================
CREATE TABLE IF NOT EXISTS reviews (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    user_id BIGINT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_product (product_id),
    INDEX idx_user (user_id),
    INDEX idx_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Create Statistics Table
-- ============================================================
CREATE TABLE IF NOT EXISTS statistics (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    total_products INT DEFAULT 0,
    total_boycotted INT DEFAULT 0,
    total_tunisian INT DEFAULT 0,
    total_searches INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Insert Initial Statistics
-- ============================================================
INSERT INTO statistics (total_products, total_boycotted, total_tunisian, total_searches) VALUES
(12, 5, 7, 0);

-- ============================================================
-- Create Views for Common Queries
-- ============================================================
CREATE OR REPLACE VIEW view_boycotted_products AS
SELECT id, name, brand, category, boycott_reason, price 
FROM products 
WHERE boycotted = TRUE 
ORDER BY name;

CREATE OR REPLACE VIEW view_tunisian_products AS
SELECT id, name, brand, category, price, details 
FROM products 
WHERE tunisian = TRUE 
ORDER BY name;

CREATE OR REPLACE VIEW view_alternatives_summary AS
SELECT 
    p1.name AS boycotted_product,
    p2.name AS tunisian_alternative,
    a.reason,
    a.similarity_score
FROM alternatives a
JOIN products p1 ON a.boycotted_product_id = p1.id
JOIN products p2 ON a.alternative_product_id = p2.id
ORDER BY a.similarity_score DESC;

-- ============================================================
-- Set Privileges for ConsumeSafe User
-- ============================================================
GRANT ALL PRIVILEGES ON consumesafe.* TO 'consumesafe'@'%';
FLUSH PRIVILEGES;

-- ============================================================
-- Display Summary
-- ============================================================
SELECT 'ConsumeSafe Database Initialized Successfully ✓' AS status;
SELECT CONCAT('Total Products: ', COUNT(*)) FROM products;
SELECT CONCAT('Boycotted Products: ', COUNT(*)) FROM products WHERE boycotted = TRUE;
SELECT CONCAT('Tunisian Products: ', COUNT(*)) FROM products WHERE tunisian = TRUE;
