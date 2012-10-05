package Selenium::WebDriver::BridgeHelper;
use Mouse;
use MouseX::StrictConstructor;
use Selenium::WebDriver::Element;
use CGI::Cookie;

sub unwrap_script_result {
    my ($self, $arg) = @_;

    if (ref $arg eq 'ARRAY') {
        return map { $self->unwrap_script_result($self, $_) } @$arg;

    } elsif (ref $arg eq 'HASH') {
        if (my $id = $self->element_id_from($arg)) {
            return Selenium::WebDriver::Element->new($self, $id);

        } else {
            for my $key (keys %$arg) {
                $arg->{$key} = $self->unwrap_script_result($arg->{$key});
            }
            return $arg;
        }
    }

    $arg;
}

sub element_id_from { $_[0]->{ELEMENT} }

sub parse_cookie_string {
    my ($self, $cookie) = @_;

    +{ CGI::Cookie->parse($cookie) };
}

no Mouse;
__PACKAGE__->meta->make_immutable();
