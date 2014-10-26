#!/usr/bin/perl -T
use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN { use_ok 'Test::Magpie', qw(mock inspect) }

use Test::Magpie::ArgumentMatcher qw( anything );

my $mock = mock;
$mock->foo;
$mock->foo(123, bar => 456);

my $inspect;

subtest 'inspect()' => sub {
    $inspect = inspect($mock);
    isa_ok $inspect, 'Test::Magpie::Inspect';

    like exception { inspect },
        qr/^inspect\(\) must be given a mock object/,
        'no arg';
    like exception { inspect('string') },
        qr/^inspect\(\) must be given a mock object/,
        'invalid arg';
};

subtest 'get invocation' => sub {
    my $invocation1 = $inspect->foo;
    isa_ok $invocation1, 'Test::Magpie::Invocation';
    is $invocation1->name, 'foo';
    is_deeply [$invocation1->args], [];
};

subtest 'get invocation with argument matchers' => sub {
    my $invocation2 = $inspect->foo(anything);
    isa_ok $invocation2, 'Test::Magpie::Invocation';
    is $invocation2->name, 'foo';
    is_deeply [$invocation2->args], [123, 'bar', 456];
};

done_testing(4);
