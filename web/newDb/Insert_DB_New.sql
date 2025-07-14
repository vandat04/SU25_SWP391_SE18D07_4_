use CraftDB
go

INSERT INTO [dbo].[Role] (roleName, description, status)
VALUES
('User', 'Regular customer', 1),
('Seller', 'Seller or Craft Village owner', 1),
('Admin', 'System Administrator', 1);
Go

INSERT INTO [dbo].[Account] (
	userName, password, email, address, phoneNumber, status, roleID,
	isEmailVerified, lastLoginDate, loginAttempts, lockedUntil,
	avatarUrl, preferredLanguage, fullName
)
VALUES
('customer01', dbo.HashPassword('123123'), 'john.doe@example.com', 'New York, USA', '1234567890', 1, 1, 1, GETDATE(), 0, NULL, NULL, 'en', 'John Doe'),
('customer02', dbo.HashPassword('123123'), 'emma.smith@example.com', 'Los Angeles, USA', '2345678901', 1, 1, 1, GETDATE(), 0, NULL, NULL, 'en', 'Emma Smith'),
('seller01', dbo.HashPassword('123123'), 'william.brown@example.com', 'Chicago, USA', '3456789012', 1, 2, 1, GETDATE(), 0, NULL, NULL, 'en', 'Nguyen Van A'),
('seller02', dbo.HashPassword('123123'), 'molivia.jones@example.com', 'Houston, USA', '4567890123', 1, 2, 1, GETDATE(), 0, NULL, NULL, 'en', 'Nguyen Van B'),
('seller03', dbo.HashPassword('123123'), 'mwilliam.brown@example.com', 'Chicago, USA', '3456789012', 1, 2, 1, GETDATE(), 0, NULL, NULL, 'en', 'Nguyen Van C'),
('seller04', dbo.HashPassword('123123'), 'uolivia.jones@example.com', 'Houston, USA', '4567890123', 1, 2, 1, GETDATE(), 0, NULL, NULL, 'en', 'Nguyen Van D'),
('admin01', dbo.HashPassword('123123'), 'admin.taylor@example.com', 'San Francisco, USA', '5678901234', 1, 3, 1, GETDATE(), 0, NULL, NULL, 'en', 'Admin Taylor');
Go

INSERT INTO [dbo].[AccountPoints] (userID, points)
VALUES
(1, 500000),
(2, 300)
Go

INSERT INTO [dbo].[CraftType] (typeName, description, status)
VALUES
('Pottery', 'Handmade pottery products', 1),
('Weaving', 'Traditional weaving crafts', 1),
('Wood carving', 'Wood carved artworks', 1),
('Bronze Casting', 'Traditional bronze casting craft', 1);
Go

INSERT INTO [dbo].[CraftVillage] (
	typeID, villageName, description, address, latitude, longitude,
	contactPhone, contactEmail, status, clickCount, sellerId,
	openingHours, closingDays, averageRating, totalReviews, mainImageUrl,
	mapEmbedUrl, virtualTourUrl, history, specialFeatures,
	famousProducts, culturalEvents, craftProcess, videoDescriptionUrl, travelTips
)
VALUES
(1, 'Thanh Ha Pottery Village', 'Thanh Ha Pottery Village is famous for traditional pottery products with reddish brown color and elegant shapes.', 'Thanh Ha Ward, Hoi An City, Quang Nam Province', 40.7128, -74.0060, '02353912123', 'info@thanhhapottery.vn', 1, 120, 3, '08:00 - 18:00', 'Sunday', 4.5, 15, 'hinhanh/village/thanh-ha.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3837.5900332747174!2d108.29793087598922!3d15.878130184773996!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420e587421d439%3A0x73a31b4ddd945e16!2zTMOgbmcgR-G7kW0gVGhhbmggSMOg!5e0!3m2!1svi!2s!4v1752496153634!5m2!1svi!2s', NULL, 'Established in the 16th century, Thanh Ha pottery was once widely exported to many countries in Southeast Asia and beyond.', 'Reddish brown color, durable quality, and diverse shapes.', 'Pots, vases, souvenirs.', 'Thanh Ha Pottery Festival held every year in March', 'Mixing clay, shaping, and firing at high temperature.', NULL, 'Best visited in dry season for comfortable weather.'),

(2, 'Ma Chau Embroidery Village',
 'Ma Chau Village is renowned for exquisite embroidery, creating high-quality textile artworks.', 'Nam Phuoc Town, Duy Xuyen District, Quang Nam Province', 15.8140, 108.2205,
 '02353957433', 'info@machauembroidery.vn', 4, 70, 2, '08:30 - 18:30', 'Tuesday', 4.9, 25, 'hinhanh/village/ma-chau.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d122834.73113640549!2d108.10471773147582!3d15.825803380442343!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x314209e5faf384bb%3A0xa9ccb037584ef07a!2zTOG7pWEgTcOjIENow6J1IChNYSBDaGF1IFNpbGsgdmlsbGFnZSk!5e0!3m2!1svi!2s!4v1752496398663!5m2!1svi!2s', NULL,
 'The craft of embroidery in Ma Chau has existed for over 400 years, famous for high-quality silk threads and fine craftsmanship.', 'Sophisticated patterns, diverse color schemes, and high precision.', 'Decorative cloths, paintings, traditional costumes.', 'Embroidery Week showcasing artists’ works.', 'Stitching silk threads on cloth to create delicate images.', NULL, 'Great place to buy unique souvenirs.'),

(3, 'Kim Bong Wood Carving Village',
 'Kim Bong Village is famous for wood carving products, especially architectural and decorative items.',
 'Cam Kim Commune, Hoi An City, Quang Nam Province',
 15.8750, 108.3306,
 '02353934321', 'hello@kimbongwood.vn',
 1, 95, 5,
 '07:00 - 19:00', 'Saturday',
 4.2, 10, 'hinhanh/village/kim-bong.jpg',
  'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3837.8371156260714!2d108.32165507598914!3d15.865155984785243!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420f8ac65ddd09%3A0xdd301bcd3fa4019f!2zTMOgbmcgbeG7mWMgS2ltIELhu5NuZw!5e0!3m2!1svi!2s!4v1752496971634!5m2!1svi!2s', NULL,
 'Established in the 16th century, Kim Bong artisans contributed to the architecture of ancient Hoi An.',
 'Intricate details, delicate lines, and durable materials.',
 'Wooden statues, furniture, and architectural decor.',
 'Wood Carving Competition held every year.',
 'Chiseling, carving, and finishing with traditional techniques.',
 NULL, 'Wear comfortable shoes as the village streets are narrow.'),


(4, 'Phuoc Kieu Bronze Casting Village',
 'Phuoc Kieu is a long-standing bronze casting village specializing in products like bells, gongs, and statues.', 'Dien Phuong Commune, Dien Ban Town, Quang Nam Province', 15.8975, 108.2170, '02353944222', 'contact@phuockieu.vn', 1, 65, 6, '09:00 - 18:00', 'Wednesday', 4.3, 12, 'hinhanh/village/phuoc-kieu.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3837.7681290258934!2d108.25876437598917!3d15.868779484782014!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420f72a9ed5293%3A0xa3146eef15a8950!2zTMOgbmcgxJHDumMgxJHhu5NuZyBQaMaw4bubYyBLaeG7gXU!5e0!3m2!1svi!2s!4v1752496582124!5m2!1svi!2s', NULL, 'Founded in the early 17th century, Phuoc Kieu artisans supplied bronze items for temples, pagodas, and the royal court.', 'Solid and resonant bronze sound, precise casting techniques.', 'Gongs, bells, statues, decorative items.', 'Bronze Casting Festival held annually.', 'Melting bronze, pouring into molds, and finishing.', NULL, 'Check festival schedule for a lively visit.');
Go

INSERT INTO [dbo].[VillageImage] (villageID, imageUrl, isMain)
VALUES
(1, 'hinhanh/village/thanh-ha1.jpg', 1),
(1, 'hinhanh/village/ma-chau1.jpg', 0),
(2, 'hinhanh/village/kim-bong1.jpg', 1),
(3, 'hinhanh/village/thanh-ha1.jpg', 1),
(4, 'hinhanh/village/phuc-kieu1.jpg', 1);
Go

INSERT INTO [dbo].[VillageReview] (villageID, userID, rating, reviewText)
VALUES
(1, 1, 5, 'Amazing pottery village with beautiful products.'),
(2, 2, 4, 'High quality silk. Worth visiting.'),
(3, 1, 3, 'Nice carvings but fewer products.'),
(4, 2, 5, 'Excellent embroidery work!'),
(1, 1, 4, 'Lacquer products are impressive.');
Go

INSERT INTO [dbo].[TicketType] (typeName, description, ageRange, status)
VALUES
('Adult', 'For adults above 18', '18+', 1),
('Child', 'For children below 12', '0-12', 1),
('Senior', 'For seniors above 60', '60+', 1),
('Student', 'For students with ID', '13-25', 1),
('Family Pack', 'Special price for families (3 Adult - 2 Child)', 'All ages', 1);
go

INSERT INTO [dbo].[VillageTicket] (villageID, typeID, price, status)
VALUES
(1, 1, 10.00, 1),
(1, 2, 5.00, 1),
(2, 1, 12.00, 1),
(3, 1, 8.00, 1),
(4, 3, 6.50, 1);

INSERT INTO [dbo].[ProductCategory] (categoryName, description, status)
VALUES
('Home Decor', 'Decorative items for home', 1),
('Fashion Accessories', 'Scarves, hats, jewelry', 1),
('Tableware', 'Plates, bowls, cups', 1),
('Artwork', 'Paintings, sculptures', 1),
('Gift Items', 'Gifts and souvenirs', 1);
go

INSERT INTO [dbo].[Product] (
	name, price, description, stock, status, villageID,
	categoryID, mainImageUrl, craftTypeID, sku, weight, dimensions,
	materials, careInstructions, warranty, averageRating, totalReviews, modelFile
)
VALUES
('Ceramic teapot', 25.50, 'Handmade blue pottery vase.', 50, 1, 1, 1, 'hinhanh/product/ceramic-teapot.jpg', 1, 'BPV001', 1.20, '20x10 cm', 'Clay', 'Clean with dry cloth.', '6 months', 4.8, 10, 'hinhanh/model/ceramic-teapot.glb'),
('Taffeta silk', 35.00, 'Soft silk scarf in red.', 100, 1, 2, 2, 'hinhanh/product/taffeta-silk.jpg', 2, 'SS002', 0.20, '150x30 cm', 'Silk', 'Hand wash only.', '3 months', 4.7, 15, 'hinhanh/model/taffeta-silk.glb'),
('Four sacred animals: Dragon - Unicorn - Turtle - Phoenix', 55.75, 'Beautiful wood carving.', 20, 1, 3, 4, 'hinhanh/product/four-sacred-animal.jpg', 3, 'WS003', 2.50, '30x15 cm', 'Wood', 'Keep away from water.', '12 months', 4.5, 5,  'hinhanh/model/four-sacred-animal.glb'),
('Bronze Bell', 28.90, 'Glossy lacquer serving tray.', 60, 1, 4, 3, 'hinhanh/product/bronze-bell.jpg', 4, 'LT005', 1.00, '35x25 cm', 'Wood, lacquer', 'Wipe with soft cloth.', '9 months', 4.6, 12, 'hinhanh/model/bronze-bell.glb');
go

INSERT INTO [dbo].[ProductImage] (productID, imageUrl, isMain)
VALUES
(1, 'hinhanh/product/ceramic-teapot1.jpg', 0),
(2, 'hinhanh/product/taffeta-silk1.jpg', 0),
(3, 'hinhanh/product/four-sacred-animal1.jpg', 0),
(4, 'hinhanh/product/bronze-bell1.jpg', 0);
go

INSERT INTO [dbo].[ProductReview] (productID, userID, rating, reviewText)
VALUES
(1, 1, 5, 'Absolutely stunning vase.'),
(2, 2, 4, 'Lovely scarf and soft material.'),
(3, 1, 3, 'Good carving but a bit pricey.'),
(4, 2, 5, 'Beautiful embroidery details.'),
(1, 1, 4, 'Nice tray for serving guests.');
go

INSERT INTO [dbo].[NotificationType] (typeName)
VALUES
('Order Update'),
('New Message'),
('Promotion'),
('System Alert'),
('Review Reminder');
go