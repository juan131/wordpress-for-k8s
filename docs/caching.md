# Caching database queries and objects

WordPress is configured to use Memcached to cache both database queries and objects. To do so, it makes use of the W3 Total Cache plugin that is automatically configured during the WordPress containers' first boot.

The diagram below (see green arrows) illustrates the setup:

![Database and Cache](img/database-and-cache.png)

This is an important feature to improve the stability of your blog by reducing the number of read/write queries done to the database. This is specially important when using plugins that make an intense use of the database.
