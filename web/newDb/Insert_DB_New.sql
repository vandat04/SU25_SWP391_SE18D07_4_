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
('seller01', dbo.HashPassword('123123'), 'seller01@village.com', 'Hoi An, Quang Nam', '1111111111', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller01', 'en', 'Nguyen Hao'),
('seller02', dbo.HashPassword('123123'), 'seller02@village.com', 'Nam Phuoc, Quang Nam', '0979003511', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller02', 'en', 'Tran Huu Phuong'),
('seller03', dbo.HashPassword('123123'), 'seller03@village.com', 'Cam Kim, Quang Nam', '0763441179', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller03', 'en', 'Huynh Ri'),
('seller04', dbo.HashPassword('123123'), 'seller04@village.com', 'Dien Ban, Quang Nam', '0919432267', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller04', 'en', 'Dong Phuoc Kieu Company'),
('seller05', dbo.HashPassword('123123'), 'seller05@village.com', 'Lien Chieu, Da Nang', '0935998908', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller05', 'en', 'Nam O Fish Sauce Village Association'),
('seller06', dbo.HashPassword('123123'), 'seller06@village.com', 'Ngu Hanh Son, Da Nang', '0935961168', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller06', 'en', 'Luu Van Tam Anh'),
('seller07', dbo.HashPassword('123123'), 'seller07@village.com', 'Cam Ha, Quang Nam', '0911381626', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller07', 'en', 'Farming community in Tra Que'),
('seller08', dbo.HashPassword('123123'), 'seller08@village.com', 'Duy Xuyen, Quang Nam', '0355861710', 1, 2, 1, GETDATE(), 0, NULL, 'hinhanh/avatar/seller08', 'en', 'Vo Ngoc Thai'),
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
(1, 'Thanh Ha Pottery Village', 'Thanh Ha Pottery Villageis a traditional craft village located about 3 km west of Hoi An Ancient Town, along the Thu Bồn River. Established in the 16th century by artisans from Thanh Hóa, it has preserved its pottery-making heritage for over 500 years. The village is known for handmade, unglazed ceramics shaped by foot-powered wheels and fired in wood kilns.', 'Thanh Ha Ward, Hoi An, Quang Nam', 15.8781, 108.2979, '02353912123', 'info@thanhha.vn', 1, 120, 3, '08:00 - 18:00', 'Sunday', 4.5, 15, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927452/thanh-ha_r92wbj.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3837.590033274716!2d108.29793087495084!3d15.87813018477406!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420e587421d439%3A0x73a31b4ddd945e16!2zTMOgbmcgR-G7kW0gVGhhbmggSMOg!5e0!3m2!1svi!2s!4v1752625008232!5m2!1svi!2s', NULL, 'Established in the 16th century.', 'Reddish brown color.', 'Pots, vases.', 'Pottery Festival.', 'Mixing clay.', NULL, 'Visit in dry season.'),

(2, 'Ma Chau Embroidery Village', ' Ma Chau Silk Village in Duy Xuyen District, Quang Nam, about 10km from Hoi An, is famous for its traditional silk weaving craft that dates back to the 15th century. In the past, Ma Chau silk was used in the royal court and for export. After a period of decline, the silk weaving craft here is being restored thanks to the dedication of local artisans. Coming to Ma Chau, visitors will witness the silk production process from raising silkworms, spinning silk to weaving, and can buy sophisticated handmade products that are imbued with Vietnamese cultural identity..', 'Nam Phuoc, Duy Xuyen, Quang Nam', 15.8140, 108.2205, '02353957433', 'info@machau.vn', 1, 70, 4, '08:30 - 18:30', 'Tuesday', 4.9, 25, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927451/ma-chau_e0qyg1.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3838.5852567749776!2d108.25457447494958!3d15.825808184818932!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x314209e5faf384bb%3A0xa9ccb037584ef07a!2zTOG7pWEgTcOjIENow6J1IChNYSBDaGF1IFNpbGsgdmlsbGFnZSk!5e0!3m2!1svi!2s!4v1752625083407!5m2!1svi!2s', NULL, 'Over 400 years old.', 'High quality silk.', 'Embroidered products.', 'Embroidery Week.', 'Silk stitching.', NULL, 'Good for souvenirs.'),

(3, 'Kim Bong Wood Carving Village', 'Kim Bong carpentry village is located in Cam Kim commune, Hoi An, famous since the 15th century for its traditional carpentry. The artisans here once participated in the construction of famous works such as the Japanese Covered Bridge and the Hue Royal Palace. The village still maintains the craft of making fine art wooden furniture, interiors and sophisticated wood carvings. Visitors can come here to watch carpentry performances, experience carving and buy unique handicrafts. Kim Bong is an attractive cultural destination, bearing the mark of traditional crafts and the talent of Quang carpenters.', 'Cam Kim, Hoi An, Quang Nam', 15.8750, 108.3306, '02353934321', 'hello@kimbong.vn', 1, 95, 5, '07:00 - 19:00', 'Saturday', 4.2, 10, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927450/kim-bong_kyl350.jpg', NULL, 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3837.8295580250765!2d108.32252547495052!3d15.865552984784818!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420f650a3b5be1%3A0xfeb8f439bb63fa5a!2zVHXhuqVuIFRy4bqnbiAtIE3hu5ljIEtpbSBC4buTbmcgLSBDYXJwZW50cnkgdmlsbGFnZQ!5e0!3m2!1svi!2s!4v1752625181428!5m2!1svi!2s', 'Since the 16th century.', 'Intricate carvings.', 'Wood statues.', 'Wood Carving Competition.', 'Chiseling wood.', NULL, 'Wear comfortable shoes.'),

(4, 'Phuoc Kieu Bronze Casting Village', 'Phuoc Kieu bronze casting village (Dien Phuong commune, Dien Ban, Quang Nam), about 10km from Hoi An, is a traditional bronze casting village with a history of over 400 years. In the past, it specialized in producing weapons, coins, gongs, and bells for the Nguyen and Tay Son dynasties. Today, it is famous for its bronze trumpets, gongs, incense burners, and Buddha statues. Visitors can watch the casters melt bronze, pour molds, and fine-tune the sound of gongs. The craft has now been revived by more than 20 households, keeping the traditional fire alive, combining production with experiential tourism.', 'Dien Phuong, Dien Ban, Quang Nam', 15.8975, 108.2170, '02353944222', 'contact@phuockieu.vn', 1, 65, 6, '09:00 - 18:00', 'Wednesday', 4.3, 12, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927452/phuoc-kieu_awfnpk.jpg', '<https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3837.7681290259015!2d108.25876437495057!3d15.868779484782042!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420f72a9ed5293%3A0xa3146eef15a8950!2zTMOgbmcgxJHDumMgxJHhu5NuZyBQaMaw4bubYyBLaeG7gXU!5e0!3m2!1svi!2s!4v1752625247939!5m2!1svi!2s', NULL, 'Founded in the 17th century.', 'Resonant bronze.', 'Gongs, bells.', 'Bronze Festival.', 'Melting bronze.', NULL, 'Check festival schedule.'),

(5, 'Nam O Fish Sauce Village', 'Nam O fish sauce village is located in Lien Chieu district, Da Nang, with a history of more than 400 years, famous for its traditional fish sauce making. The main ingredients are anchovies combined with refined salt, fermented for 12-18 months in jackfruit wood jars, producing a fish sauce with a cockroach brown color and a distinctive rich flavor. Nam O fish sauce making is recognized as a national intangible cultural heritage. Visitors can visit the production process, learn about the traditional craft and buy pure fish sauce as gifts.', 'Nam Ô, Lien Chieu, Da Nang', 16.1005, 108.1263, '02363812345', 'info@namofishsauce.vn', 1, 80, 7, '07:30 - 17:30', 'Monday', 4.6, 20, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927450/nam-o_m9avov.webp', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d61333.69947978204!2d108.06355037272064!3d16.09886348441691!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31421fe5d9c9ec2d%3A0xdaf04b88490d22d5!2zTsaw4bubYyBt4bqvbSBOYW0gw5QgLSBIxrDGoW5nIEzDoG5nIEPhu5U!5e0!3m2!1svi!2s!4v1752625358403!5m2!1svi!2s', NULL, 'Over 400 years old.', 'Strong aroma.', 'Fish sauce.', 'Fish Sauce Festival.', 'Fermenting fish.', NULL, 'Visit in dry season.'),

(6, 'Non Nuoc Stone Carving Village', 'Non Nuoc Stone Village, located at the foot of Ngu Hanh Son, Da Nang, is a famous stone carving village with more than 300 years of history. Established in the late 18th century, the village specializes in making Buddha statues, mascots, stone steles, decorations... from natural stone. In 2014, the village was recognized as a National Intangible Cultural Heritage. Coming here, visitors can see the art of stone carving directly, visit wood products and buy exquisite handicrafts that bring spiritual, artistic and traditional cultural values to the Chinese region.', 'Hoa Hai, Ngu Hanh Son, Da Nang', 16.0033, 108.2637, '02363856789', 'contact@nonnuocstone.vn', 1, 150, 8, '08:00 - 18:00', 'Sunday', 4.8, 32, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927452/non-nuoc_bgvuna.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3835.2813406931505!2d108.26095527495339!3d15.998863384670448!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x314211003a1dafdd%3A0xdb25a0578e5d5a27!2sNon%20Nuoc%20Stone%20Carving%20Village!5e0!3m2!1svi!2s!4v1752625533135!5m2!1svi!2s' , NULL, 'Over 400 years old.', 'Marble statues.', 'Sculptures.', 'Stone Festival.', 'Carving marble.', NULL, 'Wear sun protection.'),

(7, 'Tra Que Vegetable Village', 'Tra Que Vegetable Village, Cam Ha Commune, Hoi An, about 3km from the center, stands out with more than 40 hectares of 20-40 types of clean vegetables and spices grown in rotation according to traditional organic methods using seaweed fertilizer from Co Co lagoon. The village has a history of nearly 400 years, Tra Que vegetables are considered typical ingredients in Quang Nam cuisine such as Quang noodles and Hoi An bread. Entrance tickets are only about 20,000-35,000 VND/person, including farm experience, cooking and herbal foot bath activities. Visitors can learn how to grow, plant, pick vegetables, participate in local cooking classes and enjoy the peaceful village atmosphere.', 'Cam Ha, Hoi An, Quang Nam', 15.9090, 108.3271, '02353999999', 'hello@traque.vn', 1, 45, 9, '06:00 - 18:00', 'Friday', 4.5, 10, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927452/tra-que_dyaiec.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d30700.788967134486!2d108.31484355318247!3d15.877679425537984!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420de155207241%3A0xb084a84384f41fbf!2sTRA%20QUE%20VEGETABLE%20VILLAGE%20-Nh%C3%A0%20h%C3%A0ng%20Tra%20Que%20Organic!5e0!3m2!1svi!2s!4v1752625417449!5m2!1svi!2s', NULL, 'Over 300 years old.', 'Organic vegetables.', 'Herbs, veggies.', 'Vegetable tours.', 'Farming activities.', NULL, 'Visit early morning.'),

(2, 'Ban Thach Mat Weaving Village', 'Coi Ban Thach Mat Village (Ban Thach Mat Village) is located in Duy Vinh Commune, Duy Xuyen District, Quang Nam, about 6km from Hoi An. The craft of weaving mats from water hyacinth has a history of more than 300-500 years, brought by migrants from Thanh Hoa. Hand-woven mats go through the following steps: harvesting grass, drying for 4-5 days, dyeing naturally and weaving by two artisans with bamboo and wooden frames, creating sophisticated patterns without printed patterns.', 'Duy Vinh, Duy Xuyen, Quang Nam', 15.8476, 108.2789, '02353888888', 'contact@banthach.vn', 1, 60, 10, '07:30 - 17:00', 'Sunday', 4.4, 18, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927337/ban-thach_tjyudg.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d15352.542348807636!2d108.32518099702112!3d15.849469556775533!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31420d90505b41f9%3A0x4d39caee3e344d5f!2zV0VBVklORyBNQVQgVFJBRElUSU9OQUwtIEThu4d0IENoaeG6v3UgVHJ1eeG7gW4gVGjhu5FuZyBCw6AgOA!5e0!3m2!1svi!2s!4v1752625577221!5m2!1svi!2s', NULL, 'Since the 18th century.', 'Colorful patterns.', 'Rush mats.', 'Mat competitions.', 'Weaving rush.', NULL, 'Wear light clothes.'),

(8, 'Hoi An Lantern Village', 'Hoi An Lantern Village, located near the old town on the banks of the Thu Bon River, is a cultural highlight with a history of more than 400 years. This craft was formed in the 16th-17th centuries, when the Chinese and Japanese contributed lantern-making techniques. Currently, the village has about 40 workshops with 200 artisans, specializing in producing bamboo lanterns, hanging frames and covering them with colorful natural fabrics. Every full moon night (14th lunar month), the old town turns off the lights, thousands of lanterns are lit, visitors release flower lanterns on the river and watch folk performances. Here, you can join a lantern-making class, buy handmade products and bring home unique memories.', 'Hoi An, Quang Nam', 15.8794, 108.3343, '02353777777', 'info@hoianlanterns.vn', 1, 130, 11, '09:00 - 21:00', 'Monday', 4.9, 40, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927452/lantern_s9emn0.jpg', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d61400.2857377966!2d108.26462144863277!3d15.881918099999991!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1a1f6cb50a73e55%3A0xfb35692b84a2101a!2sHoi%20An%20Lantern%20Company!5e0!3m2!1svi!2s!4v1752625726520!5m2!1svi!2s', NULL, 'From the 16th century.', 'Colorful lanterns.', 'Lanterns.', 'Lantern Festival.', 'Making bamboo frames.', NULL, 'Best at night.');
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
('Ceramic Teapot', 255000, 'Handmade blue pottery teapot.', 50, 1, 1, 1, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927481/ceramic-teapot_om7k2w.jpg', 1, 'BPV001', 1.20, '20x10 cm', 'Clay', 'Clean with dry cloth.', '6 months', 4.8, 10, 'hinhanh/model/ceramic-teapot.glb'),
('Ceramic Bowl', 12500000, 'Handmade ceramic bowl.', 80, 1, 1, 1, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927465/ceramic-bowl_qcjbu9.jpg', 1, 'CB001', 0.45, '15x7 cm', 'Clay', 'Hand wash.', '6 months', 4.6, 8, 'hinhanh/model/ceramic-bowl.glb'),

-- Ma Chau Embroidery
('Taffeta Silk', 3500000, 'Soft silk scarf.', 100, 1, 2, 2, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927467/taffeta-silk_dufliq.webp', 2, 'SS002', 0.20, '150x30 cm', 'Silk', 'Hand wash.', '3 months', 4.7, 15, 'hinhanh/model/taffeta-silk.glb'),
('Embroidered Silk Scarf', 4200000, 'Silk scarf with embroidery.', 90, 1, 2, 2, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927482/embroidered-scarf_v0dp5q.jpg', 2, 'ES001', 0.15, '160x30 cm', 'Silk', 'Hand wash only.', '3 months', 4.8, 10, 'hinhanh/model/embroidered-scarf.glb'),

-- Kim Bong Wood Carving
('Four Sacred Animals Carving', 5575000, 'Beautiful wood carving.', 20, 1, 3, 3, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927484/four-sacred-animal_olhkrk.jpg', 3, 'WS003', 2.50, '30x15 cm', 'Wood', 'Keep dry.', '12 months', 4.5, 5, 'hinhanh/model/four-sacred-animal.glb'),
('Wooden Buddha Statue', 6000000, 'Hand-carved Buddha.', 30, 1, 4, 3, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927466/wooden-buddha_ohi5e6.jpg', 3, 'WB001', 1.50, '25x15 cm', 'Wood', 'Keep away from moisture.', '12 months', 4.6, 14, 'hinhanh/model/wooden-buddha.glb'),

-- Phuoc Kieu Bronze
('Bronze Bell', 2890000, 'Glossy lacquer serving tray.', 60, 1, 4, 4, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927478/bronze-bell_tworwq.jpg', 4, 'LT005', 1.00, '35x25 cm', 'Wood, lacquer', 'Wipe with soft cloth.', '9 months', 4.6, 12, 'hinhanh/model/bronze-bell.glb'),
('Bronze Drum Replica', 12000000, 'Replica of Dong Son drum.', 10, 1, 4, 4, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927468/bronze-drum_bwsdbg.jpg', 4, 'BD001', 2.80, '30x30 cm', 'Bronze', 'Wipe gently.', '24 months', 4.9, 5, 'hinhanh/model/bronze-drum.glb'),

-- Nam Ô Fish Sauce
('Premium Fish Sauce Bottle', 950000, 'Premium fish sauce.', 200, 1, 6, 5, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927479/fish-sauce_htke0c.jpg', 5, 'FS001', 0.50, '20x5 cm', 'Fish, salt', 'Store cool.', '12 months', 4.8, 18, 'hinhanh/model/fish-sauce.glb'),

-- Non Nuoc Stone
('Marble Lion Sculpture', 25000000, 'Marble lion statue.', 5, 1, 4, 6, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927479/marble-lion_srnqgn.jpg', 6, 'ML002', 12.0, '60x30 cm', 'Marble', 'Keep dry.', '24 months', 5.0, 3, 'hinhanh/model/marble-lion.glb'),

-- Lantern Village
('Silk Lantern', 1500000, 'Handmade silk lantern.', 100, 1, 5, 1, 'https://res.cloudinary.com/do8uakd0l/image/upload/v1752927483/silk-lantern_bezytv.jpg', 8, 'LN001', 0.30, '40x20 cm', 'Silk, Bamboo', 'Avoid rain.', '6 months', 4.8, 12, 'hinhanh/model/silk-lantern.glb');
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
(1, 1, 100.00, 1),
(1, 2, 50.00, 1),
(2, 1, 120.00, 1),
(3, 1, 80.00, 1),
(4, 3, 60.50, 1),
(5, 1, 70.0, 1),
(6, 1, 100.00, 1),
(9, 1, 150.00, 1);
GO

INSERT INTO [dbo].[TicketAvailability] 
(ticketID, availableDate, totalSlots, bookedSlots, availableSlots, status)
VALUES
(1, '2025-07-29', 100, 20, 80, 1),
(1, '2025-07-30', 100, 20, 80, 1),
(1, '2025-07-31', 100, 20, 80, 1),
(1, '2025-08-1', 100, 20, 80, 1),
(2, '2025-07-29', 50, 10, 40, 1),
(2, '2025-07-30', 50, 10, 40, 1),
(2, '2025-07-31', 50, 10, 40, 1),
(3, '2025-07-30', 80, 20, 60, 1),
(4, '2025-07-30', 60, 10, 50, 1),
(5, '2025-07-30', 30, 5, 25, 1);
GO

-- Script sửa lỗi foreign key constraints cho Tour 360° system
USE [CraftDB]
GO

PRINT '=== FIXING TOUR 360° FOREIGN KEY CONSTRAINTS ==='

-- 1. Tạm thời disable foreign key constraints
PRINT 'Disabling foreign key constraints...'

-- Disable FK từ CraftVillage đến Tours
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_CraftVillage_DefaultTour')
BEGIN
    ALTER TABLE [dbo].[CraftVillage] NOCHECK CONSTRAINT [FK_CraftVillage_DefaultTour]
    PRINT 'Disabled FK_CraftVillage_DefaultTour'
END

-- Disable FK từ Panoramas đến Tours
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Panoramas_Tours')
BEGIN
    ALTER TABLE [dbo].[Panoramas] NOCHECK CONSTRAINT [FK_Panoramas_Tours]
    PRINT 'Disabled FK_Panoramas_Tours'
END

-- Disable FK từ NavigationPoints đến Panoramas
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_NavigationPoints_Panorama')
BEGIN
    ALTER TABLE [dbo].[NavigationPoints] NOCHECK CONSTRAINT [FK_NavigationPoints_Panorama]
    PRINT 'Disabled FK_NavigationPoints_Panorama'
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_NavigationPoints_TargetPanorama')
BEGIN
    ALTER TABLE [dbo].[NavigationPoints] NOCHECK CONSTRAINT [FK_NavigationPoints_TargetPanorama]
    PRINT 'Disabled FK_NavigationPoints_TargetPanorama'
END

-- Disable FK từ TourHotspots đến Panoramas
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_TourHotspots_Panorama')
BEGIN
    ALTER TABLE [dbo].[TourHotspots] NOCHECK CONSTRAINT [FK_TourHotspots_Panorama]
    PRINT 'Disabled FK_TourHotspots_Panorama'
END

-- Disable FK từ TourSettings đến Tours
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_TourSettings_Tours')
BEGIN
    ALTER TABLE [dbo].[TourSettings] NOCHECK CONSTRAINT [FK_TourSettings_Tours]
    PRINT 'Disabled FK_TourSettings_Tours'
END

GO

-- 2. Xóa dữ liệu cũ theo thứ tự đúng
PRINT 'Cleaning up old tour data in correct order...'

-- Xóa dữ liệu theo thứ tự để tránh lỗi foreign key
IF OBJECT_ID('dbo.TourSettings', 'U') IS NOT NULL
    DELETE FROM [dbo].[TourSettings]
GO

IF OBJECT_ID('dbo.TourHotspots', 'U') IS NOT NULL
    DELETE FROM [dbo].[TourHotspots]
GO

IF OBJECT_ID('dbo.NavigationPoints', 'U') IS NOT NULL
    DELETE FROM [dbo].[NavigationPoints]
GO

IF OBJECT_ID('dbo.Panoramas', 'U') IS NOT NULL
    DELETE FROM [dbo].[Panoramas]
GO

-- Cập nhật CraftVillage để xóa tham chiếu đến Tours
IF OBJECT_ID('dbo.CraftVillage', 'U') IS NOT NULL
    UPDATE [dbo].[CraftVillage] SET [defaultTourID] = NULL WHERE [defaultTourID] IS NOT NULL
GO

IF OBJECT_ID('dbo.Tours', 'U') IS NOT NULL
    DELETE FROM [dbo].[Tours]
GO

-- Reset identity columns
IF OBJECT_ID('dbo.Tours', 'U') IS NOT NULL
    DBCC CHECKIDENT ('Tours', RESEED, 0)
GO

IF OBJECT_ID('dbo.Panoramas', 'U') IS NOT NULL
    DBCC CHECKIDENT ('Panoramas', RESEED, 0)
GO

IF OBJECT_ID('dbo.NavigationPoints', 'U') IS NOT NULL
    DBCC CHECKIDENT ('NavigationPoints', RESEED, 0)
GO

IF OBJECT_ID('dbo.TourHotspots', 'U') IS NOT NULL
    DBCC CHECKIDENT ('TourHotspots', RESEED, 0)
GO

IF OBJECT_ID('dbo.TourSettings', 'U') IS NOT NULL
    DBCC CHECKIDENT ('TourSettings', RESEED, 0)
GO

PRINT 'Old data cleaned up successfully'
GO

-- 3. Thêm dữ liệu mới
PRINT 'Creating new tour data...'

-- Thêm dữ liệu mẫu cho bảng Tours
INSERT INTO [dbo].[Tours] ([villageID], [tourName], [description], [isDefault], [createdBy])
VALUES 
(1, N'Tour 360° Làng Gốm Thanh Hà', N'Khám phá làng gốm truyền thống Thanh Hà qua công nghệ 360°', 1, 1),
(2, N'Tour 360° Làng Thêu Ma Châu', N'Trải nghiệm làng thêu Ma Châu với công nghệ thực tế ảo', 1, 1),
(3, N'Tour 360° Làng Chạm Khắc Kim Bồng', N'Khám phá làng chạm khắc gỗ Kim Bồng qua công nghệ 360°', 1, 1),
(4, N'Tour 360° Làng Đúc Đồng Phước Kiều', N'Trải nghiệm làng đúc đồng Phước Kiều với công nghệ 360°', 1, 1),
(5, N'Tour 360° Làng Nước Mắm Nam Ô', N'Khám phá làng nước mắm Nam Ô qua công nghệ 360°', 1, 1),
(6, N'Tour 360° Làng Đá Non Nước', N'Trải nghiệm làng đá Non Nước với công nghệ 360°', 1, 1),
(7, N'Tour 360° Làng Rau Trà Quế', N'Khám phá làng rau Trà Quế qua công nghệ 360°', 1, 1),
(8, N'Tour 360° Làng Đan Chiếu Bàn Thạch', N'Trải nghiệm làng đan chiếu Bàn Thạch với công nghệ 360°', 1, 1),
(9, N'Tour 360° Làng Lồng Đèn Hội An', N'Khám phá làng lồng đèn Hội An qua công nghệ 360°', 1, 1)
GO

PRINT 'Tours created successfully'
GO

-- Cập nhật CraftVillage với tour mặc định
UPDATE [dbo].[CraftVillage] SET [defaultTourID] = 1 WHERE [villageID] = 1
GO
UPDATE [dbo].[CraftVillage] SET [defaultTourID] = 2 WHERE [villageID] = 2
GO
UPDATE [dbo].[CraftVillage] SET [defaultTourID] = 3 WHERE [villageID] = 3
GO
UPDATE [dbo].[CraftVillage] SET [defaultTourID] = 4 WHERE [villageID] = 4
GO
UPDATE [dbo].[CraftVillage] SET [defaultTourID] = 5 WHERE [villageID] = 5
GO
UPDATE [dbo].[CraftVillage] SET [defaultTourID] = 6 WHERE [villageID] = 6
GO
UPDATE [dbo].[CraftVillage] SET [defaultTourID] = 7 WHERE [villageID] = 7
GO
UPDATE [dbo].[CraftVillage] SET [defaultTourID] = 8 WHERE [villageID] = 8
GO
UPDATE [dbo].[CraftVillage] SET [defaultTourID] = 9 WHERE [villageID] = 9
GO

PRINT 'CraftVillage updated successfully'
GO

-- Thêm dữ liệu mẫu cho bảng Panoramas
INSERT INTO [dbo].[Panoramas] ([tourID], [panoramaName], [imageUrl], [description], [orderIndex], [isStartPoint])
VALUES 
-- Tour 1: Làng Gốm Thanh Hà
(1, N'Cổng làng Thanh Hà', '/CraftVillage/hinhanh/panorama/1_1.jpg', N'Cổng làng gốm truyền thống Thanh Hà', 0, 1),
(1, N'Xưởng gốm Thanh Hà', '/CraftVillage/hinhanh/panorama/1_2.jpg', N'Xưởng sản xuất gốm truyền thống', 1, 0),
-- Tour 2: Làng Thêu Ma Châu
(2, N'Cổng làng Ma Châu', '/CraftVillage/hinhanh/panorama/1_1.jpg', N'Cổng làng thêu Ma Châu', 0, 1),
(2, N'Xưởng thêu Ma Châu', '/CraftVillage/hinhanh/panorama/1_3.jpg', N'Xưởng thêu lụa truyền thống', 1, 0),
-- Tour 3: Làng Chạm Khắc Kim Bồng
(3, N'Cổng làng Kim Bồng', '/CraftVillage/hinhanh/panorama/1_2.jpg', N'Cổng làng chạm khắc Kim Bồng', 0, 1),
(3, N'Xưởng chạm khắc', '/CraftVillage/hinhanh/panorama/1_3.jpg', N'Xưởng chạm khắc gỗ truyền thống', 1, 0),
-- Tour 4: Làng Đúc Đồng Phước Kiều
(4, N'Cổng làng Phước Kiều', '/CraftVillage/hinhanh/panorama/1_1.jpg', N'Cổng làng đúc đồng Phước Kiều', 0, 1),
(4, N'Xưởng đúc đồng', '/CraftVillage/hinhanh/panorama/1_2.jpg', N'Xưởng đúc đồng truyền thống', 1, 0),
-- Tour 5: Làng Nước Mắm Nam Ô
(5, N'Cổng làng Nam Ô', '/CraftVillage/hinhanh/panorama/1_3.jpg', N'Cổng làng nước mắm Nam Ô', 0, 1),
(5, N'Xưởng nước mắm', '/CraftVillage/hinhanh/panorama/1_1.jpg', N'Xưởng sản xuất nước mắm truyền thống', 1, 0),
-- Tour 6: Làng Đá Non Nước
(6, N'Cổng làng Non Nước', '/CraftVillage/hinhanh/panorama/1_2.jpg', N'Cổng làng đá Non Nước', 0, 1),
(6, N'Xưởng đá Non Nước', '/CraftVillage/hinhanh/panorama/1_3.jpg', N'Xưởng chạm khắc đá truyền thống', 1, 0),
-- Tour 7: Làng Rau Trà Quế
(7, N'Cổng làng Trà Quế', '/CraftVillage/hinhanh/panorama/1_1.jpg', N'Cổng làng rau Trà Quế', 0, 1),
(7, N'Vườn rau Trà Quế', '/CraftVillage/hinhanh/panorama/1_2.jpg', N'Vườn rau sạch truyền thống', 1, 0),
-- Tour 8: Làng Đan Chiếu Bàn Thạch
(8, N'Cổng làng Bàn Thạch', '/CraftVillage/hinhanh/panorama/1_3.jpg', N'Cổng làng đan chiếu Bàn Thạch', 0, 1),
(8, N'Xưởng đan chiếu', '/CraftVillage/hinhanh/panorama/1_1.jpg', N'Xưởng đan chiếu truyền thống', 1, 0),
-- Tour 9: Làng Lồng Đèn Hội An
(9, N'Cổng làng Lồng Đèn', '/CraftVillage/hinhanh/panorama/1_2.jpg', N'Cổng làng lồng đèn Hội An', 0, 1),
(9, N'Xưởng lồng đèn', '/CraftVillage/hinhanh/panorama/1_3.jpg', N'Xưởng làm lồng đèn truyền thống', 1, 0)
GO

PRINT 'Panoramas created successfully'
GO

-- Thêm dữ liệu mẫu cho bảng NavigationPoints
INSERT INTO [dbo].[NavigationPoints] ([panoramaID], [targetPanoramaID], [x], [y], [description], [navigationType], [iconClass])
VALUES 
-- Tour 1: Làng Gốm Thanh Hà
(1, 2, 0.5, 0.5, N'Chuyển đến xưởng gốm', 'scene', 'fa-arrow-right'),
(2, 1, 0.5, 0.5, N'Quay lại cổng làng', 'scene', 'fa-arrow-left'),
-- Tour 2: Làng Thêu Ma Châu
(3, 4, 0.5, 0.5, N'Chuyển đến xưởng thêu', 'scene', 'fa-arrow-right'),
(4, 3, 0.5, 0.5, N'Quay lại cổng làng', 'scene', 'fa-arrow-left'),
-- Tour 3: Làng Chạm Khắc Kim Bồng
(5, 6, 0.5, 0.5, N'Chuyển đến xưởng chạm khắc', 'scene', 'fa-arrow-right'),
(6, 5, 0.5, 0.5, N'Quay lại cổng làng', 'scene', 'fa-arrow-left'),
-- Tour 4: Làng Đúc Đồng Phước Kiều
(7, 8, 0.5, 0.5, N'Chuyển đến xưởng đúc đồng', 'scene', 'fa-arrow-right'),
(8, 7, 0.5, 0.5, N'Quay lại cổng làng', 'scene', 'fa-arrow-left'),
-- Tour 5: Làng Nước Mắm Nam Ô
(9, 10, 0.5, 0.5, N'Chuyển đến xưởng nước mắm', 'scene', 'fa-arrow-right'),
(10, 9, 0.5, 0.5, N'Quay lại cổng làng', 'scene', 'fa-arrow-left'),
-- Tour 6: Làng Đá Non Nước
(11, 12, 0.5, 0.5, N'Chuyển đến xưởng đá', 'scene', 'fa-arrow-right'),
(12, 11, 0.5, 0.5, N'Quay lại cổng làng', 'scene', 'fa-arrow-left'),
-- Tour 7: Làng Rau Trà Quế
(13, 14, 0.5, 0.5, N'Chuyển đến vườn rau', 'scene', 'fa-arrow-right'),
(14, 13, 0.5, 0.5, N'Quay lại cổng làng', 'scene', 'fa-arrow-left'),
-- Tour 8: Làng Đan Chiếu Bàn Thạch
(15, 16, 0.5, 0.5, N'Chuyển đến xưởng đan chiếu', 'scene', 'fa-arrow-right'),
(16, 15, 0.5, 0.5, N'Quay lại cổng làng', 'scene', 'fa-arrow-left'),
-- Tour 9: Làng Lồng Đèn Hội An
(17, 18, 0.5, 0.5, N'Chuyển đến xưởng lồng đèn', 'scene', 'fa-arrow-right'),
(18, 17, 0.5, 0.5, N'Quay lại cổng làng', 'scene', 'fa-arrow-left')
GO

PRINT 'Navigation points created successfully'
GO

-- Thêm dữ liệu mẫu cho bảng TourHotspots
INSERT INTO [dbo].[TourHotspots] ([panoramaID], [x], [y], [title], [description], [hotspotType], [iconClass])
VALUES 
-- Tour 1: Làng Gốm Thanh Hà
(1, 0.3, 0.4, N'Lịch sử làng Thanh Hà', N'Làng gốm Thanh Hà có lịch sử hơn 500 năm', 'info', 'fa-info-circle'),
(2, 0.7, 0.6, N'Cửa hàng gốm', N'Xem và mua sản phẩm gốm Thanh Hà', 'shop', 'fa-shopping-cart'),
-- Tour 2: Làng Thêu Ma Châu
(3, 0.4, 0.3, N'Lịch sử làng Ma Châu', N'Làng thêu Ma Châu nổi tiếng với nghề thêu lụa truyền thống', 'info', 'fa-info-circle'),
(4, 0.6, 0.7, N'Cửa hàng thêu', N'Xem và mua sản phẩm thêu Ma Châu', 'shop', 'fa-shopping-cart'),
-- Tour 3: Làng Chạm Khắc Kim Bồng
(5, 0.3, 0.4, N'Lịch sử làng Kim Bồng', N'Làng chạm khắc Kim Bồng có lịch sử hơn 400 năm', 'info', 'fa-info-circle'),
(6, 0.7, 0.6, N'Cửa hàng chạm khắc', N'Xem và mua sản phẩm chạm khắc Kim Bồng', 'shop', 'fa-shopping-cart'),
-- Tour 4: Làng Đúc Đồng Phước Kiều
(7, 0.4, 0.3, N'Lịch sử làng Phước Kiều', N'Làng đúc đồng Phước Kiều có lịch sử hơn 400 năm', 'info', 'fa-info-circle'),
(8, 0.6, 0.7, N'Cửa hàng đồng', N'Xem và mua sản phẩm đồng Phước Kiều', 'shop', 'fa-shopping-cart'),
-- Tour 5: Làng Nước Mắm Nam Ô
(9, 0.3, 0.4, N'Lịch sử làng Nam Ô', N'Làng nước mắm Nam Ô có lịch sử hơn 400 năm', 'info', 'fa-info-circle'),
(10, 0.7, 0.6, N'Cửa hàng nước mắm', N'Xem và mua nước mắm Nam Ô', 'shop', 'fa-shopping-cart'),
-- Tour 6: Làng Đá Non Nước
(11, 0.4, 0.3, N'Lịch sử làng Non Nước', N'Làng đá Non Nước có lịch sử hơn 300 năm', 'info', 'fa-info-circle'),
(12, 0.6, 0.7, N'Cửa hàng đá', N'Xem và mua sản phẩm đá Non Nước', 'shop', 'fa-shopping-cart'),
-- Tour 7: Làng Rau Trà Quế
(13, 0.3, 0.4, N'Lịch sử làng Trà Quế', N'Làng rau Trà Quế có lịch sử hơn 300 năm', 'info', 'fa-info-circle'),
(14, 0.7, 0.6, N'Cửa hàng rau', N'Xem và mua rau sạch Trà Quế', 'shop', 'fa-shopping-cart'),
-- Tour 8: Làng Đan Chiếu Bàn Thạch
(15, 0.4, 0.3, N'Lịch sử làng Bàn Thạch', N'Làng đan chiếu Bàn Thạch có lịch sử hơn 300 năm', 'info', 'fa-info-circle'),
(16, 0.6, 0.7, N'Cửa hàng chiếu', N'Xem và mua chiếu Bàn Thạch', 'shop', 'fa-shopping-cart'),
-- Tour 9: Làng Lồng Đèn Hội An
(17, 0.3, 0.4, N'Lịch sử làng Lồng Đèn', N'Làng lồng đèn Hội An có lịch sử hơn 400 năm', 'info', 'fa-info-circle'),
(18, 0.7, 0.6, N'Cửa hàng lồng đèn', N'Xem và mua lồng đèn Hội An', 'shop', 'fa-shopping-cart')
GO

PRINT 'Hotspots created successfully'
GO

-- Thêm dữ liệu mẫu cho bảng TourSettings
INSERT INTO [dbo].[TourSettings] ([tourID], [settingKey], [settingValue], [settingType], [description])
VALUES 
-- Tour 1: Làng Gốm Thanh Hà
(1, 'autoRotate', 'true', 'boolean', N'Tự động xoay panorama'),
(1, 'autoRotateSpeed', '0.5', 'number', N'Tốc độ xoay tự động'),
(1, 'showHotspots', 'true', 'boolean', N'Hiển thị các điểm nóng'),
(1, 'showNavigation', 'true', 'boolean', N'Hiển thị điều hướng'),
-- Tour 2: Làng Thêu Ma Châu
(2, 'autoRotate', 'false', 'boolean', N'Tự động xoay panorama'),
(2, 'autoRotateSpeed', '0.3', 'number', N'Tốc độ xoay tự động'),
(2, 'showHotspots', 'true', 'boolean', N'Hiển thị các điểm nóng'),
(2, 'showNavigation', 'true', 'boolean', N'Hiển thị điều hướng'),
-- Tour 3: Làng Chạm Khắc Kim Bồng
(3, 'autoRotate', 'true', 'boolean', N'Tự động xoay panorama'),
(3, 'autoRotateSpeed', '0.4', 'number', N'Tốc độ xoay tự động'),
(3, 'showHotspots', 'true', 'boolean', N'Hiển thị các điểm nóng'),
(3, 'showNavigation', 'true', 'boolean', N'Hiển thị điều hướng'),
-- Tour 4: Làng Đúc Đồng Phước Kiều
(4, 'autoRotate', 'false', 'boolean', N'Tự động xoay panorama'),
(4, 'autoRotateSpeed', '0.6', 'number', N'Tốc độ xoay tự động'),
(4, 'showHotspots', 'true', 'boolean', N'Hiển thị các điểm nóng'),
(4, 'showNavigation', 'true', 'boolean', N'Hiển thị điều hướng'),
-- Tour 5: Làng Nước Mắm Nam Ô
(5, 'autoRotate', 'true', 'boolean', N'Tự động xoay panorama'),
(5, 'autoRotateSpeed', '0.3', 'number', N'Tốc độ xoay tự động'),
(5, 'showHotspots', 'true', 'boolean', N'Hiển thị các điểm nóng'),
(5, 'showNavigation', 'true', 'boolean', N'Hiển thị điều hướng'),
-- Tour 6: Làng Đá Non Nước
(6, 'autoRotate', 'false', 'boolean', N'Tự động xoay panorama'),
(6, 'autoRotateSpeed', '0.4', 'number', N'Tốc độ xoay tự động'),
(6, 'showHotspots', 'true', 'boolean', N'Hiển thị các điểm nóng'),
(6, 'showNavigation', 'true', 'boolean', N'Hiển thị điều hướng'),
-- Tour 7: Làng Rau Trà Quế
(7, 'autoRotate', 'true', 'boolean', N'Tự động xoay panorama'),
(7, 'autoRotateSpeed', '0.2', 'number', N'Tốc độ xoay tự động'),
(7, 'showHotspots', 'true', 'boolean', N'Hiển thị các điểm nóng'),
(7, 'showNavigation', 'true', 'boolean', N'Hiển thị điều hướng'),
-- Tour 8: Làng Đan Chiếu Bàn Thạch
(8, 'autoRotate', 'false', 'boolean', N'Tự động xoay panorama'),
(8, 'autoRotateSpeed', '0.5', 'number', N'Tốc độ xoay tự động'),
(8, 'showHotspots', 'true', 'boolean', N'Hiển thị các điểm nóng'),
(8, 'showNavigation', 'true', 'boolean', N'Hiển thị điều hướng'),
-- Tour 9: Làng Lồng Đèn Hội An
(9, 'autoRotate', 'true', 'boolean', N'Tự động xoay panorama'),
(9, 'autoRotateSpeed', '0.3', 'number', N'Tốc độ xoay tự động'),
(9, 'showHotspots', 'true', 'boolean', N'Hiển thị các điểm nóng'),
(9, 'showNavigation', 'true', 'boolean', N'Hiển thị điều hướng')
GO

PRINT 'Tour settings created successfully'
GO

-- 4. Re-enable foreign key constraints
PRINT 'Re-enabling foreign key constraints...'

-- Re-enable FK từ CraftVillage đến Tours
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_CraftVillage_DefaultTour')
BEGIN
    ALTER TABLE [dbo].[CraftVillage] WITH CHECK CHECK CONSTRAINT [FK_CraftVillage_DefaultTour]
    PRINT 'Re-enabled FK_CraftVillage_DefaultTour'
END

-- Re-enable FK từ Panoramas đến Tours
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Panoramas_Tours')
BEGIN
    ALTER TABLE [dbo].[Panoramas] WITH CHECK CHECK CONSTRAINT [FK_Panoramas_Tours]
    PRINT 'Re-enabled FK_Panoramas_Tours'
END

-- Re-enable FK từ NavigationPoints đến Panoramas
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_NavigationPoints_Panorama')
BEGIN
    ALTER TABLE [dbo].[NavigationPoints] WITH CHECK CHECK CONSTRAINT [FK_NavigationPoints_Panorama]
    PRINT 'Re-enabled FK_NavigationPoints_Panorama'
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_NavigationPoints_TargetPanorama')
BEGIN
    ALTER TABLE [dbo].[NavigationPoints] WITH CHECK CHECK CONSTRAINT [FK_NavigationPoints_TargetPanorama]
    PRINT 'Re-enabled FK_NavigationPoints_TargetPanorama'
END

-- Re-enable FK từ TourHotspots đến Panoramas
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_TourHotspots_Panorama')
BEGIN
    ALTER TABLE [dbo].[TourHotspots] WITH CHECK CHECK CONSTRAINT [FK_TourHotspots_Panorama]
    PRINT 'Re-enabled FK_TourHotspots_Panorama'
END

-- Re-enable FK từ TourSettings đến Tours
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_TourSettings_Tours')
BEGIN
    ALTER TABLE [dbo].[TourSettings] WITH CHECK CHECK CONSTRAINT [FK_TourSettings_Tours]
    PRINT 'Re-enabled FK_TourSettings_Tours'
END

GO

-- 5. Verification
PRINT '=== VERIFICATION ==='

-- Kiểm tra số lượng dữ liệu
SELECT 'Tours' AS TableName, COUNT(*) AS RecordCount FROM Tours
UNION ALL
SELECT 'Panoramas', COUNT(*) FROM Panoramas
UNION ALL
SELECT 'NavigationPoints', COUNT(*) FROM NavigationPoints
UNION ALL
SELECT 'TourHotspots', COUNT(*) FROM TourHotspots
UNION ALL
SELECT 'TourSettings', COUNT(*) FROM TourSettings;

PRINT '=== TOUR 360° SYSTEM SETUP COMPLETED SUCCESSFULLY ==='
PRINT 'You can now access the tours at:'
PRINT 'http://localhost:8080/CraftVillage/tour360?villageID=1'
PRINT 'http://localhost:8080/CraftVillage/tour360?villageID=2'
PRINT 'http://localhost:8080/CraftVillage/tour360?villageID=3'
PRINT '... and so on for all 9 villages' 

-- Cập nhật tour làng 1 với xóa hoàn toàn dữ liệu cũ (phiên bản cuối cùng)
USE [CraftDB]
GO

-- Xóa hoàn toàn dữ liệu cũ của làng 1 (theo thứ tự để tránh FK constraint)
UPDATE CraftVillage SET defaultTourID = NULL WHERE villageID = 1;

-- Xóa tất cả dữ liệu tour cũ
DELETE FROM TourSettings WHERE tourID IN (SELECT tourID FROM Tours WHERE villageID = 1);
DELETE FROM TourHotspots WHERE panoramaID IN (SELECT panoramaID FROM Panoramas WHERE tourID IN (SELECT tourID FROM Tours WHERE villageID = 1));
DELETE FROM NavigationPoints WHERE panoramaID IN (SELECT panoramaID FROM Panoramas WHERE tourID IN (SELECT tourID FROM Tours WHERE villageID = 1));
DELETE FROM Panoramas WHERE tourID IN (SELECT tourID FROM Tours WHERE villageID = 1);
DELETE FROM Tours WHERE villageID = 1;

-- Reset identity columns về 0
DBCC CHECKIDENT ('Tours', RESEED, 0);
DBCC CHECKIDENT ('Panoramas', RESEED, 0);
DBCC CHECKIDENT ('NavigationPoints', RESEED, 0);
DBCC CHECKIDENT ('TourHotspots', RESEED, 0);
DBCC CHECKIDENT ('TourSettings', RESEED, 0);

-- Tạo tour mới cho làng 1
INSERT INTO Tours (villageID, tourName, description, isDefault, status, createdDate)
VALUES (1, 'Tour 360° Làng Gốm Thanh Hà', 'Khám phá làng gốm truyền thống Thanh Hà qua công nghệ 360°', 1, 1, GETDATE());

-- Lấy tour ID vừa tạo
DECLARE @newTourID INT = SCOPE_IDENTITY();

-- Cập nhật CraftVillage với tour mới
UPDATE CraftVillage SET defaultTourID = @newTourID WHERE villageID = 1;

-- Tạo panorama 1
INSERT INTO Panoramas (tourID, panoramaName, imageUrl, description, orderIndex, isStartPoint, status, createdDate)
VALUES (@newTourID, 'Cổng làng Thanh Hà', '/CraftVillage/hinhanh/panorama/1_1.jpg', 'Cổng làng gốm truyền thống Thanh Hà', 0, 1, 1, GETDATE());

-- Lấy panorama 1 ID
DECLARE @panorama1ID INT = SCOPE_IDENTITY();

-- Tạo panorama 2
INSERT INTO Panoramas (tourID, panoramaName, imageUrl, description, orderIndex, isStartPoint, status, createdDate)
VALUES (@newTourID, 'Xưởng gốm Thanh Hà', '/CraftVillage/hinhanh/panorama/1_2.jpg', 'Xưởng sản xuất gốm truyền thống', 1, 0, 1, GETDATE());

-- Lấy panorama 2 ID
DECLARE @panorama2ID INT = SCOPE_IDENTITY();

-- Tạo navigation points (chuyển cảnh)
INSERT INTO NavigationPoints (panoramaID, targetPanoramaID, x, y, yaw, pitch, description, navigationType, iconClass, status, createdDate)
VALUES (@panorama1ID, @panorama2ID, 0.5, 0.5, 0.5, 0, 'Chuyển sang cảnh 2', 'scene', 'fa-arrow-right', 1, GETDATE());

INSERT INTO NavigationPoints (panoramaID, targetPanoramaID, x, y, yaw, pitch, description, navigationType, iconClass, status, createdDate)
VALUES (@panorama2ID, @panorama1ID, 0.5, 0.5, 3.14, 0, 'Quay lại cảnh 1', 'scene', 'fa-arrow-left', 1, GETDATE());

-- Tạo hotspots theo code của user
-- Panorama 1: 2 hotspots
INSERT INTO TourHotspots (panoramaID, title, description, hotspotType, x, y, yaw, pitch, iconClass, status, createdDate)
VALUES (@panorama1ID, 'Chuyển cảnh', 'Chuyển sang cảnh 2', 'navigation', 0.5, 0.5, 0.5, 0, 'fa-arrow-right', 1, GETDATE());

INSERT INTO TourHotspots (panoramaID, title, description, hotspotType, x, y, yaw, pitch, iconClass, status, createdDate)
VALUES (@panorama1ID, 'Mở shop', 'Mở cửa hàng', 'shop', 0.5, 0.5, 4.28, 0, 'fa-shopping-cart', 1, GETDATE());

-- Panorama 2: 1 hotspot
INSERT INTO TourHotspots (panoramaID, title, description, hotspotType, x, y, yaw, pitch, iconClass, status, createdDate)
VALUES (@panorama2ID, 'Quay lại', 'Quay lại cảnh 1', 'navigation', 0.5, 0.5, 3.14, 0, 'fa-arrow-left', 1, GETDATE());

-- Tạo tour settings
INSERT INTO TourSettings (tourID, settingKey, settingValue, settingType, createdDate)
VALUES (@newTourID, 'autoRotate', 'true', 'boolean', GETDATE());

INSERT INTO TourSettings (tourID, settingKey, settingValue, settingType, createdDate)
VALUES (@newTourID, 'autoRotateSpeed', '0.5', 'number', GETDATE());

INSERT INTO TourSettings (tourID, settingKey, settingValue, settingType, createdDate)
VALUES (@newTourID, 'showHotspots', 'true', 'boolean', GETDATE());

INSERT INTO TourSettings (tourID, settingKey, settingValue, settingType, createdDate)
VALUES (@newTourID, 'showNavigation', 'true', 'boolean', GETDATE());

PRINT '=== CẬP NHẬT TOUR LÀNG 1 HOÀN TẤT ===';
PRINT 'Tour ID: ' + CAST(@newTourID AS VARCHAR(10));
PRINT 'Panorama 1 ID: ' + CAST(@panorama1ID AS VARCHAR(10));
PRINT 'Panorama 2 ID: ' + CAST(@panorama2ID AS VARCHAR(10));
PRINT 'Panoramas: 2';
PRINT 'Navigation Points: 2';
PRINT 'Hotspots: 3';
PRINT 'Settings: 4';
PRINT '====================================='; 


-- Sample Village Reviews Data
-- Thêm dữ liệu mẫu cho bảng VillageReview

USE [CraftDB]
GO

-- Thêm dữ liệu mẫu cho VillageReview
-- Lưu ý: Sử dụng cột pictrureUrl (giữ nguyên lỗi chính tả trong schema)

INSERT INTO [dbo].[VillageReview] ([villageID], [userID], [rating], [reviewText], [reviewDate], [response], [responseDate], [pictrureUrl])
VALUES 
-- Reviews cho Village ID 1 (Làng Gốm Thanh Hà)
(1, 1, 5, N'Làng gốm Thanh Hà thật sự tuyệt vời! Tôi đã được tham quan xưởng gốm và chứng kiến quá trình làm gốm thủ công. Các nghệ nhân rất tài năng và nhiệt tình. Sản phẩm gốm đẹp, chất lượng cao.', GETDATE(), N'Cảm ơn bạn đã ghé thăm làng gốm Thanh Hà! Chúng tôi rất vui khi bạn hài lòng với trải nghiệm.', DATEADD(day, 1, GETDATE()), NULL),
(1, 2, 4, N'Làng gốm có không gian rộng rãi, thoáng mát. Được tham quan quy trình làm gốm từ đất sét đến sản phẩm hoàn chỉnh rất thú vị. Có thể mua sản phẩm gốm đẹp làm quà lưu niệm.', GETDATE(), NULL, NULL, NULL),
(1, 1, 5, N'Tuyệt vời! Làng gốm Thanh Hà là một điểm đến không thể bỏ qua khi đến Hội An. Nghệ thuật làm gốm truyền thống được bảo tồn rất tốt.', DATEADD(day, -3, GETDATE()), N'Chúng tôi luôn cố gắng bảo tồn và phát triển nghề gốm truyền thống!', DATEADD(day, -2, GETDATE()), NULL),

-- Reviews cho Village ID 2 (Làng Thêu Ma Châu)
(2, 1, 4, N'Làng thêu Ma Châu có những sản phẩm thêu tay rất tinh xảo. Được xem các nghệ nhân thêu hoa văn truyền thống rất ấn tượng. Áo dài thêu ở đây rất đẹp.', GETDATE(), NULL, NULL, NULL),
(2, 2, 5, N'Làng thêu rất đẹp và yên bình. Các nghệ nhân thêu rất khéo léo, sản phẩm chất lượng cao. Tôi đã mua một chiếc áo dài thêu rất đẹp.', DATEADD(day, -1, GETDATE()), N'Cảm ơn bạn đã ủng hộ nghề thêu truyền thống!', GETDATE(), NULL),
(2, 1, 4, N'Không gian làng thêu rất thoáng mát, có nhiều cây xanh. Được học cách thêu cơ bản rất thú vị. Sản phẩm thêu đa dạng và đẹp.', DATEADD(day, -5, GETDATE()), NULL, NULL, NULL),

-- Reviews cho Village ID 3 (Làng Chạm Khắc Kim Bồng)
(3, 1, 5, N'Làng chạm khắc Kim Bồng thật sự ấn tượng! Các sản phẩm gỗ chạm khắc tinh xảo, thể hiện tài năng của nghệ nhân. Được xem quá trình chạm khắc rất thú vị.', GETDATE(), N'Chúng tôi tự hào về nghề chạm khắc gỗ truyền thống!', DATEADD(day, 1, GETDATE()), NULL),
(3, 2, 4, N'Làng có không gian rộng rãi, nhiều sản phẩm gỗ đẹp. Các nghệ nhân chạm khắc rất tài năng. Sản phẩm chất lượng cao, giá cả hợp lý.', DATEADD(day, -2, GETDATE()), NULL, NULL, NULL),
(3, 1, 5, N'Tuyệt vời! Làng chạm khắc Kim Bồng là nơi lý tưởng để tìm hiểu về nghề thủ công truyền thống. Sản phẩm gỗ chạm khắc rất đẹp và độc đáo.', DATEADD(day, -4, GETDATE()), N'Cảm ơn bạn đã đánh giá cao nghề chạm khắc!', DATEADD(day, -3, GETDATE()), NULL),

-- Reviews cho Village ID 4 (Làng Đúc Đồng Phước Kiều)
(4, 1, 4, N'Làng đúc đồng Phước Kiều có lịch sử lâu đời. Được xem quá trình đúc đồng thủ công rất ấn tượng. Sản phẩm đồng đẹp, có giá trị nghệ thuật cao.', GETDATE(), NULL, NULL, NULL),
(4, 2, 5, N'Làng đúc đồng rất thú vị! Các nghệ nhân đúc đồng rất tài năng. Sản phẩm đồng chất lượng cao, hoa văn tinh xảo. Đáng để tham quan.', DATEADD(day, -1, GETDATE()), N'Chúng tôi rất vui khi bạn hài lòng với trải nghiệm!', GETDATE(), NULL),
(4, 1, 4, N'Không gian làng đúc đồng rộng rãi, thoáng mát. Được học về lịch sử nghề đúc đồng rất bổ ích. Sản phẩm đồng đa dạng và đẹp.', DATEADD(day, -6, GETDATE()), NULL, NULL, NULL),

-- Reviews cho Village ID 5 (Làng Nước Mắm Nam Ô)
(5, 1, 5, N'Làng nước mắm Nam Ô nổi tiếng với nước mắm truyền thống. Được tham quan quy trình làm nước mắm rất thú vị. Nước mắm ở đây rất ngon và đậm đà.', GETDATE(), N'Cảm ơn bạn đã ủng hộ nước mắm truyền thống Nam Ô!', DATEADD(day, 1, GETDATE()), NULL),
(5, 2, 4, N'Làng nước mắm có không gian rộng rãi, sạch sẽ. Được nếm thử các loại nước mắm khác nhau rất thú vị. Sản phẩm chất lượng cao.', DATEADD(day, -2, GETDATE()), NULL, NULL, NULL),
(5, 1, 5, N'Tuyệt vời! Làng nước mắm Nam Ô là nơi lý tưởng để tìm hiểu về nghề làm nước mắm truyền thống. Sản phẩm nước mắm rất ngon.', DATEADD(day, -3, GETDATE()), N'Chúng tôi tự hào về nước mắm truyền thống!', DATEADD(day, -2, GETDATE()), NULL),

-- Reviews cho Village ID 6 (Làng Đá Non Nước)
(6, 1, 4, N'Làng đá Non Nước có những sản phẩm đá chạm khắc rất đẹp. Các nghệ nhân chạm khắc đá rất tài năng. Sản phẩm đá có giá trị nghệ thuật cao.', GETDATE(), NULL, NULL, NULL),
(6, 2, 5, N'Làng đá rất ấn tượng! Được xem quá trình chạm khắc đá thủ công rất thú vị. Sản phẩm đá đa dạng và đẹp, phù hợp làm quà lưu niệm.', DATEADD(day, -1, GETDATE()), N'Cảm ơn bạn đã đánh giá cao nghề chạm khắc đá!', GETDATE(), NULL),
(6, 1, 4, N'Không gian làng đá rộng rãi, có nhiều sản phẩm đá đẹp. Được học về các loại đá và kỹ thuật chạm khắc rất bổ ích.', DATEADD(day, -4, GETDATE()), NULL, NULL, NULL),

-- Reviews cho Village ID 7 (Làng Rau Trà Quế)
(7, 1, 5, N'Làng rau Trà Quế rất xanh tươi và đẹp! Được tham quan các vườn rau hữu cơ rất thú vị. Rau ở đây rất tươi ngon và an toàn.', GETDATE(), N'Chúng tôi tự hào về rau hữu cơ Trà Quế!', DATEADD(day, 1, GETDATE()), NULL),
(7, 2, 4, N'Làng rau có không gian rộng rãi, nhiều loại rau đa dạng. Được học cách trồng rau hữu cơ rất bổ ích. Sản phẩm rau chất lượng cao.', DATEADD(day, -2, GETDATE()), NULL, NULL, NULL),
(7, 1, 5, N'Tuyệt vời! Làng rau Trà Quế là nơi lý tưởng để tìm hiểu về nông nghiệp hữu cơ. Rau tươi ngon và an toàn cho sức khỏe.', DATEADD(day, -5, GETDATE()), N'Cảm ơn bạn đã ủng hộ nông nghiệp hữu cơ!', DATEADD(day, -4, GETDATE()), NULL),

-- Reviews cho Village ID 8 (Làng Chiếu Bàn Thạch)
(8, 1, 4, N'Làng chiếu Bàn Thạch có những sản phẩm chiếu đẹp và chất lượng cao. Được xem quá trình đan chiếu thủ công rất thú vị. Chiếu ở đây rất bền và đẹp.', GETDATE(), NULL, NULL, NULL),
(8, 2, 5, N'Làng chiếu rất ấn tượng! Các nghệ nhân đan chiếu rất khéo léo. Sản phẩm chiếu đa dạng, có nhiều hoa văn đẹp. Đáng để tham quan.', DATEADD(day, -1, GETDATE()), N'Cảm ơn bạn đã đánh giá cao nghề đan chiếu!', GETDATE(), NULL),
(8, 1, 4, N'Không gian làng chiếu rộng rãi, thoáng mát. Được học cách đan chiếu cơ bản rất thú vị. Sản phẩm chiếu chất lượng cao.', DATEADD(day, -3, GETDATE()), NULL, NULL, NULL),

-- Reviews cho Village ID 9 (Làng Lồng Đèn Hội An)
(9, 1, 5, N'Làng lồng đèn Hội An thật sự tuyệt vời! Những chiếc lồng đèn đẹp lung linh, đặc biệt vào buổi tối. Được học cách làm lồng đèn rất thú vị.', GETDATE(), N'Lồng đèn Hội An là biểu tượng văn hóa của thành phố!', DATEADD(day, 1, GETDATE()), NULL),
(9, 2, 4, N'Làng lồng đèn có không gian rộng rãi, nhiều loại lồng đèn đẹp. Các nghệ nhân làm lồng đèn rất tài năng. Sản phẩm chất lượng cao.', DATEADD(day, -2, GETDATE()), NULL, NULL, NULL),
(9, 1, 5, N'Tuyệt vời! Làng lồng đèn Hội An là nơi lý tưởng để tìm hiểu về văn hóa truyền thống. Lồng đèn đẹp và có ý nghĩa văn hóa sâu sắc.', DATEADD(day, -4, GETDATE()), N'Cảm ơn bạn đã yêu thích lồng đèn Hội An!', DATEADD(day, -3, GETDATE()), NULL),

-- Reviews cho Village ID 9 (Làng Lồng Đèn Hội An) - thêm 3 reviews nữa
(9, 1, 4, N'Làng lồng đèn có không gian rộng rãi, nhiều loại lồng đèn đẹp. Các nghệ nhân làm lồng đèn rất tài năng. Sản phẩm chất lượng cao.', DATEADD(day, -6, GETDATE()), NULL, NULL, NULL),
(9, 2, 5, N'Lồng đèn Hội An thật sự đẹp! Được học cách làm lồng đèn rất thú vị. Sản phẩm đẹp và có ý nghĩa văn hóa sâu sắc.', DATEADD(day, -7, GETDATE()), N'Cảm ơn bạn đã yêu thích lồng đèn Hội An!', DATEADD(day, -6, GETDATE()), NULL),
(9, 1, 4, N'Không gian làng lồng đèn rộng rãi, có nhiều sản phẩm đẹp. Được học cách làm lồng đèn cơ bản rất thú vị. Sản phẩm chất lượng cao.', DATEADD(day, -8, GETDATE()), NULL, NULL, NULL);

-- Cập nhật averageRating và totalReviews cho các villages
UPDATE [dbo].[CraftVillage] 
SET averageRating = (
    SELECT AVG(CAST(rating AS FLOAT))
    FROM [dbo].[VillageReview] vr
    WHERE vr.villageID = CraftVillage.villageID
),
totalReviews = (
    SELECT COUNT(*)
    FROM [dbo].[VillageReview] vr
    WHERE vr.villageID = CraftVillage.villageID
);

PRINT N'Đã thêm thành công dữ liệu mẫu cho VillageReview!';
PRINT N'Tổng cộng: 30 reviews cho 9 craft villages';
PRINT N'Đã cập nhật averageRating và totalReviews cho các craft villages'; 

-- Sample Product Reviews Data
-- Thêm dữ liệu mẫu cho bảng ProductReview

USE [CraftDB]
GO

-- Thêm dữ liệu mẫu cho ProductReview
-- Lưu ý: Sử dụng cột pictrureUrl (giữ nguyên lỗi chính tả trong schema)

INSERT INTO [dbo].[ProductReview] ([productID], [userID], [rating], [reviewText], [reviewDate], [response], [responseDate], [pictrureUrl])
VALUES 
-- Reviews cho Product ID 1 (Gốm Thanh Hà)
(1, 1, 5, N'Sản phẩm gốm Thanh Hà rất đẹp và chất lượng cao. Tôi rất hài lòng với việc mua hàng này. Gốm được làm thủ công rất tinh xảo.', GETDATE(), N'Cảm ơn bạn đã đánh giá cao sản phẩm của chúng tôi!', DATEADD(day, 1, GETDATE()), NULL),
(1, 2, 4, N'Gốm Thanh Hà có màu sắc đẹp, hoa văn tinh tế. Chất lượng tốt, đóng gói cẩn thận. Sẽ mua thêm sản phẩm khác.', GETDATE(), NULL, NULL, NULL),
(1, 1, 5, N'Tuyệt vời! Sản phẩm gốm Thanh Hà vượt quá mong đợi. Hoa văn truyền thống rất đẹp, chất lượng gốm rất tốt.', DATEADD(day, -2, GETDATE()), N'Chúng tôi rất vui khi bạn hài lòng với sản phẩm!', DATEADD(day, -1, GETDATE()), NULL),

-- Reviews cho Product ID 2 (Thêu Ma Châu)
(2, 1, 4, N'Áo thêu Ma Châu rất đẹp, đường thêu tinh xảo. Chất liệu vải tốt, mặc rất thoải mái.', GETDATE(), NULL, NULL, NULL),
(2, 2, 5, N'Sản phẩm thêu Ma Châu chất lượng cao, hoa văn truyền thống rất đẹp. Đóng gói cẩn thận, giao hàng nhanh.', DATEADD(day, -1, GETDATE()), N'Cảm ơn bạn đã tin tưởng sản phẩm của chúng tôi!', GETDATE(), NULL),
(2, 1, 3, N'Sản phẩm đẹp nhưng giá hơi cao. Chất lượng thêu tốt nhưng có thể cải thiện thêm về mẫu mã.', GETDATE(), NULL, NULL, NULL),

-- Reviews cho Product ID 3 (Chạm Khắc Kim Bồng)
(3, 2, 5, N'Sản phẩm chạm khắc Kim Bồng tuyệt vời! Đường nét chạm khắc rất tinh xảo, thể hiện được tay nghề thợ thủ công.', GETDATE(), N'Cảm ơn bạn đã đánh giá cao tay nghề của chúng tôi!', DATEADD(day, 1, GETDATE()), NULL),
(3, 1, 4, N'Gỗ chạm khắc Kim Bồng chất lượng tốt, hoa văn đẹp. Sản phẩm phù hợp để trang trí nhà cửa.', DATEADD(day, -3, GETDATE()), NULL, NULL, NULL),
(3, 2, 5, N'Tuyệt vời! Sản phẩm chạm khắc Kim Bồng vượt quá mong đợi. Đường nét chạm khắc rất sắc sảo và tinh tế.', GETDATE(), NULL, NULL, NULL),

-- Reviews cho Product ID 4 (Đúc Đồng Phước Kiều)
(4, 1, 4, N'Sản phẩm đúc đồng Phước Kiều chất lượng cao, hoa văn truyền thống đẹp. Đóng gói cẩn thận.', GETDATE(), NULL, NULL, NULL),
(4, 2, 5, N'Đồng Phước Kiều rất đẹp, chất lượng đúc tốt. Hoa văn truyền thống thể hiện được văn hóa Việt Nam.', DATEADD(day, -2, GETDATE()), N'Chúng tôi rất vui khi bạn hài lòng với sản phẩm!', DATEADD(day, -1, GETDATE()), NULL),
(4, 1, 4, N'Sản phẩm đẹp, chất lượng tốt. Giao hàng nhanh, đóng gói cẩn thận. Sẽ mua thêm sản phẩm khác.', GETDATE(), NULL, NULL, NULL),

-- Reviews cho Product ID 5 (Nước Mắm Nam Ô)
(5, 1, 5, N'Nước mắm Nam Ô rất ngon, mùi vị đặc trưng. Chất lượng cao, đóng chai cẩn thận.', GETDATE(), N'Cảm ơn bạn đã tin tưởng sản phẩm truyền thống của chúng tôi!', DATEADD(day, 1, GETDATE()), NULL),
(5, 2, 4, N'Nước mắm Nam Ô chất lượng tốt, mùi vị tự nhiên. Đóng gói đẹp, giao hàng nhanh.', DATEADD(day, -1, GETDATE()), NULL, NULL, NULL),
(5, 1, 5, N'Tuyệt vời! Nước mắm Nam Ô đúng như mong đợi. Mùi vị đặc trưng, chất lượng cao.', GETDATE(), NULL, NULL, NULL),

-- Reviews cho Product ID 6 (Đá Non Nước)
(6, 2, 4, N'Sản phẩm đá Non Nước đẹp, chạm khắc tinh xảo. Chất lượng đá tốt, phù hợp trang trí.', GETDATE(), NULL, NULL, NULL),
(6, 1, 5, N'Đá Non Nước rất đẹp, hoa văn chạm khắc tinh tế. Sản phẩm thể hiện được tay nghề thợ thủ công.', DATEADD(day, -2, GETDATE()), N'Cảm ơn bạn đã đánh giá cao tay nghề của chúng tôi!', DATEADD(day, -1, GETDATE()), NULL),
(6, 2, 4, N'Chất lượng đá tốt, chạm khắc đẹp. Đóng gói cẩn thận, giao hàng nhanh.', GETDATE(), NULL, NULL, NULL),

-- Reviews cho Product ID 7 (Rau Trà Quế)
(7, 1, 5, N'Rau Trà Quế rất tươi ngon, hương vị đặc trưng. Chất lượng cao, đóng gói cẩn thận.', GETDATE(), N'Cảm ơn bạn đã tin tưởng sản phẩm nông nghiệp của chúng tôi!', DATEADD(day, 1, GETDATE()), NULL),
(7, 2, 4, N'Rau Trà Quế tươi ngon, hương vị tự nhiên. Giao hàng nhanh, đóng gói tốt.', DATEADD(day, -1, GETDATE()), NULL, NULL, NULL),
(7, 1, 5, N'Tuyệt vời! Rau Trà Quế đúng như mong đợi. Hương vị đặc trưng, chất lượng cao.', GETDATE(), NULL, NULL, NULL),

-- Reviews cho Product ID 8 (Chiếu Bàn Thạch)
(8, 2, 4, N'Chiếu Bàn Thạch chất lượng tốt, đan thủ công tinh xảo. Sử dụng rất thoải mái.', GETDATE(), NULL, NULL, NULL),
(8, 1, 5, N'Chiếu Bàn Thạch rất đẹp, đan thủ công tinh tế. Chất liệu tốt, sử dụng bền.', DATEADD(day, -2, GETDATE()), N'Cảm ơn bạn đã đánh giá cao sản phẩm thủ công của chúng tôi!', DATEADD(day, -1, GETDATE()), NULL),
(8, 2, 4, N'Sản phẩm đẹp, chất lượng tốt. Đóng gói cẩn thận, giao hàng nhanh.', GETDATE(), NULL, NULL, NULL),

-- Reviews cho Product ID 9 (Lồng Đèn Hội An)
(9, 1, 5, N'Lồng đèn Hội An rất đẹp, làm thủ công tinh xảo. Ánh sáng ấm áp, phù hợp trang trí.', GETDATE(), N'Cảm ơn bạn đã tin tưởng sản phẩm truyền thống của chúng tôi!', DATEADD(day, 1, GETDATE()), NULL),
(9, 2, 4, N'Lồng đèn Hội An chất lượng tốt, hoa văn đẹp. Đóng gói cẩn thận, giao hàng nhanh.', DATEADD(day, -1, GETDATE()), NULL, NULL, NULL),
(9, 1, 5, N'Tuyệt vời! Lồng đèn Hội An đúng như mong đợi. Ánh sáng đẹp, chất lượng cao.', GETDATE(), NULL, NULL, NULL),

-- Reviews cho Product ID 10 (Gốm Thanh Hà - Sản phẩm khác)
(10, 1, 4, N'Sản phẩm gốm Thanh Hà đẹp, chất lượng tốt. Hoa văn truyền thống rất tinh tế.', GETDATE(), NULL, NULL, NULL),
(10, 2, 5, N'Gốm Thanh Hà tuyệt vời! Chất lượng cao, hoa văn đẹp. Sẽ mua thêm sản phẩm khác.', DATEADD(day, -2, GETDATE()), N'Cảm ơn bạn đã tin tưởng sản phẩm của chúng tôi!', DATEADD(day, -1, GETDATE()), NULL),
(10, 1, 4, N'Sản phẩm đẹp, chất lượng tốt. Đóng gói cẩn thận, giao hàng nhanh.', GETDATE(), NULL, NULL, NULL)
GO

-- Cập nhật averageRating và totalReviews cho các sản phẩm
-- Product ID 1
UPDATE [dbo].[Product] 
SET [averageRating] = 4.67, [totalReviews] = 3 
WHERE [pid] = 1

-- Product ID 2  
UPDATE [dbo].[Product] 
SET [averageRating] = 4.00, [totalReviews] = 3 
WHERE [pid] = 2

-- Product ID 3
UPDATE [dbo].[Product] 
SET [averageRating] = 4.67, [totalReviews] = 3 
WHERE [pid] = 3

-- Product ID 4
UPDATE [dbo].[Product] 
SET [averageRating] = 4.33, [totalReviews] = 3 
WHERE [pid] = 4

-- Product ID 5
UPDATE [dbo].[Product] 
SET [averageRating] = 4.67, [totalReviews] = 3 
WHERE [pid] = 5

-- Product ID 6
UPDATE [dbo].[Product] 
SET [averageRating] = 4.33, [totalReviews] = 3 
WHERE [pid] = 6

-- Product ID 7
UPDATE [dbo].[Product] 
SET [averageRating] = 4.67, [totalReviews] = 3 
WHERE [pid] = 7

-- Product ID 8
UPDATE [dbo].[Product] 
SET [averageRating] = 4.33, [totalReviews] = 3 
WHERE [pid] = 8

-- Product ID 9
UPDATE [dbo].[Product] 
SET [averageRating] = 4.67, [totalReviews] = 3 
WHERE [pid] = 9

-- Product ID 10
UPDATE [dbo].[Product] 
SET [averageRating] = 4.33, [totalReviews] = 3 
WHERE [pid] = 10
GO

PRINT 'Đã thêm thành công dữ liệu mẫu cho ProductReview!'
PRINT 'Tổng cộng: 30 reviews cho 10 sản phẩm'
PRINT 'Đã cập nhật averageRating và totalReviews cho các sản phẩm' 