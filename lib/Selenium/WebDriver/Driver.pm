package Selenium::WebDriver::Driver;
use Mouse;
use MouseX::StrictConstructor;

use Carp qw(croak);
use Path::Class;
use Class::Load;

extends 'Selenium::WebDriver::SearchContext';

has driver => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has switches => (
    is  => 'rw',
    isa => 'ArrayRef[Str]',
);

has bridge => (
    is      => 'rw',
    isa     => 'Selenium::WebDriver::Remote::Bridge',
    handles => +{
        current_url          => 'getCurrentUrl',
        title                => 'getTitle',
        page_source          => 'getPageSource',
        quit                 => 'quit',
        close                => 'close',
        window_handles       => 'getWindowHandles',
        window_handle        => 'getWindowHandle',
        execute_script       => 'executeScript',
        execute_async_script => 'executeAsyncScript',
        browser              => 'browser',
        capabilities         => 'capabilities',
    },
);

has navigate => (
    is      => 'rw',
    isa     => 'Selenium::WebDriver::Navigation',
    lazy    => 1,
    default => sub {
        require Selenium::WebDriver::Navigation;
		Selenium::WebDriver::Navigation->new(bridge => $_[0]->bridge);
	},
    handles => +{
        get => 'to',
    },
);

has switch_to => (
    is      => 'rw',
    isa     => 'Selenium::WebDriver::TargetLocator',
    lazy    => 1,
    default => sub {
        require Selenium::WebDriver::TargetLocator;
		Selenium::WebDriver::TargetLocator->new;
	},
);

has manage => (
    is      => 'rw',
    isa     => 'Selenium::WebDriver::Options',
    lazy    => 1,
    default => sub {
        require Selenium::WebDriver::Options;
		Selenium::WebDriver::Options->new;
	},
);

has root => (
    is      => 'rw',
    isa     => 'Str',
    default => sub {
        Path::Class::file(__FILE__)->dir->parent->parent->stringify,
    },
);


sub BUILD {
    my ($self, $args) = @_;
    my $driver = delete $args->{driver};
    if ($driver =~ /^chrome$/i) {
        my $module = 'Selenium::WebDriver::Remote::Bridge::' . ucfirst($driver);
        Class::Load::load_class($module);
        $self->bridge( $module->new(%$args) );
    # } elsif ($driver =~ /^(?:ie|internet_explorer)$/i) {
    # } elsif ($driver =~ /^(?:firefox|ff)$/i) {
    # } elsif ($driver =~ /^iphone$/i) {
    # } elsif ($driver =~ /^opera$/i) {
    } else {
        croak "unknown driver: $driver";
    }

    # TODO Driver Extensions Option
}

sub is_visible { # TODO test this later
    my ($self, $val) = @_;
    return $self->bridge->setBrowserVisible($val) if @_ == 2;
    $self->bridge->getBrowserVisible;
}

sub ref { undef }

{
    no warnings 'once';
    *first  = *Selenium::WebDriver::SearchContext::find_element;
    *all    = *Selenium::WebDriver::SearchContext::find_elements;
    *script = *Selenium::WebDriver::SearchContext::execute_script;
}

sub DEMOLISH {
    my ($self) = @_;
    $self->bridge->quit if $self->bridge;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
