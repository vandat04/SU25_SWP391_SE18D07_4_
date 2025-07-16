USE [CraftDB]
GO

INSERT INTO [dbo].[Role] (roleName, description, status)
VALUES
('User', 'Regular customer', 1),
('Seller', 'Seller or Craft Village owner', 1),
('Admin', 'System Administrator', 1);
GO

INSERT INTO [dbo].[Account] (
    userName, password, email, address, phoneNumber, status, roleID,
    isEmailVerified, lastLoginDate, loginAttempts, lockedUntil,
    avatarUrl, preferredLanguage, fullName
)
VALUES
-- Customers
('customer01', dbo.HashPassword('123123'), 'john.doe@example.com', 'New York, USA', '1234567890', 1, 1, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/customer01', 'en', 'John Doe'),
('customer02', dbo.HashPassword('123123'), 'emma.smith@example.com', 'Los Angeles, USA', '2345678901', 1, 1, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/customer02', 'en', 'Emma Smith'),
-- Sellers for each CraftVillage
('seller01', dbo.HashPassword('123123'), 'seller01@village.com', 'Hoi An, Quang Nam', '1111111111', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller01', 'en', 'Nguyen Van A'),
('seller02', dbo.HashPassword('123123'), 'seller02@village.com', 'Nam Phuoc, Quang Nam', '2222222222', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller02', 'en', 'Nguyen Van B'),
('seller03', dbo.HashPassword('123123'), 'seller03@village.com', 'Cam Kim, Quang Nam', '3333333333', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller03', 'en', 'Nguyen Van C'),
('seller04', dbo.HashPassword('123123'), 'seller04@village.com', 'Dien Ban, Quang Nam', '4444444444', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller04', 'en', 'Nguyen Van D'),
('seller05', dbo.HashPassword('123123'), 'seller05@village.com', 'Lien Chieu, Da Nang', '5555555555', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller05', 'en', 'Nguyen Van E'),
('seller06', dbo.HashPassword('123123'), 'seller06@village.com', 'Ngu Hanh Son, Da Nang', '6666666666', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller06', 'en', 'Nguyen Van F'),
('seller07', dbo.HashPassword('123123'), 'seller07@village.com', 'Cam Ha, Quang Nam', '7777777777', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller07', 'en', 'Nguyen Van G'),
('seller08', dbo.HashPassword('123123'), 'seller08@village.com', 'Duy Xuyen, Quang Nam', '8888888888', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller08', 'en', 'Nguyen Van H'),
('seller09', dbo.HashPassword('123123'), 'seller09@village.com', 'Hoi An, Quang Nam', '9999999999', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller09', 'en', 'Nguyen Van I'),
-- Admin
('admin01', dbo.HashPassword('123123'), 'admin.taylor@example.com', 'San Francisco, USA', '5678901234', 1, 3, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/admin01', 'en', 'Admin Taylor');
GO

INSERT INTO [dbo].[CraftType] (typeName, description, status)
VALUES
('Pottery', 'Handmade pottery products', 1),
('Weaving', 'Traditional weaving crafts', 1),
('Wood carving', 'Wood carved artworks', 1),
('Bronze Casting', 'Traditional bronze casting craft', 1),
('Food Production', 'Traditional food making villages.', 1),
('Stone Carving', 'Stone sculpture and fine art stone works.', 1),
('Agriculture', 'Organic vegetable villages and eco-tourism.', 1),
('Bamboo Craft', 'Making lanterns and bamboo products.', 1);
GO

INSERT INTO [dbo].[CraftVillage] (
    typeID, villageName, description, address, latitude, longitude,
    contactPhone, contactEmail, status, clickCount, sellerId,
    openingHours, closingDays, averageRating, totalReviews, mainImageUrl,
    mapEmbedUrl, virtualTourUrl, history, specialFeatures,
    famousProducts, culturalEvents, craftProcess, videoDescriptionUrl, travelTips
)
VALUES
(1, 'Thanh Ha Pottery Village', 'Thanh Ha Pottery Villageis a traditional craft village located about 3 km west of Hoi An Ancient Town, along the Thu Bồn River. Established in the 16th century by artisans from Thanh Hóa, it has preserved its pottery-making heritage for over 500 years. The village is known for handmade, unglazed ceramics shaped by foot-powered wheels and fired in wood kilns.', 'Thanh Ha Ward, Hoi An, Quang Nam', 15.8781, 108.2979, '02353912123', 'info@thanhha.vn', 1, 120, 3, '08:00 - 18:00', 'Sunday', 4.5, 15, 'hinhanh/village/thanh-ha.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3837.590033274716!2d108.29793087495084!3d15.87813018477406!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420e587421d439%3A0x73a31b4ddd945e16!2zTMOgbmcgR-G7kW0gVGhhbmggSMOg!5e0!3m2!1svi!2s!4v1752625008232!5m2!1svi!2s', NULL, 'Established in the 16th century.', 'Reddish brown color.', 'Pots, vases.', 'Pottery Festival.', 'Mixing clay.', NULL, 'Visit in dry season.'),

(2, 'Ma Chau Embroidery Village', ' Ma Chau Silk Village in Duy Xuyen District, Quang Nam, about 10km from Hoi An, is famous for its traditional silk weaving craft that dates back to the 15th century. In the past, Ma Chau silk was used in the royal court and for export. After a period of decline, the silk weaving craft here is being restored thanks to the dedication of local artisans. Coming to Ma Chau, visitors will witness the silk production process from raising silkworms, spinning silk to weaving, and can buy sophisticated handmade products that are imbued with Vietnamese cultural identity..', 'Nam Phuoc, Duy Xuyen, Quang Nam', 15.8140, 108.2205, '02353957433', 'info@machau.vn', 1, 70, 4, '08:30 - 18:30', 'Tuesday', 4.9, 25, 'hinhanh/village/ma-chau.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3838.5852567749776!2d108.25457447494958!3d15.825808184818932!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x314209e5faf384bb%3A0xa9ccb037584ef07a!2zTOG7pWEgTcOjIENow6J1IChNYSBDaGF1IFNpbGsgdmlsbGFnZSk!5e0!3m2!1svi!2s!4v1752625083407!5m2!1svi!2s', NULL, 'Over 400 years old.', 'High quality silk.', 'Embroidered products.', 'Embroidery Week.', 'Silk stitching.', NULL, 'Good for souvenirs.'),

(3, 'Kim Bong Wood Carving Village', 'Kim Bong carpentry village is located in Cam Kim commune, Hoi An, famous since the 15th century for its traditional carpentry. The artisans here once participated in the construction of famous works such as the Japanese Covered Bridge and the Hue Royal Palace. The village still maintains the craft of making fine art wooden furniture, interiors and sophisticated wood carvings. Visitors can come here to watch carpentry performances, experience carving and buy unique handicrafts. Kim Bong is an attractive cultural destination, bearing the mark of traditional crafts and the talent of Quang carpenters.', 'Cam Kim, Hoi An, Quang Nam', 15.8750, 108.3306, '02353934321', 'hello@kimbong.vn', 1, 95, 5, '07:00 - 19:00', 'Saturday', 4.2, 10, 'hinhanh/village/kim-bong.jpg', NULL, 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3837.8295580250765!2d108.32252547495052!3d15.865552984784818!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420f650a3b5be1%3A0xfeb8f439bb63fa5a!2zVHXhuqVuIFRy4bqnbiAtIE3hu5ljIEtpbSBC4buTbmcgLSBDYXJwZW50cnkgdmlsbGFnZQ!5e0!3m2!1svi!2s!4v1752625181428!5m2!1svi!2s', 'Since the 16th century.', 'Intricate carvings.', 'Wood statues.', 'Wood Carving Competition.', 'Chiseling wood.', NULL, 'Wear comfortable shoes.'),

(4, 'Phuoc Kieu Bronze Casting Village', 'Phuoc Kieu bronze casting village (Dien Phuong commune, Dien Ban, Quang Nam), about 10km from Hoi An, is a traditional bronze casting village with a history of over 400 years. In the past, it specialized in producing weapons, coins, gongs, and bells for the Nguyen and Tay Son dynasties. Today, it is famous for its bronze trumpets, gongs, incense burners, and Buddha statues. Visitors can watch the casters melt bronze, pour molds, and fine-tune the sound of gongs. The craft has now been revived by more than 20 households, keeping the traditional fire alive, combining production with experiential tourism.', 'Dien Phuong, Dien Ban, Quang Nam', 15.8975, 108.2170, '02353944222', 'contact@phuockieu.vn', 1, 65, 6, '09:00 - 18:00', 'Wednesday', 4.3, 12, 'hinhanh/village/phuoc-kieu.jpg', '<https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3837.7681290259015!2d108.25876437495057!3d15.868779484782042!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420f72a9ed5293%3A0xa3146eef15a8950!2zTMOgbmcgxJHDumMgxJHhu5NuZyBQaMaw4bubYyBLaeG7gXU!5e0!3m2!1svi!2s!4v1752625247939!5m2!1svi!2s', NULL, 'Founded in the 17th century.', 'Resonant bronze.', 'Gongs, bells.', 'Bronze Festival.', 'Melting bronze.', NULL, 'Check festival schedule.'),

(5, 'Nam O Fish Sauce Village', 'Nam O fish sauce village is located in Lien Chieu district, Da Nang, with a history of more than 400 years, famous for its traditional fish sauce making. The main ingredients are anchovies combined with refined salt, fermented for 12-18 months in jackfruit wood jars, producing a fish sauce with a cockroach brown color and a distinctive rich flavor. Nam O fish sauce making is recognized as a national intangible cultural heritage. Visitors can visit the production process, learn about the traditional craft and buy pure fish sauce as gifts.', 'Nam Ô, Lien Chieu, Da Nang', 16.1005, 108.1263, '02363812345', 'info@namofishsauce.vn', 1, 80, 7, '07:30 - 17:30', 'Monday', 4.6, 20, 'hinhanh/village/nam-o.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d61333.69947978204!2d108.06355037272064!3d16.09886348441691!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31421fe5d9c9ec2d%3A0xdaf04b88490d22d5!2zTsaw4bubYyBt4bqvbSBOYW0gw5QgLSBIxrDGoW5nIEzDoG5nIEPhu5U!5e0!3m2!1svi!2s!4v1752625358403!5m2!1svi!2s', NULL, 'Over 400 years old.', 'Strong aroma.', 'Fish sauce.', 'Fish Sauce Festival.', 'Fermenting fish.', NULL, 'Visit in dry season.'),

(6, 'Non Nuoc Stone Carving Village', 'Non Nuoc Stone Village, located at the foot of Ngu Hanh Son, Da Nang, is a famous stone carving village with more than 300 years of history. Established in the late 18th century, the village specializes in making Buddha statues, mascots, stone steles, decorations... from natural stone. In 2014, the village was recognized as a National Intangible Cultural Heritage. Coming here, visitors can see the art of stone carving directly, visit wood products and buy exquisite handicrafts that bring spiritual, artistic and traditional cultural values to the Chinese region.', 'Hoa Hai, Ngu Hanh Son, Da Nang', 16.0033, 108.2637, '02363856789', 'contact@nonnuocstone.vn', 1, 150, 8, '08:00 - 18:00', 'Sunday', 4.8, 32, 'hinhanh/village/non-nuoc.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3835.2813406931505!2d108.26095527495339!3d15.998863384670448!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x314211003a1dafdd%3A0xdb25a0578e5d5a27!2sNon%20Nuoc%20Stone%20Carving%20Village!5e0!3m2!1svi!2s!4v1752625533135!5m2!1svi!2s' , NULL, 'Over 400 years old.', 'Marble statues.', 'Sculptures.', 'Stone Festival.', 'Carving marble.', NULL, 'Wear sun protection.'),

(7, 'Tra Que Vegetable Village', 'Tra Que Vegetable Village, Cam Ha Commune, Hoi An, about 3km from the center, stands out with more than 40 hectares of 20-40 types of clean vegetables and spices grown in rotation according to traditional organic methods using seaweed fertilizer from Co Co lagoon. The village has a history of nearly 400 years, Tra Que vegetables are considered typical ingredients in Quang Nam cuisine such as Quang noodles and Hoi An bread. Entrance tickets are only about 20,000-35,000 VND/person, including farm experience, cooking and herbal foot bath activities. Visitors can learn how to grow, plant, pick vegetables, participate in local cooking classes and enjoy the peaceful village atmosphere.', 'Cam Ha, Hoi An, Quang Nam', 15.9090, 108.3271, '02353999999', 'hello@traque.vn', 1, 45, 9, '06:00 - 18:00', 'Friday', 4.5, 10, 'hinhanh/village/tra-que.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d30700.788967134486!2d108.31484355318247!3d15.877679425537984!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420de155207241%3A0xb084a84384f41fbf!2sTRA%20QUE%20VEGETABLE%20VILLAGE%20-Nh%C3%A0%20h%C3%A0ng%20Tra%20Que%20Organic!5e0!3m2!1svi!2s!4v1752625417449!5m2!1svi!2s', NULL, 'Over 300 years old.', 'Organic vegetables.', 'Herbs, veggies.', 'Vegetable tours.', 'Farming activities.', NULL, 'Visit early morning.'),

(2, 'Ban Thach Mat Weaving Village', 'Coi Ban Thach Mat Village (Ban Thach Mat Village) is located in Duy Vinh Commune, Duy Xuyen District, Quang Nam, about 6km from Hoi An. The craft of weaving mats from water hyacinth has a history of more than 300-500 years, brought by migrants from Thanh Hoa. Hand-woven mats go through the following steps: harvesting grass, drying for 4-5 days, dyeing naturally and weaving by two artisans with bamboo and wooden frames, creating sophisticated patterns without printed patterns.', 'Duy Vinh, Duy Xuyen, Quang Nam', 15.8476, 108.2789, '02353888888', 'contact@banthach.vn', 1, 60, 10, '07:30 - 17:00', 'Sunday', 4.4, 18, 'hinhanh/village/ban-thach.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d15352.542348807636!2d108.32518099702112!3d15.849469556775533!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420d90505b41f9%3A0x4d39caee3e344d5f!2zV0VBVklORyBNQVQgVFJBRElUSU9OQUwtIEThu4d0IENoaeG6v3UgVHJ1eeG7gW4gVGjhu5FuZyBCw6AgOA!5e0!3m2!1svi!2s!4v1752625577221!5m2!1svi!2s', NULL, 'Since the 18th century.', 'Colorful patterns.', 'Rush mats.', 'Mat competitions.', 'Weaving rush.', NULL, 'Wear light clothes.'),

(8, 'Hoi An Lantern Village', 'Hoi An Lantern Village, located near the old town on the banks of the Thu Bon River, is a cultural highlight with a history of more than 400 years. This craft was formed in the 16th-17th centuries, when the Chinese and Japanese contributed lantern-making techniques. Currently, the village has about 40 workshops with 200 artisans, specializing in producing bamboo lanterns, hanging frames and covering them with colorful natural fabrics. Every full moon night (14th lunar month), the old town turns off the lights, thousands of lanterns are lit, visitors release flower lanterns on the river and watch folk performances. Here, you can join a lantern-making class, buy handmade products and bring home unique memories.', 'Hoi An, Quang Nam', 15.8794, 108.3343, '02353777777', 'info@hoianlanterns.vn', 1, 130, 11, '09:00 - 21:00', 'Monday', 4.9, 40, 'hinhanh/village/lantern.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d61400.2857377966!2d108.26462144863277!3d15.881918099999991!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1a1f6cb50a73e55%3A0xfb35692b84a2101a!2sHoi%20An%20Lantern%20Company!5e0!3m2!1svi!2s!4v1752625726520!5m2!1svi!2s', NULL, 'From the 16th century.', 'Colorful lanterns.', 'Lanterns.', 'Lantern Festival.', 'Making bamboo frames.', NULL, 'Best at night.');
GO

INSERT INTO [dbo].[VillageImage] (villageID, imageUrl, isMain)
VALUES
(1, 'hinhanh/village/thanh-ha1.jpg', 1),
(2, 'hinhanh/village/ma-chau1.jpg', 1),
(3, 'hinhanh/village/kim-bong1.jpg', 1),
(4, 'hinhanh/village/phuoc-kieu1.jpg', 1),
(5, 'hinhanh/village/nam-o1.jpg', 1),
(6, 'hinhanh/village/non-nuoc1.jpg', 1),
(7, 'hinhanh/village/tra-que1.jpg', 1),
(8, 'hinhanh/village/ban-thach1.jpg', 1),
(9, 'hinhanh/village/lantern1.jpg', 1);
GO

INSERT INTO [dbo].[VillageReview] (villageID, userID, rating, reviewText)
VALUES
(1, 1, 5, 'Amazing pottery village with beautiful products.'),
(2, 2, 4, 'High quality silk embroidery. Worth visiting.'),
(3, 1, 4, 'Exquisite wood carvings and sculptures.'),
(4, 2, 5, 'Excellent bronze casting works!'),
(5, 1, 5, 'The fish sauce here is incredible. Very rich taste.'),
(6, 2, 4, 'Magnificent marble sculptures at Non Nuoc.'),
(7, 1, 5, 'Loved the fresh vegetables and eco-tourism experience.'),
(8, 2, 4, 'Colorful and high-quality woven mats.'),
(9, 1, 5, 'Lanterns are magical at night. Beautiful colors!');
GO

INSERT INTO [dbo].[ProductCategory] (categoryName, description, status)
VALUES
('Home Decor', 'Decorative items for home', 1),
('Fashion Accessories', 'Scarves, hats, jewelry', 1),
('Tableware', 'Plates, bowls, cups', 1),
('Artwork', 'Paintings, sculptures', 1),
('Gift Items', 'Gifts and souvenirs', 1),
('Food Products', 'Traditional food items', 1);
GO

INSERT INTO [dbo].[Product] (
    name, price, description, stock, status, villageID,
    categoryID, mainImageUrl, craftTypeID, sku, weight, dimensions,
    materials, careInstructions, warranty, averageRating, totalReviews, modelFile
)
VALUES
-- Thanh Ha Pottery
('Ceramic Teapot', 255000, 'Handmade blue pottery teapot.', 50, 1, 1, 1, 'hinhanh/product/ceramic-teapot.jpg', 1, 'BPV001', 1.20, '20x10 cm', 'Clay', 'Clean with dry cloth.', '6 months', 4.8, 10, 'hinhanh/model/ceramic-teapot.glb'),
('Ceramic Bowl', 12500000, 'Handmade ceramic bowl.', 80, 1, 1, 1, 'hinhanh/product/ceramic-bowl.jpg', 1, 'CB001', 0.45, '15x7 cm', 'Clay', 'Hand wash.', '6 months', 4.6, 8, 'hinhanh/model/ceramic-bowl.glb'),

-- Ma Chau Embroidery
('Taffeta Silk', 3500000, 'Soft silk scarf.', 100, 1, 2, 2, 'hinhanh/product/taffeta-silk.jpg', 2, 'SS002', 0.20, '150x30 cm', 'Silk', 'Hand wash.', '3 months', 4.7, 15, 'hinhanh/model/taffeta-silk.glb'),
('Embroidered Silk Scarf', 4200000, 'Silk scarf with embroidery.', 90, 1, 2, 2, 'hinhanh/product/embroidered-scarf.jpg', 2, 'ES001', 0.15, '160x30 cm', 'Silk', 'Hand wash only.', '3 months', 4.8, 10, 'hinhanh/model/embroidered-scarf.glb'),

-- Kim Bong Wood Carving
('Four Sacred Animals Carving', 5575000, 'Beautiful wood carving.', 20, 1, 3, 3, 'hinhanh/product/four-sacred-animal.jpg', 3, 'WS003', 2.50, '30x15 cm', 'Wood', 'Keep dry.', '12 months', 4.5, 5, 'hinhanh/model/four-sacred-animal.glb'),
('Wooden Buddha Statue', 6000000, 'Hand-carved Buddha.', 30, 1, 4, 3, 'hinhanh/product/wooden-buddha.jpg', 3, 'WB001', 1.50, '25x15 cm', 'Wood', 'Keep away from moisture.', '12 months', 4.6, 14, 'hinhanh/model/wooden-buddha.glb'),

-- Phuoc Kieu Bronze
('Bronze Bell', 2890000, 'Glossy lacquer serving tray.', 60, 1, 4, 4, 'hinhanh/product/bronze-bell.jpg', 4, 'LT005', 1.00, '35x25 cm', 'Wood, lacquer', 'Wipe with soft cloth.', '9 months', 4.6, 12, 'hinhanh/model/bronze-bell.glb'),
('Bronze Drum Replica', 12000000, 'Replica of Dong Son drum.', 10, 1, 4, 4, 'hinhanh/product/bronze-drum.jpg', 4, 'BD001', 2.80, '30x30 cm', 'Bronze', 'Wipe gently.', '24 months', 4.9, 5, 'hinhanh/model/bronze-drum.glb'),

-- Nam Ô Fish Sauce
('Premium Fish Sauce Bottle', 950000, 'Premium fish sauce.', 200, 1, 6, 5, 'hinhanh/product/fish-sauce.jpg', 5, 'FS001', 0.50, '20x5 cm', 'Fish, salt', 'Store cool.', '12 months', 4.8, 18, 'hinhanh/model/fish-sauce.glb'),

-- Non Nuoc Stone
('Marble Lion Sculpture', 25000000, 'Marble lion statue.', 5, 1, 4, 6, 'hinhanh/product/marble-lion.jpg', 6, 'ML002', 12.0, '60x30 cm', 'Marble', 'Keep dry.', '24 months', 5.0, 3, 'hinhanh/model/marble-lion.glb'),

-- Lantern Village
('Silk Lantern', 1500000, 'Handmade silk lantern.', 100, 1, 5, 1, 'hinhanh/product/silk-lantern.jpg', 8, 'LN001', 0.30, '40x20 cm', 'Silk, Bamboo', 'Avoid rain.', '6 months', 4.8, 12, 'hinhanh/model/silk-lantern.glb');
GO

INSERT INTO [dbo].[ProductImage] (productID, imageUrl, isMain)
VALUES
(1, 'hinhanh/product/ceramic-teapot1.jpg', 0),
(2, 'hinhanh/product/ceramic-bowl1.jpg', 0),
(3, 'hinhanh/product/taffeta-silk1.jpg', 0),
(4, 'hinhanh/product/embroidered-scarf1.jpg', 0),
(5, 'hinhanh/product/four-sacred-animal1.jpg', 0),
(6, 'hinhanh/product/wooden-buddha1.jpg', 0),
(7, 'hinhanh/product/bronze-bell1.jpg', 0),
(8, 'hinhanh/product/bronze-drum1.jpg', 0),
(9, 'hinhanh/product/fish-sauce1.jpg', 0),
(10, 'hinhanh/product/marble-lion1.jpg', 0),
(11, 'hinhanh/product/silk-lantern1.jpg', 0);
GO

INSERT INTO [dbo].[ProductReview] (productID, userID, rating, reviewText)
VALUES
(1, 1, 5, 'Absolutely stunning teapot.'),
(2, 2, 4, 'Very nice ceramic bowl.'),
(3, 1, 5, 'Soft silk and elegant color.'),
(4, 2, 5, 'Gorgeous embroidery details.'),
(5, 1, 4, 'Wood carving is beautiful.'),
(6, 2, 4, 'Impressive wooden statue.'),
(7, 1, 5, 'Shiny and high quality.'),
(8, 2, 5, 'Amazing bronze drum replica.'),
(9, 1, 5, 'Best fish sauce ever.'),
(10, 2, 5, 'Stunning marble sculpture.'),
(11, 1, 5, 'Lanterns look magical when lit.');
GO

INSERT INTO [dbo].[NotificationType] (typeName)
VALUES
('Order Update'),
('New Message'),
('Promotion'),
('System Alert'),
('Review Reminder');
GO

INSERT INTO [dbo].[TicketType] (typeName, description, ageRange, status)
VALUES
('Adult', 'For adults above 18', '18+', 1),
('Child', 'For children below 12', '0-12', 1),
('Senior', 'For seniors above 60', '60+', 1),
('Student', 'For students with ID', '13-25', 1),
('Family Pack', 'Special price for families', 'All ages', 1);
GO

INSERT INTO [dbo].[VillageTicket] (villageID, typeID, price, status)
VALUES
(1, 1, 10.00, 1),
(1, 2, 5.00, 1),
(2, 1, 12.00, 1),
(3, 1, 8.00, 1),
(4, 3, 6.50, 1),
(5, 1, 7.50, 1),
(6, 1, 10.00, 1),
(9, 1, 15.00, 1);
GO

INSERT INTO [dbo].[TicketAvailability] 
(ticketID, availableDate, totalSlots, bookedSlots, availableSlots, status)
VALUES
(1, '2025-07-16', 100, 20, 80, 1),
(2, '2025-07-16', 50, 10, 40, 1),
(3, '2025-07-16', 80, 20, 60, 1),
(4, '2025-07-16', 60, 10, 50, 1),
(5, '2025-07-16', 30, 5, 25, 1);
GO