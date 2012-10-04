package Selenium::WebDriver::Navigation;
use Mouse;
use MouseX::StrictConstructor;

has bridge => (
    is      => 'rw',
    does    => 'Selenium::WebDriver::Remote::Bridge',
    handles => +{
        to      => 'get',
        back    => 'go_back',
        forward => 'go_forward',
        refresh => 'refresh',
    },
);

no Mouse;
__PACKAGE__->meta->make_immutable();
