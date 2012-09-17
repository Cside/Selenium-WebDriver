package Selenium::WebDriver::SocketPoller;
use Mouse;
use MouseX::StrictConstructor;
use IO::Socket::INET;
use Time::HiRes qw(sleep);

has host => (
    is  => 'rw',
    isa => 'Str',
);

has port => (
    is  => 'rw',
    isa => 'Int',
);

has timeout => (
    is      => 'rw',
    isa     => 'Num',
    default => 0,
);

has interval => (
    is      => 'rw',
    isa     => 'Num',
    default => 0.25,
);

sub is_connected {
    my ($self) = @_;
    $self->_with_timeout(sub { $self->is_listening });
}

sub is_closed {
    my ($self) = @_;
    $self->_with_timeout(sub { ! $self->is_listening });
}

sub is_listening {
    my ($self) = @_;
    my $sock = IO::Socket::INET->new(
        Proto     => 'tcp',
        PeerAddr  => $self->host,
        PeerPort  => $self->port,
    );
    
    if ($sock) {
        close $sock;
        return 1;
    }

    0;
}

sub _with_timeout {
    my ($self, $code) = @_;
    my $max_time = _time_now() + $self->timeout;
    
    do {
        return 1 if $code->();
        _wait($self->interval);
    } until (_time_now() > $max_time);
    0;
}

sub _time_now { time }

sub _wait { sleep $_[0] }

no Mouse;
__PACKAGE__->meta->make_immutable();
