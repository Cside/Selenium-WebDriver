package Selenium::WebDriver::Element;
use Mouse;
use MouseX::StrictConstructor;
use JSON::XS qw(encode_json);
use Scalar::Util qw(blessed);

extends 'Selenium::WebDriver::SearchContext';

has bridge => (
    is  => 'rw',
    isa => 'Selenium::WebDriver::Remote::Bridge',
);

has id => (
    is  => 'rw',
    isa => 'Str',
);

use Scalar::Util;

sub dump {  # orig name is "inspect"
    my ($self) = @_;
    sprintf '#<%s:%s id=%s tag_name=%s>', __PACKAGE__, $self, $self->id, $self->tag_name;
}

sub eql {
    my ($self, $other) = @_;
    blessed($other) eq __PACKAGE__ && $self->bridge->elementEquals($self, $other);
}

sub click {
    my ($self) = @_;
    $self->bridge->clickElement($self->id);
}

sub tag_name {
    my ($self) = @_;
    $self->bridge->getElementTagName($self->id);
}

sub attribute {
    my ($self, $name) = @_;
    $self->bridge->getElementAttribute($self->id, $name);
}

sub text {
    my ($self) = @_;
    $self->bridge->getElementText($self->id);
}

sub send_keys {
    # TODO
    $self->bridge->sendKeysToElement($self->id, @values);
}

sub clear {
    my ($self) = @_;
    $self->bridge->clearElement($self->id);
}

sub is_enabled {
    my ($self) = @_;
    $self->bridge->isElementEnabled($self->id);
}

sub is_selected {
    my ($self) = @_;
    $self->bridge->isElementSelected($self->id);
}

sub is_displayed {
    my ($self) = @_;
    $self->bridge->isElementDisplayed($self->id);
}

sub submit {
    my ($self) = @_;
    $self->bridge->submitElement($self->id);
}

sub style {
    my ($self, $prop) = @_;
    $self->bridge->getElementValueOfCssProperty($self->id, $prop);
}

sub location {
    my ($self) = @_;
    $self->bridge->getElementLocation($self->id);
}

sub location_once_scrolled_into_view {
    my ($self) = @_;
    $self->bridge->getElementLocationOnceScrolledIntoView($self->id);
}

sub size {
    my ($self) = @_;
    $self->bridge->getElementSize($self->id);
}

{
    no warnings 'once';
    *first = *Selenium::WebDriver::SearchContext::find_element;
    *all   = *Selenium::WebDriver::SearchContext::find_elements;
}

sub ref { $_[0]->id }


sub to_json {
    my ($self, $arg) = @_;
    encode_json +{ ELEMENT => $arg };
}

sub is_selectable {
    my ($self) = @_;
    my $tag_name = lc($self->tag_name);
}

no Mouse;
__PACKAGE__->meta->make_immutable();
