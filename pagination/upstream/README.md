Pagination module for Kohana 3.3
---
 * Request, Route and route parameters dependency injection added
 * Current Request is used by default instead of the initial one ($_GET was used directly in < 3.2)
 * URL::query() has been removed, Pagination::query() added instead (HMVC support)
 * Initial pass for PSR-0 autoloading support