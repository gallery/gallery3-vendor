<?php defined('SYSPATH') OR die('No direct access allowed.');
/**
 * Database Log Driver Config
 *
 * ###### MySQL Database Schema
 *     CREATE TABLE IF NOT EXISTS `logs` (
 *      `id` int(10) unsigned NOT NULL auto_increment,
 *      `date` int(11) NOT NULL,
 *      `level` varchar(5) NOT NULL,
 *      `message` text NOT NULL,
 *      PRIMARY KEY  (`id`),
 *      KEY `date` (`date`)
 *     ) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
 *
 * @package    Kohana
 * @author     Kohana Team
 * @copyright  (c) 2007-2009 Kohana Team
 * @license    http://kohanaphp.com/license
 */

/**
 * Database config group to store log messages
 */
$config['group'] = 'default';

/**
 * Database table to store log messages in
 */
$config['table'] = 'logs';