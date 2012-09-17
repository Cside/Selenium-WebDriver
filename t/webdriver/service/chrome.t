#!perl -w
use strict;
use Test::More;
use Test::Exception;
use Test::Mock::Guard qw(mock_guard);
use Selenium::WebDriver::Service::Chrome;
use Selenium::WebDriver::Remote::Bridge::Chrome;

mock_guard('Proc::Background', +{
    new => sub { bless +{}, $_[0] },
});

mock_guard('Selenium::WebDriver::Service::Chrome', +{
    start => sub { 1 },
    stop  => sub { 1 },
});

subtest 'uses the user-provided path if set' => sub {
    my $guard = mock_guard('Selenium::WebDriver::Service::Chrome', +{
        assert_executable => sub { 1 },
    });

    my $service = Selenium::WebDriver::Service::Chrome->new(
        driver_path => '/some/path',
    );

    is $service->executable_path, '/some/path';
};

subtest 'finds the Chrome server binary by searching PATH' => sub {
    my $guard = mock_guard('Selenium::WebDriver::Service::Chrome', +{
        find_binary => sub { '/some/path' },
    });
    my $service = Selenium::WebDriver::Service::Chrome->new;

    is $service->executable_path, '/some/path';
};

subtest "raises a nice error if the server binary can't be found" => sub {
    my $guard = mock_guard('Selenium::WebDriver::Service::Chrome', +{
        find_binary => sub { undef },
    });

    my $service = Selenium::WebDriver::Service::Chrome->new;

    throws_ok { $service->executable_path } qr{code\.google\.com};
};

done_testing;
