package Selenium::WebDriver::Remote::Capabilities;
use strict;
use warnings;
use parent qw(Class::Accessor::Fast);

use JSON::XS qw(encode_json);

sub new {
    my ($class, %args) = @_;

    my %data = (
        browser_name             => '',
        version                  => '',
        platform                 => '',
        is_javascript_enabled    => 0 ,
        is_css_selectors_enabled => 0 ,
        can_take_screenshot      => 0 ,
        is_native_events         => 0 ,
        is_rotatable             => 0 ,
        firefox_profile          => undef,
        proxy                    => undef,
        %args,
    );
    $data{platform} = lc $data{platform} if exists $data{platform};

    $class->mk_accessors(keys %data);
    my $self = $class->SUPER::new(\%data);

    for my $field (keys %data) {
        $self->$field($data{$field});
    }

    $self;
}

my $CHROME;
sub chrome {
    my ($class, %opts) = @_;

    $CHROME ||= $class->new(
        browser_name             => 'chrome',
        is_javascript_enabled    => 1,
        is_css_selectors_enabled => 1,
        %opts,
    );
}

sub json_create {
    my ($class, %data) = @_;

    $class->new(%data);
}

sub merge {
    my ($self) = @_;
    # TODO
}

# TODO proxy

sub as_json {
    my ($self) = @_;

    my $result = +{};
    for my $key (keys %$self) {
        if      (defined($key) && $key eq 'platform') {
            $result->{$key} = uc $self->{$key};
        } elsif (defined($key) && $key eq 'firefox_profile') {
        } elsif (defined($key) && $key eq 'proxy') {
        } else {
            $result->{$key} = $self->{$key};
        }
    }
    $result;
}

sub to_json {
    my ($self) = @_;
    encode_json $self->as_json;
}

1;
