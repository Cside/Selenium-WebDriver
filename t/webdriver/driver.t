#!perl -w
use strict;
use Test::More;
use Test::Mock::Guard qw(mock_guard);
use Selenium::WebDriver::Driver;
use Test::MockObject;
use Mouse::Util qw(apply_all_roles);

# Bridge的なことしかしてないので、メソッド呼べるかのテストにとどめる。
# 期待通りの値を返すかは各モジュールのユニットテストにて頑張れ。

Test::MockObject->fake_module('Selenium::WebDriver::Navigation',
    new => sub { bless +{}, shift },
    to  => sub {},
);

Test::MockObject->fake_module('Selenium::WebDriver::TargetLocator',
    new => sub { bless +{}, shift },
);

Test::MockObject->fake_module('Selenium::WebDriver::Options',
    new => sub { bless +{}, shift },
);

Test::MockObject->fake_module('Selenium::WebDriver::Remote::Bridge',
    new => sub { bless +{}, shift },

);

Test::MockObject->fake_module('Selenium::WebDriver::Remote::Bridge::Chrome',
    new => sub { bless +{}, shift },
);

Test::MockObject->fake_module('Selenium::WebDriver::SearchContext',
    new           => sub { bless +{}, shift },
    find_element  => sub {},
    find_elements => sub {},
    execute_script => sub {},
);

{
    no strict 'refs';
    push @{'Selenium::WebDriver::Remote::Bridge::Chrome::ISA'},
           'Selenium::WebDriver::Remote::Bridge';
}

my $driver = Selenium::WebDriver::Driver->new(
    driver => 'chrome',
);

subtest attributes => sub {
    isa_ok $driver->navigate,  'Selenium::WebDriver::Navigation';
    isa_ok $driver->bridge,    'Selenium::WebDriver::Remote::Bridge';
    isa_ok $driver->switch_to, 'Selenium::WebDriver::TargetLocator';
    isa_ok $driver->manage,    'Selenium::WebDriver::Options';
};

subtest methods => sub {
    can_ok $driver, 'current_url';
    can_ok $driver, 'title';
    can_ok $driver, 'page_source';
    can_ok $driver, 'close';
    can_ok $driver, 'quit';
    can_ok $driver, 'is_visible';
    can_ok $driver, 'window_handles';
    can_ok $driver, 'window_handle';
    can_ok $driver, 'execute_script';
    can_ok $driver, 'execute_async_script';
    can_ok $driver, 'script';
    can_ok $driver, 'ref';
    can_ok $driver, 'browser';
    can_ok $driver, 'capabilities';
    can_ok $driver, 'first';
    can_ok $driver, 'all';
    can_ok $driver, 'script';
};

subtest root => sub {
    like $driver->root,  qr{lib$};
    ok -d $driver->root;
};

done_testing;
