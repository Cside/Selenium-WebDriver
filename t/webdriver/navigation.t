#!perl -w
use strict;
use Test::More;
use Test::Mouse;
use Selenium::WebDriver::Navigation;

my $module = 'Selenium::WebDriver::Navigation';

can_ok $module, 'to';
can_ok $module, 'back';
can_ok $module, 'forward';
can_ok $module, 'refresh';

# TODO check if $bridge->* are called

done_testing;
