package Selenium::WebDriver::Remote::Http;
use Mouse;
use MouseX::StrictConstructor;
use MouseX::Types::URI;

use JSON::XS qw(encode_json);
use Data::Dump qw(dump);
use Sub::Retry qw(retry);
use HTTP::Request;
use LWP::UserAgent;
use Carp qw(croak);
use Data::Dump qw(dump);

our $MAX_REDIRECTS   = 20; # same as chromium/gecko
our $CONTENT_TYPE    = 'application/json';
our $DEFAULT_HEADERS = { "Accept" => $CONTENT_TYPE };
our $MAX_RETRIES     = 3;
our $USER_AGENT      = LWP::UserAgent->new;

has server_url => (
    is     => 'rw',
    isa    => 'URI',
    coerce => 1,
);

sub call {
    my ($self, $method, $url, $command) = @_;

    my %headers = %$DEFAULT_HEADERS;
    $headers{'Cache-Control'} = 'no-cache' if $method eq 'get';

    my $body;
    if ($command) {
        $body = encode_json($command);
        $headers{'Content-Type'}   = "$CONTENT_TYPE; charset=utf-8";
        $headers{'Content-Length'} = length $body;
        if ($ENV{DEBUG}) {
            print "$body\n";
            print dump(\%headers), "\n";
        }

    } elsif ($method eq 'post') {
        $body = '{}';
        $headers{'Content-Length'} = length $body;
    }

    $self->request($method, $url, \%headers, $body);
}

sub request {
    my ($self, $method, $url, $headers, $body, $redirects) = @_;
    $redirects ||= 2;
    # TODO handle too many redirects

    my $res = retry($MAX_RETRIES, 0.5, sub {
        my $req = HTTP::Request->new(uc($method), $url, [%$headers], $body);
        $USER_AGENT->clone->request($req);
    }, sub {
        ! $_[0]->is_success;
    });

    unless ($res) {
        croak sprintf('Request failed: %s %s %s %s',
            $method,
            $url,
            dump($headers),
            $body,
        );
    }
}

# TODO use proxy

no Mouse;
__PACKAGE__->meta->make_immutable();
