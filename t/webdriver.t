#!perl -w
use strict;
use Test::More;
use Test::Exception;
use Selenium::WebDriver;
use Test::MockObject;

Test::MockObject->fake_module(
    'Selenium::WebDriver::Driver',
    new => sub { bless +{}, shift },
);

my $driver = Selenium::WebDriver->new;
isa_ok $driver, 'Selenium::WebDriver::Driver';

done_testing;
