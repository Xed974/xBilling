CREATE TABLE `xBilling` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `sender` varchar(255) NOT NULL,
  `raison` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `society` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `xBilling`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `xBilling`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

--- Xed#1188