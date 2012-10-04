package Selenium::WebDriver::SearchContext;
use Mouse;
use Carp qw(croak);
use Data::Dump qw(dump);

my $FINDERS = +{
    class             => 'ClassName',
    class_name        => 'ClassName',
    css               => 'CssSelector',
    id                => 'Id',
    link              => 'LinkText',
    link_text         => 'LinkText',
    name              => 'Name',
    partial_link_text => 'PartialLinkText',
    tag_name          => 'TagName',
    xpath             => 'Xpath',
};

sub find_element {
    my $self = shift;
    my ($how, $what) = _extract_args(@_);

    my $by;
    unless ($by = $FINDERS->{$how}) {
        croak 'cannot find element by ' . dump($how)
    }

    my $method = "findElementBy$by";
    $self->bridge->$method($self->ref, $what);
}

sub find_elements {
    my $self = shift;
    my ($how, $what) = _extract_args(@_);

    my $by;
    unless ($by = $FINDERS->{$how}) {
        croak 'cannot find elements by ' . dump($how)
    }

    my $method = "findElementsBy$by";
    $self->bridge->$method($self->ref, $what);
}

sub _extract_args {
    # TODO when scalar @_ == 1
    croak 'wrong number of arguments (' . scalar(@_) . ' for 2)'
        unless scalar @_ == 2;
    @_;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
