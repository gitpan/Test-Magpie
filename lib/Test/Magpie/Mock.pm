package Test::Magpie::Mock;
BEGIN {
  $Test::Magpie::Mock::VERSION = '0.01_01';
}
use Moose;

use Sub::Exporter -setup => {
    exports => [qw( add_stub )],
};

use aliased 'Test::Magpie::Invocation';

use Test::Magpie::Util qw( extract_method_name );
use List::AllUtils qw( first );
use MooseX::Types::Moose qw( ArrayRef Int Object Str );
use MooseX::Types::Structured qw( Map );
use Moose::Util qw( find_meta );
use Test::Builder;

has 'invocations' => (
    isa => ArrayRef,
    is => 'bare',
    default => sub { [] }
);

has 'stubs' => (
    isa => Map[Str, Object],
    is => 'bare',
    default => sub { {} }
);

our $AUTOLOAD;

sub AUTOLOAD {
    my $method = $AUTOLOAD;
    my $self = shift;
    my $meta = find_meta($self);
    my $invocations = $meta->get_attribute('invocations')->get_value($self);
    my $invocation = Invocation->new(
        method_name => extract_method_name($method),
        arguments => \@_
    );

    push @$invocations, $invocation;

    if(my $stubs = $meta->get_attribute('stubs')->get_value($self)->{
        $invocation->method_name
    }) {
        
        my $stub = first { $_->satisfied_by($invocation) } @$stubs;
        return unless $stub;
        $stub->execute;
    }
}

sub add_stub {
    my ($self, $stub) = @_;
    my $meta = find_meta($self);
    my $stubs = $meta->get_attribute('stubs')->get_value($self);
    my $method = $stub->method_name;
    $stubs->{$method} ||= [];
    push @{ $stubs->{$method} }, $stub;
}

1;

__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Mock

=head1 AUTHOR

  Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

