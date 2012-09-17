package Selenium::WebDriver::Service::Chrome;
use Mouse;
use MouseX::StrictConstructor;
use Test::TCP qw(empty_port);
use Carp qw(croak);
use Proc::Background;
use URI;
use Selenium::WebDriver::Platform qw(find_binary assert_executable);

has port => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => sub { empty_port() },
);

has executable_path => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        find_binary('chromedriver') or croak << '_MISSING_';
Unable to find the chromedriver executable. Please
download the server from
http://code.google.com/p/chromedriver/downloads/list
and place it somewhere on your PATH.  More info at
http://code.google.com/p/selenium/wiki/ChromeDriver.
_MISSING_
    },
);

has driver_path => (
    is      => 'rw',
    isa     => 'Str',
    trigger => sub {
        my ($self, $path) = @_;
        assert_executable($path);
        $self->executable_path($path);
    },
);

has _process => (
    is      => 'rw',
    isa     => 'CodeRef',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        sub {
            Proc::Background->new(
                +{ die_upon_destroy => 1 },
                sprintf("%s --port=%d", $self->executable_path, $self->port),
            );
        }
    },
);

has process => (
    is  => 'rw',
    isa => 'Proc::Background',
);

has uri => (
    is      => 'rw',
    isa     => 'URI',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        URI->new('http://127.0.0.1: ' . $self->port);
    },
);

sub start {
    my ($self) = @_;
    $self->process( $self->_process->() );
}

sub stop {
    my ($self) = @_;
    return unless $self->process && $self->process->alive;

    $self->process->die;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
