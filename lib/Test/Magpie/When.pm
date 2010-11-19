package Test::Magpie::When;
BEGIN {
  $Test::Magpie::When::VERSION = '0.04';
}
# ABSTRACT: The process of stubbing a mock method call
use Moose;
use namespace::autoclean;

use aliased 'Test::Magpie::Stub';
use Moose::Util qw( find_meta );
use Test::Magpie::Mock qw( add_stub );
use Test::Magpie::Util qw( extract_method_name );

with 'Test::Magpie::Role::HasMock';

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my $method_name = $AUTOLOAD;
    my $mock = find_meta($self)->get_attribute('mock')->get_value($self);
    
    my $stub = Stub->new(
        method_name => extract_method_name($method_name),
        arguments => \@_
    );

    my $stubs = find_meta($mock)->find_attribute_by_name('stubs')
        ->get_value($mock);

    my $method = $stub->method_name;
    $stubs->{$method} ||= [];
    push @{ $stubs->{$method} }, $stub;

    return $stub;
}

1;


__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::When - The process of stubbing a mock method call

=head1 DESCRIPTION

A mock object in stub mode to declare a stubbed method. You generate this by
calling C<when> in L<Test::Magpie> with a mock object.

This object has the same API as the mock object - any method call will start the
creation of a L<Test::Magpie::Stub>, which can be modified to tailor the stub
call. You are probably more interested in that documentation.

=head1 AUTHOR

Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

