/*
 Navicat MySQL Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80015
 Source Host           : localhost:3306
 Source Schema         : myemployees

 Target Server Type    : MySQL
 Target Server Version : 80015
 File Encoding         : 65001

 Date: 04/09/2019 23:46:02
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for departments
-- ----------------------------
DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments`  (
  `department_id` int(4) NOT NULL AUTO_INCREMENT,
  `department_name` varchar(3) CHARACTER SET gb2312 COLLATE gb2312_chinese_ci NULL DEFAULT NULL,
  `manager_id` int(6) NULL DEFAULT NULL,
  `location_id` int(4) NULL DEFAULT NULL,
  PRIMARY KEY (`department_id`) USING BTREE,
  INDEX `loc_id_fk`(`location_id`) USING BTREE,
  CONSTRAINT `loc_id_fk` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 271 CHARACTER SET = gb2312 COLLATE = gb2312_chinese_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of departments
-- ----------------------------
INSERT INTO `departments` VALUES (10, 'Adm', 200, 1700);
INSERT INTO `departments` VALUES (20, 'Mar', 201, 1800);
INSERT INTO `departments` VALUES (30, 'Pur', 114, 1700);
INSERT INTO `departments` VALUES (40, 'Hum', 203, 2400);
INSERT INTO `departments` VALUES (50, 'Shi', 121, 1500);
INSERT INTO `departments` VALUES (60, 'IT', 103, 1400);
INSERT INTO `departments` VALUES (70, 'Pub', 204, 2700);
INSERT INTO `departments` VALUES (80, 'Sal', 145, 2500);
INSERT INTO `departments` VALUES (90, 'Exe', 100, 1700);
INSERT INTO `departments` VALUES (100, 'Fin', 108, 1700);
INSERT INTO `departments` VALUES (110, 'Acc', 205, 1700);
INSERT INTO `departments` VALUES (120, 'Tre', NULL, 1700);
INSERT INTO `departments` VALUES (130, 'Cor', NULL, 1700);
INSERT INTO `departments` VALUES (140, 'Con', NULL, 1700);
INSERT INTO `departments` VALUES (150, 'Sha', NULL, 1700);
INSERT INTO `departments` VALUES (160, 'Ben', NULL, 1700);
INSERT INTO `departments` VALUES (170, 'Man', NULL, 1700);
INSERT INTO `departments` VALUES (180, 'Con', NULL, 1700);
INSERT INTO `departments` VALUES (190, 'Con', NULL, 1700);
INSERT INTO `departments` VALUES (200, 'Ope', NULL, 1700);
INSERT INTO `departments` VALUES (210, 'IT ', NULL, 1700);
INSERT INTO `departments` VALUES (220, 'NOC', NULL, 1700);
INSERT INTO `departments` VALUES (230, 'IT ', NULL, 1700);
INSERT INTO `departments` VALUES (240, 'Gov', NULL, 1700);
INSERT INTO `departments` VALUES (250, 'Ret', NULL, 1700);
INSERT INTO `departments` VALUES (260, 'Rec', NULL, 1700);
INSERT INTO `departments` VALUES (270, 'Pay', NULL, 1700);

SET FOREIGN_KEY_CHECKS = 1;
