#!perl -w
use strict;
use Test::More;
use Test::LoadAllModules;

BEGIN {
    all_uses_ok(
        search_path => 'Selenium::WebDriver',
    );
}
