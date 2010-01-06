<?php defined('SYSPATH') OR die('No direct access allowed.');
/**
 * File Log Driver Config
 *
 * @package    Kohana
 * @author     Kohana Team
 * @copyright  (c) 2007-2009 Kohana Team
 * @license    http://kohanaphp.com/license
 */

/**
 * Message logging directory.
 */
$config['log_directory'] = APPPATH.'logs';

/**
 * Permissions of the log file
 */
$config['posix_permissions'] = 0644;