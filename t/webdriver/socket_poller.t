#!perl -w
use strict;
use warnings;
use Test::More;
use Test::TCP;
use Test::Mock::Guard qw(mock_guard);
use Time::Piece;
use IO::Socket::INET;
use Selenium::WebDriver::SocketPoller;

my $PORT = empty_port;

my $SERVER = IO::Socket::INET->new(
    Listen    => Socket::SOMAXCONN,
    LocalAddr => '127.0.0.1',
    LocalPort => $PORT,
    Proto     => 'tcp',
);

my $POLLER = Selenium::WebDriver::SocketPoller->new(
    host     => '127.0.0.1',
    port     => $PORT,
    timeout  => 5,
    interval => 0.05,
);

subtest 'connected' => sub {
    ok $POLLER->is_connected;

    {
        my $guard = mock_guard('IO::Socket::INET', +{
            new => sub { undef },
        });

        my $i = 0;
        my $guard2 = mock_guard('Selenium::WebDriver::SocketPoller', +{
            _time_now => sub {
                $i++;

                my $datetime = $i == 1 ? '2010-01-01 00:00:00'
                             : $i == 2 ? '2010-01-01 00:00:04'
                             :           '2010-01-01 00:00:06';

                Time::Piece->strptime($datetime, '%Y-%m-%d %H:%M:%S');
            },
        });

        ok ! $POLLER->is_connected;
    }
};

subtest 'closed' => sub {
    {
        my $guard = mock_guard('IO::Socket::INET', +{
            new => sub { undef },
        });

        ok $POLLER->is_closed;
    }

    {
        my $i = 0;
        my $guard2 = mock_guard('Selenium::WebDriver::SocketPoller', +{
            _time_now => sub {
                $i++;

                my $datetime = $i == 1 ? '2010-01-01 00:00:00'
                             : $i == 2 ? '2010-01-01 00:00:04'
                             :           '2010-01-01 00:00:06';

                Time::Piece->strptime($datetime, '%Y-%m-%d %H:%M:%S');
            },
        });

        ok ! $POLLER->is_closed;
    }
};

close $SERVER;

done_testing;
