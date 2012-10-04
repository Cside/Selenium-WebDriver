#!perl -w
use strict;
use Test::More;
use Test::Exception;
use Test::MockObject;
use Test::MockObject::Extends;
use Selenium::WebDriver::SearchContext;

my $search_context = Selenium::WebDriver::SearchContext->new;

Test::MockObject->fake_module('Selenium::WebDriver::Remote::Bridge',
    new              => sub { bless +{}, shift; },
    findElementById  => sub { my ($self, $parent, $id) = @_; [$id] },
    findElementsById => sub { my ($self, $parent, $id) = @_; [$id] },
);

Test::MockObject::Extends->new($search_context)
->mock(bridge => sub { bless +{}, 'Selenium::WebDriver::Remote::Bridge' })
->mock(ref    => sub { undef });

subtest 'finding a single element' => sub {
    is_deeply $search_context->find_element(id => 'bar'), [qw(bar)],
        'finding a single element';

    throws_ok { $search_context->find_element(foo => 'bar') }
        qr{cannot find element by };
};

subtest 'finding multiple elements' => sub {
    is_deeply $search_context->find_elements(id => 'bar'), [qw(bar)],
        'finding a single element';

    throws_ok { $search_context->find_elements(foo => 'bar') }
        qr{cannot find elements by };
};

# TODO wrong number of args

done_testing;
