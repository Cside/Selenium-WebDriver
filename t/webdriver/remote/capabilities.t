#!perl -w
use strict;
use Test::More;

use Selenium::WebDriver::Remote::Capabilities;

my $cap = Selenium::WebDriver::Remote::Capabilities->new(
    browser_name      => "firefox",
    custom_capability => 0,
);

subtest 'default capabilities for Chrome' => sub {
    is(
        Selenium::WebDriver::Remote::Capabilities->chrome->browser_name,
        'chrome',
    );
};

subtest 'default to no proxy' => sub {
    ok !Selenium::WebDriver::Remote::Capabilities->new->proxy;
};

subtest 'set and get standard capabilities' => sub {
    my $caps = Selenium::WebDriver::Remote::Capabilities->new;
    $caps->browser_name('foo');
    is $caps->browser_name('foo'), 'foo';
};

subtest 'serialized and deserialized to JSON' => sub {
    my $caps = Selenium::WebDriver::Remote::Capabilities->new(
        platform => 'android',
        custom_capability => 1,
    );

    is_deeply(
        $caps,
        Selenium::WebDriver::Remote::Capabilities->json_create(%{$caps->as_json}),
    );
};

done_testing;
