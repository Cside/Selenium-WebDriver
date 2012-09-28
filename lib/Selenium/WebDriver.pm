package Selenium::WebDriver;
use strict;
use warnings;

use Selenium::WebDriver::Driver;

our $VERSION = '0.01';

sub new {
    my ($class, %args) = @_;
    Selenium::WebDriver::Driver->new(%args);
}

1;
