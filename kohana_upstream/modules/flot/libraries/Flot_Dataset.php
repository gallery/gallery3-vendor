<?php defined('SYSPATH') OR die('No direct access allowed.');
/**
 * Flot dataset class.
 *
 * $Id$
 *
 * @package    Flot
 * @author     Woody Gilk
 * @copyright  (c) 2007-2008 Kohana Team
 * @license    http://kohanaphp.com/license.html
 */
class Flot_Dataset_Core {

	// Plot points
	public $data = array();

	/**
	 * Add a plot point to this set.
	 *
	 * @chainable
	 * @param   numeric   x-axis plot position
	 * @param   numeric   y-axis plot position
	 * @return  object
	 */
	public function add($x, $y)
	{
		$this->data[] = array($x, $y);

		return $this;
	}

} // End Flot Dataset